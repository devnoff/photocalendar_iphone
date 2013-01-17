//
//  CSBarButtonItemUtils.m
//  travelog
//
//  Created by Cho, Young-Un on 11. 8. 25..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import "CSBarButtonItemUtils.h"


@implementation CSBarButtonItemUtils

+ (UIBarButtonItem *)buttonWithType:(CSBarButtonItemType)barButtonItemType target:(id)target action:(SEL)action {
    NSArray *buttonName = [NSArray arrayWithObjects:@"Back", @"Cancel", @"Done", @"Edit", nil];
    
    UIImage *normalImage = [UIImage imageNamed:[NSString stringWithFormat:@"NavBtn%@.png", [buttonName objectAtIndex:barButtonItemType]]];
    UIImage *highlightedImage = [UIImage imageNamed:[NSString stringWithFormat:@"NavBtn%@.png", [buttonName objectAtIndex:barButtonItemType]]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, normalImage.size.width, normalImage.size.height);
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightedImage forState:UIControlStateHighlighted];
    if (nil != target && nil != action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    

    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}


+ (UIBarButtonItem *)backButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    // 최대 너비는 160
    // 최소 너비는 이미지 크기를 기준으로
    
    int buttonMaxWidth = 160;
    int buttonHeight = 30;
    int labelOffsetStart = 15;
    int labelOffsetEnd = 10;
    int labelMaxWidth = buttonMaxWidth - (labelOffsetStart + labelOffsetEnd);
    int labelWidth = labelMaxWidth;
    
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    CGSize size = [title sizeWithFont:font];
    if (size.width < labelMaxWidth) {
        labelWidth = size.width;
    }
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(labelOffsetStart, -1, labelWidth, buttonHeight)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.text = title;
    label.shadowColor = [UIColor colorWithWhite:0 alpha:.8];
    label.shadowOffset = CGSizeMake(0, -1);
    
    
    // 이미지 크기가 버튼 최소 크기
    UIImage *normalImage = [[UIImage imageNamed:@"NavBar_BtnRed.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    UIImage *highlightedImage = [[UIImage imageNamed:@"NavBar_BtnRed_On.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    
    int buttonWidth = labelWidth + (labelOffsetStart + labelOffsetEnd);
    size = normalImage.size;
    if (buttonWidth < size.width) {
        buttonWidth = size.width;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button addSubview:label];
    if (nil != target && nil != action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

+ (UIBarButtonItem *)blackBackButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    // 최대 너비는 160
    // 최소 너비는 이미지 크기를 기준으로
    
    int buttonMaxWidth = 160;
    int buttonHeight = 30;
    int labelOffsetStart = 15;
    int labelOffsetEnd = 10;
    int labelMaxWidth = buttonMaxWidth - (labelOffsetStart + labelOffsetEnd);
    int labelWidth = labelMaxWidth;
    
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    CGSize size = [title sizeWithFont:font];
    if (size.width < labelMaxWidth) {
        labelWidth = size.width;
    }
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(labelOffsetStart, -1, labelWidth, buttonHeight)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.text = title;
    
    
    // 이미지 크기가 버튼 최소 크기
    UIImage *normalImage = [[UIImage imageNamed:@"NavBar_BtnBlack.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    UIImage *highlightedImage = [[UIImage imageNamed:@"NavBar_BtnBlack_On.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    
    int buttonWidth = labelWidth + (labelOffsetStart + labelOffsetEnd);
    size = normalImage.size;
    if (buttonWidth < size.width) {
        buttonWidth = size.width;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button addSubview:label];
    if (nil != target && nil != action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

+ (UIBarButtonItem *)blackButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    // 최대 너비는 160
    // 최소 너비는 이미지 크기를 기준으로
    
    int buttonMaxWidth = 160;
    int buttonHeight = 30;
    int labelOffsetStart = 12;
    int labelOffsetEnd = 10;
    int labelMaxWidth = buttonMaxWidth - (labelOffsetStart + labelOffsetEnd);
    int labelWidth = labelMaxWidth;
    
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    CGSize size = [title sizeWithFont:font];
    if (size.width < labelMaxWidth) {
        labelWidth = size.width;
    }
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(labelOffsetStart, -1, labelWidth, buttonHeight)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.text = title;
    
    
    // 이미지 크기가 버튼 최소 크기
    UIImage *normalImage = [[UIImage imageNamed:@"NavBar_BtnBlack_Round"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    UIImage *highlightedImage = [[UIImage imageNamed:@"NavBar_BtnBlack_Round_On"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    
    int buttonWidth = labelWidth + (labelOffsetStart + labelOffsetEnd);
    size = normalImage.size;
    if (buttonWidth < size.width) {
        buttonWidth = size.width;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button addSubview:label];
    if (nil != target && nil != action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}


+ (UIBarButtonItem *)redButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    // 최대 너비는 160
    // 최소 너비는 이미지 크기를 기준으로
    
    int buttonMaxWidth = 160;
    int buttonHeight = 30;
    int labelOffsetStart = 12;
    int labelOffsetEnd = 10;
    int labelMaxWidth = buttonMaxWidth - (labelOffsetStart + labelOffsetEnd);
    int labelWidth = labelMaxWidth;
    
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    CGSize size = [title sizeWithFont:font];
    if (size.width < labelMaxWidth) {
        labelWidth = size.width;
    }
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(labelOffsetStart, -1, labelWidth, buttonHeight)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.text = title;
    
    
    // 이미지 크기가 버튼 최소 크기
    UIImage *normalImage = [[UIImage imageNamed:@"NavBar_BtnRed_Cancel"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    UIImage *highlightedImage = [[UIImage imageNamed:@"NavBar_BtnRed_Cancel_On"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    
    int buttonWidth = labelWidth + (labelOffsetStart + labelOffsetEnd);
    size = normalImage.size;
    if (buttonWidth < size.width) {
        buttonWidth = size.width;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button addSubview:label];
    if (nil != target && nil != action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}


+ (UIBarButtonItem *)smallBlackBackButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    // 최대 너비는 160
    // 최소 너비는 이미지 크기를 기준으로
    
    int buttonMaxWidth = 160;
    int buttonHeight = 24;
    int labelOffsetStart = 15;
    int labelOffsetEnd = 10;
    int labelMaxWidth = buttonMaxWidth - (labelOffsetStart + labelOffsetEnd);
    int labelWidth = labelMaxWidth;
    
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    CGSize size = [title sizeWithFont:font];
    if (size.width < labelMaxWidth) {
        labelWidth = size.width;
    }
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(labelOffsetStart, -1, labelWidth, buttonHeight)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.text = title;
    
    
    // 이미지 크기가 버튼 최소 크기
    UIImage *normalImage = [[UIImage imageNamed:@"NavBar_Hr_BtnBlack.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    UIImage *highlightedImage = [[UIImage imageNamed:@"NavBar_Hr_BtnBlack_On.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    
    int buttonWidth = labelWidth + (labelOffsetStart + labelOffsetEnd);
    size = normalImage.size;
    if (buttonWidth < size.width) {
        buttonWidth = size.width;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button addSubview:label];
    if (nil != target && nil != action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

+ (UIBarButtonItem *)smallBlackButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    // 최대 너비는 160
    // 최소 너비는 이미지 크기를 기준으로
    
    int buttonMaxWidth = 160;
    int buttonHeight = 24;
    int labelOffsetStart = 12;
    int labelOffsetEnd = 10;
    int labelMaxWidth = buttonMaxWidth - (labelOffsetStart + labelOffsetEnd);
    int labelWidth = labelMaxWidth;
    
    UIFont *font = [UIFont boldSystemFontOfSize:12.0f];
    CGSize size = [title sizeWithFont:font];
    if (size.width < labelMaxWidth) {
        labelWidth = size.width;
    }
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(labelOffsetStart, -1, labelWidth, buttonHeight)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.font = font;
    label.textColor = [UIColor whiteColor];
    label.text = title;
    
    
    // 이미지 크기가 버튼 최소 크기
    UIImage *normalImage = [[UIImage imageNamed:@"NavBar_Hr_BtnBlack_Round"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    UIImage *highlightedImage = [[UIImage imageNamed:@"NavBar_Hr_BtnBlack_Round_On"] stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    
    int buttonWidth = labelWidth + (labelOffsetStart + labelOffsetEnd);
    size = normalImage.size;
    if (buttonWidth < size.width) {
        buttonWidth = size.width;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonWidth, buttonHeight);
    [button setBackgroundImage:normalImage forState:UIControlStateNormal];
    [button setBackgroundImage:highlightedImage forState:UIControlStateHighlighted];
    [button addSubview:label];
    if (nil != target && nil != action) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
}

@end
