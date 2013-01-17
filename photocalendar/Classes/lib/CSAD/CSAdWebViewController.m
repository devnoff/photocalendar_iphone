//
//  CSAdWebViewController.m
//  photocalendar
//
//  Created by Yongnam Park on 12. 12. 20..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "CSAdWebViewController.h"
#import "CSAdController.h"

@interface CSAdWebViewController ()

@end




@implementation CSAdWebViewController
@synthesize startURL;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - Button Actions
- (IBAction)closeBtnTapped:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Checkbox

- (IBAction)checkboxTapped:(id)sender{
    UIButton *checkbox = (UIButton*)sender;
    
    checkbox.selected = !checkbox.selected;
    
    if (checkbox.selected){
        double currentTimestamp = [[NSDate date] timeIntervalSince1970];
        
        [[NSUserDefaults standardUserDefaults] setDouble:currentTimestamp forKey:CSAD_HIDE_FOR_30_DAYS_FROM];

    } else {
        [[NSUserDefaults standardUserDefaults] setDouble:0 forKey:CSAD_HIDE_FOR_30_DAYS_FROM];

    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [_closeBtn setTitle:NSLocalizedStringFromTable(@"Close", @"CSAD_localized", nil) forState:UIControlStateNormal];
    [_descLabel setText:NSLocalizedStringFromTable(@"Hide AD for 30 days", @"CSAD_localized", nil)];
    
    _webView.delegate = self;
    if (self.startURL){
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.startURL]]];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)req navigationType:(UIWebViewNavigationType)navigationType{
   
    NSMutableURLRequest *request = (NSMutableURLRequest *)req;
    
    NSString *url = [[request URL] absoluteString];
    NSLog(@"url : %@",url);
    NSArray *comp = [url componentsSeparatedByString:@":"];
    if (comp.count <= 1)
        return YES;
    
    if ([[comp objectAtIndex:0] isEqualToString:@"itms"] || [[comp objectAtIndex:0] isEqualToString:@"itms-apps"] || [[comp objectAtIndex:0] isEqualToString:@"browser"]){
        
        // 앱 링크 일 경우 앱스토어 열기
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return NO;
    }
  
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


@end
