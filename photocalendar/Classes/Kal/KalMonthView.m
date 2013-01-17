/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalView.h"
#import "KalDate.h"
#import "KalPrivate.h"

#import "PhotoKalDataSource.h"
#import "KalViewController.h"
#import "DateGroup.h"
#import "PhotoModel.h"

extern const CGSize kTileSize;

@implementation KalMonthView

@synthesize numWeeks,delegate,_dataSource;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    self.clipsToBounds = YES;
    for (int i=0; i<6; i++) {
      for (int j=0; j<7; j++) {
        CGRect r = CGRectMake(j*kTileSize.width, i*kTileSize.height, kTileSize.width, kTileSize.height);
          KalTileView * tile = [[[KalTileView alloc] initWithFrame:r] autorelease];
          tile.delegate = self;
        [self addSubview:tile];
      }
    }
  }
  return self;
}

- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates
{
  int tileNum = 0;
  NSArray *dates[] = { leadingAdjacentDates, mainDates, trailingAdjacentDates };
  
  for (int i=0; i<3; i++) {
    for (KalDate *d in dates[i]) {
      KalTileView *tile = [self.subviews objectAtIndex:tileNum];
      [tile resetState];
      tile.date = d;
      tile.type = dates[i] != mainDates
                    ? KalTileTypeAdjacent
                    : [d isToday] ? KalTileTypeToday : KalTileTypeRegular;
      tileNum++;
    }
  }
  
  numWeeks = ceilf(tileNum / 7.f);
  [self sizeToFit];
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,kTileSize}, [[UIImage imageNamed:@"Kal.bundle/kal_tile.png"] CGImage]);
}

- (KalTileView *)firstTileOfMonth
{
  KalTileView *tile = nil;
  for (KalTileView *t in self.subviews) {
    if (!t.belongsToAdjacentMonth) {
      tile = t;
      break;
    }
  }
  
  return tile;
}

- (KalTileView *)tileForDate:(KalDate *)date
{
  KalTileView *tile = nil;
  for (KalTileView *t in self.subviews) {
    if ([t.date isEqual:date]) {
      tile = t;
      break;
    }
  }
  NSAssert1(tile != nil, @"Failed to find corresponding tile for date %@", date);
  
  return tile;
}

- (void)sizeToFit
{
  self.height = 1.f + kTileSize.height * numWeeks;
}

- (void)markTilesForDates:(NSArray *)dates
{
    
    PhotoKalDataSource * dataSource = (PhotoKalDataSource*)[(KalViewController*)_dataSource dataSource];
    NSArray * arr = [dataSource.resultController fetchedObjects];
    
    for (KalTileView *tile in self.subviews){
        BOOL mark = [dates containsObject:tile.date];
        tile.marked = mark;
        
        if (mark) {
            KalDate * date = tile.date;
            NSCalendar *calendar = [NSCalendar currentCalendar];
            
            for(DateGroup * group in arr){
                NSDateComponents *dc1 = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit ) fromDate:group.date];
                if(date.year==dc1.year&&date.month==dc1.month&&date.day==dc1.day){
                    
                    if ([group.photos count]>0) {
                        NSString * filePath = [LIBRARY_FOLDER stringByAppendingPathComponent:[(PhotoModel*)[group latestPhoto] thumb_url]];
                        tile.iv.image = [UIImage imageWithContentsOfFile:filePath];    
                    }
                    
                    break;
                }
            }    
        } else {
            tile.iv.image = nil;
            [tile setNeedsDisplay];
        }
        
    }
}

- (void)resetImageViews{
    for (KalTileView *tile in self.subviews){
        [tile.iv setAlpha:0.0f];
    }
}



@end
