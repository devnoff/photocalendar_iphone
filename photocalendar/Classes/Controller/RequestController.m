//
//  RequestController.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 6..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import "RequestController.h"
#import "AppDelegate.h"
#import "PhotoModel.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define kManagedObjectContext [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext]


@implementation NSArray (Reverse)

- (NSArray *)reversedArray {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [array addObject:element];
    }
    return array;
}

@end



@implementation RequestController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}





+ (void) requestAlbumGroupsFromDelegate:(id)delegate{
    NSLog(@"requestAlbumGroupsFrom");
    [NSFetchedResultsController deleteCacheWithName:@"PhotoGroup.cache"];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        NSPersistentStoreCoordinator * coord = [(AppDelegate*)[[UIApplication sharedApplication]delegate] persistentStoreCoordinator];
        NSManagedObjectContext * moc = [[NSManagedObjectContext alloc] init];
        [moc setPersistentStoreCoordinator:coord];
        
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"PhotoGroup" inManagedObjectContext:moc];
        [request setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"group_type" ascending:NO];
        NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"group_id" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor,sortDescriptor1, nil];
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptors release];
        [sortDescriptor release];
        [sortDescriptor1 release];
        
//        [request setFetchBatchSize:20];
        
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                                                   managedObjectContext:moc 
                                                                                                     sectionNameKeyPath:nil cacheName:@"PhotoGroup.cache"];
        fetchedResultsController.delegate = delegate;
        
        NSError *error;
        BOOL success = [fetchedResultsController performFetch:&error];
        if (!success) {
            //Handle the error.
            NSLog(@"failed to fetch");
        }
        
        [request release];
        [moc release];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate didSuccessRequest:fetchedResultsController];
        });
        [fetchedResultsController release];
    });
}

+ (NSFetchedResultsController*) requestPhotosInGroup:(NSString*)groupId fromDelegate:(id)delegate{
    NSPersistentStoreCoordinator * coord = [(AppDelegate*)[[UIApplication sharedApplication]delegate] persistentStoreCoordinator];
    NSManagedObjectContext * moc = [[NSManagedObjectContext alloc] init];
    [moc setPersistentStoreCoordinator:coord];
    
    [NSFetchedResultsController deleteCacheWithName:@"PhotoInGroup.cache"];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"PhotoModel" inManagedObjectContext:moc];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group.group_id CONTAINS %@",groupId];
    [request setPredicate:predicate];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date.date_str" ascending:ORDER_BY_ASC];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:sortDescriptors];
    [sortDescriptors release];
    [sortDescriptor release];
    
    [request setFetchBatchSize:20];
    
    
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:@"date.date_str" cacheName:@"PhotoInGroup.cache"];
    fetchedResultsController.delegate = delegate;
    
    NSError *error;
    BOOL success = [fetchedResultsController performFetch:&error];
    if (!success) {
        //Handle the error.
        NSLog(@"errors : %@", error);
    }
    
    [request release];
    [moc release];
    
    return fetchedResultsController;
}


+ (void) requestMonthGroupsOnBackgroundFromDelegate:(id)delegate{
    NSLog(@"request Month group");
    
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSPersistentStoreCoordinator * coord = [(AppDelegate*)[[UIApplication sharedApplication]delegate] persistentStoreCoordinator];
        NSManagedObjectContext * moc = [[NSManagedObjectContext alloc] init];
        [moc setPersistentStoreCoordinator:coord];
        
        
        [NSFetchedResultsController deleteCacheWithName:@"MonthGroup.cache"];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MonthGroup" inManagedObjectContext:moc];
        [request setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"month" ascending:ORDER_BY_ASC];
        NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"year" ascending:ORDER_BY_ASC];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor1,sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptors release];
        [sortDescriptor release];
        [sortDescriptor1 release];
        
        [request setFetchBatchSize:20];
        
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:@"year" cacheName:@"MonthGroup.cache"];
        fetchedResultsController.delegate = delegate;
        
        NSError *error;
        BOOL success = [fetchedResultsController performFetch:&error];
        if (!success) {
            //Handle the error.
        }
        
        [request release];
        [moc release];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate didSuccessRequest:fetchedResultsController];
        });
        [fetchedResultsController release];
    });
    
    
}

