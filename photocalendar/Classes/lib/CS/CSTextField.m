//
//  CSTextField.m
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 17..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import "CSTextField.h"


@implementation CSTextField

@synthesize padding=_padding;

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(bounds.origin.x + _padding.left, 
                      bounds.origin.y + _padding.top,
                      bounds.size.width - (_padding.left + _padding.right),
                      bounds.size.height - (_padding.top + _padding.bottom));
}


- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [self textRectForBounds:bounds];
}

@end
