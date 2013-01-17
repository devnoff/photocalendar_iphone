//
//  PhotoImageView.m
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 30..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import "PhotoView.h"
#import "UIImage+Resize.h"
#import "AppDelegate.h"
#import "PullRefreshTableViewController.h"

@interface PhotoView()

- (void)setupImageViewWithImage:(UIImage*)image;
- (void)handleFailedImage;
- (void)playButtonTapped:(id)sender;
- (void)fitImageToScreen;
- (void)releaseBlankImage;
@end



@implementation PhotoView

@synthesize index=_index,photodata=_photoData,delegate=_delegate;
@synthesize landcape=_landcape;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
		self.userInteractionEnabled = NO;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.opaque = YES;
        
        [self setClipsToBounds:YES];
        
        _zoomView = [[PhotoZoomView alloc] initWithFrame:self.bounds];
		_zoomView.delegate = self;

        
        _zoomView.contentMode = UIViewContentModeScaleAspectFit;
        
		[self addSubview:_zoomView];
        
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
		_imageView.opaque = YES;
        _imageView.alpha = 0;
        //		_imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
		[_zoomView addSubview:_imageView];
        
        
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		_activityView.frame = CGRectMake((CGRectGetWidth(self.frame) / 2) - 11.0f, CGRectGetHeight(self.frame)/2 , 22.0f, 22.0f);
		_activityView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
		[self addSubview:_activityView];
        [_activityView startAnimating];
        
        
        UIImage * playOn = [UIImage imageNamed:@"PLVideoOverlayPlay"];
        UIImage * playOver = [UIImage imageNamed:@"PLVideoOverlayPlayDown"];
        
        _playBtnSize = playOn.size;
        
        _playButton = [[UIButton alloc] initWithFrame:self.bounds];
        [_playButton setImage:playOn forState:UIControlStateNormal];
        [_playButton setImage:playOver forState:UIControlStateHighlighted];
        [_playButton addTarget:self action:@selector(playButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_playButton];
        _playButton.hidden = YES;
        
        
        _landcape = NO;
    }
    
    return self;
}


- (void)dealloc
{
    if (nil != _photoData) {
		[[EGOImageLoader sharedImageLoader] cancelLoadForURL:_photoData.URL];
	}
    [_photoData release];
    
    [_zoomView release];
    [_imageView release];
    [_activityView release];
    [_caption release];
    [_playButton release];
    [self releaseBlankImage];
    [super dealloc];
}


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    _zoomView.frame = self.bounds;
    _zoomView.zoomScale = 1.0f;
    _imageView.frame = self.bounds;
    _activityView.frame = CGRectMake((CGRectGetWidth(self.frame) / 2) - 11.0f, CGRectGetHeight(self.frame) /2, 22.0f, 22.0f);
    _playButton.frame = CGRectMake((CGRectGetWidth(self.frame)/2)-(_playBtnSize.width/2), (CGRectGetHeight(self.frame)/2)-(_playBtnSize.height/2), _playBtnSize.width, _playBtnSize.height);
    
    
    
}



- (void)setPhoto:(PhotoData *)photoData {
    
    
    
    if (!photoData) {
        return;   
    }
    
    if (![_photoData isEqual:photoData]) {
        [_photoData release], _photoData = nil;    
        _photoData = [photoData retain];
    }
    
    
    // 사진이 없을 경우 새로고침 이미지 보이기
    if (!_photoData.image) {
        [self showBlankImage];
        self.userInteractionEnabled = YES;
        [_activityView stopAnimating];
        return;
    }
    [self releaseBlankImage];
    
    
    if ([photoData.assetType isEqualToString:ALAssetTypeVideo]) {
        _playButton.hidden = NO;
    } else {
        _playButton.hidden = YES;
    }
    
    if (!_imageView.image) {
        
        _imageView.image = _photoData.image;
        
        [_activityView stopAnimating];
        [UIView animateWithDuration:.5 
                         animations:^{
                             _imageView.alpha = 1.0f;
                             _caption.alpha = 1.0f;
                         } 
                         completion:^(BOOL finished){
                             
                         }];    
        
        
    }
    
    
    //    if (_imageView.image) {
    //		self.userInteractionEnabled = YES;
    //	} else {
    //		self.userInteractionEnabled = NO;
    //	}
    
    self.userInteractionEnabled = YES;
    
    [self fitImageToScreen];
    
    
    
    
    
}

