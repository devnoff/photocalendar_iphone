//
//  MapViewController.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 18..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "MapViewController.h"
#import "CSBarButtonItemUtils.h"
#import "AppDelegate.h"
#import <AddressBookUI/AddressBookUI.h>

@implementation MyPin

@synthesize coordinate;
@synthesize title;
@synthesize subtitle;



- (void)dealloc {
    [title release];
    [subtitle release];
    [super dealloc];
}
@end


@implementation MapViewController
@synthesize pins=_pins;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _pins = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
    
}

- (IBAction)closeBtnTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addPinsObject:(NSDictionary *)pinInfo{
    
    
    [_pins addObject:pinInfo];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _manager = [[CLLocationManager alloc] init];
    _manager.delegate = self;
    
    
    NSDictionary * pinInfo = [_pins objectAtIndex:0];
    
    CLLocationCoordinate2D  coordinate;
    coordinate.latitude = [[pinInfo objectForKey:@"lat"] doubleValue];
    coordinate.longitude = [[pinInfo objectForKey:@"long"] doubleValue];
    
    
    NSLog(@"lat : %f  long :  %f", coordinate.latitude, coordinate.longitude);
    
    MyPin * pin = [[[MyPin alloc] init]autorelease];
    pin.coordinate = coordinate;
    
    
    
    MKCoordinateRegion region;
    region.center.latitude = coordinate.latitude;
    region.center.longitude = coordinate.longitude;
    region.span.latitudeDelta = 0.02;
    region.span.longitudeDelta = 0.02;
    //    _mapView.showsUserLocation = YES;
    [_mapView setRegion:region animated:YES];
    
    //[_manager startUpdatingLocation];
    
    self.title = NSLocalizedString(@"MAP", nil);
    
    
    
    
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5")) {
        
        CLGeocoder * coder = [[[CLGeocoder alloc] init] autorelease];
        CLLocation * location = [[CLLocation alloc] initWithLatitude:pin.coordinate.latitude longitude:pin.coordinate.longitude];
        [coder reverseGeocodeLocation:location 
                    completionHandler:^(NSArray *placemark, NSError *error){
                        
                        if (placemark>0) {
                            CLPlacemark * place= (CLPlacemark *)[placemark objectAtIndex:0];    
                            
                            NSString * address = ABCreateStringWithAddressDictionary(place.addressDictionary, YES);
                            
                            pin.title = address;
                            
                            [_mapView addAnnotation:pin];
                            
                            
                        }
                        
                        if (error) {
                            NSLog(@"error: %@",error);
                        }
                        
                    }];     
    }
    
    
    
    [self.navigationItem hidesBackButton];
    self.navigationItem.leftBarButtonItem = [CSBarButtonItemUtils blackBackButtonWithTitle:NSLocalizedString(@"BACK", nil) target:self action:@selector(back)];
    
    
    // Button for send to Google Map App 
    if (!_gBtn) {
        
        UIImage *normalImage = [UIImage imageNamed:@"NavBtn_Map"];
        UIImage *highlightedImage = [UIImage imageNamed:@"NavBtn_Map_On"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
        [button setImage:normalImage forState:UIControlStateNormal];
        [button setImage:highlightedImage forState:UIControlStateHighlighted];
        
        [button addTarget:self action:@selector(goToGoogleApp:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _gBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationItem.rightBarButtonItem = _gBtn;
    }
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [(AppDelegate*)[[UIApplication sharedApplication]delegate] hideADViewWithAnimate]; // 광고 보이기
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)goToGoogleApp:(id)Sender{
    NSDictionary * pinInfo = [_pins objectAtIndex:0];
    
    NSString *title = @"";
    float latitude = [[pinInfo objectForKey:@"lat"] doubleValue];
    float longitude = [[pinInfo objectForKey:@"long"] doubleValue];
    int zoom = 13;
    NSString *stringURL = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@@%1.6f,%1.6f&z=%d", title, latitude, longitude, zoom];
    NSURL *url = [NSURL URLWithString:stringURL];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)dealloc{
    _manager.delegate = nil;
    [_manager release];
    [_mapView release];
    [_pins release];
    [_gBtn release];
    [super dealloc];
}



- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views{
    for(MKAnnotationView *view in views){
        [_mapView selectAnnotation:view.annotation animated:YES];
    }
}

@end
