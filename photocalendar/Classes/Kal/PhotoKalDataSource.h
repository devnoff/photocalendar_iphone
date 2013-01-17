//
//  PhotoKalDataSource.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 16..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "Kal.h"
#import <dispatch/dispatch.h>
#import <Foundation/Foundation.h>
#import "RequestController.h"

@interface PhotoKalDataSource : NSObject <KalDataSource,UITableViewDelegate,RequestControllerDelegate>{
    
    NSFetchedResultsController * _resultController;
    
    NSMutableArray * _dates;
    
    NSArray * _items;
    
    id _delegate;

    
}

@property (nonatomic,retain) NSFetchedResultsController * resultController;
@property (nonatomic,retain) NSArray * dates;
@property (nonatomic,retain) NSArray * items;

+ (PhotoKalDataSource*)dataSource;

@end
