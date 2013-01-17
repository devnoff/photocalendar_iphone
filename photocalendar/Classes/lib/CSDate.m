//
//  CSDate.m
//  new_d_day
//
//  Created by Darknobi on 11. 4. 18..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CSDate.h"


@implementation CSDate
@synthesize year,month,day,type;
-(id)initWithYear:(int)y month:(int)m day:(int)d{
	self = [super init];
	if (self) {
		year = y;
		month = m;
		day = d;
	}
	return self;
}

-(id)initWithYear:(int)y month:(int)m day:(int)d type:(DateType)t{
	self = [self initWithYear:y month:m day:d];
	if (self) {
		year = y;
		month = m;
		day = d;
		type = t;
	}
	return self;
}
-(int)nextMonth{
	int next_month = month+1;
	if (next_month >12) {
		next_month = 1;
	}
	return next_month;
}
-(NSString*)getMonthString{
	NSString *str[] = {@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December"};
	return str[month-1];
}
@end
