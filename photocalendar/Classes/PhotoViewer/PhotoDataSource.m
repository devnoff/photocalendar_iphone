//
//  PhotoDataSource.m
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 30..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import "PhotoDataSource.h"


@interface PhotoDataSource()
- (void)requestAssetForIndex:(NSInteger)index;
- (BOOL)isDestroy;
- (void)createQueue; 
@end
@implementation PhotoDataSource

@synthesize photos=_photos, numberOfPhotos=_numberOfPhotos, resultController=_resultController, delegate = _delegate, photoCache=_photoCache;
@synthesize photoModels = _photoModels;

static BOOL reqesting = NO;

- (id)initWithPhotos:(NSArray *)photos {
    self = [super init];
	if (self) {
		_photos = [photos retain];
		_numberOfPhotos = [_photos count];
        
        [self createQueue];
        
	}
	
	return self;
}

- (id)initWithResultController:(NSFetchedResultsController*)resultController{
    self = [super init];
    if (self) {
        _resultController = [resultController retain];
        _numberOfPhotos = [[_resultController fetchedObjects]count];
        _library = [[ALAssetsLibrary alloc]init];
        _photoCache = [[NSMutableDictionary alloc]init];
        _requestSet = [[NSMutableArray alloc] initWithCapacity:20];
        for (int i = 0; i<10; i++) {
            [_requestSet addObject:@""];   
        }
        
        currentRange = NSMakeRange(-10, 0);
        
        [self createQueue];
    }
    return self;
}

- (id)initForPhotoModels{
    self = [super init];
	if (self) {
        _library = [[ALAssetsLibrary alloc]init];
        _photoCache = [[NSMutableDictionary alloc]init];
        _requestSet = [[NSMutableArray alloc] initWithCapacity:20];
        for (int i = 0; i<10; i++) {
            [_requestSet addObject:@""];   
        }
        
        currentRange = NSMakeRange(-10, 0);
        
        
        destroy = NO;
        
        [self createQueue];
	}
	
	return self;
}

- (void)createQueue{
    
    _enumerQueue = dispatch_queue_create("collectQueue", NULL);
    
    justIndex = 100000000;
    
}


- (void) setPhotoModels:(NSArray *)photoModels{
    if (_photoModels) {
        [_photoModels release];
        _photoModels = nil;
    }
    
    _photoModels = [photoModels retain];
    
    _numberOfPhotos = [_photoModels count];
    
    [_photoCache removeAllObjects];
}


- (id)photoAtIndex:(NSInteger)index {
	return [_photos objectAtIndex:index];
}

- (void) requestCachedPhotoAtIndex:(NSNumber*)aIndex{
    
    NSInteger index = [aIndex integerValue];
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    if (!reqesting) {
        reqesting = YES;
        
        // 인덱스의 범위
        int halfRange;
        int tempLength;
        
        if (SYSTEM_VERSION_LESS_THAN(@"5")) {
            halfRange = 0;
            tempLength = 1;
        } else {
            halfRange = 1;
            tempLength = 3;
        }
        
        int location = index-halfRange;
        int length = tempLength;
        if (location<0) {
            location = 0;
            length = tempLength + index;
        }
        
        NSRange indexRange = NSMakeRange(location, length);
        
        // 이미 요청된 범위
        NSRange requestedRange = NSIntersectionRange(indexRange, currentRange);
        
        
        
        int j = index;
        int cnt = 0;
        int x = -1;
        while (true) {
            
            j = j + (cnt*x);   
            cnt++;
            x = -x;
            
            if(j==NSMaxRange(indexRange)) break;
            
            if (!NSLocationInRange(j, requestedRange)) {
                if(j>=0 && j<_numberOfPhotos){
                    NSLog(@"j: %d index: %d",j, index);
                    [self requestAssetForIndex:j];    
                }
            }
        }
        
        
        currentRange = indexRange;
        
        // 캐싱 범위 밖의 캐시 삭제
        for(NSNumber * key in [_photoCache allKeys]){
            NSInteger keyNum = [key integerValue];
            if(!NSLocationInRange(keyNum, indexRange)){
                [_photoCache removeObjectForKey:key];
            }
        }
        
        
        reqesting = NO;
    }
    
    
    [pool release];
    
}

