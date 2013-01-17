//
//  LoadingViewController.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 5..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
//#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseViewController.h"


@protocol LoadingViewControllerDelegate;
@interface LoadingViewController : BaseViewController{
    int cnt;
    int _curCnt;
    id<LoadingViewControllerDelegate> _delegate;
    
    IBOutlet UIProgressView * _progView;
    IBOutlet UILabel * _progDesc;
    IBOutlet UIActivityIndicatorView * _activity;
    
    ALAssetsLibrary * _assetsLibrary;
    
    NSMutableDictionary * _monthGroup;
    NSMutableDictionary * _dateGroup;
    NSMutableDictionary * _photos;
    NSDateFormatter * _formatter;
    
    NSSet * _choosenGroup;
    
    
    
    NSMutableDictionary * _groupsDB;
    NSMutableDictionary * _photosDB;
    NSSet * _groupDBKeys;
    NSSet * _photosDBKeys;
    
    
    NSMutableDictionary * _urlsGroup;
    NSManagedObjectContext * _context;
    
    
    dispatch_queue_t collectQueue;
    
    int sync;
    
    NSMutableSet *_deletablePhotos;
    
    BOOL _workingProgress;
}



@property (nonatomic,retain) id<LoadingViewControllerDelegate> delegate;
@property (nonatomic,retain) NSSet * choosenGroup;

- (void)startLoading;

@end

@protocol LoadingViewControllerDelegate <NSObject>
@optional
- (void) didFinishedLoading;
- (void) didFailedLoading;
- (void) didFinishLoadindWithNoPhoto;
@end