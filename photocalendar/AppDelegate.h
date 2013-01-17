//
//  AppDelegate.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 21..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RootViewController.h"
#import "NewLoadingViewController.h"
#import "RequestController.h"
#import "GADBannerView.h"
#import "PasscodeViewController.h"
#import "ChoosingGroupViewController.h"
#import "BackgroundLoadingController.h"
#import "MainViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,NewLoadingViewController,NSFetchedResultsControllerDelegate,GADBannerViewDelegate,PasscodeViewControllerDelegate,CLLocationManagerDelegate,BackgroundLoadingControllerDelegate>{
//    RootViewController * _rootViewController;
    MainViewController * _navCon;
    NewLoadingViewController *_loadingViewController;
    RequestController * _requstController;
    
    GADBannerView * _bannerView;
    
    UIView * _ADContainer;
    
    PasscodeViewController * _passcodeViewController;
    
    BOOL _refreshing;
    
    CLLocationManager *_locationManager;
    
    BackgroundLoadingController *_backLoading;
    
    ALAssetsLibrary *_library;
}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) UINavigationController * navCon;
//@property (nonatomic, retain) RootViewController * rootViewController;

@property (nonatomic, retain) UIView * ADContainer;

@property (nonatomic, retain) GADBannerView * bannerView;

- (NSPersistentStoreCoordinator *)newPersistentStoreCoordinatorWithName:(NSString *)fileName;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (BOOL)releasePersistantStoreCoordinator;

- (void) loadRootViewController;
- (void) loadLoadingViewController;
- (void) didReceiveALAssetsNotification:(NSNotification*)notification;

- (void)showADViewWithAnimate;
- (void)hideADViewWithAnimate;

- (void) releaseAdView;
- (void) showAdView;

- (void) checkPassword;

- (void) refresh;
- (void) removeAds;

- (void)releaseBackgroundLoading;
- (void)runBackgroundLoading;
- (BOOL)isRunningBackgroundLoading;
@end
