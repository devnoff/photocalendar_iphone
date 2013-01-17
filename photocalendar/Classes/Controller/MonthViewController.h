//
//  MonthViewController.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 5..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RequestController.h"


@interface MonthViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,NSFetchedResultsControllerDelegate,RequestControllerDelegate>{
    IBOutlet UITableView * _tableView;
    
    NSFetchedResultsController * _resultController;
    
    ALAssetsLibrary * _assetLibrary;
    
    IBOutlet UIActivityIndicatorView * _activity;
    
    
    NSDateFormatter * _formatter;
}

@property (nonatomic,retain) UITableView * tableView;
@end
