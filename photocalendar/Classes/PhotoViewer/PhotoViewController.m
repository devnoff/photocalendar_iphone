//
//  PhotoViewController.m
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 30..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import "PhotoViewController.h"
#import "CSBarButtonItemUtils.h"
#import "MapViewController.h"
#import "AppDelegate.h"

//#import "DetailViewController.h"
#import "PhotoModel.h"
#import "SHK.h"



@interface PhotoViewController()

- (void)storeStyle;
- (void)restoreStyle;

- (void)displayPageInfo;
- (void)layoutPhotoViewPages;
- (PhotoView *)dequeueRecycledPage;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;

- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index;
- (CGSize)contentSizeForPagingScrollView;

- (void)moveContentOffsetToCurrentPage;
- (void) backBtnTapped:(id)sender;

- (void)showCaptionText;
- (void)hideCaptionText;

- (void) mapBtnTapped:(id)sender;
- (void)showMapButton:(BOOL)show;
- (void)scrollViewFitToScreen:(UIInterfaceOrientation)orientation;

- (void)setCaptionText;

- (void) shareActionCalled;

- (void)subMenuButtonTapped:(id)sender;

- (void)doneButtonTapped;
- (void)checkCurrentPageStatus;
@end




@implementation PhotoViewController

@synthesize photoDataSource=_photoDataSource;
@synthesize currentPage=_currentPage;
@synthesize modifyLocked=_modifyLocked;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        _recycledPages = [[NSMutableSet alloc] init];
        _visiblePages  = [[NSMutableSet alloc] init];
        
        self.hidesBottomBarWhenPushed = YES;
        self.wantsFullScreenLayout = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(photoViewToggleBarNotification) 
                                                     name:@"PhotoViewToggleBarNotification" 
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(shareActionCalled) 
                                                     name:@"PhotoViewShareActionNotification" 
                                                   object:nil];
        
        
        _photoContainer = [[NSMutableDictionary alloc] init];
        
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [_visiblePages release];
    [_recycledPages release];
    [_photoDataSource release]; _photoDataSource = nil;
    [_scrollView release];
    [_photoContainer release];
    [_backStr release];
    [_captionToolBar release];
    [_moreSheet release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:[self frameForPagingScrollView]];
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _scrollView.multipleTouchEnabled = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.canCancelContentTouches = YES;
    _scrollView.delaysContentTouches = YES;
    _scrollView.clipsToBounds = YES;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.bounces = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_scrollView];
    
    //
    
    
    //    [self.view addSubview:_caption];
    //    _caption.alpha = 0.0f;
    
    NSString * backStr = [[self.navigationController.viewControllers objectAtIndex:([self.navigationController.viewControllers count]-2)] title];
    backStr = backStr==nil||[backStr isEqualToString:@""]?NSLocalizedString(@"BACK", nil):backStr;
    _backStr = [[NSString alloc]initWithString: backStr];
    
    
    
    // caption tool bar
    _captionToolBar = [[PPCaptionView alloc] initWithFrame:CGRectMake(0, 480-44, 320, 44)];
    _captionToolBar.delegate = self;
    [self.view addSubview:_captionToolBar];
    
    
    
    
    
    
    // rotate
    _rotate = YES;
    _orientation = UIInterfaceOrientationPortrait;
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    
}


#define NO_ORIENTATION 123456
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self storeStyle];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5")) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Bg_Black"] forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Bg_Hr_Black"] forBarMetrics:UIBarMetricsLandscapePhone];
    } else {
        self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Bg_Black"]];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
    self.navigationController.toolbar.tintColor = nil;
    self.navigationController.toolbar.barStyle = UIBarStyleBlack;
    self.navigationController.toolbar.translucent = YES;
    
    
    [self.navigationItem setHidesBackButton:YES];
    
    
    
    
    [self.navigationItem setLeftBarButtonItem:[CSBarButtonItemUtils blackBackButtonWithTitle:_backStr target:self action:@selector(backBtnTapped:)]];
    
    [self.navigationItem setRightBarButtonItem:[CSBarButtonItemUtils blackButtonWithTitle:@"Map" target:self action:@selector(mapBtnTapped:)]];
    
    [_photoDataSource destroyDispatch:NO];
    
    [self resizeContent];
    
    // 화면의 오리엔테이션에 맞게 뷰 정렬 
    _orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self scrollViewFitToScreen:_orientation];
    
    mapCalled = NO;
    
    
}

