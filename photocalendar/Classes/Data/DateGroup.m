//
//  DateGroup.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 10..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "DateGroup.h"
#import "PhotoModel.h"


@implementation DateGroup
@dynamic date;
@dynamic date_str;
@dynamic url;
@dynamic photos;

- (NSArray*)photosArray{
    NSArray* sort = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"date_create" ascending:NO]];
//    NSMutableArray * arr = [NSMutableArray arrayWithArray:[self.photos allObjects]];
//    [arr sortUsingSelector:@selector(compare:)];
//    return arr;
    return [[self.photos allObjects] sortedArrayUsingDescriptors:sort];
}

- (PhotoModel *)latestPhoto{
    
    NSArray *arr = [self.photos allObjects];
    NSSortDescriptor * desc = [[NSSortDescriptor alloc] initWithKey:@"date_create" ascending:NO];
    arr = [arr sortedArrayUsingDescriptors:[NSArray arrayWithObjects:desc,nil]];
    [desc release];
    
    if ([arr count]>0) {
        return [arr objectAtIndex:0];
    }
    
    return nil;
}

@end
