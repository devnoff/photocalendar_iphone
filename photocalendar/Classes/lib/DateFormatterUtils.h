//
//  DateFormatterUtils.h
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 5..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#define kDATE_FORMAT_1 @"dd/MM/yyyy hh:mm a"


@interface DateFormatterUtils : NSObject {
    
}


+ (NSString *)stringFromDate:(NSDate *)date withDateFormat:(NSString *)dateFormat;

@end