- (void)resizeContent{
    //    _scrollView.frame = [self frameForPagingScrollView];
    _scrollView.contentSize = [self contentSizeForPagingScrollView];
    [self moveContentOffsetToCurrentPage];
    [self layoutPhotoViewPages];    
}





- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    if (!mapCalled) {
        [self restoreStyle];
        
    }
	//
//    [self performSelector:@selector(hideLocationView)];
    
}


#pragma mark - orientation


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    _rotating = YES;
    
    
    // 
    for (PhotoView *page in _visiblePages) {
        page.alpha = 0.0f;
    }
    
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    _orientation = toInterfaceOrientation;
    [self scrollViewFitToScreen:toInterfaceOrientation];
    
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    _rotating = NO;
    
    [UIView animateWithDuration:.2 
                     animations:^{
                         for (PhotoView *page in _visiblePages) {
                             page.alpha = 1.0f;
                         }
                     } 
                     completion:nil];
    
}

- (void)scrollViewFitToScreen:(UIInterfaceOrientation)orientation{
    _scrollView.contentSize = [self contentSizeForPagingScrollView];
    NSLog(@"orientation: %d",orientation);
    
    
    [self moveContentOffsetToCurrentPage];
    
    
    // 캡션
    CGSize screenSize = self.view.bounds.size;
    if (orientation == NO_ORIENTATION) {
        orientation = UIInterfaceOrientationPortrait;
        screenSize = CGSizeMake(320, 480);
    }
    
    for (PhotoView *page in _visiblePages) {
        page.frame = [self frameForPageAtIndex:page.index];
        [page rotateToOrientation:orientation];
    }
    
    
    int ad_margin = 0;
    if ((orientation == UIInterfaceOrientationPortraitUpsideDown || orientation == UIInterfaceOrientationPortrait) && !HAS_UPGRADED) {
        ad_margin = 50;
    }
    
    //    _caption.frame = CGRectMake(0, screenSize.height-15-ad_margin, screenSize.width-10, 13);
    _captionToolBar.frame = CGRectMake(0, screenSize.height-ad_margin-_captionToolBar.frame.size.height, _scrollView.bounds.size.width, _captionToolBar.frame.size.height);
    [_captionToolBar fitToView:orientation];
    
    // 네비게이션
    if ((orientation == UIInterfaceOrientationPortraitUpsideDown || orientation == UIInterfaceOrientationPortrait)){
        if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5")) {
            self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Bg_Black"]];
        }
        [self.navigationItem setLeftBarButtonItem:[CSBarButtonItemUtils blackBackButtonWithTitle:_backStr target:self action:@selector(backBtnTapped:)]];
        [self.navigationItem setRightBarButtonItem:[CSBarButtonItemUtils blackButtonWithTitle:@"Map" target:self action:@selector(mapBtnTapped:)]];
        
    } else {
        if (!SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5")) {
            self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Bg_Hr_Black"]];
        }
        
        [self.navigationItem setLeftBarButtonItem:[CSBarButtonItemUtils smallBlackBackButtonWithTitle:_backStr target:self action:@selector(backBtnTapped:)]];
        [self.navigationItem setRightBarButtonItem:[CSBarButtonItemUtils smallBlackButtonWithTitle:@"Map" target:self action:@selector(mapBtnTapped:)]];
    }
    
    [self showMapButton:YES];
    
}


#pragma mark - Button Actions

- (void)backBtnTapped:(id)sender{
    [_photoDataSource destroyDispatch:YES];
    //    NSArray * arr = self.navigationController.childViewControllers;
    //    for (id prev_controller in arr) {
    //        if ([prev_controller isKindOfClass:[DetailViewController class]]) {
    //            [(DetailViewController*)prev_controller scrollToIndex:_currentPage];
    //        }
    //    }
    //
    
    

    [[NSNotificationCenter defaultCenter] postNotificationName:@"UINavigationShouldRestoreRotation" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
}

- (void)mapBtnTapped:(id)sender{
    for (PhotoView * pv in _visiblePages) {
        if (pv.index == _pageNum) {
            mapCalled = YES;
            if (pv.photodata.photo.location_lat&&pv.photodata.photo.location_long) {
                NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      pv.photodata.photo.location_lat,@"lat",
                                      pv.photodata.photo.location_long,@"long",
                                      pv.photodata.captionString,@"title", nil];
                MapViewController * mvc = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
                [mvc addPinsObject:dic];
                [self.navigationController pushViewController:mvc animated:YES];
                [mvc release];   
            }
        } 
    }
}


