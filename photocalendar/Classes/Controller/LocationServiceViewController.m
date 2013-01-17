//
//  LocationServiceViewController.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 26..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "LocationServiceViewController.h"

@implementation LocationServiceViewController

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    for(UIView * v in [self.view subviews]){
        [v removeFromSuperview];
    }
    
    // close button
    
    UIImage *normalImage = [[UIImage imageNamed:@"NavBar_BtnBlack_Round"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    UIImage *highlightedImage = [[UIImage imageNamed:@"NavBar_BtnBlack_Round_.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(4, 5, 48, 30);
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button setTitle:NSLocalizedString(@"CLOSE", nil) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:12.0];
    [button addTarget:self action:@selector(closeBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    
    // title
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 161, self.view.frame.size.width, 18)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:18.0];
    label.textColor = RGB(123, 123, 123);
    label.shadowColor = [UIColor colorWithWhite:0 alpha:.5];
    label.shadowOffset = CGSizeMake(0, -1);
    label.textAlignment = UITextAlignmentCenter;
    label.text = NSLocalizedString(@"LOCATION_SERVICE_TITLE", nil);
    
    [self.view addSubview:label];
    
    
    
    // snap shot
    
    UIImage * snap = [UIImage imageNamed:@"Add26_Msg"];
    UIImageView * snapImg = [[UIImageView alloc] initWithImage:snap];
    snapImg.frame = CGRectMake((self.view.frame.size.width/2)-(snap.size.width/2), label.frame.origin.y+33, snap.size.width, snap.size.height);
    [self.view addSubview:snapImg];
    
    
    // desc
    UILabel * labelDesc = [[UILabel alloc] initWithFrame:CGRectMake(0, snapImg.frame.origin.y+snap.size.height+15, self.view.frame.size.width, 45)];
    labelDesc.backgroundColor = [UIColor clearColor];
    labelDesc.font = [UIFont boldSystemFontOfSize:12.0];
    labelDesc.textColor = RGB(123, 123, 123);
    labelDesc.shadowColor = [UIColor colorWithWhite:0 alpha:.5];
    labelDesc.shadowOffset = CGSizeMake(0, -1);
    labelDesc.textAlignment = UITextAlignmentCenter;
    labelDesc.numberOfLines = 3;
    labelDesc.text = NSLocalizedString(@"LOCATION_SERVICE_DESC", nil);
    
    [self.view addSubview:labelDesc];

    
    
    
    // btn setting 
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5")) {
        UIImage * arrImg = [UIImage imageNamed:@"Add26_BtnArrow"];
        UIButton * arrBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2)-(arrImg.size.width/2), labelDesc.frame.origin.y+labelDesc.frame.size.height+15, arrImg.size.width, arrImg.size.height)];
        [arrBtn setImage:arrImg forState:UIControlStateNormal];
        [arrBtn addTarget:self action:@selector(goSettingApp) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:arrBtn];
        [arrBtn release];
    }
    
    
    // release
    
    [label release];
    [snapImg release];
    [labelDesc release];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)closeBtnTapped:(id)sender{
    BOOL anim=NO;
    if ([sender isKindOfClass:[UIButton class]]) {
        anim = YES;
    }
    [self dismissModalViewControllerAnimated:anim];
}

- (void)goSettingApp{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"]];
}
@end
