//
//  AppDelegate.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 21..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "LocationServiceViewController.h"
#import "AlbumsViewController.h"
#import "NoPhotoView.h"
#import "KalViewController.h"
#import "CSAdController.h"
#import "SHKConfiguration.h"
#import "SHKFacebook.h"
#import "SHKConfiguration.h"
#import "MySHKConfigurator.h"
#import "Flurry.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize navCon = _navCon;
@synthesize ADContainer = _ADContainer;
@synthesize bannerView=_bannerView;
//@synthesize rootViewController = _rootViewController;

- (void)dealloc
{
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [_requstController release];
    [_navCon release];
    [_passcodeViewController release];
    if (_locationManager) {
        _locationManager.delegate = nil;
        [_locationManager release];    
    }
    [self releaseBackgroundLoading];
    
    [self releaseAdView];
    
    if (_library){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:_library];    
        [_library release];
    }
    
    [super dealloc];
}

- (void)releaseBackgroundLoading{
    
    
    [_navCon finishSync];
    
    if (_backLoading){
        _backLoading.delegate = nil;
        [_backLoading release];
        _backLoading = nil;
    }
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // 앱을 처음 실행시 FOR SHOWING PULL DOWN MSG
//    FIRST(YES);
//    SYNC_USER_DEFAULT;
    
    DefaultSHKConfigurator *configurator = [[[MySHKConfigurator alloc] init] autorelease];
    [SHKConfiguration sharedInstanceWithConfigurator:configurator];

     
    if (SYSTEM_VERSION_LESS_THAN(@"5.0")) {
        if (!HAS_DATA_LOADED) {
            _locationManager = [[CLLocationManager alloc]init];
            _locationManager.delegate = self;
            [_locationManager startUpdatingLocation];  
        }    
    }
    
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = RGB(51, 51, 51);
    
    
    _requstController = [[RequestController alloc] init];

    
    // 데이터가 로드 된 적이 없거나, 현재버전의 정보가 없거나 저장된 버전 정보가 1.5보다 낮은 경우 로딩을 다시함
    if (!HAS_DATA_LOADED || !GET_APP_VERSION || APP_VERSION_LESS_THAN(@"1.5")) {//|| APP_VERSION_LESS_THAN(@"1.4")
        [self loadLoadingViewController];
    } else {
        [self loadRootViewController];
        [self runBackgroundLoading];
    }
    
    
    
    
    [self.window makeKeyAndVisible];
    [self checkPassword];
    
    
    
    _library = [[ALAssetsLibrary alloc] init];
    [_library writeImageToSavedPhotosAlbum:nil 
                                  metadata:nil 
                           completionBlock:^(NSURL *assetURL, NSError *error) {
                               [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveALAssetsNotification:) 
                                                                            name:ALAssetsLibraryChangedNotification object:_library];
                            }];
    
    
// for testing    
//    [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:CSAD_HIDE_FOR_30_DAYS_FROM];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    // Flurry Start
    [Flurry startSession:@"8Y3QCSZ54N3CQ56KT2M3"];
    
    
    return YES;
}

- (void)runBackgroundLoading{
    
    NSLog(@"runBackgroundLoading");
    
    if (_backLoading==nil){
        _backLoading = [[BackgroundLoadingController alloc] init];
        _backLoading.delegate = self;
        [_navCon startSync];
    }
}

- (BOOL)isRunningBackgroundLoading{
    if(_backLoading==nil) return NO;
    return YES;
}

- (void)loadRootViewController{
       
    NSLog(@"loadRootViewController");
    if (!_navCon) {
        
        RootViewController * _rootViewController = [[RootViewController alloc] initWithNibName:@"RootViewController" bundle:nil]; 
        _navCon = [[MainViewController alloc] initWithRootViewController:_rootViewController];
        [_rootViewController release];
        
        [_navCon.navigationBar setAlpha:0.0f];
        
        // navigation view controller style
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5")) {
            _navCon.view.backgroundColor = [UIColor blackColor];
            [_navCon.navigationBar setBackgroundImage:[UIImage imageNamed:@"Bg_Red"] forBarMetrics:UIBarMetricsDefault];
            
        } else {
            _navCon.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Bg_Red"]];
        }
    } else {
        [_navCon dismissModalViewControllerAnimated:YES];
    }
    
    
    self.window.rootViewController = _navCon;
    [UIView animateWithDuration:.3 
                     animations:^{
                         if (_navCon.view.alpha==0) {
                             _navCon.view.alpha = 1.0f;    
                         }
                         [_navCon.navigationBar setAlpha:1.0f];
                     } 
                     completion:^(BOOL finished){}];
    
    
    
    
    [self showAdView];
    
    
}

