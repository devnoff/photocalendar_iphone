//
//  DOGroup.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 23..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DOGroup : NSObject{
    NSString *group_id;
    NSString *group_name;
    NSNumber *group_type;
    NSNumber *photo_cnt;
    NSData *poster;    
}

@property (nonatomic, retain) NSString * group_id;
@property (nonatomic, retain) NSString * group_name;
@property (nonatomic, retain) NSNumber * group_type;
@property (nonatomic, retain) NSNumber * photo_cnt;
@property (nonatomic, retain) NSData * poster;


@end
