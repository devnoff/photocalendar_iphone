//
//  DateClass.h
//  DateTest
//
//  Created by ;; on 11. 1. 19..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSDate.h"

@interface CSDateCalculator : NSObject {
@private
	NSCalendar *calendar;
}
+(NSDate*)stringToDate:(NSString*)date;
+(NSString*)dateToString:(NSDate*)date;
+(NSString*)getRemoveTimeAtDate:(NSString *)date;
+(NSDate*)getDateWithoutTime:(NSDate*)date;
+(BOOL)isLunarDate:(CSDate*)date;
-(int)dateCalculateAtDay:(NSDate *)date;


-(int)dateCalculateFromDate:(NSDate *)fromDate toDate:(NSDate*)toDate;

-(NSDate*)dateCalculateRepeatDayCount:(int)count fixedDate:(NSDate*)fixedDate targetDate:(NSDate*)targetDate;
-(NSDate*)getNextDay:(NSDate*)date fixedDate:(NSDate*)fixedDate next_interval:(int)intv;
-(NSDate*)getNextMonth:(NSDate*)date fixedDate:(NSDate*)fixedDate next_interval:(int)intv;
-(NSDate*)getNextYear:(NSDate*)date fixedDate:(NSDate*)fixedDate next_interval:(int)intv;
-(NSDate *)dateCalculateAtYear:(NSDate *)date after:(int)year;
-(NSDate *)dateCalculateAtMonth:(NSDate *)date after:(int)month;
-(NSDate *)dateCalculateAtDay:(NSDate *)date after:(int)day;;
-(NSDate*)getNextEvent:(NSDate*)date repeat:(int)repeat isLunar:(BOOL)isLunar;
-(int)dateCalculateAtYear:(NSDate *)date nextDate:(NSDate*)nextDate;
//-(NSDictionary*)getThisMonthEvent:(NSArray*)dateArr startDate:(NSDate*)startDate endDate:(NSDate*)endDate;
//-(NSString*)getNextEventFromLunar:(NSString*)date  repeat:(int)repeat isLeaf:(BOOL)isLeaf;
-(int)dateCalculateAtMonth:(NSDate *)date nextDate:(NSDate*)nextDate;
-(int)dateCalculateAtDay:(NSDate *)date nextDate:(NSDate*)nextDate;
@end