- (void) loadLoadingViewController{


    NSLog(@"loadLoadingViewController");
    
    /*
     * 전체 로딩
     */
    NewLoadingViewController * loading = [[NewLoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
    loading.delegate = self;
    loading.view.alpha = 0.0f;
    self.window.rootViewController = loading;
    [loading release];
    
    [UIView animateWithDuration:.3 
                     animations:^{
                         loading.view.alpha = 1.0f;
                     } 
                     completion:^(BOOL finished){

                     }];
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    
    NSLog(@"Application Will Resign Active");

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if (_navCon.modalViewController) {
        if ([_navCon.modalViewController isKindOfClass:[LocationServiceViewController class]]) {
            [(LocationServiceViewController*)_navCon.modalViewController closeBtnTapped:nil];
        }
    }
    

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"applicationWillEnterForeground");
//    if (GET_APP_VERSION && !APP_VERSION_LESS_THAN(@"1.5")) {//|| APP_VERSION_LESS_THAN(@"1.4")
//        [self runBackgroundLoading];    
//    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"applicationDidBecomeActive");
    [self showAdView];
    [self checkPassword];
    
    
    // 광고 요청
    if (!HAS_UPGRADED)
        [CSAdController requestFullscreenADForViewController:self.window.rootViewController];
    
    [SHKFacebook handleDidBecomeActive];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    NSLog(@"applicationWillTerminate");
//    [SHKTwitter logout];
//    [SHKFacebook logout];
    [self saveContext];
    
    
    // Save data if appropriate
    [SHKFacebook handleWillTerminate];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) 
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}


- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"photocalendar" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    NSString * newFileName = GET_DB_FILE_NAME;
    
    if (__persistentStoreCoordinator != nil && !newFileName)
    {
        return __persistentStoreCoordinator;
    }
    
    // DB 파일명으로 1.5 버전 전후가 구분됨
    NSString * fileName = newFileName?newFileName:@"photocalendar.sqlite";
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:fileName];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

- (NSPersistentStoreCoordinator *)newPersistentStoreCoordinatorWithName:(NSString *)fileName
{
    NSPersistentStoreCoordinator *persc = nil;
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:fileName];
    
    NSError *error = nil;
    persc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persc;
}


