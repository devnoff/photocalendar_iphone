//
//  AlbumsViewController.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 5..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "BaseViewController.h"
#import "MainViewController.h"
#import "NoPhotoView.h"
#import "RequestController.h"

@interface AlbumsViewController : BaseViewController<NSFetchedResultsControllerDelegate,RequestControllerDelegate>{
    IBOutlet UITableView * _tableView;
    
    NSFetchedResultsController * _resultController;
    
    IBOutlet UIActivityIndicatorView * _activity;
    

}

@property (nonatomic,retain) UITableView * tableView;


@end
