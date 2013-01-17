//
//  CSButton.h
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 28..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CSButton : UIButton {
@private
    UIView *_inputView;
    
    BOOL _canBecomeFirstResponder;
}


@property (nonatomic, retain) UIView *inputView;
@property (nonatomic, assign) BOOL canBecomeFirstResponder;

@end
