//
//  PhotoModel.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 14..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DateGroup, MonthGroup, PhotoGroup;

@interface PhotoModel : NSManagedObject

@property (nonatomic, retain) NSNumber * category;
@property (nonatomic, retain) NSDate * date_create;
@property (nonatomic, retain) NSDate * date_exif;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSDate * group_date;
@property (nonatomic, retain) NSDate * group_date_day;
@property (nonatomic, retain) NSDate * group_date_month;
@property (nonatomic, retain) NSDate * group_date_year;
@property (nonatomic, retain) NSString * group_loc_city;
@property (nonatomic, retain) NSString * group_loc_country;
@property (nonatomic, retain) NSString * group_loc_state;
@property (nonatomic, retain) NSString * group_name;
@property (nonatomic, retain) NSNumber * group_type;
@property (nonatomic, retain) NSNumber * location_lat;
@property (nonatomic, retain) NSNumber * location_long;
@property (nonatomic, retain) NSString * string_day;
@property (nonatomic, retain) NSData * thumb_data;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * UTI;
@property (nonatomic, retain) DateGroup *date;
@property (nonatomic, retain) NSSet *group;
@property (nonatomic, retain) MonthGroup *month;
@property (nonatomic, retain) NSString * thumb_url;

- (NSString *) dateStrAsFormat:(NSString*)format;

@end

@interface PhotoModel (CoreDataGeneratedAccessors)

- (void)addGroupObject:(PhotoGroup *)value;
- (void)removeGroupObject:(PhotoGroup *)value;
- (void)addGroup:(NSSet *)values;
- (void)removeGroup:(NSSet *)values;
@end
