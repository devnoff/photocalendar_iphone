//
//  
//    ___  _____   ______  __ _   _________ 
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_| 
//
//  Created by Bart Claessens. bart (at) revolver . be
//

#import "REVMapViewController.h"
#import "REVClusterMap.h"
#import "REVClusterAnnotationView.h"
#import "PhotoViewController.h"

#define BASE_RADIUS 100.5 // = 1 mile
#define MINIMUM_LATITUDE_DELTA 0.20
#define BLOCKS 4

#define MINIMUM_ZOOM_LEVEL 90000


@interface MKMapView (AdditionForGoogleLogo) 

- (UIImageView*)googleLogo;

@end

@implementation MKMapView (AdditionForGoogleLogo)

- (UIImageView*)googleLogo {
	UIImageView *imgView = nil;
	for (UIView *subview in self.subviews) {
		if ([subview isMemberOfClass:[UIImageView class]]) {
			imgView = (UIImageView*)subview;
			break;
		}
	}
	
	return imgView;
}

@end

@implementation REVMapViewController
@synthesize pins = _pins,minmax=_minmax;

- (void)dealloc
{
    _mapView.delegate = nil;
    [_mapView release], _mapView = nil;
    
    [_pins release], _pins = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    [self initMapView];
    
}

- (void)initMapView{
    if(_mapView){
        [_mapView removeFromSuperview];
        [_mapView release];
        _mapView = nil;
    }
    
    _mapView = [[REVClusterMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;    

    [self.view addSubview:_mapView];
    
}

- (void)showMap {
    [self zoomToFitMapAnnotations];
    
    if ([_mapView.annotations count]<1) {
        [_mapView addAnnotations:self.pins];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self relocateGoogleLogo];
    //[self zoomToFitMapAnnotations];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation class] == MKUserLocation.class) {
		//userLocation = annotation;
		return nil;
	}
    
    REVClusterPin *pin = (REVClusterPin *)annotation;
    
    MKAnnotationView *annView = (REVClusterAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"cluster"];
    
    
    if (!annView)
        annView = (REVClusterAnnotationView*)[[[REVClusterAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"cluster"] autorelease];

    
    // 
    PhotoModel * photo;
    if ([pin nodeCount] > 0) {
        photo = [(REVClusterPin *)[pin.nodes objectAtIndex:0] photo];
        pin.title = [NSString stringWithFormat:@"%i Photos",[pin nodeCount]];
    } else {
        photo = pin.photo;
        pin.title = @"1 Photo";
    }
    ((REVClusterAnnotationView*)annView).pin = pin;
    
    // 
//    UIImage *arrow = [UIImage imageNamed:@"PhotoPin_DescArrow"];
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, arrow.size.width, arrow.size.height)];
//    [btn setImage:arrow forState:UIControlStateNormal];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    annView.rightCalloutAccessoryView = btn;
//    [btn release];
    
    
    NSString * thumb_url = photo.thumb_url;
    
    UIImage * thumb = [UIImage imageWithContentsOfFile:[LIBRARY_FOLDER stringByAppendingPathComponent:thumb_url]];
    [(REVClusterAnnotationView *)annView setPhotoThumb:thumb];
    
    annView.canShowCallout = YES;
    
    return annView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
//    [_mapView removeAnnotations:_mapView.annotations];
//    _mapView.frame = self.view.bounds;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

-(void)zoomToFitMapAnnotations{
//    if([_mapView.annotations count] == 0)
//        return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = _minmax.min_lat;
    topLeftCoord.longitude = _minmax.min_lon;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = _minmax.max_lat;
    bottomRightCoord.longitude = _minmax.max_lon;
    
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1; // Add a little extra space on the sides
    
    //region = [_mapView regionThatFits:region];
    [_mapView setRegion:region animated:YES];
}


- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"didselectAnnotationView");
}

     

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    REVClusterPin *pin = ((REVClusterAnnotationView*)view).pin;
    NSMutableArray * photos = [[NSMutableArray alloc] init];
    if ([pin.nodes count]<1) {
        [photos addObject:pin.photo];
    } else {
        for(REVClusterPin * pin_ in pin.nodes){
            [photos addObject:pin_.photo];
        }
    }
    
    PhotoDataSource * dataSource = [[PhotoDataSource alloc] initForPhotoModels];
    [dataSource setPhotoModels:photos];
    PhotoViewController * photoVC = [[PhotoViewController alloc] init];
    photoVC.photoDataSource = dataSource;
    [photoVC setDefaultPage:0];
    [photos release];
    
    [[self _navigation] pushViewController:photoVC animated:YES];
    [dataSource release];
    [photoVC release];
}



// 줌 제한

#define MAX_ZOOM_LEVEL 15
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"%f",[mapView getZoomLevel]);
    double currLevel = [mapView getZoomLevel];
    if (currLevel>MAX_ZOOM_LEVEL) {
        [mapView setCenterCoordinate:[mapView centerCoordinate] zoomLevel:MAX_ZOOM_LEVEL animated:YES];
    }
}


////////////// Custom MapView Category start ///////////////

- (void)relocateGoogleLogo {
    
    
	UIImageView *logo = [_mapView googleLogo];
	if (logo == nil)
		return;
	
	CGRect frame = logo.frame;
	frame.origin.y = 480-44-20-(HAS_UPGRADED?0:50) - frame.size.height - frame.origin.x;
	logo.frame = frame;
}
////////////// Custom MapView Category end ///////////////

@end
