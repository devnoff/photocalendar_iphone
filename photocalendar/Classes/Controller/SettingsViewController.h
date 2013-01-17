//
//  SettingsViewController.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 5..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <StoreKit/StoreKit.h>
#import "InAppPurchaseObserver.h"
#import "PasscodeViewController.h"
#import "CSWebViewController.h"



@interface SettingsViewController : BaseViewController<SKProductsRequestDelegate,InAppPurchaseObserverDelegate,UIAlertViewDelegate,PasscodeViewControllerDelegate>{
    
    IBOutlet UIView *contentView;
    
    
    // main view container views
    IBOutlet UIView *upgradeContainer;
    IBOutlet UIView *beforeUpgradeContainer;
    IBOutlet UIView *afterUpgradeContainer;
    IBOutlet UIView *companyViewContainer;
    
    IBOutlet UIButton * companyInfoBtn;
    IBOutlet UIButton * companyAppsBtn;
    IBOutlet UIButton * travelogBtn;
    
    // before upgrade container views
    IBOutlet UILabel * msgBeforeUpgrade;
    IBOutlet UIButton * upgradeBtn;
    IBOutlet UILabel * msgWorryUpgrade;
    
    // after upgrade container views
//    IBOutlet UILabel * msgAfterUpgrade;
    IBOutlet UISwitch * passcodeSwitch;
    IBOutlet UILabel * passcodeLabel;
//    IBOutlet UIView * passcodeView;
    
    
    // facebook 
    IBOutlet UILabel * facebookLabel;
    IBOutlet UISwitch * facebookSwitch;
    IBOutlet UIView * facebookView;
    
    
    // loading view
    IBOutlet UIView * loadingView;
    
    
    InAppPurchaseObserver * _inappObserver;
    SKProductsRequest * productRequest;
    
    
    
    // album select
    IBOutlet UIButton * albumSelectBtn;
    
    // order switch
    IBOutlet UISwitch * orderSwitch;
    IBOutlet UILabel * orderLabel;
    
    
    BOOL _requestProductForBuying;
}

// state - not upgrade
- (void) showBeforeUpgradeContainer;

// state - upgrade
- (void) showAfterUpgradeContainer;

// upgrade btn tappd
- (IBAction)upgradeBtnTapped:(id)sender;

// passcode switch
- (IBAction) passcodeSwitchTapped:(id)sender;

- (void) showPasscodeViewControllerForLock:(BOOL)lock;

- (void) savePasscode:(NSString*)passcode;

- (void) removePasscode;


// house ads

- (IBAction)companyInfoTapped:(id)sender;
- (IBAction)companyAppsTapped:(id)sender;
- (IBAction)travelogTapped:(id)sender;

- (IBAction)facebookTurnOn:(BOOL)on;
@end
