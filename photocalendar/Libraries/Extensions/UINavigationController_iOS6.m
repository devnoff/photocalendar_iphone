//
//  UINavigationController_iOS6.m
//  photocalendar
//
//  Created by Yongnam Park on 12. 12. 20..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "UINavigationController_iOS6.h"

@implementation UINavigationController(Rotate_iOS6)

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return self.topViewController.preferredInterfaceOrientationForPresentation;
}
@end