- (BOOL)releasePersistantStoreCoordinator{
    
    BOOL success = NO;
    
    NSString * newFileName = GET_DB_FILE_NAME;
    NSString * fileName = newFileName?newFileName:@"photocalendar.sqlite";
    
    NSString * storePath = [DOCUMENT_FOLDER stringByAppendingPathComponent:fileName];
    
    NSFileManager *fManager = [NSFileManager defaultManager];
    if ([fManager isDeletableFileAtPath:storePath]) {
        NSError * err;
        
        if ([fManager removeItemAtPath:storePath error:&err]) {
            if (__persistentStoreCoordinator!=nil) {
                [__persistentStoreCoordinator release];
                __persistentStoreCoordinator = nil;    
            }
            
            if (__managedObjectContext!=nil) {
                [__managedObjectContext release];
                __managedObjectContext = nil;
            }
            
            
            if (__managedObjectModel) {
                [__managedObjectModel release];
                __managedObjectModel = nil;
            }
            
            success = YES;
            NSLog(@"success removing core data");
            
        } else {
            if (err) {
                NSLog(@"error to remove: %@",err);
            }    
        }
        
    }
    return success;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark - BackgroundLoadingControllerDelegate method
- (void) backgroundLoadingDidFinishedLoadingWithAssetsLibrary:(ALAssetsLibrary *)library{
    
    
    if (_library){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:_library];
        [_library release];
        _library = nil;
    }
    
    _library = [library retain];
    
//    
//    [_library writeImageToSavedPhotosAlbum:nil 
//                                  metadata:nil 
//                           completionBlock:^(NSURL *assetURL, NSError *error) {
//                               [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveALAssetsNotification:) 
//                                                                            name:ALAssetsLibraryChangedNotification object:_library];
//                           }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveALAssetsNotification:) 
                                                 name:ALAssetsLibraryChangedNotification object:_library];
    
    NSLog(@"finish loading");
    _refreshing = NO;
    
    if (_navCon) {
        for (UIViewController *vc in [_navCon childViewControllers]) {
            
            if ([vc isKindOfClass:[BaseViewController class]]){
//                if([vc isViewLoaded]&&vc.view.window)
                [(BaseViewController *)vc refresh];
            }
            
            if ([vc isKindOfClass:[RootViewController class]]) {
                NSArray * arr = ((RootViewController*)vc).controllers;
                for(UIViewController *vvc in arr){
                    if ([vvc isKindOfClass:[BaseViewController class]]){
//                        if([vvc isViewLoaded]&&vvc.view.window)
                        [(BaseViewController *)vvc refresh];
                    }
                    
                    if ([vvc isKindOfClass:[AlbumsViewController class]]) {
                        for(UIView * sv in [vvc.view subviews]){
                            if ([sv isKindOfClass:[NoPhotoView class]]) {
                                [sv removeFromSuperview];
//                                break;
                            }
                        }
                    }
                }
            }
        }
    }
    
    [self releaseBackgroundLoading];
}


- (void)backgroundLoadingDidFailedLoading{
    _refreshing  = NO;
//    [self loadRootViewController];
    
    LocationServiceViewController * lsv = [[LocationServiceViewController alloc] initWithNibName:@"LocationServiceViewController" bundle:nil];
    [_navCon presentModalViewController:lsv animated:YES];
    
    [lsv release];
    
    [self releaseBackgroundLoading];
}

- (void) backgroundLoadingDidFinishLoadindWithNoPhoto{
    _refreshing = NO;
    //    [self loadRootViewController];
    
    for(UIViewController *vc in [_navCon childViewControllers]){
        if ([vc isKindOfClass:[BaseViewController class]]){
            //                if([vc isViewLoaded]&&vc.view.window)
            [(BaseViewController *)vc refresh];
        }
        
        if ([vc isKindOfClass:[RootViewController class]]) {
            NSArray * arr = ((RootViewController*)vc).controllers;
            for(UIViewController *vvc in arr){
                if ([vvc isKindOfClass:[BaseViewController class]]){
                    //                        if([vvc isViewLoaded]&&vvc.view.window)
                    [(BaseViewController *)vvc refresh];
                }

                if ([vvc isKindOfClass:[AlbumsViewController class]]) {
                    NoPhotoView *noView = [[NoPhotoView alloc]initWithFrame:vvc.view.frame];
                    [vvc.view insertSubview:noView atIndex:0];
                    [noView release];
                    break;
                }
            }
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ZERO_PHOTO"];
    SYNC_USER_DEFAULT;
    
    [self releaseBackgroundLoading];
}

- (void) backgroundLoadingUpdateUIProcessingValue:(int)current total:(int)total title:(NSString *)title{
    
    double c = current+0.0;
    double t = total+0.0;
    double p = c/t*100;
    int per = p;
//    NSLog(@"loading current: %d / %d / %@", current, total, title);
    if (title==nil){
        [_navCon updateProgress:[NSString stringWithFormat:@" %d%%",per]];
    }
}


#pragma mark - LoadingViewControllerDelegate method

- (void) didFinishedLoadingWithAssetsLibrary:(ALAssetsLibrary *)library{
    
    if (_library){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ALAssetsLibraryChangedNotification object:_library];
        [_library release];
        _library = nil;
    }
    
    _library = [library retain];
    
    ALAssetsLibrary *notificationSender = nil;
    
    NSString *minimumSystemVersion = @"4.1";
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    if ([systemVersion compare:minimumSystemVersion options:NSNumericSearch] != NSOrderedAscending)
        notificationSender = library;
    
//    [_library writeImageToSavedPhotosAlbum:nil 
//                                  metadata:nil 
//                           completionBlock:^(NSURL *assetURL, NSError *error) {
//                               [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveALAssetsNotification:) 
//                                                                            name:ALAssetsLibraryChangedNotification object:_library];
//                           }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveALAssetsNotification:) 
                                                 name:ALAssetsLibraryChangedNotification object:_library];

    
    
    NSLog(@"finish loading");
    _refreshing = NO;
    
    if (_navCon) {
        for (UIViewController *vc in [_navCon childViewControllers]) {
            if ([vc isKindOfClass:[RootViewController class]]) {
                NSArray * arr = ((RootViewController*)vc).controllers;
                for(UIViewController *vvc in arr){
                    if ([vvc isKindOfClass:[AlbumsViewController class]]) {
                        for(UIView * sv in [vvc.view subviews]){
                            if ([sv isKindOfClass:[NoPhotoView class]]) {
                                [sv removeFromSuperview];
                                break;
                            }
                        }
                    }
                }
            }
        }
    }
    
    [self loadRootViewController];
}