- (void)showBlankImage{
    //Black View
    
    [self releaseBlankImage];
    
    if (!_blankView) {
        _blankView = [[UIView alloc] initWithFrame:self.bounds];
        UIImage * refreshImg = [UIImage imageNamed:@"RefreshBig"];
        
        UIButton * refreshBtn = [[UIButton alloc] initWithFrame:CGRectMake((_blankView.frame.size.width/2) - (refreshImg.size.width/2) , 0.35*self.bounds.size.height, refreshImg.size.width, refreshImg.size.height)];
        [refreshBtn setImage:refreshImg forState:UIControlStateNormal];
        [refreshBtn addTarget:self action:@selector(refreshButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [_blankView addSubview:refreshBtn];
        
        
        UILabel *deleteTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, refreshBtn.frame.origin.y+refreshBtn.frame.size.height+18, _blankView.frame.size.width, 18)];
        [deleteTitle setText:NSLocalizedString(@"DELETED_PHOTO_TITLE", nil)];
        [deleteTitle setTextAlignment:UITextAlignmentCenter];
        [deleteTitle setFont:[UIFont boldSystemFontOfSize:18]];
        [deleteTitle setTextColor:RGB(123, 123, 123)];
        [deleteTitle setBackgroundColor:[UIColor clearColor]];
        [_blankView addSubview:deleteTitle];
        
        
        NSString * text = NSLocalizedString(@"DELETED_PHOTO_DESC", nil);
        CGSize maximumLabelSize = CGSizeMake(self.bounds.size.width,9999);
        UIFont * font = [UIFont boldSystemFontOfSize:12.0];
        
        CGSize expectedLabelSize = [text sizeWithFont:font 
                                    constrainedToSize:maximumLabelSize 
                                        lineBreakMode:UILineBreakModeCharacterWrap]; 
        
        //adjust the label the the new height.
        CGRect newFrame = CGRectMake(0, deleteTitle.frame.origin.y+ deleteTitle.frame.size.height+18, self.bounds.size.width, 45);
        newFrame.size.height = expectedLabelSize.height;
        
        UILabel * labelDesc = [[UILabel alloc] initWithFrame:newFrame];
        labelDesc.backgroundColor = [UIColor clearColor];
        labelDesc.font = font;
        labelDesc.textColor = RGB(123, 123, 123);
        labelDesc.shadowColor = [UIColor colorWithWhite:0 alpha:.5];
        labelDesc.shadowOffset = CGSizeMake(0, -1);
        labelDesc.textAlignment = UITextAlignmentCenter;
        labelDesc.numberOfLines = 4;
        labelDesc.text = NSLocalizedString(@"DELETED_PHOTO_DESC", nil);
        labelDesc.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [_blankView addSubview:labelDesc];
        
        
        [self addSubview:_blankView];
        
        [labelDesc release];
        [deleteTitle release];
        [refreshBtn release];
        
        
    }
    
}

- (void)releaseBlankImage{
    if (_blankView) {
        [_blankView removeFromSuperview];
        [_blankView release];
        _blankView = nil;
    }
}


- (void)refreshButtonTapped{
    AppDelegate *app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    
    for (UIViewController *vc in [app.navCon childViewControllers]) {
        if ([vc isKindOfClass:[RootViewController class]]) {
            NSArray * arr = ((RootViewController*)vc).controllers;
            for (UIViewController *vvc in arr) {
                if ([vvc isKindOfClass:[PullRefreshTableViewController class]]) {
                    [vvc performSelector:@selector(refresh)];
                    return;
                }
            }
        }
    }
    
    
}

