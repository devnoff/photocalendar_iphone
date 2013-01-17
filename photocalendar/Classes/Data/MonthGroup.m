//
//  MonthGroup.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 10..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "MonthGroup.h"
#import "PhotoModel.h"


@implementation MonthGroup
@dynamic cnt;
@dynamic month;
@dynamic url;
@dynamic year;
@dynamic photos;

- (NSString*) monthTitle{
    NSDateFormatter * formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"MMMM"];
    return [formatter stringFromDate:self.month];
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
