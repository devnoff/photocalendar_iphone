//
//  MainViewController.m
//  PhotoCal
//
//  Created by Park Yongnam on 11. 12. 16..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import "PhotoViewController.h"

@implementation MainViewController



- (void)dealloc{

    [_customStatusBar release];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UINavigationShouldRestoreRotation" object:nil];
    [super dealloc];
}


- (void)viewDidLoad{
    [super viewDidLoad];
    [self initialize];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restoreRotation) name:@"UINavigationShouldRestoreRotation" object:nil];
}

- (void)initialize{
    
    NSLog(@"MainViewController initialize");
    
    if (!_customStatusBar)
        _customStatusBar = [[CustomStatusBar alloc] initWithFrame:CGRectZero];
}


- (void)startSync{
    NSLog(@"MainViewController startSync");
    if (_customStatusBar)
        [_customStatusBar start];
}
- (void)finishSync{
    NSLog(@"MainViewController finishSync");
    if (_customStatusBar)
        [_customStatusBar finish];
}


- (void)updateProgress:(NSString*)progress{
    if (_customStatusBar){
        [_customStatusBar updateCurrentProcess:progress];
    }
}


//- (BOOL)shouldAutorotate{
//    if ([self.topViewController isKindOfClass:[PhotoViewController class]]){
//        return YES;
//    }
//
//    return NO;
//}
//
//
//
//- (NSInteger)supportedInterfaceOrientations{
//    
//    if ([self.topViewController isKindOfClass:[PhotoViewController class]]){
//        return UIInterfaceOrientationMaskAll;
//    }
//    return 0;
//}


#define degreesToRadian(x) (M_PI * (x) / 180.0)
- (void)restoreRotation{
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
    //뷰 회전 시키기
    CGAffineTransform transform = CGAffineTransformMakeRotation(degreesToRadian(0));
    self.navigationController.view.transform = transform;
    self.navigationController.view.bounds = CGRectMake(0, 0, 480, 320);

}

@end