- (void)subMenuButtonTapped:(id)sender{
    
    
    if (_moreSheet) {
        [_moreSheet release];
    }
    
    if (_currentPageHasLocation&&UIInterfaceOrientationIsPortrait(_orientation)) {
        _moreSheet = [[UIActionSheet alloc] 
                      initWithTitle: NSLocalizedString(@"MORE", nil)
                      delegate:self
                      cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                      destructiveButtonTitle:nil
                      otherButtonTitles:NSLocalizedString(@"MAP", nil), NSLocalizedString(@"MODIFY", nil), nil];
        
    } else {
        _moreSheet = [[UIActionSheet alloc] 
                      initWithTitle: NSLocalizedString(@"MORE", nil)
                      delegate:self
                      cancelButtonTitle:NSLocalizedString(@"CANCEL", nil)
                      destructiveButtonTitle:nil
                      otherButtonTitles:NSLocalizedString(@"MAP", nil), nil];
        
    }
    
    [_moreSheet showInView:self.view];  
}

- (void)doneButtonTapped{
//    [self performSelector:@selector(hideLocationView)];
}





#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_rotating) {
        return;
    }
    
    CGRect visibleBounds = _scrollView.bounds;
    float visible = CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds);
    
    
    _pageNum = round(visible);
    
    [self displayPageInfo];
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    _currentPage = (_scrollView.contentOffset.x)/_scrollView.bounds.size.width;
    
    [_photoDataSource requestCachedPhotoAtIndex:[NSNumber numberWithInteger:_currentPage]];
    [self layoutPhotoViewPages];
    
    
    [self setCaptionText];
    
    [self showMapButton:YES];
    
    for (PhotoView *page in _visiblePages) {
        if (page.index!=_currentPage) {
            [page restoreZoom];
        } else {
            // 스크롤 후 보여지는 페이지일 경우
            
            NSLog(@"latitude %f, longitude %f",page.photodata.coordinate.latitude,page.photodata.coordinate.longitude);
        }
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    //    [self setCaptionText];
//    [self showMapButton:NO]; 
//    [_captionToolBar setLocationString:nil andTimestamp:nil];    
}


#pragma mark -
#pragma mark PhotoView 페이지 구성

- (void)setDefaultPage:(NSInteger)page{
    
    [_photoDataSource requestCachedPhotoAtIndex:[NSNumber numberWithInteger: page]];
    _pageNum = page;
    _currentPage = page;
    [self displayPageInfo];
    [self moveContentOffsetToCurrentPage];
    [self layoutPhotoViewPages];
    
    // set disable modifybtn
//    [_captionToolBar setLocationString:nil andTimestamp:nil];
    
    
    [self showMapButton:YES];
    
}

- (void)displayPageInfo{
    //
    self.title = [NSString stringWithFormat:@"%i of %i", _pageNum + 1, _photoDataSource.numberOfPhotos];
    
}


- (void)layoutPhotoViewPages {
    
    int range;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5")) {
        range = 1;
    } else {
        range = 0;
    }
    
    CGRect visibleBounds = _scrollView.bounds;
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds)-range);
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds) - 1) / CGRectGetWidth(visibleBounds)+range);
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex = MIN(lastNeededPageIndex, _photoDataSource.numberOfPhotos - 1);
    
    for (PhotoView *page in _visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [page resetView];
            [_recycledPages addObject:page];
            [page removeFromSuperview];
        }
    }
    
    
    [_visiblePages minusSet:_recycledPages];
    
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            
            PhotoView *page = [self dequeueRecycledPage];
            
            if (nil == page) {
                page = [[[PhotoView alloc] init] autorelease];
                page.delegate = self;
            }
            [page resetView];
            
            page.index = index;
            page.frame = [self frameForPageAtIndex:index];
            page.landcape = !UIInterfaceOrientationIsPortrait(_orientation);
            
            PhotoData * pdata = [_photoDataSource.photoCache objectForKey:[NSNumber numberWithInteger:index]];
            if (!pdata) {
                NSLog(@"request missing photo at index: %d",index);
                [_photoDataSource requestMissingPhotoAtIndex:index];
            } else {
                [page setPhoto:pdata];                  
            }
            
            NSLog(@"obj for key: %@  and index: %d  first: %d  last: %d", pdata.asset, index, firstNeededPageIndex, lastNeededPageIndex);
            
            [_scrollView addSubview:page];
            [_visiblePages addObject:page];
            
        } else {
            for (PhotoView *page in _visiblePages) {
                if (page.index == index) {
                    
                    if (![page hasImage]) {
                        PhotoData * pdata = [_photoDataSource.photoCache objectForKey:[NSNumber numberWithInteger:index]];
                        if (!pdata) {
                            [_photoDataSource requestMissingPhotoAtIndex:index];
                            NSLog(@"request missing in visible at index: %d",index);
                        } else {
                            [page setPhoto:pdata];
                            NSLog(@"set photo again at index: %d",index);
                        }
                    }
                    
                }
            }
        }
    }
    
}




