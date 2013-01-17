//
//  NewLoadingViewController.m
//  photocalendar
//
//  Created by Park Yongnam on 12. 1. 11..
//  Copyright (c) 2012 CultStory Inc. All rights reserved.
//

#import "NewLoadingViewController.h"

@implementation NewLoadingViewController

@synthesize delegate = _delegate;

- (void)dealloc{
    _backLoading.delegate = nil;
    [_backLoading release];
    _delegate = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        if (!_backLoading){
            _backLoading = [[BackgroundLoadingController alloc] init];
            _backLoading.delegate = self;    
        }
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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


- (void)backgroundLoadingUpdateUIProcessingValue:(int)current total:(int)total title:(NSString *)title{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateProgressWithValues:current totalCnt:total withTitle:title];
    }); 
    
}

- (void)updateProgressWithValues:(NSInteger)currCnt totalCnt:(NSInteger)totalCnt withTitle:(NSString*)title{
    NSInteger count = currCnt;
    NSInteger total = totalCnt;
    double prog = (count+0.0)/(total+0.0);
    //NSLog(@"prog: %f",prog);
    NSString * desc = title;
    if (!desc) {
        desc = [NSString stringWithFormat:@"%d/%d", count,total];
    }
    
    
    [_progView setProgress:prog];
    [_progDesc setText:desc];
    
}


- (void)backgroundLoadingDidFailedLoading{
    [_delegate didFailedLoading];
}

- (void)backgroundLoadingDidFinishedLoadingWithAssetsLibrary:(ALAssetsLibrary *)library{
    [_delegate didFinishedLoadingWithAssetsLibrary:library];
}

- (void)backgroundLoadingDidFinishLoadindWithNoPhoto{
    [_delegate didFinishLoadindWithNoPhoto];
}


@end
