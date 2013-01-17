//
//  ChoosingGroupViewController.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 23..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DOGroup.h"
#import "AlbumListCell.h"
#import "BaseViewController.h"

@interface ChoosingGroupViewController : BaseViewController <UITableViewDelegate,UITableViewDataSource,AlbumListCellDelegate>{
    IBOutlet UITableView * _tableView;
    
    NSMutableSet * _choosenGroup;
    
    NSMutableArray * _groups;
    
    ALAssetsLibrary * _library;
    
    IBOutlet UILabel * _summaryLabel;
    IBOutlet UIButton * _importBtn;
    IBOutlet UIButton * _cancelBtn;
    IBOutlet UILabel * _titleLabel;
    UIView * _sectionHeader;
    
    NSMutableDictionary * _groupsMapping;
    
    NSMutableSet * _hiddenGroup;
    
}

- (void)loadHiddenGroup;

- (IBAction)importBtnTapped:(id)sender;

// Collect Group list

- (void) collectGroupList;

// select Group

// remove Group

// import


// update summary label
- (void) updateSummaryLabel;



@end


