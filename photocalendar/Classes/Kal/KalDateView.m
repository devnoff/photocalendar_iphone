//
//  KalDateView.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 17..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "KalDateView.h"


extern const CGSize kTileSize;

@implementation KalDateView
@synthesize date;
@synthesize highlighted;
@synthesize selected;
@synthesize marked;
@synthesize type;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];

        
        [self resetState];
        
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{ 
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    CGFloat fontSize = 11.f;
    UIFont *font = [UIFont boldSystemFontOfSize:fontSize];
    UIColor *shadowColor = nil;
    UIColor *textColor = nil;
    UIImage *markerImage = nil;
    CGContextSelectFont(ctx, [font.fontName cStringUsingEncoding:NSUTF8StringEncoding], fontSize, kCGEncodingMacRoman);
    
    CGContextTranslateCTM(ctx, 0, kTileSize.height);
    CGContextScaleCTM(ctx, 1, -1);
    
    
    if ([self isToday] && self.selected) {
        [[[UIImage imageNamed:@"Kal.bundle/kal_tile_today_selected.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] drawInRect:CGRectMake(0, 0, kTileSize.width, kTileSize.height-1) blendMode:kCGBlendModeNormal alpha:.6];
        textColor = [UIColor whiteColor];
        shadowColor = [UIColor colorWithWhite:0 alpha:.25];
    } else if ([self isToday] && !self.selected) {
        [[[UIImage imageNamed:@"Kal.bundle/kal_tile_today.png"] stretchableImageWithLeftCapWidth:6 topCapHeight:0] drawInRect:CGRectMake(0, 0, kTileSize.width, kTileSize.height-1)];
        textColor = [UIColor whiteColor];
        shadowColor = [UIColor colorWithWhite:0 alpha:.25];
    } else if (self.selected) {
        [[[UIImage imageNamed:@"Kal.bundle/kal_tile_selected.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0] drawInRect:CGRectMake(0, 0, kTileSize.width, kTileSize.height-1)];
        textColor = [UIColor whiteColor];
        shadowColor = [UIColor colorWithWhite:0 alpha:.25];
    } else if (self.belongsToAdjacentMonth) {  // 현재달이 아닌 타일
        textColor = RGB(120, 120, 120);
        shadowColor = [UIColor colorWithWhite:1 alpha:.1];
    } else {
        textColor = RGB(180, 180, 180);
        shadowColor = [UIColor colorWithWhite:0 alpha:.25];
    }
    
    if (marked)
        [markerImage drawInRect:CGRectMake(21.f, 5.f, 4.f, 5.f)];
    
    NSUInteger n = [self.date day];
    NSString *dayText = [NSString stringWithFormat:@"%lu", (unsigned long)n];
    const char *day = [dayText cStringUsingEncoding:NSUTF8StringEncoding];
    CGSize textSize = [dayText sizeWithFont:font];
    CGFloat textX, textY;
    textX = 5;
    textY = kTileSize.height - ((textSize.height/2) + 8);
    if (shadowColor) {
        [shadowColor setFill];
        if (self.belongsToAdjacentMonth) {
            CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);
            textY += 1.f;
        } else {
            CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);
            textY -= 1.f;
        }
    }
    [textColor setFill];
    CGContextShowTextAtPoint(ctx, textX, textY, day, n >= 10 ? 2 : 1);
    
    if (self.highlighted) {
        [[UIColor colorWithWhite:0.25f alpha:0.3f] setFill];
        CGContextFillRect(ctx, CGRectMake(0.f, 0.f, kTileSize.width, kTileSize.height));
    }
}


- (void)resetState
{
    [date release];
    date = nil;
    type = KalTileTypeRegular;
    highlighted = NO;
    selected = NO;
    marked = NO;
    
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)aHighlighted{
    highlighted = aHighlighted;
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)aselected{
    selected = aselected;
    [self setNeedsDisplay];
}

- (void)setMarked:(BOOL)amarked{
    marked = amarked;
    [self setNeedsDisplay];
}

- (void)setType:(KalTileType)atype{
    type = atype;
    [self setNeedsDisplay];
}


- (BOOL)isToday{
   return [delegate isToday];
}
- (BOOL)belongsToAdjacentMonth{
   return [delegate belongsToAdjacentMonth];
}


- (void)dealloc
{
    [date release];
    [super dealloc];
}

- (void)setFlags:(id) aFlags{
    
}
@end
