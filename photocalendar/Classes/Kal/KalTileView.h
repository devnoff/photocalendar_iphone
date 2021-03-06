/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KalDateView.h"

//enum {
//  KalTileTypeRegular   = 0,
//  KalTileTypeAdjacent  = 1 << 0,
//  KalTileTypeToday     = 1 << 1,
//};
//typedef char KalTileType;

@class KalDate;

@interface KalTileView : UIView
{
  KalDate *date;
  CGPoint origin;
  struct {
    unsigned int selected : 1;
    unsigned int highlighted : 1;
    unsigned int marked : 1;
    unsigned int type : 2;
  } flags;
    
    id delegate;
    
    UIImageView * iv;
    KalDateView *dv;
}

@property (nonatomic, retain) KalDate *date;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isSelected) BOOL selected;
@property (nonatomic, getter=isMarked) BOOL marked;
@property (nonatomic) KalTileType type;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) UIImageView *iv;

- (void)resetState;
- (BOOL)isToday;
- (BOOL)belongsToAdjacentMonth;
//- (void)setThumbPhoto;

@end
