//
//  DateViewController.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 7..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RequestController.h"
#import "PhotoButton.h"
#import "PhotoViewController.h"


typedef enum{
    DateViewControllerTypeAsGroupId,
    DateViewControllerTypeAsMonth
}DateViewControllerType;

@interface DateViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,RequestControllerDelegate,PhotoButtonDelegate>
{
     UITableView * _tableView;
    
    NSDate * _groupMonth;
    NSString * _groupId;

    DateViewControllerType _type;
    
    NSFetchedResultsController * _resultController;
    
    ALAssetsLibrary * _assetsLibrary;
    
    IBOutlet UIActivityIndicatorView * _activity;
    
    IBOutlet UILabel * _summaryLabel;
    
    
    PhotoViewController * _photoVC;
    
}

@property (nonatomic,retain) NSDate * groupMonth;
@property (nonatomic,retain) NSString * groupId;
@property (nonatomic,assign) DateViewControllerType type;
@property (nonatomic,retain) IBOutlet UITableView * tableView;


- (id) initWithType:(DateViewControllerType)type groupMonth:(NSDate*)month orGroupId:(NSString*)groupId;
- (void) backBtnTapped:(id)sender;
- (void) scrollToIndex:(NSInteger)index;
- (void) updateSummaryLabel;
@end


