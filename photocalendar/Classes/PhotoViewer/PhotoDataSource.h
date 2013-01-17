//
//  PhotoDataSource.h
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 30..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoModel.h"
#import "PhotoData.h"


static const CLLocationDegrees EmptyLocation = -1000.0;

@protocol PhotoDataSourceDelgate;
@interface PhotoDataSource : NSObject {
@private
    NSArray *_photos;
    NSInteger _numberOfPhotos;
    NSFetchedResultsController * _resultController;
    ALAssetsLibrary * _library;
    
    id<PhotoDataSourceDelgate> _delegate;
    
    NSMutableDictionary * _photoCache;
    
    NSMutableArray * _requestSet;
    
    NSRange currentRange;
    
    NSArray *_photoModels;
    
    BOOL destroy;
    
    int justIndex;
    
    dispatch_queue_t _enumerQueue;
}

@property (nonatomic, readonly) NSArray *photos;
@property (nonatomic, readonly) NSInteger numberOfPhotos;
@property (nonatomic, readonly) NSFetchedResultsController * resultController;
@property (nonatomic, assign) id<PhotoDataSourceDelgate> delegate;
@property (nonatomic, retain) NSMutableDictionary * photoCache;
@property (nonatomic, retain) NSArray * photoModels;

- (id)initWithPhotos:(NSArray *)photos;
- (id)initForPhotoModels;
- (id)photoAtIndex:(NSInteger)index;
- (id)initWithResultController:(NSFetchedResultsController*)resultController;

- (void) requestCachedPhotoAtIndex:(NSNumber*)aIndex;
- (PhotoData*)cachedPhotoAtIndex:(NSInteger)index;

- (void) requestMissingPhotoAtIndex:(NSInteger)index;

- (void) destroyDispatch:(BOOL)destroy_;
@end


@protocol PhotoDataSourceDelgate <NSObject>
//- (void)resultImage:(UIImage*)image atIndex:(NSInteger)index;
- (void)resultALAsset:(ALAsset*)asset atIndex:(NSInteger)index;
- (void)didFaildToLoadImage:(NSInteger)index;

@end