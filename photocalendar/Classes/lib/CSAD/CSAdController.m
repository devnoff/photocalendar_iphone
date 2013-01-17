//
//  CSAdController.m
//  photocalendar
//
//  Created by Yongnam Park on 12. 12. 20..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import "CSAdController.h"
#import "CSAsyncRequest.h"
#import "CSAdWebViewController.h"

#define API_KEY @"X-API-KEY"
#define CSAD_TYPE_BANNER @"csad_type_banner"
#define CSAD_TYPE_FULLSCREEN @"csad_type_fullscreen"


#define kAPI_RESULT_OK 0
#define kAPI_RESULT_SERVER_ERROR 1
#define kAPI_RESULT_LACK_PARAMS 2
#define kAPI_RESULT_NOT_PERMITTED 3
#define kAPI_RESULT_FAIL 4
#define kAPI_RESULT_LATEST 5

@implementation CSAdController



//#pragma mark Singleton Methods
//
//+ (id)sharedController {
//    static CSAdController *sharedAdController = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedAdController = [[self alloc] init];
//    });
//    return sharedAdController;
//}
//
//- (id)init {
//    if (self = [super init]) {
//        
//    }
//    return self;
//}
//

+ (void)requestFullscreenADForViewController:(UIViewController*)controller{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSDate *hideFrom = [NSDate dateWithTimeIntervalSince1970:[def doubleForKey:CSAD_HIDE_FOR_30_DAYS_FROM]];
    NSDate *now = [NSDate date];
    NSDate *hideTo = [hideFrom dateByAddingTimeInterval:(30 * 24 * 60 * 60)]; // 60 sec * 60min * 24hour * 30days
    
    BOOL shouldShowAd = [hideTo compare:now] == NSOrderedAscending;
    
    if (shouldShowAd){
        
        // 앱번들ID
        NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
        
        // 언어코드
        NSString *languageCode = [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
        
        // 국가코드
        NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
        
        
        NSString *requestUrl = [NSString stringWithFormat:
                                @"http://ad.cultstory.com/api/v1/requestAD?bundleID=%@&languageCode=%@&countryCode=%@&type=%@",
                                bundleID,
                                languageCode,
                                countryCode,
                                CSAD_TYPE_FULLSCREEN];
        
        CSAsyncRequest *asyncRequest = [[CSAsyncRequest alloc] init];
        [asyncRequest appendHeaderKey:@"X-API-KEY" value:API_KEY];
        [asyncRequest get:requestUrl
             successBlock:^(NSDictionary *data) {
                 
                 NSLog(@"URL: %@ \nResult Data: %@",requestUrl,data);
                 
                 int code = [[data objectForKey:@"code"] intValue];
                 if (code == kAPI_RESULT_OK){
                     NSDictionary *result = [data objectForKey:@"result"];
                     
                     CSAdWebViewController *web = [[CSAdWebViewController alloc] initWithNibName:@"CSAdWebViewController" bundle:nil];
                     web.startURL = [result objectForKey:@"content_url"];
                     if (controller && [controller respondsToSelector:@selector(presentModalViewController:animated:)])
                         [controller presentModalViewController:web animated:YES];
                     
                 }
                 
             }
              failureBock:^(NSError *error) {
                  
              }];
        
        
    }
    
}

@end
