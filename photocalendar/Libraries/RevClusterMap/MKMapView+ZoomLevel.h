//
//  MKMapView+ZoomLevel.h
//  photoplace
//
//  Created by Park Yongnam on 11. 12. 21..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

// MKMapView+ZoomLevel.h
#import <MapKit/MapKit.h>

@interface MKMapView (ZoomLevel)

- (void)setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

- (double)getZoomLevel;
@end