//
//  PhotoViewController.h
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 30..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PhotoDataSource.h"
#import "PhotoView.h"
#import "CaptionView.h"
#import "BaseViewController.h"
#import "PPCaptionView.h"


@interface PhotoViewController : BaseViewController <UIScrollViewDelegate,PhotoDataSourceDelgate,PhotoViewDelegate,PPCaptionViewDelegate,UIActionSheetDelegate> {
@private
    UIScrollView *_scrollView;
    CaptionView *_captionView;
    
    PhotoDataSource *_photoDataSource;
    
    NSMutableSet *_visiblePages;
	NSMutableSet *_recycledPages;
    
    NSUInteger _currentPage;
    
    BOOL _rotating;
    
    
    BOOL _storedOldStyles;
	UIStatusBarStyle _oldStatusBarSyle;
	UIBarStyle _oldNavBarStyle;
	BOOL _oldNavBarTranslucent;
	UIColor* _oldNavBarTintColor;	
	UIBarStyle _oldToolBarStyle;
	BOOL _oldToolBarTranslucent;
	UIColor* _oldToolBarTintColor;	
	BOOL _oldToolBarHidden;
    
    UIColor * _oldNavBarBgColor;
    
    
    NSMutableDictionary * _photoContainer;
    
    NSInteger _pageNum;
    
    NSString * _backStr;
    
    BOOL mapCalled;
    
    
    // captions
    PPCaptionView * _captionToolBar;
    
    int _justIndex;
    
    

    
    
    // rotate
    BOOL _rotate;
    UIInterfaceOrientation _orientation;
    
    // enable modify
    BOOL _modifyLocked;
    
    
    // action sheets    
    UIActionSheet *_moreSheet;
    
    
    BOOL _currentPageHasLocation;
    BOOL _currentPageHasPhoto;
    BOOL _currentPageTypePhoto;
    
}


@property (nonatomic, retain) PhotoDataSource *photoDataSource;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) BOOL modifyLocked;


- (void)setDefaultPage:(NSInteger)page;
- (void)resizeContent;

@end
