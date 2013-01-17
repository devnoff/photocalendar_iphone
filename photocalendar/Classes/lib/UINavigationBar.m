//
//  UINavigationBar.m
//  travelog
//
//  Created by Cho, Young-Un on 11. 8. 25..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import "UINavigationBar.h"


@implementation UINavigationBar (UINavigationBarCategory)

- (void)drawRectCustom:(CGRect)rect {
    if (UIBarStyleDefault == self.barStyle) {
        UIImage *bgImage = [UIImage imageNamed:@"NavBg.png"];
        [bgImage drawInRect:rect];
        
        return;
    }
    
    [self drawRectCustom:rect];
}

@end
