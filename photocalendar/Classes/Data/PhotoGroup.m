//
//  PhotoGroup.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 10..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "PhotoGroup.h"
#import "PhotoModel.h"


@implementation PhotoGroup
@dynamic group_id;
@dynamic group_name;
@dynamic group_type;
@dynamic photo_cnt;
@dynamic poster;
@dynamic photos;
@dynamic thumb_url;

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