- (PhotoData*)cachedPhotoAtIndex:(NSInteger)index{
    
    
    
    // 인덱스 값이 이미 요청이 된 것인지 확인
    BOOL hasRequested = NSLocationInRange(index, currentRange);
    //        NSLog(@"hasrequested: %@", [NSNumber numberWithBool:hasRequested]);
    
    
    [self performSelectorInBackground:@selector(requestCachedPhotoAtIndex:) withObject:[NSNumber numberWithInteger:index]];
    
    PhotoData * data = nil;
    // 이미 요청 되었을 경우
    if (hasRequested) {
        // 캐시에서 데이터를 반환
        data = [_photoCache objectForKey:[NSNumber numberWithInt:index]];
        if (!data) {
            [self requestAssetForIndex:index];
        }
    } 
    
    reqesting = NO;
    
    return data;
    
}

- (void)requestAssetForIndex:(NSInteger)index{
    
    PhotoModel * photo;
    if (_resultController) {
        photo = [[_resultController fetchedObjects]objectAtIndex:index];
    } else {
        photo = [_photoModels objectAtIndex:index];
    }
    
    if (justIndex==index) {
        return;
    }
    justIndex = index;
    
    ALAssetsLibraryAssetForURLResultBlock block = ^(ALAsset*result){
        BOOL stillContain = NSLocationInRange(index, currentRange);
        NSLog(@"stiilcontain : %@   index: %d  currentrange loc: %d  len: %d", [NSNumber numberWithBool:stillContain], index, currentRange.location, currentRange.length);
        if (stillContain) {
            ALAssetRepresentation * rep = result.defaultRepresentation;
            
            NSLog(@"%@",rep);
            
            PhotoData * pData;
            
            if (rep==NULL) {
                pData = [[PhotoData alloc]init]; 
            } else {
                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5")) {
                    pData = [[PhotoData alloc]initWithImage:[UIImage imageWithCGImage:rep.fullScreenImage]];    
                } else {
                    pData = [[PhotoData alloc]initWithImage:[UIImage imageWithCGImage:rep.fullScreenImage scale:rep.scale orientation:(UIImageOrientation)rep.orientation]];    
                }
                
                //
                pData.photo = photo;
                
                // caption
                
                
                
                //                pData.captionString =str;
                
                // asset type
                pData.assetType = [result valueForProperty:ALAssetPropertyType];
                
                // asset
                pData.asset = result;
                
                pData.datetime = photo.date_create;
                
                // location
                
                NSLog(@"location model: %@ %@", photo.location_lat,photo.location_long);
                
                if (photo.location_lat&&photo.location_long) {
                    CLLocation * loc = [[CLLocation alloc] initWithLatitude:[photo.location_lat floatValue] longitude:[photo.location_long floatValue]];
                    NSLog(@"location: %@",loc);
                    
                    if (!isnan(loc.coordinate.latitude)&&!isnan(loc.coordinate.longitude)) {
                        
                        pData.coordinate = loc.coordinate;
                    } else {
                        pData.coordinate = CLLocationCoordinate2DMake(EmptyLocation, EmptyLocation);
                    }
                    
                    [loc release];    
                }

                
            }
            
            [_photoCache setObject:pData forKey:[NSNumber numberWithInt:index]];    
            
            
            
            
            [pData release];
            
            
            NSLog(@"success collect image for index: %d", index);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([self isDestroy]) {
                    return;
                }else{
                    [_delegate resultALAsset:result atIndex:index];
                }
            });    
            
        }
        
    };
    
    
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError * error){
        NSLog(@"error: %@",error);
    };
    
    
    dispatch_async(_enumerQueue, ^{
        NSURL * url=nil;
        @try {
            url = [NSURL URLWithString:photo.url];    
        }
        @catch (NSException *exception) {
            url = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self requestAssetForIndex:index];
            });
            
            NSLog(@"exception : %@",exception);
        }
        @finally {
            if (url) {
                
                [_library assetForURL: url
                          resultBlock:block
                         failureBlock:failureBlock];   // failure block not woking at all
            }
        }
        
        
    });    
    
    
}

- (void) requestMissingPhotoAtIndex:(NSInteger)index{
    NSLog(@"requestMissingPHotoatindex");
    [self requestAssetForIndex:index];
    
}

- (BOOL) isDestroy{
    return destroy;
}

- (void) destroyDispatch:(BOOL)destroy_{
    destroy = destroy_;
}

- (void)dealloc{
	[_photos release], _photos=nil;
    [_library release], _library=nil;
    [_photoCache release], _photoCache=nil;
    [_requestSet release], _requestSet=nil;
    [_photoModels release], _photoModels=nil;
    dispatch_release(_enumerQueue);
	[super dealloc];
}

@end
