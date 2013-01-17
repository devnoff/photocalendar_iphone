//
//  MNMapViewController.h
//  photoplace
//
//  Created by Park Yongnam on 11. 11. 25..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "REVMapViewController.h"
#import "RequestController.h"


@interface MNMapViewController : REVMapViewController <RequestControllerDelegate> {

    NSFetchedResultsController *_resultController;
    NSManagedObjectContext *_context;
    
    BOOL _loading;
    
    UIActivityIndicatorView *_activity;
    
    dispatch_queue_t collectQueue;
}

@property (nonatomic, retain) NSFetchedResultsController *resultController;

@end
