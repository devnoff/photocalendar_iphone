//
//  CSBarButtonItemUtils.h
//  travelog
//
//  Created by Cho, Young-Un on 11. 8. 25..
//  Copyright 2011 cultstory.com. All rights reserved.
//

typedef enum {
    CSBarButtonItemTypeBack,
    CSBarButtonItemTypeCancle,
    CSBarButtonItemTypeDone,
    CSBarButtonItemTypeEdit
} CSBarButtonItemType;



@interface CSBarButtonItemUtils : NSObject {
    
}


+ (UIBarButtonItem *)buttonWithType:(CSBarButtonItemType)barButtonItemType target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)backButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;


+ (UIBarButtonItem *)blackBackButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)blackButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)redButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;


+ (UIBarButtonItem *)smallBlackBackButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
+ (UIBarButtonItem *)smallBlackButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action;
@end
