//
//  
//    ___  _____   ______  __ _   _________ 
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_| 
//
//  Created by Bart Claessens. bart (at) revolver . be
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "REVClusterPin.h"

@protocol REVClusterAnnotationViewDelegate;
@interface REVClusterAnnotationView : MKAnnotationView <MKAnnotation> {
    UILabel *label;
    
    UIImageView *_frame;
    UIButton *_imageView;
    
    id<REVClusterAnnotationViewDelegate> _delegate;
    
    REVClusterPin *_pin;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) id<REVClusterAnnotationViewDelegate> delegate;
@property (nonatomic, retain) REVClusterPin *pin;

- (void) setClusterText:(NSString *)text;

- (void) setPhotoThumb:(UIImage *)thumb;

- (void) photoThumbTapped:(id)sender;

- (void) resetAnnotationView;

@end


@protocol REVClusterAnnotationViewDelegate <NSObject>

- (void)didSelectAnnotationView:(MKAnnotationView *)annotationView;

@end