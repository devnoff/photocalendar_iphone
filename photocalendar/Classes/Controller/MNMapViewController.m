//
//  MNMapViewController.m
//  photoplace
//
//  Created by Park Yongnam on 11. 11. 25..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "MNMapViewController.h"
#import "PhotoModel.h"
#import "REVClusterPin.h"
#import "AppDelegate.h"



@interface MNMapViewController()
- (void) loadMapViewWithPhotos:(NSArray *)photos;
- (void) requestAllPhotosFromDelegate:(id)delegate;
@end



@implementation MNMapViewController

@synthesize resultController=_resultController;

- (id)init {
    self = [super init];
    if (self) {
        _loading = NO;
        
        _activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activity startAnimating];
        [_activity hidesWhenStopped];
    }
    
    return self;
}

- (void)dealloc {
    [_resultController release];
    [_activity release];
    [_context release];
    dispatch_release(collectQueue);
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    
    if (!_loading) {
        
        _loading = YES;
        _activity.frame = CGRectMake((self.view.frame.size.width/2)-30, (self.view.frame.size.height/2)-30, 60, 60);
        _activity.hidden = NO;
        [self.view addSubview:_activity];
        
        [self requestAllPhotosFromDelegate:self];    
    }
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear - MNMapView");
//    if (!_loading) {
//    
//        _loading = YES;
//        _activity.frame = CGRectMake((self.view.frame.size.width/2)-30, (self.view.frame.size.height/2)-30, 60, 60);
//        _activity.hidden = NO;
//        [self.view addSubview:_activity];
//        
//        [self requestAllPhotosFromDelegate:self];    
//    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - RequestControllerDelegate methods

- (void)didSuccessRequest:(id)result {
    
    [_activity stopAnimating];
    
    self.resultController = (NSFetchedResultsController *)result;
    
    NSArray *photos =[_resultController fetchedObjects];
    
    dispatch_async(collectQueue, ^{
        [self loadMapViewWithPhotos:photos];
    });
    
    
}

- (void)loadMapViewWithPhotos:(NSArray *)photos {
    NSArray * allObjects = photos;
    
    // 맵뷰에 핀 세팅
    if ([photos count]<1) {
//        [_mapView removeAnnotations:_mapView.annotations];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self showMap];
            
        });
        return;
    }
    CGFloat min_lat = [[[allObjects objectAtIndex:0] location_lat] floatValue];
    CGFloat max_lat = [[[allObjects objectAtIndex:0] location_lat] floatValue];
    CGFloat min_lon = [[[allObjects objectAtIndex:0] location_long] floatValue];
    CGFloat max_lon = [[[allObjects objectAtIndex:0] location_long] floatValue];
    
    NSMutableArray *pins = [[NSMutableArray alloc] init];
    
    for (PhotoModel *photo in photos){
        CGFloat lat = [photo.location_lat floatValue];
        CGFloat lon = [photo.location_long floatValue];
        if (photo.managedObjectContext == nil) {
            // Assume that the managed object has been deleted.
            NSLog(@"managed object context deleted");
        }

        min_lat = lat < min_lat ? lat:min_lat;
        max_lat = lat > max_lat ? lat:max_lat;
        min_lon = lon < min_lon ? lon:min_lon;
        max_lon = lon > max_lon ? lon:max_lon;
        
        CLLocationCoordinate2D newCoord = {lat,lon};
        REVClusterPin *pin = [[REVClusterPin alloc] init];
        [pin setPhoto:photo];
        pin.coordinate = newCoord;
        [pins addObject:pin];
        [pin release];   
    }
    
    //[_mapView addAnnotations:pins];
    self.pins = pins;
    [pins release];
    
    MinMaxLatLon minmax = { min_lat, max_lat, min_lon, max_lon };
    _minmax = minmax;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showMap];
        
    });
    
    NSLog(@"min_lat %f, max_lat %f, min_lon %f, max_lon %f",min_lat, max_lat, min_lon, max_lon);
}


- (void)requestAllPhotosFromDelegate:(id)delegate {
    [NSFetchedResultsController deleteCacheWithName:@"AllPhoto.cache"];
    collectQueue = dispatch_queue_create("collectQueue", NULL);
    dispatch_async(collectQueue, ^{
        
        NSPersistentStoreCoordinator * coord = [(AppDelegate*)[[UIApplication sharedApplication]delegate] persistentStoreCoordinator];
        _context = [[NSManagedObjectContext alloc] init];
        [_context setPersistentStoreCoordinator:coord];
        
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"PhotoModel" inManagedObjectContext:_context];
        [request setEntity:entity];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"location_lat != nil && location_lat != 0"];
        [request setPredicate:predicate];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"string_day" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [request setSortDescriptors:sortDescriptors];
        [sortDescriptors release];
        [sortDescriptor release];
        
        
        NSFetchedResultsController *fetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:request 
                                                                                                   managedObjectContext:_context 
                                                                                                     sectionNameKeyPath:nil 
                                                                                                              cacheName:@"AllPhoto.cache"]autorelease];
        fetchedResultsController.delegate = delegate;
        
        NSError *error;
        BOOL success = [fetchedResultsController performFetch:&error];
        if (!success) {
            //Handle the error.
            NSLog(@"failed to fetch");
        }
        
        [request release];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate didSuccessRequest:fetchedResultsController];
            _loading = NO;
        });
//        [fetchedResultsController release];

    });
}



#pragma mark - MKMapViewDelegate methods

// mapView:annotationView:calloutAccessoryControlTapped: is called when the user taps on left & right callout accessory UIControls.
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    NSLog(@"calloutAccessoryControlTapped");
    [super mapView:mapView annotationView:view calloutAccessoryControlTapped:control];
    
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"didSelectAnnotationView");
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view{
    NSLog(@"didDeselectAnnotationView");
}


- (void)refresh{
    self.pins = [NSArray array];
    [self initMapView];
    [self requestAllPhotosFromDelegate:self]; 
}

@end
