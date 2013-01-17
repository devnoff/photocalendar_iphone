//
//  CSWebViewController.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 21..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "CSWebViewController.h"
#import "CSBarButtonItemUtils.h"
#import "AppDelegate.h"

@implementation CSWebViewController
@synthesize webView=_webView,stringURL=_stringURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)dealloc{
    [_webView release];
    [_stringURL release];
    [super dealloc];
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5")) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Bg_Red"] forBarMetrics:UIBarMetricsDefault];
        
    } else {
        self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Bg_Red"]];
    }
    
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = [CSBarButtonItemUtils backButtonWithTitle:@"Back" target:self action:@selector(back)];

    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_stringURL]]];
}
                                                  
                                                
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] hideADViewWithAnimate];
}

//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    [(AppDelegate*)[[UIApplication sharedApplication] delegate] showADViewWithAnimate];
//    
//}

@end
