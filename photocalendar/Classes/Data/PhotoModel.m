//
//  PhotoModel.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 14..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "PhotoModel.h"
#import "DateGroup.h"
#import "MonthGroup.h"
#import "PhotoGroup.h"


@implementation PhotoModel

@dynamic category;
@dynamic date_create;
@dynamic date_exif;
@dynamic duration;
@dynamic group_date;
@dynamic group_date_day;
@dynamic group_date_month;
@dynamic group_date_year;
@dynamic group_loc_city;
@dynamic group_loc_country;
@dynamic group_loc_state;
@dynamic group_name;
@dynamic group_type;
@dynamic location_lat;
@dynamic location_long;
@dynamic string_day;
@dynamic thumb_data;
@dynamic type;
@dynamic url;
@dynamic UTI;
@dynamic date;
@dynamic group;
@dynamic month;
@dynamic thumb_url;

- (NSString *)dateStrAsFormat:(NSString*)format{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString * str = [formatter stringFromDate:self.date_create];
    [formatter release];
    return str;
}



@end