- (void)fitImageToScreen{
    
    
    NSLog(@"landscape : %d",_landcape);
    
//    if ((_landcape &&(_imageView.image.size.width > _imageView.image.size.height))||
//        (!_landcape && (_imageView.image.size.width < _imageView.image.size.height))) {   
//        
//        _imageView.contentMode = UIViewContentModeScaleAspectFill;
//        
//    } else {
//        
//        _imageView.contentMode = UIViewContentModeScaleAspectFit;
//    }
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [_zoomView setContentSize:CGSizeMake(_imageView.frame.size.width,_imageView.frame.size.height)];
    //    [self restoreZoom];
    
    
    if (_blankView) {
        [self showBlankImage];
    }
}


- (void)rotateToOrientation:(UIInterfaceOrientation)orientation {
    _zoomView.frame = self.bounds;
    _imageView.frame = self.bounds;
    _activityView.frame = CGRectMake((CGRectGetWidth(self.frame) / 2) - 11.0f, CGRectGetHeight(self.frame) - 100.0f , 22.0f, 22.0f);
    _playButton.frame = CGRectMake((CGRectGetWidth(self.frame)/2)-(_playBtnSize.width/2), (CGRectGetHeight(self.frame)/2)-(_playBtnSize.height/2), _playBtnSize.width, _playBtnSize.height);
    
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        _landcape = NO;
    } else {
        _landcape = YES;
    }
    
    [self fitImageToScreen];
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return _imageView;
}


#pragma mark -
#pragma mark EGOImageLoader Callbacks

- (void)imageLoaderDidLoad:(NSNotification*)notification {	
	if ([notification userInfo] == nil) {
        return;
    }
	if (![[[notification userInfo] objectForKey:@"imageURL"] isEqual:_photoData.URL]) {
        return;
    }
	
	[self setupImageViewWithImage:[[notification userInfo] objectForKey:@"image"]];
	
}

- (void)imageLoaderDidFailToLoad:(NSNotification*)notification {
	if ([notification userInfo] == nil) {
        return;
    }
	if (![[[notification userInfo] objectForKey:@"imageURL"] isEqual:_photoData.URL]) {
        return;
    }
	
    [self handleFailedImage];
}


- (void)setupImageViewWithImage:(UIImage*)image {
	if (!image) {
        return;
    }
    
    [_activityView stopAnimating];
	_imageView.image = image; 	
    self.userInteractionEnabled = YES;
}


- (void)handleFailedImage {
    [_activityView stopAnimating];
    
	_photoData.failed = YES;
	self.userInteractionEnabled = NO;
}

- (void)resetView{
    _imageView.alpha = 0.0f; 
    _imageView.image = nil;
    _caption.alpha = 0.0f;
    _caption.text = @"";
    _playButton.hidden = YES;
    [_photoData release]; _photoData = nil;
    [_activityView startAnimating];
}


- (void)setImageViewAlpha:(float)alpha{
    _imageView.alpha = alpha;
}

- (BOOL)hasImage{
    if (_blankView) return YES;
    
    return _imageView.image?YES:NO;
}

- (NSInteger)getWidthOfView{
    return _zoomView.bounds.size.width;
}

- (void)restoreZoom{
    _zoomView.zoomScale = 1.0;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale{

    NSLog(@"scrollview: %@ / zooming %@ / scale %f",scrollView, scrollView.zooming?@"Y":@"N",scrollView.zoomScale);
    NSLog(@"imageview: %@", _imageView);
    
    if (scrollView.zoomScale==1.0f){
        [UIView animateWithDuration:.3 
                         animations:^{
                             _imageView.contentMode = UIViewContentModeScaleAspectFit;
                         } 
                         completion:^(BOOL finished){
                         }];
    }
}

#pragma mark - play movie

- (void)playButtonTapped:(id)sender{
    if (_photoData) {
        MPMoviePlayerViewController * mp = [[MPMoviePlayerViewController alloc]initWithContentURL:_photoData.asset.defaultRepresentation.url];
        [_delegate playVideo:mp];
        [mp release];    
    }
    
}

//
//#pragma mark - PhotoZoomViewDelegate method
//- (void)multiTouchEventHappen{
//
//
//}
@end
