//
//  CSLabel.m
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 20..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import "CSLabel.h"


@implementation CSLabel

@synthesize padding=_padding;

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, _padding)];
}

@end
