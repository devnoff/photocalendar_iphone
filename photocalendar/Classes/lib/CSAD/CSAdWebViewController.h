//
//  CSAdWebViewController.h
//  photocalendar
//
//  Created by Yongnam Park on 12. 12. 20..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSAdWebViewController : UIViewController<UIWebViewDelegate>{
    IBOutlet UIWebView *_webView;
    IBOutlet UIButton *_closeBtn;
    IBOutlet UIButton *_checkBox;
    IBOutlet UILabel *_descLabel;

}

@property (nonatomic,strong) NSString *startURL;

@end