- (PhotoView *)dequeueRecycledPage {
    PhotoView *page = [_recycledPages anyObject];
    if (page) {
        [[page retain] autorelease];
        [_recycledPages removeObject:page];
    }
    return page;
}


- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    BOOL foundPage = NO;
    for (PhotoView *page in _visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}


#define PADDING  20

- (CGRect)frameForPagingScrollView {
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}


- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    CGRect bounds = _scrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}


- (CGSize)contentSizeForPagingScrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = _scrollView.bounds;
    return CGSizeMake(bounds.size.width * _photoDataSource.numberOfPhotos, bounds.size.height);
}


- (void)moveContentOffsetToCurrentPage {
    CGFloat pageWidth = _scrollView.bounds.size.width;
    CGFloat newOffset = _currentPage * pageWidth;
    _scrollView.contentOffset = CGPointMake(newOffset, 0);
}


#pragma mark -
#pragma mark 네비게이션 스타일 저장/복원

- (void)storeStyle {
    if (_storedOldStyles) {
        return;
    }
    _oldNavBarBgColor = [self.navigationController.navigationBar.backgroundColor retain];
    
    _oldStatusBarSyle = [UIApplication sharedApplication].statusBarStyle;
    
    _oldNavBarTintColor = [self.navigationController.navigationBar.tintColor retain];
    _oldNavBarStyle = self.navigationController.navigationBar.barStyle;
    _oldNavBarTranslucent = self.navigationController.navigationBar.translucent;
    
    _oldToolBarTintColor = [self.navigationController.toolbar.tintColor retain];
    _oldToolBarStyle = self.navigationController.toolbar.barStyle;
    _oldToolBarTranslucent = self.navigationController.toolbar.translucent;
    _oldToolBarHidden = [self.navigationController isToolbarHidden];
    
    _storedOldStyles = YES;
    
    
}


- (void)restoreStyle {
    self.navigationController.navigationBar.barStyle = _oldNavBarStyle;
	self.navigationController.navigationBar.tintColor = _oldNavBarTintColor;
	self.navigationController.navigationBar.translucent = _oldNavBarTranslucent;
	
	[[UIApplication sharedApplication] setStatusBarStyle:_oldStatusBarSyle animated:YES];
	
	if (!_oldToolBarHidden) {
		if ([self.navigationController isToolbarHidden]) {
			[self.navigationController setToolbarHidden:NO animated:YES];
		}
		
		self.navigationController.toolbar.barStyle = _oldNavBarStyle;
		self.navigationController.toolbar.tintColor = _oldNavBarTintColor;
		self.navigationController.toolbar.translucent = _oldNavBarTranslucent;
	} else {
		[self.navigationController setToolbarHidden:_oldToolBarHidden animated:YES];
	}
    
    self.navigationController.navigationBar.backgroundColor = _oldNavBarBgColor;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5")) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Bg_Red"] forBarMetrics:UIBarMetricsDefault];
    } else {
        self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Bg_Red"]];
    }
}


#pragma mark -
#pragma mark PhotoViewToggleBarNotification

- (void)photoViewToggleBarNotification {
    BOOL hidden = !self.navigationController.navigationBarHidden;
    BOOL animated = YES;
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationFade];
    
    [self.navigationController setNavigationBarHidden:hidden animated:animated];
    if (!_oldToolBarHidden) {
        [self.navigationController setToolbarHidden:hidden animated:animated];
    }
    
    //    _caption.hidden = hidden;
    if (hidden) {
        [self hideCaptionText];
    } else {
        [self showCaptionText];
    }
    
    if (hidden) {
        [(AppDelegate*)[[UIApplication sharedApplication]delegate] hideADViewWithAnimate];
    } else {
        [(AppDelegate*)[[UIApplication sharedApplication]delegate] showADViewWithAnimate];
    }
}


#pragma mark - PhotoDataSourceDelegate methods


