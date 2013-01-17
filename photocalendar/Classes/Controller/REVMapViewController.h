//
//  
//    ___  _____   ______  __ _   _________ 
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_| 
//
//  Created by Bart Claessens. bart (at) revolver . be
//

#import <UIKit/UIKit.h>
#import "REVClusterMapView.h"
#import "REVClusterAnnotationView.h"
#import "BaseViewController.h"
#import "MKMapView+ZoomLevel.h"

typedef struct {
	CLLocationDegrees min_lat;
	CLLocationDegrees max_lat;
    CLLocationDegrees min_lon;
	CLLocationDegrees max_lon;
} MinMaxLatLon;

@interface REVMapViewController : BaseViewController <MKMapViewDelegate> {
    REVClusterMapView *_mapView;
    
    NSArray * _pins;
    
    MinMaxLatLon _minmax;
}

@property (nonatomic,retain) NSArray * pins;
@property (nonatomic) MinMaxLatLon minmax;

- (void)initMapView;
- (void) showMap;
- (void) zoomToFitMapAnnotations;
- (void)relocateGoogleLogo;
@end
