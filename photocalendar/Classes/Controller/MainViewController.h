//
//  MainViewController.h
//  PhotoCal
//
//  Created by Park Yongnam on 11. 12. 16..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomStatusBar.h"

@interface MainViewController : UINavigationController{
    
    CustomStatusBar * _customStatusBar;
    
    BOOL _shouldRestoreRotation;
}

- (void)initialize;
- (void)startSync;
- (void)finishSync;
- (void)updateProgress:(NSString*)progress;
- (void)restoreRotation;
@end
