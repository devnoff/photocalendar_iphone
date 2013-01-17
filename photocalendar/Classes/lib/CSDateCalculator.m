//
//  DateClass.m
//  DateTest
//
//  Created by Darknobi on 11. 1. 19..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CSDateCalculator.h"

@implementation CSDateCalculator
-(id) init{
	self = [super init];
	if(self){
		calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];	
		[calendar setTimeZone:[NSTimeZone systemTimeZone]];
	}
	return self;
}
+(NSDate*)stringToDate:(NSString*)date{
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];	
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	return [dateFormatter dateFromString:date];
}

+(NSString*)dateToString:(NSDate*)date{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-M-d hh:mm:ss"];
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	return [dateFormatter stringFromDate:date];
}

+(NSString*)getRemoveTimeAtDate:(NSString *)date{
	return [[date componentsSeparatedByString:@" "] objectAtIndex:0];
}

+(NSDate*)getDateWithoutTime:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponent = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:date];
    return [calendar dateFromComponents:dateComponent];
}


+(NSDate*)getToDay{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd 12:00:00"];	
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	
	return [CSDateCalculator stringToDate:[dateFormatter stringFromDate:[NSDate date]]];
}
+(BOOL)isLunarDate:(CSDate*)date{
	return date.type == CSDateLunar ||date.type == CSDateLeafMonth;
}


-(NSDate*)getNextEvent:(NSDate*)date repeat:(int)repeat isLunar:(BOOL)isLunar{
	
	NSDate* now = [CSDateCalculator getToDay];
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd 12:00:00"];	
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	
	int interval = [self dateCalculateFromDate:	now toDate:[CSDateCalculator stringToDate:[dateFormatter stringFromDate:date]]];
	if (!repeat || interval >= 0 ) {
		return date;
	}
	
	NSDate *recentdate = nil;
	if (repeat & 1) {
		recentdate =  [self getNextYear:date fixedDate:now next_interval:1];
	}
	if (repeat & 2) {
		if (recentdate == nil) {
			recentdate = [self getNextMonth:date fixedDate:now next_interval:1];
		}else {
			NSDate *new_date = [self getNextMonth:date fixedDate:now next_interval:1];
			int day =[self dateCalculateFromDate:recentdate toDate:new_date];
			recentdate = day>0?recentdate:new_date;
		}
	}
	if (repeat & 4) {
		if (recentdate == nil) {
			return [self getNextDay:date fixedDate:now next_interval:100];
		}
		NSDate *new_date = [self getNextDay:date fixedDate:now next_interval:100];
		int day =[self dateCalculateFromDate:recentdate toDate:new_date];
		recentdate = day>0?recentdate:new_date;
	}
	
	return recentdate;
}
-(BOOL)isThisMonth:(int)endInterval startInterval:(int)startInterval{
    return startInterval > 0 && endInterval <= 0 ;
}

- (NSString *) getKeyForSolar: (NSDate *) endDate startDate: (NSDate *) startDate dic: (NSMutableDictionary *) dic  {
	
	int _repeat = [[dic objectForKey:@"repeat"] intValue];
	NSDate *date = [CSDateCalculator stringToDate:[dic objectForKey:@"anniversarydate"] ];
	if (_repeat == 0)
		return [CSDateCalculator getRemoveTimeAtDate:[CSDateCalculator dateToString:date]];
	
	int startInterval = [self dateCalculateFromDate:startDate toDate:date];
	int endInterval = [self dateCalculateFromDate:endDate toDate:date];		
	
    
	if ([self isThisMonth: endInterval startInterval: startInterval]) 
		return [CSDateCalculator getRemoveTimeAtDate:[CSDateCalculator dateToString:date]];
	
	NSString *key= nil;
	
	NSDate *recentdate = nil;
	switch (_repeat) {
		case 1:
			recentdate =  [self getNextYear:date fixedDate:startDate next_interval:0];
			break;
		case 2:
			recentdate =   [self getNextMonth:date fixedDate:startDate next_interval:1];
			break;
		case 3:
			recentdate =  [self getNextDay:date fixedDate:startDate next_interval:100];
			break;
	}
	if (recentdate && [self dateCalculateFromDate:endDate toDate:recentdate] <= 0) {
		key = [CSDateCalculator getRemoveTimeAtDate:[CSDateCalculator dateToString:recentdate]];
	}
	
	return key;
}


-(NSDate*)getNextDay:(NSDate*)date fixedDate:(NSDate*)fixedDate next_interval:(int)intv{
	NSDate * next_date = [self dateCalculateAtDay:date after:intv];
	int interval = [self dateCalculateFromDate:fixedDate toDate:next_date];
	if (interval < 0) {
		next_date = [self getNextDay:date fixedDate:fixedDate next_interval:intv+100];
	}
	return next_date;
}

