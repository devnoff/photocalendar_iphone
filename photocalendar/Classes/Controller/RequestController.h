//
//  RequestController.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 6..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhotoGroup.h"


#define DATES @"dates"
#define RESULTCONTROLLER @"resultController"

@protocol RequestControllerDelegate;

@interface RequestController : NSObject{
    
}


+ (NSFetchedResultsController*) requestPhotosInGroup:(NSString*)groupId fromDelegate:(id)delegate;


+ (void) requestAlbumGroupsFromDelegate:(id)delegate;
+ (void) requestMonthGroupsOnBackgroundFromDelegate:(id)delegate;

+ (void) backgroundRequestPhotosInGroup:(NSString*)groupId fromDelegate:(id)delegate;
+ (void) backgroundRequestPHotosInMonth:(NSDate*)month fromDelegate:(id)delegate;
+ (void) requestPhotosFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate fromDelegate:(id)delegate;

+ (NSManagedObjectContext*) _context;
@end


@protocol RequestControllerDelegate <NSObject>
- (void) didSuccessRequest:(id)result;
@end