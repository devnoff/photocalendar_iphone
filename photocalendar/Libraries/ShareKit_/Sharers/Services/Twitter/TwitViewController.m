//
//  TwitViewController.m
//  PhotoCal
//
//  Created by Park Yongnam on 11. 12. 16..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "TwitViewController.h"

@implementation TwitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (id)init{
    self = [super init];
    if (self) {
        
        
        
    }
    
    return self;
}

- (void)loadItem:(SHKItem *)i{
    
    
    
    
    Class twitterClass = NSClassFromString(@"TWTweetComposeViewController");   // for backward compatibility
    if(twitterClass) {
        if ([TWTweetComposeViewController canSendTweet]) {   // to check if twitter is set on settings
            
            TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
            
            [tweetViewController setInitialText:@"From PhotoPlace"];
            
            if (i.image != nil) {
                [tweetViewController addImage:i.image]; // add image. just as it says
            }
            
            
            // check on this part using blocks. no more delegates? :)
            tweetViewController.completionHandler = ^(TWTweetComposeViewControllerResult res) {
                if (res == TWTweetComposeViewControllerResultDone) {
                    
                    // Twitter sent successfully.
                    
                    [self popViewControllerAnimated:YES];
                    
                } else if (res == TWTweetComposeViewControllerResultCancelled) {
                    
                    // Tweet cancelled. 트윗 실패시
                    
                    
                }
                [tweetViewController dismissModalViewControllerAnimated:YES];
                
                [tweetViewController release];
            };
            
            UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
            if (topWindow.windowLevel != UIWindowLevelNormal)
            {
                NSArray *windows = [[UIApplication sharedApplication] windows];
                for(topWindow in windows)
                {
                    if (topWindow.windowLevel == UIWindowLevelNormal)
                        break;
                }
            }
            
            [topWindow.rootViewController presentModalViewController:tweetViewController animated:YES];
            
        } else {
            
            // no twitter set ::: 트위터 설정이 없을 경우 AlertView 로 설정을 변경하라고 알림
            
            NSString * buttonName;
            // ios5 이상일 경우 세팅앱으로 바로 보냄
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5")) {
                buttonName = SHKLocalizedString(@"SETTING ACCOUNT");
            } else {
                buttonName = SHKLocalizedString(@"OK");
            }
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Set Twitter Account")
                                                                 message:SHKLocalizedString(@"Need to set Twitter account in Settings App in order to send twit pics.") 
                                                                delegate:self 
                                                       cancelButtonTitle:SHKLocalizedString(@"NO THANKS") 
                                                       otherButtonTitles:buttonName, nil];
            
            alertView.delegate = self;
            [alertView show];
            [alertView release];
            
        }
        
    } else {
        
        [self popViewControllerAnimated:YES];
    }
    
    

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
    
    
    
}


- (void)viewDidUnload
{

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

+ (BOOL)canShareImage
{
	return YES;
}

+ (NSString *)sharerTitle
{
	return @"Twitter";
}


- (BOOL)isAuthorized
{		
	return YES;
}


#pragma mark - UIAlertViewDelegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            NSLog(@"0 tapped");
            break;
        case 1:
            NSLog(@"1 tapped");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=TWITTER"]];
            break;
    }
}

@end
