//
//  CSWebViewController.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 21..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSWebViewController : UIViewController{
    IBOutlet UIWebView * _webView;
    
    NSString * _stringURL;
}

@property (nonatomic,retain) UIWebView * webView;
@property (nonatomic,retain) NSString * stringURL;


- (void)back;

@end
