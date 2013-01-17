//
//  RootViewController.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 4..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import "RootViewController.h"
#import "AlbumsViewController.h"
#import "MonthViewController.h"
#import "SettingsViewController.h"

#import "KalViewController.h"
#import "PhotoKalDataSource.h"
#import "MNMapViewController.h"

@implementation UINavigationBar (CustomImage)


- (void)drawRect:(CGRect)rect {

//    UIImage *image = [UIImage imageNamed:@"Bg_Red"];
//    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];        

    [super drawRect:rect];
}
@end

@interface RootViewController ()

@end

@implementation RootViewController

@synthesize controllers = _controllers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        
        _index = 0;
        // 
        _controllers = [[NSMutableArray alloc] init];
        
        // init controllers
        AlbumsViewController * albumVc = [[AlbumsViewController alloc] initWithNibName:@"AlbumsViewController" bundle:nil];
        [_controllers addObject:albumVc];
        [self addChildViewController:albumVc];
        [albumVc release];
        
        MonthViewController * monthVc = [[MonthViewController alloc] initWithNibName:@"MonthViewController" bundle:nil];
        [_controllers addObject:monthVc];
        [self addChildViewController:monthVc];
        [monthVc release];
        
        //CalendarViewController * calendarVc = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
        //[_controllers addObject:calendarVc];
        //[calendarVc release];
        
        PhotoKalDataSource * source = [[PhotoKalDataSource alloc] init];
        KalViewController * calendarVC = [[KalViewController alloc] initWithSelectedDate:[NSDate date]];
        [calendarVC setDataSource:source];
        [calendarVC setDelegate:source];
        [_controllers addObject:calendarVC];
        [self addChildViewController:calendarVC];
        [calendarVC release];
        [source release];
        
        
        MNMapViewController * _mapView = [[MNMapViewController alloc] init];
        _mapView.view.frame = ADS_FRAME;//CGRectMake(0, -20, 320, 480-20-64);
        [_controllers addObject:_mapView];
        [self addChildViewController:_mapView];
        [_mapView release];
        
        
        
        SettingsViewController * settingsVc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
        [_controllers addObject:settingsVc];
        [self addChildViewController:settingsVc];
        [settingsVc release];
        
    
        // init navigation view
        _csNavigationView = [[CSNavigationView alloc] initWithFrame:CGRectMake(0, 0, 320.0, 44.0) 
                                                     withLabelTexts:[NSArray arrayWithObjects:
                                                                     NSLocalizedString(@"ALBUMS", nil),
                                                                     NSLocalizedString(@"MONTH", nil),
                                                                     NSLocalizedString(@"CALENDAR", nil),
                                                                     NSLocalizedString(@"MAP", nil),nil]];
        _csNavigationView.delegate = self;
        [_csNavigationView setViewControllers:_controllers];
        
    
        // right margin of navigation bar
        UIView * rightMargin = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
        rightMargin.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UIBarButtonItem * rightM = [[[UIBarButtonItem alloc] initWithCustomView:rightMargin] autorelease];
        [rightMargin release];
        rightM.width = 1;

        
        
        
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = rightM;
        self.navigationItem.titleView = _csNavigationView;
        
        
        [_csNavigationView selectedIndex:_index];
        
    }
    return self;
}

- (void) awakeFromNib{
    [super awakeFromNib];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Bg"]]];
    
//    [self didSelectedViewController:[_controllers objectAtIndex:_index] atIndex:_index];
    
//    NSLog(@"rootview viewdidload : %@  / %d", [_controllers objectAtIndex:_index], _index);
}

#pragma mark - view life cycle

- (void)dealloc{
    [_csNavigationView release];
    [_controllers release];
    [super dealloc];
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

//    [[_controllers objectAtIndex:_index] viewDidUnload];
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}



#pragma mark - CSNavigationDelegate methods

- (void) didSelectedViewController:(UIViewController*)viewController atIndex:(NSInteger)index{
    
    
    
    NSLog(@"didSecectedViewContriller");
    for (id view in [self.view subviews]) {
        if ([view isKindOfClass:[UIButton class]]) continue;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.4];
        [view setAlpha:0.0f];
        [UIView commitAnimations];
        [view removeFromSuperview];
    }

    if (SYSTEM_VERSION_LESS_THAN(@"5"))
        [viewController viewWillAppear:YES];
    UIView * subView = viewController.view;
    subView.frame = self.view.frame;
    [subView setAlpha:0.0f];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.4];
    [subView setAlpha:1.0f];
    [UIView commitAnimations];
    [self.view addSubview:subView];
    if (SYSTEM_VERSION_LESS_THAN(@"5"))
        [viewController viewDidAppear:YES];
    
    _index = index;
}

- (void)refresh{
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
