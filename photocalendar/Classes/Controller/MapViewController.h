//
//  MapViewController.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 18..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BaseViewController.h"

@interface MyPin : NSObject <MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;
}

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end



@interface MapViewController : UIViewController <CLLocationManagerDelegate>{
    IBOutlet MKMapView * _mapView;
    
    NSMutableArray * _pins;
    
    CLLocationManager * _manager;
    
    UIBarButtonItem * _gBtn;
}

@property (nonatomic,retain) NSMutableArray * pins;

- (IBAction)closeBtnTapped:(id)sender;
-(void)addPinsObject:(NSDictionary *)pinInfo;
- (void)goToGoogleApp:(id)Sender;
- (void)back;

@end
