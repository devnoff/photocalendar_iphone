//
//  PasscodeViewController.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 20..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "PasscodeViewController.h"
#import "CSBarButtonItemUtils.h"

@interface PasscodeViewController()
- (void) cancelBtnTapped:(id)sender;
- (void)drawDot:(NSInteger)count;
- (BOOL) comparePasscode;
- (void) clearDot;
- (void) createPasscodeProcess;
- (void) unlockPasscodeProcess;
@end

@implementation PasscodeViewController
@synthesize delegate;

- (id)initForLock{
    self = [self initWithNibName:@"PasscodeViewController" bundle:nil];
    if (self) {
        passcodeType = CSPasscodeTypeCreate;
    }
    return self;
}

- (id)initForUnLock{
    self = [self initWithNibName:@"PasscodeViewController" bundle:nil];
    if (self) {
        passcodeType = CSPasscodeTypeUnlock;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        passcodes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc{
    _textField.delegate = nil;
    [_textField release];
    [dot1 release];
    [dot2 release];
    [dot3 release];
    [dot4 release];
    [_dots release];
    [passcodes release];
    [_navBar release];
    [_rightBtn release];
    [meessage release];
    delegate = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5")) {
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Bg_Red"] forBarMetrics:UIBarMetricsDefault];
        
    } else {
        self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Bg_Red"]];
    }
    
    if (cancelBtn) {
        self.navigationItem.rightBarButtonItem = [CSBarButtonItemUtils redButtonWithTitle:@"Cancel" target:self action:@selector(cancelBtnTapped:)];
    }
    
    
    
    
    _dots = [[NSArray alloc]initWithObjects:dot1,dot2,dot3,dot4, nil];
    
    _textField.delegate = self;
    [_textField becomeFirstResponder];
    
    
    meessage.text = @"";
    switch (passcodeType) {
        case CSPasscodeTypeCreate:
            
            break;
            
        case CSPasscodeTypeUnlock:
            break;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    BOOL navHidden = self.navigationController.navigationBarHidden;
    if (navHidden) {
        self.navigationController.navigationBarHidden = !navHidden;    
    }
}

#pragma mark -

- (void) setCancelButton:(BOOL)set{
    cancelBtn = set;
}

#define MAX_LENGTH 4

- (void) drawDot:(NSInteger)count{
    
    for (int i = 0; i<[_dots count]; i++) {
        UIImageView *iv = [_dots objectAtIndex:i];
        if (i<count) {
            iv.hidden = NO;    
        } else {
            iv.hidden = YES;
        }
    }
    
    if (count==MAX_LENGTH) {
        switch (passcodeType) {
            case CSPasscodeTypeCreate:{
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                
                dispatch_async(queue, ^{
                    [self createPasscodeProcess];
                });
            }
                break;
                
                
            case CSPasscodeTypeUnlock:{
                
                dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                
                dispatch_async(queue, ^{
                    [self unlockPasscodeProcess];
                });
            }
                
                break;
        }
        
    }
}

- (void) clearDot{
    dot1.hidden = YES;
    dot2.hidden = YES;
    dot3.hidden = YES;
    dot4.hidden = YES;

}


#pragma mark - UITextFieldDelegate methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    if (newLength>MAX_LENGTH) {
        
        return NO;
    } 
    [self drawDot:newLength];
    meessage.text = @"";
    
    return YES;
}


#pragma mark - create process

- (void) createPasscodeProcess{

    [NSThread sleepForTimeInterval:.2];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 패시워드 생성 프로세스
        if ([passcodes count]<2) {   
            if ([passcodes count]<1) {       
                meessage.text = @"Reconfirm password";
            }
            [passcodes addObject:_textField.text];
        } 
        
        if ([passcodes count]==2) {
            // 패스워드가 두번 다 입력되었을경우 
            
            if ([self comparePasscode]) { // compare two passwords
                
                [delegate passcodeCorrect:[passcodes objectAtIndex:0]];
                [[self _navigation] dismissModalViewControllerAnimated:YES];
                
                
            } else {  // if incorrect input again
                
                [passcodes removeAllObjects];
                meessage.text = @"Passcodes did not match. Try again.";
            }
        }
        
        
        _textField.text = nil;
        [self clearDot];
        
    }); 

}

- (BOOL) comparePasscode{
    NSString * pass1 = [passcodes objectAtIndex:0];
    NSString * pass2 = [passcodes objectAtIndex:1];
    NSLog(@"pass1 : %@ pass2: %@", pass1, pass2);
    return [pass1 isEqualToString:pass2];
}




#pragma mark - ulock process

- (void) unlockPasscodeProcess{
    [NSThread sleepForTimeInterval:.2];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        BOOL result = [delegate compareWithCode:_textField.text];
        
        if (result) {
            [delegate passcodeCorrect:nil];
            [[self _navigation] dismissModalViewControllerAnimated:YES];
        } else {
            meessage.text = @"Passcodes did not match. Try again.";
        }
        
        _textField.text = nil;
        [self clearDot];
    }); 
}


#pragma mark - 

- (void) cancelBtnTapped:(id)sender{
    [delegate passcodeCancelled];
    [[self _navigation] dismissModalViewControllerAnimated:YES];
}

- (void)setTitle:(NSString *)title{

}

@end
