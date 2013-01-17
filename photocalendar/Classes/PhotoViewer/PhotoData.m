//
//  PhotoData.m
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 30..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import "PhotoData.h"


@implementation PhotoData

@synthesize URL=_URL, image=_image, size=_size, failed=_failed, cgImgRef = _cgImgRef, asset = _asset, representation=_representation;
@synthesize captionString=_captionString,coordinate=_coordinate,assetType=_assetType,datetime=_datetime;
@synthesize photo=_photo;


- (id)initWithImageURL:(NSURL*)URL image:(UIImage*)image {
    self = [super init];
	if (self) {
		_URL = [URL retain];
		_image = [image retain];
		
	}
	
	return self;
}


- (id)initWithImageURL:(NSURL*)URL {
	return [self initWithImageURL:URL image:nil];
}


- (id)initWithImage:(UIImage*)image {
	return [self initWithImageURL:nil image:image];
}


- (id)initWithAsset:(ALAsset *)asset{
    self = [super init];
    if (self) {
        _asset = [asset retain];
    }
    return self;
}

- (void)dealloc {
	[_URL release], _URL=nil;
	[_image release], _image=nil;
    [_representation release], _representation= nil;
    [_captionString release], _captionString=nil;
    [_asset release], _asset = nil;
    [_representation release], _representation = nil;
    [_assetType release], _assetType = nil;
    [_datetime release], _datetime = nil;
    [_photo release], _photo = nil;
	[super dealloc];
}



@end
