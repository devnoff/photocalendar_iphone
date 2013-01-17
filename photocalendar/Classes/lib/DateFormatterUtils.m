//
//  DateFormatterUtils.m
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 5..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import "DateFormatterUtils.h"


@implementation DateFormatterUtils


+ (NSString *)stringFromDate:(NSDate *)date withDateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm a"];
    
    return [dateFormatter stringFromDate:date];
}

@end