- (void) didFailedLoading{
    _refreshing  = NO;
    [self loadRootViewController];
    
    LocationServiceViewController * lsv = [[LocationServiceViewController alloc] initWithNibName:@"LocationServiceViewController" bundle:nil];
    [_navCon presentModalViewController:lsv animated:YES];
    
    [lsv release];
    
}

- (void) didFinishLoadindWithNoPhoto{
    _refreshing = NO;
    [self loadRootViewController];
    
    for(UIViewController *vc in [_navCon childViewControllers]){
        if ([vc isKindOfClass:[RootViewController class]]) {
            NSArray * arr = ((RootViewController*)vc).controllers;
            for(UIViewController *vvc in arr){
                if ([vvc isKindOfClass:[AlbumsViewController class]]) {
                    NoPhotoView *noView = [[NoPhotoView alloc]initWithFrame:vvc.view.frame];
                    [vvc.view insertSubview:noView atIndex:0];
                    [noView release];
                    break;
                }
            }
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ZERO_PHOTO"];
    SYNC_USER_DEFAULT;

}



#pragma mark -


- (void)showADViewWithAnimate{
    if (_ADContainer) {
        CGRect newFrame = _ADContainer.frame;
        int add=0;
        if (_navCon.view.frame.size.height<416) {
            add = 416+50;
        } else {
            add = _navCon.view.frame.size.height;
        }
        newFrame.origin.y = add-50;
        [UIView animateWithDuration:.2 
                         animations:^{
                             _ADContainer.frame = newFrame;
                         } 
                         completion:^(BOOL finished){
                             
                         }];
    }
}

- (void)hideADViewWithAnimate {
    if (_ADContainer) {
        CGRect newFrame = _ADContainer.frame;
        newFrame.origin.y = _navCon.view.frame.size.height+50;
        [UIView animateWithDuration:.2 
                         animations:^{
                             _ADContainer.frame = newFrame;
                         } 
                         completion:^(BOOL finished){
                             
                         }];
    }
}



- (void) releaseAdView{
    if (_bannerView) {
        _bannerView.delegate = nil;
//        NSLog(@"bannerview retaincount: %d", [_bannerView retainCount]);
        [_bannerView release];
        _bannerView = nil;
    }
    
    if (_ADContainer) {
        [_ADContainer removeFromSuperview];
        [_ADContainer release];
        _ADContainer = nil;
    }
}

- (void) showAdView{
    if (!HAS_UPGRADED) {
        
        //[self releaseAdView];
        
        if (!_ADContainer) {
            _ADContainer = [[UIView alloc] initWithFrame:CGRectMake(0, _navCon.view.frame.size.height-50, _navCon.view.frame.size.width, 50)];
            _ADContainer.backgroundColor = [UIColor colorWithWhite:.1 alpha:1];
        } else {
            [_ADContainer removeFromSuperview];
        }
        
        _ADContainer.frame = CGRectMake(0, _navCon.view.frame.size.height-50, _navCon.view.frame.size.width, 50);
        [_navCon.view addSubview:_ADContainer];
        [_navCon.view bringSubviewToFront:_ADContainer];
        
        
        //////// admob
        
        
        // Create a view of the standard size at the bottom of the screen.
        if (!_bannerView) {
            
            _bannerView = [[GADBannerView alloc]
                           initWithFrame:CGRectMake(0.0,
                                                    0.0,
                                                    GAD_SIZE_320x50.width,
                                                    GAD_SIZE_320x50.height)];
            
            // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
            _bannerView.adUnitID = MY_BANNER_UNIT_ID;
            
            // Let the runtime know which UIViewController to restore after taking
            // the user wherever the ad goes and add it to the view hierarchy.
            [_ADContainer addSubview:_bannerView];
            [_bannerView setDelegate:self];
        } else {
            [_ADContainer bringSubviewToFront:_bannerView];
        }
        
        
        if (!_bannerView.rootViewController)
            _bannerView.rootViewController = _navCon;
        
        if (_bannerView.rootViewController) {
            // Initiate a generic request to load it with an ad.
            GADRequest *gRequest = [GADRequest request];
            [gRequest setLocationWithDescription:[[NSLocale currentLocale]objectForKey:NSLocaleCountryCode]];
            [_bannerView loadRequest:gRequest];
              
        }
        

        
        
    }
}

- (void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"ad error: %@",error);
    
}

#pragma mark - passcodeviewcontroller delegate

- (void) passcodeCorrect:(NSString*)passcode{
    
}
- (void) passcodeCancelled{
    
}
- (BOOL) compareWithCode:(NSString*)code{
    return [code isEqualToString:GET_PASSCODE];
}

- (void) checkPassword{
    if (GET_PASSCODE) {
        PasscodeViewController * passvc = [[PasscodeViewController alloc] initForUnLock];        
        passvc.delegate = self;
        
        UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:passvc];
        //        navc.navigationBarHidden = YES;
        [_navCon presentModalViewController:navc animated:YES];
        [navc release];
        
    }
}