-(NSDate*)getNextMonth:(NSDate*)date fixedDate:(NSDate*)fixedDate next_interval:(int)intv{
	NSDate * next_date = [self dateCalculateAtMonth:date after:intv];
	int interval = [self dateCalculateFromDate:fixedDate toDate:next_date];
	if (interval < 0 ) {
		next_date = [self getNextMonth:date fixedDate:fixedDate next_interval:++intv];
	}
	
	return next_date;
}

-(NSDate*)getNextYear:(NSDate*)date fixedDate:(NSDate*)fixedDate next_interval:(int)intv{
	NSDate * next_date = [self dateCalculateAtYear:date after:intv];
	int interval = [self dateCalculateFromDate:fixedDate toDate:next_date];
	if (interval < 0) {
		next_date = [self getNextYear:date fixedDate:fixedDate next_interval:++intv];
	}
	return next_date;
}

-(NSDate*)dateCalculateRepeatDayCount:(int)count fixedDate:(NSDate*)fixedDate targetDate:(NSDate*)targetDate{
	int i = 0;
	NSDateComponents * resultcomps;
	NSDate *target;
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"MM"];
	
	while (i>=0) {
		NSDateComponents *targetcomps = [[NSDateComponents alloc] init];
		[targetcomps setDay:i*count];
		target = [calendar dateByAddingComponents:targetcomps toDate:targetDate options:0];
		[targetcomps release];
		resultcomps =[calendar components:NSMonthCalendarUnit fromDate:fixedDate  toDate:target  options:0];
		if( resultcomps.month == 0){
			if ([[dateFormatter stringFromDate:target] isEqualToString:[dateFormatter stringFromDate:fixedDate]]) {
				return target;
			}
			break;
		}else if(resultcomps.month > 0){
			break;
		}
		i++;
	}
	
	return 	nil;
}

-(NSDate *)dateCalculate:(NSDate *)date afterYear:(int)year afterMonth:(int)month afterDay:(int)day{
	NSDate *result;
	NSDateComponents *comps = [[NSDateComponents alloc] init];
	if (year) {
		[comps setYear:year];
	}
	if (month) {
		[comps setMonth:month];
	}
	if (day) {
		[comps setDay:day];
	}
	
	result = [calendar dateByAddingComponents:comps toDate:date options:0];
	[comps release];
	return result;
	
}
-(NSDate *)dateCalculateAtMonth:(NSDate *)date after:(int)month{
	return [self dateCalculate:date afterYear:0 afterMonth:month afterDay:0];
	
}

-(NSDate *)dateCalculateAtYear:(NSDate *)date after:(int)year{
	return [self dateCalculate:date afterYear:year afterMonth:0 afterDay:0];
}

-(NSDate *)dateCalculateAtDay:(NSDate *)date after:(int)day{
	if (day > 0) {
		day = day -1;
	}
	return [self dateCalculate:date afterYear:0 afterMonth:0 afterDay:day];
}

-(int)dateCalculateAtDay:(NSDate *)date{
	
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd 12:00:00"];	
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	NSDate* now = [CSDateCalculator getToDay];
	NSDateComponents * resultcomps =[calendar components:NSDayCalendarUnit fromDate:[CSDateCalculator stringToDate:[dateFormatter stringFromDate:now]]  toDate:date  options:0];
	
	return resultcomps.day;
}
-(int)dateCalculateAtDay:(NSDate *)date nextDate:(NSDate*)nextDate{
	
	NSDateComponents * resultcomps =[calendar components:NSDayCalendarUnit fromDate:date  toDate:nextDate  options:0];
	
	return resultcomps.day;
}

-(int)dateCalculateAtMonth:(NSDate *)date nextDate:(NSDate*)nextDate{
	
	NSDateComponents * resultcomps =[calendar components:(NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:date  toDate:nextDate  options:0];
	
	return resultcomps.day>0?resultcomps.month+1:resultcomps.month;
}

-(int)dateCalculateAtYear:(NSDate *)date nextDate:(NSDate*)nextDate{
	
	NSDateComponents * resultcomps =[calendar components:(NSYearCalendarUnit|NSDayCalendarUnit) fromDate:date  toDate:nextDate  options:0];
	
	return resultcomps.day?resultcomps.year+1:resultcomps.year;
}

-(int)dateCalculateFromDate:(NSDate *)fromDate toDate:(NSDate*)toDate{
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-MM-dd 12:00:00"];	
	[dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
	NSDateComponents * resultcomps =[calendar components:NSDayCalendarUnit fromDate:[CSDateCalculator stringToDate:[dateFormatter stringFromDate:fromDate]]  toDate:toDate  options:0];
	return resultcomps.day;
}


-(void) dealloc{
	[super dealloc];
	[calendar release];
}


@end
