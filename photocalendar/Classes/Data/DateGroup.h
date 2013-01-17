//
//  DateGroup.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 10..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PhotoModel;

@interface DateGroup : NSManagedObject {
@private
}
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * date_str;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSSet *photos;


- (NSArray*)photosArray;

- (PhotoModel *)latestPhoto;

@end

@interface DateGroup (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(PhotoModel *)value;
- (void)removePhotosObject:(PhotoModel *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;
@end
