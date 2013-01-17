//
//  CoreDataUtils.m
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 22..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import "CoreDataUtils.h"
#import "AppDelegate.h"


@implementation CoreDataUtils

+ (NSNumber *)nextEntityId:(NSString *)entityName {
    AppDelegate*appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    [fetchRequest setEntity:entityDescription];
    
    [fetchRequest setFetchBatchSize:1];
    
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:COREDATE_ATTRIBUTE_ENTITYID ascending:NO] autorelease];
    NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil] autorelease];
    [fetchRequest setSortDescriptors:sortDescriptors];

    NSNumber *entityId = 0;
    NSArray *entities = [context executeFetchRequest:fetchRequest error:nil];
    if (entities && 0 < [entities count]) {
        entityId = [[entities objectAtIndex:0] valueForKey:COREDATE_ATTRIBUTE_ENTITYID];
    }
    
    entityId = [NSNumber numberWithInt:([entityId intValue] + 1)];
    return entityId;
}

@end
