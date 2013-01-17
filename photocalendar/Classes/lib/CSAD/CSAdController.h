//
//  CSAdController.h
//  photocalendar
//
//  Created by Yongnam Park on 12. 12. 20..
//  Copyright (c) 2012년 CultStory Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CSAD_HIDE_FOR_30_DAYS_FROM @"cs_ad_hide_for_30_days_from"

@interface CSAdController : NSObject

//+ (id)sharedController;


+ (void)requestFullscreenADForViewController:(UIViewController*)controller;



@end
