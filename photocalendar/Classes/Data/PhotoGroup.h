//
//  PhotoGroup.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 10..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PhotoModel;

@interface PhotoGroup : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * group_id;
@property (nonatomic, retain) NSString * group_name;
@property (nonatomic, retain) NSNumber * group_type;
@property (nonatomic, retain) NSNumber * photo_cnt;
@property (nonatomic, retain) NSData * poster;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSString * thumb_url;


- (PhotoModel *)latestPhoto;
@end

@interface PhotoGroup (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(PhotoModel *)value;
- (void)removePhotosObject:(PhotoModel *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;
@end