#pragma mark - 

- (void) didReceiveALAssetsNotification:(NSNotification*)notification{
    
    NSLog(@"didReceiveALAssetsNotification: %@", notification);    

    if (!_refreshing)
        [self refresh];
}

- (void) refresh{
    
    _refreshing = YES;

    [self runBackgroundLoading];
//    
//    
//    
//    ChoosingGroupViewController * chooseVC = [[ChoosingGroupViewController alloc] initWithNibName:@"ChoosingGroupViewController" bundle:nil];
//    [_navCon presentModalViewController:chooseVC animated:YES];
//    [chooseVC release];
    
    
    
}



- (void) removeAds{
    UINavigationController * navCon = [self navCon];
    NSArray * controllers = [navCon childViewControllers];
    for(UIViewController *vc in controllers){
        
        if ([vc isKindOfClass:[RootViewController class]]) {
            for(UIViewController* vcon in ((RootViewController*)vc).controllers){
                for(id child in vcon.view.subviews){
                    if ([child isKindOfClass:[UITableView class]]) {
                        CGRect frame = ((UITableView*)child).frame;
                        frame.size.height = frame.size.height + 50;
                        [(UITableView*)child setFrame:frame];
                    }    
                }
                
                if ([vcon isKindOfClass:[KalViewController class]]) {
                    ((KalViewController*)vcon).view.frame = FULL_FRAME;
                }
                
            }    
        }
    }
}



#pragma mark -
#pragma mark 4.X 버전에서 설정에 위치서비스가 등록이 안되는 무제를 해결하기 위한 꼼수!!!

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"locationManager didUpdateToLocation");
    
    [manager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"locationManager didFailWithError %@",error);
    
    [manager stopUpdatingLocation];
}



#pragma mark - 

- (BOOL)handleOpenURL:(NSURL*)url
{
    NSString* scheme = [url scheme];
    NSString* prefix = [NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)];
    if ([scheme hasPrefix:prefix])
        return [SHKFacebook handleOpenURL:url];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self handleOpenURL:url];
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [self handleOpenURL:url];
}


@end
