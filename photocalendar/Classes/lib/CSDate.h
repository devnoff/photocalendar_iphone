//
//  CSDate.h
//  new_d_day
//
//  Created by Darknobi on 11. 4. 18..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
	CSDateSolar = 0,
	CSDateLunar = 1,
	CSDateLeafMonth = 2
}DateType;

@interface CSDate : NSObject {
	int year;
	int month;
	int day;
	DateType type;
}
@property (readonly)int year;
@property (readonly)int month;
@property (readonly)int day;
@property DateType type;
-(id)initWithYear:(int)y month:(int)m day:(int)d type:(DateType)t;
-(id)initWithYear:(int)y month:(int)m day:(int)d;
-(NSString*)getMonthString;
-(int)nextMonth;
@end