- (void)resultALAsset:(ALAsset *)asset atIndex:(NSInteger)index{
    
    
    for (PhotoView * pv in _visiblePages) {
        if (pv.index == index) {
            NSLog(@"delegate set photo at index: %d",index);
            PhotoData * pData = [_photoDataSource.photoCache objectForKey:[NSNumber numberWithInt:index]];
            [pv setPhoto:pData];
            //            [self showCaptionText];
            [self setCaptionText];
            [self showMapButton:YES];
        } 
    }
    
}

- (void)didFaildToLoadImage:(NSInteger)index{ // not working at all
    for (PhotoView * pv in _visiblePages) {
        if (pv.index == index) {
            NSLog(@"delegate failed photo at index: %d",index);
            [pv showBlankImage];
        } 
    }
}

- (void)setPhotoDataSource:(PhotoDataSource *)photoDataSource{
    if (_photoDataSource) {
        [_photoDataSource release];
        _photoDataSource = nil;
    }
    
    _photoDataSource = [photoDataSource retain];
    
    _photoDataSource.delegate = self;
}

- (void)setCaptionText{
    // set text for caption
    for (PhotoView * pv in _visiblePages) {
        if (pv.index == _pageNum) {
            [_captionToolBar setLocationString:nil andTimestamp:pv.photodata.datetime];
        } 
    }
}

- (void)showCaptionText{
    
    //    for (PhotoView * pv in _visiblePages) {
    //        if (pv.index == _pageNum) {
    //            if (_justIndex==pv.index) {
    //                return;
    //            } else {
    //                _justIndex = pv.index;
    //            }
    //        } 
    //    }
    
    
    
    [UIView animateWithDuration:.2 
                     animations:^{
                         [_captionToolBar showView];
                     } 
                     completion:^(BOOL finished){}];
}

- (void)hideCaptionText{
    [UIView animateWithDuration:.2 
                     animations:^{
                         
                         [_captionToolBar hideView];
                     } 
                     completion:^(BOOL finished){}];
    
}


- (void)showMapButton:(BOOL)show{
    
    [self checkCurrentPageStatus];
    
    if (show) {
        
        if (_currentPageHasLocation) {
            self.navigationItem.rightBarButtonItem.customView.hidden = NO;
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
        } else {
            self.navigationItem.rightBarButtonItem.customView.hidden = YES;
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
        }
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;            
    }
    
    
    if (_currentPageHasPhoto&&_currentPageTypePhoto) {
        _captionToolBar.modifyButton.hidden = NO;
    } else {
        _captionToolBar.modifyButton.hidden = YES;
    }
    
    
    
}


- (void)checkCurrentPageStatus{
    _currentPageHasLocation = NO;
    _currentPageHasPhoto = NO;
    for (PhotoView * pv in _visiblePages) {
        if (pv.index == _pageNum) {
            if (pv.photodata.image) {
                _currentPageHasPhoto = YES;
                
                if (!(pv.photodata.coordinate.longitude == EmptyLocation && pv.photodata.coordinate.latitude == EmptyLocation) &&  !(pv.photodata.coordinate.longitude == 0 && pv.photodata.coordinate.latitude == 0)) {
                    
                    _currentPageHasLocation = YES;
                }
            }
            
            if ([pv.photodata.assetType isEqualToString:ALAssetTypePhoto]) {
                _currentPageTypePhoto = YES;
            }
            
            break;
            
        } 
    }
}

#pragma mark - PhotoViewDelegate methods

- (void)playVideo:(MPMoviePlayerViewController *)mp {
    mapCalled = YES;
    [[self _navigation] presentMoviePlayerViewControllerAnimated:mp];
    //    [[self _navigation] presentModalViewController:mp animated:NO];
}




#pragma mark - LocationChoosingControllerDelegate method

- (void) didSelectedCell{
    
//    [self performSelector:@selector(hideLocationView) withObject:nil afterDelay:.5];
}


#pragma mark -
#pragma mark PhotoViewShareAction

- (void) shareActionCalled{
    
    UIImage *image;
    for (PhotoView *page in _visiblePages) {
        if (page.index==_currentPage) {
            image = page.photodata.image;
            break;
        }
    }
    
    
    
    // Create the item to share (in this example, a url)
	SHKItem *item = [SHKItem image:image title:@"Uploaded from PhotoCal"];
    [item setShareType:SHKShareTypeImage];
    
    
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
	// Display the action sheet
	[actionSheet showInView:_scrollView];
}


- (void)refresh{
    
}



@end
