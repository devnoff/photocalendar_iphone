//
//  CSToolbar.m
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 5..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import "CSToolbar.h"


@implementation CSToolbar

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.translucent = YES;
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.opaque = NO;
        self.translucent = YES;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
}


- (void)dealloc
{
    [super dealloc];
}

@end
