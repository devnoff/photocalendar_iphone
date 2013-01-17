//
//  KalDateView.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 17..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>




enum {
    KalTileTypeRegular   = 0,
    KalTileTypeAdjacent  = 1 << 0,
    KalTileTypeToday     = 1 << 1,
};
typedef char KalTileType;

@class KalDate;

@interface KalDateView : UIView
{
    KalDate *date;
    CGPoint origin;
    
    BOOL selected;
    BOOL highlited;
    BOOL marked;
    KalTileType type;

    
    id delegate;
}

@property (nonatomic, retain) KalDate *date;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL marked;
@property (nonatomic, assign) KalTileType type;
@property (nonatomic, assign) id delegate;

- (void)resetState;
- (BOOL)isToday;
- (BOOL)belongsToAdjacentMonth;
- (void)setFlags:(id) aFlags;
@end
