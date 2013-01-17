//
//  BaseViewController.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 7..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "ChoosingGroupViewController.h"
#import "UINavigationController_iOS6.h"
#import "PhotoViewController.h"

@implementation BaseViewController

- (void)dealloc{
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    resized = NO;
    
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Bg"]]];
    [self.view setBackgroundColor:RGB(51, 51, 51)];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    
    if (!HAS_UPGRADED&&!resized) {
        for(id child in self.view.subviews){
            if ([child isKindOfClass:[UITableView class]]&&![self isKindOfClass:[ChoosingGroupViewController class]]) {
                CGRect frame = ((UITableView*)child).frame;
                frame.size.height = frame.size.height - 50;    
                [(UITableView*)child setFrame:frame];
                
            }    
        }
        
        resized = YES;
    }
    
    
    [(AppDelegate*)[[UIApplication sharedApplication]delegate] showADViewWithAnimate]; // 광고 보이기
    
    
    
}


- (NSManagedObjectContext*) _context{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
}

- (UINavigationController*) _navigation{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] navCon];
}


- (BOOL)shouldAutorotate{
    
    if ([self isKindOfClass:[PhotoViewController class]]){
        return YES;
    }
    return NO;
}

- (NSInteger)supportedInterfaceOrientations{
    
    if ([self isKindOfClass:[PhotoViewController class]]){
        return UIInterfaceOrientationMaskAll;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}


@end
