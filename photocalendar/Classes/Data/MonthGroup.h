//
//  MonthGroup.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 10..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PhotoModel;

@interface MonthGroup : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * cnt;
@property (nonatomic, retain) NSDate * month;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate * year;
@property (nonatomic, retain) NSSet *photos;


- (NSString *) monthTitle;

- (PhotoModel *)latestPhoto;

@end

@interface MonthGroup (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(PhotoModel *)value;
- (void)removePhotosObject:(PhotoModel *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;
@end