+ (void) backgroundRequestPhotosInGroup:(NSString*)groupId fromDelegate:(id)delegate{
    
    dispatch_queue_t queue1 = dispatch_queue_create("test", NULL);
    
    dispatch_async(queue1, ^{
        NSPersistentStoreCoordinator * coord = [(AppDelegate*)[[UIApplication sharedApplication]delegate] persistentStoreCoordinator];
        NSManagedObjectContext * moc = [[NSManagedObjectContext alloc] init];
        [moc setPersistentStoreCoordinator:coord];
        
        [NSFetchedResultsController deleteCacheWithName:@"PhotoInGroup.cache"];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"PhotoModel" inManagedObjectContext:moc];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"group.group_id CONTAINS %@",groupId];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date.date_str" ascending:ORDER_BY_ASC];
        NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"date_create" ascending:ORDER_BY_ASC];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor,sortDescriptor1, nil];
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptors release];
        [sortDescriptor release];
        [sortDescriptor1 release];
        
        [request setFetchBatchSize:20];
        
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:@"date.date_str" cacheName:@"PhotoInGroup.cache"];
        fetchedResultsController.delegate = delegate;
        
        NSError *error;
        BOOL success = [fetchedResultsController performFetch:&error];
        if (!success) {
            //Handle the error.
            NSLog(@"errors : %@", error);
        }
        
        [request release];
        [moc release];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate didSuccessRequest:fetchedResultsController];
        });
        [fetchedResultsController release];
    });
    
    dispatch_release(queue1);
}



+ (void) backgroundRequestPHotosInMonth:(NSDate*)month fromDelegate:(id)delegate{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        
        NSPersistentStoreCoordinator * coord = [(AppDelegate*)[[UIApplication sharedApplication]delegate] persistentStoreCoordinator];
        NSManagedObjectContext * moc = [[NSManagedObjectContext alloc] init];
        [moc setPersistentStoreCoordinator:coord];
        
        [NSFetchedResultsController deleteCacheWithName:@"PhotoInMonth.cache"];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"PhotoModel" inManagedObjectContext:moc];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"month.month ==  %@",month];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date.date_str" ascending:ORDER_BY_ASC];
        NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"date_create" ascending:ORDER_BY_ASC];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor,sortDescriptor1, nil];
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptors release];
        [sortDescriptor release];
        [sortDescriptor1 release];
        
        [request setFetchBatchSize:20];
        
        
        NSFetchedResultsController *fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                                                   managedObjectContext:moc 
                                                                                                     sectionNameKeyPath:@"date.date_str" 
                                                                                                              cacheName:@"PhotoInMonth.cache"] autorelease];
        fetchedResultsController.delegate = delegate;
        
        NSError *error;
        BOOL success = [fetchedResultsController performFetch:&error];
        if (success) {
            //Handle the error.
        }
        
        [request release];
        [moc release];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate didSuccessRequest:fetchedResultsController];
            
        });
        

        
    });
}

+ (void) requestPhotosFromDate:(NSDate*)fromDate toDate:(NSDate*)toDate fromDelegate:(id)delegate{
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSPersistentStoreCoordinator * coord = [(AppDelegate*)[[UIApplication sharedApplication]delegate] persistentStoreCoordinator];
        NSManagedObjectContext * moc = [[NSManagedObjectContext alloc] init];
        [moc setPersistentStoreCoordinator:coord];
        
        [NSFetchedResultsController deleteCacheWithName:@"PhotoSpecificDate.cache"];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"DateGroup" inManagedObjectContext:moc];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date >=  %@ AND date <= %@",fromDate,toDate];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:ORDER_BY_ASC];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptors release];
        [sortDescriptor release];
        
        [request setFetchBatchSize:20];
        
        NSFetchedResultsController *fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                                                   managedObjectContext:moc 
                                                                                                     sectionNameKeyPath:nil 
                                                                                                              cacheName:@"PhotoSpecificDate.cache"]autorelease];
        fetchedResultsController.delegate = delegate;
        
        NSError *error;
        BOOL success = [fetchedResultsController performFetch:&error];
        if (success) {
            //Handle the error.
        }
        
        
        NSArray * dates = [[moc executeFetchRequest:request error:nil] valueForKeyPath:@"date"];
        
        
        
        [request release];
        [moc release];
        
        
        NSLog(@"count of dates array: %d", [dates count]);
        NSLog(@"count of resultcontroller object: %d",[[fetchedResultsController fetchedObjects] count]);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableDictionary * dic = [[[NSMutableDictionary alloc] init] autorelease];
            [dic setObject:dates forKey:DATES];
            [dic setObject:fetchedResultsController forKey:RESULTCONTROLLER];
            [delegate didSuccessRequest:dic];
        });
        

    });
        
    
}



+ (NSManagedObjectContext*) _context{
    return [(AppDelegate*)[[UIApplication sharedApplication] delegate] managedObjectContext];
}
@end
