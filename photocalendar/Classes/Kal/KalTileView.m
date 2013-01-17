/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import "KalTileView.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "PhotoKalDataSource.h"
#import "KalViewController.h"
#import "DateGroup.h"
#import "PhotoModel.h"
#include <stdlib.h>


extern const CGSize kTileSize;

@interface KalTileView()
- (int)makeRand:(int)numMin maxValue:(int)numMax;
@end

@implementation KalTileView

@synthesize date,delegate, iv;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = NO;
    origin = frame.origin;
    [self resetState];
      
      iv = [[UIImageView alloc] initWithFrame:self.frame];
      //iv.delegate = self;
      [iv setAlpha:0.0f];
      [self insertSubview:iv atIndex:0];
      dv = [[KalDateView alloc] initWithFrame:CGRectMake(0, 0, kTileSize.width, kTileSize.height)];
      dv.delegate = self;
      [self insertSubview:dv atIndex:1];
      [self setUserInteractionEnabled:YES];
  }
  return self;
}



- (void)resetState
{
  // realign to the grid
  CGRect frame = self.frame;
  frame.origin = origin;
  frame.size = kTileSize;
  self.frame = frame;
  
  [date release];
  date = nil;
  flags.type = KalTileTypeRegular;
  flags.highlighted = NO;
  flags.selected = NO;
  flags.marked = NO;
    
    [dv resetState];
}

- (void)setDate:(KalDate *)aDate
{
  if (date == aDate)
    return;

  [date release];
  date = [aDate retain];


    [dv setDate:date];

  [self setNeedsDisplay];
}

- (BOOL)isSelected { return flags.selected; }

- (void)setSelected:(BOOL)selected
{
  if (flags.selected == selected)
    return;

  // workaround since I cannot draw outside of the frame in drawRect:
  if (![self isToday]) {
    CGRect rect = self.frame;
    if (selected) {
      rect.origin.x--;
      rect.size.width++;
      rect.size.height++;
    } else {
      rect.origin.x++;
      rect.size.width--;
      rect.size.height--;
    }
    self.frame = rect;
  }
  
  flags.selected = selected;

    [dv setSelected:flags.selected];

  [self setNeedsDisplay];
}

- (BOOL)isHighlighted { return flags.highlighted; }

- (void)setHighlighted:(BOOL)highlighted
{
  if (flags.highlighted == highlighted)
    return;
  
  flags.highlighted = highlighted;

    [dv setHighlighted:flags.highlighted];
  [self setNeedsDisplay];
}

- (BOOL)isMarked { return flags.marked; }

- (void)setMarked:(BOOL)marked
{
  if (flags.marked == marked)
    return;
  
  flags.marked = marked;
    

    
    [dv setMarked:flags.marked];
      [self setNeedsDisplay];
    
    [iv setFrame:CGRectMake(0, 1, kTileSize.width-1, kTileSize.height-1)];
    
    float t = (rand()%15)+0.3;
    t = t/18;
    NSLog(@"time : %f",t);
    
    [UIView animateWithDuration:t animations:^{
        if (!self.belongsToAdjacentMonth) {
            [iv setAlpha:1.0f];
        } else {
            [iv setAlpha:.3f];
        }
        
    } completion:^(BOOL finished){}];
    
    
}

- (KalTileType)type { return flags.type; }

- (void)setType:(KalTileType)tileType
{
  if (flags.type == tileType)
    return;
  
  // workaround since I cannot draw outside of the frame in drawRect:
  CGRect rect = self.frame;
  if (tileType == KalTileTypeToday) {
    rect.origin.x--;
    rect.size.width++;
    rect.size.height++;
  } else if (flags.type == KalTileTypeToday) {
    rect.origin.x++;
    rect.size.width--;
    rect.size.height--;
  }
  self.frame = rect;
  
  flags.type = tileType;
  
    [dv setType:flags.type];
    
    [self setNeedsDisplay];
}

- (BOOL)isToday { return flags.type == KalTileTypeToday; }

- (BOOL)belongsToAdjacentMonth { return flags.type == KalTileTypeAdjacent; }

- (void)dealloc
{
  [date release];
    [iv release];
  [super dealloc];
}


- (int)makeRand:(int)numMin maxValue:(int)numMax {
    
    int result = 0;
    
    NSString* randSeed = [NSString stringWithFormat:@"%0.9f", [NSDate timeIntervalSinceReferenceDate]];
    randSeed = [randSeed substringFromIndex:10];
    
    srand([randSeed intValue]);
    
    while (result == 0) {
        result = (rand() % (numMax - numMin)) + numMin;
    }
    
    return result;
    
}



@end
