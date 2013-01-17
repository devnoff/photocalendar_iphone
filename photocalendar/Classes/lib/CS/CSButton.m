//
//  CSButton.m
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 28..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import "CSButton.h"


@implementation CSButton

@synthesize inputView=_inputView;
@synthesize canBecomeFirstResponder=_canBecomeFirstResponder;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)dealloc
{
    [_inputView release];
    
    [super dealloc];
}


- (BOOL)canBecomeFirstResponder {
    return _canBecomeFirstResponder;
}

@end
