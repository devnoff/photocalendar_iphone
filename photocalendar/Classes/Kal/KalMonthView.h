/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>

@class KalTileView, KalDate;
@protocol KalViewDelegate;

@interface KalMonthView : UIView
{
  NSUInteger numWeeks;
    id delegate;
    id _dataSource;
}

@property (nonatomic) NSUInteger numWeeks;
@property (nonatomic,assign) id delegate;
@property (nonatomic,assign) id _dataSource;

- (id)initWithFrame:(CGRect)rect; // designated initializer
- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates;
- (KalTileView *)firstTileOfMonth;
- (KalTileView *)tileForDate:(KalDate *)date;
- (void)markTilesForDates:(NSArray *)dates;

- (void)resetImageViews;
@end
