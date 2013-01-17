//
//  NewLoadingViewController.h
//  photocalendar
//
//  Created by Park Yongnam on 12. 1. 11..
//  Copyright (c) 2012 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BackgroundLoadingController.h"

@protocol NewLoadingViewController;
@interface NewLoadingViewController : UIViewController <BackgroundLoadingControllerDelegate>{
    
    id<NewLoadingViewController> _delegate;
    
    IBOutlet UIProgressView * _progView;
    IBOutlet UILabel * _progDesc;
    IBOutlet UIActivityIndicatorView * _activity;
    
    BackgroundLoadingController *_backLoading;
}

@property (nonatomic,assign) id<NewLoadingViewController> delegate;


- (void)updateProgressWithValues:(NSInteger)currCnt totalCnt:(NSInteger)totalCnt withTitle:(NSString*)title;


@end



@protocol NewLoadingViewController <NSObject>

- (void) didFinishedLoadingWithAssetsLibrary:(ALAssetsLibrary *)library;
- (void) didFailedLoading;
- (void) didFinishLoadindWithNoPhoto;
@end