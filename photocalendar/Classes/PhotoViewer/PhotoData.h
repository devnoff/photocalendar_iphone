//
//  PhotoData.h
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 30..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "PhotoModel.h"

@interface PhotoData : NSObject {
@private
	NSURL *_URL;
	CGSize _size;
	UIImage *_image;
    CGImageRef _cgImgRef;
    
	BOOL _failed;
    
    // 추가 정보
    
    PhotoModel *_photo;
    
    ALAsset * _asset;
    ALAssetRepresentation * _representation;
    
    NSString * _captionString;
    
    CLLocationCoordinate2D _coordinate;
    
    NSString * _assetType;
    NSDate * _datetime;
}


@property (nonatomic, readonly) NSURL *URL;
@property (nonatomic) CGSize size;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign, getter=didFail) BOOL failed;
@property (nonatomic, assign) CGImageRef cgImgRef;
@property (nonatomic, retain) ALAsset * asset;
@property (nonatomic, retain) ALAssetRepresentation *representation;
@property (nonatomic, retain) NSString * captionString;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString * assetType;
@property (nonatomic, retain) NSDate * datetime;
@property (nonatomic, retain) PhotoModel *photo;


- (id)initWithImageURL:(NSURL*)URL image:(UIImage*)image;
- (id)initWithImageURL:(NSURL*)URL;
- (id)initWithImage:(UIImage*)image;
- (id)initWithAsset:(ALAsset*)asset;



@end
