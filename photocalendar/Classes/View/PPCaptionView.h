//
//  PPCaptionView.h
//  PhotoCal
//
//  Created by Park Yongnam on 11. 11. 29..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PPCaptionViewDelegate;
@interface PPCaptionView : UIView{
    UIImageView *_bgView;
    UILabel *_timeLabel;
    UILabel *_locationLabel;
    
    UIButton *_modifyButton; // --> 공유 버튼
    
    id<PPCaptionViewDelegate> _delegate;
    
    BOOL _hidden;
    
    int ads_height;
    
    BOOL _landscape;
    
    int ads;
}
@property (nonatomic,assign) id<PPCaptionViewDelegate> delegate;
@property (nonatomic,assign) BOOL hidden;
@property (nonatomic,retain) UIButton *modifyButton;

- (void) setLocationString:(NSString *)locationStr andTimestamp:(NSDate *)datetime;

- (void) hideView;
- (void) showView;

- (void) modifyButtonTapped:(id)sender;

- (void) fitToView:(UIInterfaceOrientation)orientation;

- (void) setModifyButtonText:(NSString *)text;

@end

@protocol PPCaptionViewDelegate <NSObject>

//- (void) modifyButtonTapped;

@end