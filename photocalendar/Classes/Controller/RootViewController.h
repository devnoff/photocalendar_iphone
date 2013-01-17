//
//  RootViewController.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 4..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CSNavigationView.h"
#import "BaseViewController.h"
#import "MainViewController.h"

@interface RootViewController : BaseViewController<CSNavigationViewDelegate>{
    NSMutableArray * _controllers;
    NSMutableArray * _views;
    
    CSNavigationView * _csNavigationView;
    
    int _index;
}

@property (nonatomic, retain) NSMutableArray * controllers;


@end
