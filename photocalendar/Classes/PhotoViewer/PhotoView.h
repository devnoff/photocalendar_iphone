//
//  PhotoImageView.h
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 30..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "EGOImageLoader.h"
#import "PhotoData.h"
#import "PhotoZoomView.h"


@protocol PhotoViewDelegate;

@interface PhotoView : UIView <EGOImageLoaderObserver,UIScrollViewDelegate> {
@private
    PhotoZoomView *_zoomView;
    UIImageView *_imageView;
	UIActivityIndicatorView *_activityView;
    
    PhotoData *_photoData;
    
    NSUInteger _index;
    
    UILabel * _caption;
    
    UIButton * _playButton;
    CGSize _playBtnSize;
    
    id<PhotoViewDelegate> _delegate;
    
    BOOL _landcape;
    
    UIView *_blankView;
}


@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, retain) PhotoData * photodata;
@property (nonatomic, assign) id<PhotoViewDelegate> delegate;
@property (nonatomic, assign) BOOL landcape;

- (void)setPhoto:(PhotoData *)photoData;

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation;

- (void)resetView;

- (void)setImageViewAlpha:(float)alpha;

- (BOOL)hasImage;

- (void)showBlankImage;

- (NSInteger)getWidthOfView;

- (void)restoreZoom;

@end

@protocol PhotoViewDelegate <NSObject>

- (void)playVideo:(MPMoviePlayerViewController*)mp;

@end