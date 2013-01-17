//
//  PasscodeViewController.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 20..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef enum {
    CSPasscodeTypeCreate,
    CSPasscodeTypeUnlock
} CSPasscodeType;

@protocol PasscodeViewControllerDelegate;
@interface PasscodeViewController : BaseViewController<UITextFieldDelegate>
{
    IBOutlet UIImageView * dot1;
    IBOutlet UIImageView * dot2;
    IBOutlet UIImageView * dot3;
    IBOutlet UIImageView * dot4;
    
    IBOutlet UITextField * _textField;
    
    id<PasscodeViewControllerDelegate> delegate;
    
    IBOutlet UINavigationBar * _navBar;
    IBOutlet UIBarButtonItem * _rightBtn;
    
    NSArray * _dots;
    
    CSPasscodeType passcodeType;
    
    NSMutableArray * passcodes;
    
    IBOutlet UILabel * meessage;
    
    BOOL cancelBtn;
    
}

@property (nonatomic,retain) id<PasscodeViewControllerDelegate> delegate;

- (id)initForLock;
- (id)initForUnLock;
- (void) setCancelButton:(BOOL)set;


@end

@protocol PasscodeViewControllerDelegate <NSObject>
- (void) passcodeCorrect:(NSString*)passcode;
- (void) passcodeCancelled;
- (BOOL) compareWithCode:(NSString*)code;
@end