//
//  SettingsViewController.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 5..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"

@interface SettingsViewController()
- (void) upgrade;
- (void)prepareForPurchase;
- (void) buyAction;
- (void) removeAds;
- (void) addAds;
- (void) setProductPriceLabel:(NSDecimalNumber*)price;
@end


@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        _inappObserver = [[InAppPurchaseObserver alloc] init];
        _inappObserver.delegate = self;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) dealloc{
    [upgradeContainer release];
    [beforeUpgradeContainer release];
    [afterUpgradeContainer release];
    [companyViewContainer release];
    
    [companyInfoBtn release];
    [companyAppsBtn release];
    [travelogBtn release];
    
    // before upgrade container views
    [msgBeforeUpgrade release];
    [upgradeBtn release];
    [msgWorryUpgrade release];
    
    // after upgrade container views
//    [msgAfterUpgrade release];
    [passcodeSwitch release];
    [passcodeLabel release];
    
    [loadingView release];
    
    [_inappObserver release];
    _inappObserver.delegate = nil;
    
    
    [albumSelectBtn release];
    [orderLabel release];
    [orderSwitch release];
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    // main view container appearance
    
    // company view container appearance
    [companyInfoBtn setTitle:NSLocalizedString(@"COMPANY_INFO", nil) forState:UIControlStateNormal];
    [companyAppsBtn setTitle:NSLocalizedString(@"COMPANY_APPS", nil) forState:UIControlStateNormal];
    [travelogBtn setTitle:NSLocalizedString(@"TRAVELOG", nil) forState:UIControlStateNormal];
    
    // before upgrade view container appearance
    msgBeforeUpgrade.text = NSLocalizedString(@"MSG_BEFORE_UPGRADE", nil);
    [upgradeBtn setTitle:NSLocalizedString(@"UPGRADE", nil) forState:UIControlStateNormal];
    msgWorryUpgrade.text = NSLocalizedString(@"MSG_WORRY_ABOUT_UPGRADE", nil);
    
    // afeter upgrader view container appearance
//    msgAfterUpgrade.text = NSLocalizedString(@"MSG_AFTER_UPGRADE", nil);
    passcodeLabel.text = NSLocalizedString(@"PASSCODE", nil);
    
    passcodeSwitch.on = GET_PASSCODE?YES:NO;
    
    
    // facebook
    facebookLabel.text = NSLocalizedString(@"Facebook Login", nil);
    
    // album select
    [albumSelectBtn setTitle:NSLocalizedString(@"Select Albums to Sync", nil) forState:UIControlStateNormal];
    
    // order switch
    orderLabel.text = NSLocalizedString(@"Order by date ascending", nil);
    orderSwitch.on = ORDER_BY_ASC;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self prepareForPurchase];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"setting view will appear");
    //[USER_DEFAULT setBool:NO forKey:@"hasUpgraded"];
    
    // show sub upgradeView whether upgrade
    if (HAS_UPGRADED) {
        [self showAfterUpgradeContainer];
    } else {
        [self showBeforeUpgradeContainer];
    }
}

#pragma mark - view action


// get current upgrade state  


- (void) finishedUpgrade{
    UPGRADED(YES);
    SYNC_USER_DEFAULT;
    
    [self showAfterUpgradeContainer];
    [self removeAds];
    
    [loadingView removeFromSuperview];
    
    // 데이터 다시 로딩 
    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate runBackgroundLoading];
}

- (void) failedToUpgrade{
    UPGRADED(NO);
    SYNC_USER_DEFAULT;
    
    UIAlertView *alert= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"APP_NAME", nil) 
                                                   message:NSLocalizedString(@"FAILED_MSG", nil) 
                                                  delegate:self 
                                         cancelButtonTitle:NSLocalizedString(@"NO", nil) 
                                         otherButtonTitles:NSLocalizedString(@"TRY_AGAIN", nil),nil];
    [alert show];
    [alert release];
    
    [loadingView removeFromSuperview];
}

- (void) cancelToUpgrade{
    [loadingView removeFromSuperview];
}

// state - not upgrade
- (void) showBeforeUpgradeContainer{
    NSArray * subviews = [upgradeContainer subviews];
    for(UIView * view in subviews){
        [view removeFromSuperview];
    }
    
    CGSize bfSize = beforeUpgradeContainer.frame.size;
    CGRect upRect = upgradeContainer.frame;
    upRect.size = bfSize;
    upgradeContainer.frame = upRect;
    
    [upgradeContainer addSubview:beforeUpgradeContainer];
    
    facebookView.frame = CGRectMake(0, upgradeContainer.frame.size.height, 320, facebookView.frame.size.height);
    
    CGRect rect = companyViewContainer.frame;
    rect.origin.y = facebookView.frame.origin.y + facebookView.frame.size.height;
    companyViewContainer.frame = rect;

    CGRect contentRect = contentView.frame;
    contentRect.size = CGSizeMake(320, companyViewContainer.frame.size.height + companyViewContainer.frame.origin.y);
    contentView.frame = contentRect;
    [(UIScrollView *)self.view setContentSize:contentRect.size];
}

// state - upgrade
- (void) showAfterUpgradeContainer{
    NSArray * subviews = [upgradeContainer subviews];
    for(UIView * view in subviews){
        [view removeFromSuperview];
    }
    
//    //Calculate the expected size based on the font and linebreak mode of your label
//    CGSize maximumLabelSize = CGSizeMake(296,9999);
//    
//    CGSize expectedLabelSize = [msgAfterUpgrade.text sizeWithFont:msgAfterUpgrade.font 
//                                      constrainedToSize:maximumLabelSize 
//                                          lineBreakMode:msgAfterUpgrade.lineBreakMode]; 
//    
//    //adjust the label the the new height.
//    CGRect newFrame = msgAfterUpgrade.frame;
//    newFrame.size.height = expectedLabelSize.height;
//    msgAfterUpgrade.frame = newFrame;
//    
//    passcodeView.frame = CGRectMake(0, msgAfterUpgrade.frame.size.height+msgAfterUpgrade.frame.origin.y, passcodeView.frame.size.width, passcodeView.frame.size.height);
//    afterUpgradeContainer.frame = CGRectMake(0, 0, afterUpgradeContainer.frame.size.width, msgAfterUpgrade.frame.size.height+passcodeView.frame.size.height+msgAfterUpgrade.frame.origin.y);
//    
    CGSize bfSize = afterUpgradeContainer.frame.size;
    CGRect upRect = upgradeContainer.frame;
    upRect.size = bfSize;
    upgradeContainer.frame = upRect;
    
    [upgradeContainer addSubview:afterUpgradeContainer];
    
    facebookView.frame = CGRectMake(0, upgradeContainer.frame.size.height, 320, facebookView.frame.size.height);
    
    CGRect rect = companyViewContainer.frame;
    rect.origin.y = facebookView.frame.origin.y + facebookView.frame.size.height;
    companyViewContainer.frame = rect;
    
    CGRect contentRect = contentView.frame;
    contentRect.size = CGSizeMake(320, companyViewContainer.frame.size.height + companyViewContainer.frame.origin.y);
    contentView.frame = contentRect;
    [(UIScrollView *)self.view setContentSize:contentRect.size];
}

// upgrade btn tappd
- (IBAction) upgradeBtnTapped:(id)sender{
    //[self finishedUpgrade];
    [self upgrade];
}


// house ads

- (IBAction)companyInfoTapped:(id)sender{
    
    CSWebViewController * wv = [[CSWebViewController alloc] init];
    
    NSString * stringURL = @"http://app.cultstory.net/about";
    wv.stringURL = stringURL;
    
    [[self _navigation]pushViewController:wv animated:YES];
    [wv release];
    
}
- (IBAction)companyAppsTapped:(id)sender{
    CSWebViewController * wv = [[CSWebViewController alloc] init];
    
    NSString * stringURL = @"http://app.cultstory.net/apps";
    wv.stringURL = stringURL;

    [[self _navigation]pushViewController:wv animated:YES];
    [wv release];
}
- (IBAction)travelogTapped:(id)sender{
    CSWebViewController * wv = [[CSWebViewController alloc] init];
    
    NSString * stringURL = @"http://m.travelog.me";
    wv.stringURL = stringURL;
    
    [[self _navigation]pushViewController:wv animated:YES];
    [wv release];
}

#pragma mark - passcode process

// passcode switch
- (IBAction) passcodeSwitchTapped:(id)sender{
    if ([(UISwitch*)sender isOn]) {
        [self showPasscodeViewControllerForLock:YES];
    } else {
        [self showPasscodeViewControllerForLock:NO];
    }
}

- (void) showPasscodeViewControllerForLock:(BOOL)lock{
    PasscodeViewController * passvc;
    if (lock) {
        passvc = [[PasscodeViewController alloc] initForLock];
    } else {
        passvc = [[PasscodeViewController alloc] initForUnLock];
    }
    passvc.delegate = self;
    [passvc setCancelButton:YES];
    
    UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:passvc];
    [[self _navigation] presentModalViewController:navc animated:YES];
    [navc release];
    [passvc release];
}

- (void) savePasscode:(NSString*)passcode{
    SET_PASSCODE(passcode);
    SYNC_USER_DEFAULT;
}

- (void) removePasscode{
    SET_PASSCODE(nil);
    SYNC_USER_DEFAULT;
}



#pragma mark - passcode view controller delegate method
- (void) passcodeCorrect:(NSString*)passcode{
    if (passcodeSwitch.isOn) {
        [self savePasscode:passcode];
    } else {
        [self removePasscode];
    }
}

- (void) passcodeCancelled{
    passcodeSwitch.on = !passcodeSwitch.isOn;
}

- (BOOL) compareWithCode:(NSString*)code{
    return [code isEqualToString:GET_PASSCODE];
}


#pragma mark - in app purchase observer delegate method
- (void) didSuccessPurchase{
    [self finishedUpgrade];
}

- (void) didFailedPurchase{
    [self failedToUpgrade];
}

- (void) didCancelledPurchase{
    [self cancelToUpgrade];
}

#pragma mark - in app purchase process

- (void) upgrade{
    
    [self.view addSubview:loadingView];
    
    [self buyAction];
//    [self finishedUpgrade];

}

- (void)prepareForPurchase {
    if ([SKPaymentQueue canMakePayments]) {
		// Yes, In-App Purchase is enabled on this device!
		// Proceed to fetch available In-App Purchase items.
		
		// Replace "Your IAP Product ID" with your actual In-App Purchase Product ID,
		// fetched from either a remote server or stored locally within your app. 

        
        SKProductsRequest *request = [[[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject: @"com.cultstory.photocalendar.item001"]] autorelease];
        request.delegate = self;
        [request start];

        
//        if (!productRequest) {
//            productRequest= [[SKProductsRequest alloc] initWithProductIdentifiers: [NSSet setWithObject: @"com.cultstory.photocalendar.item001"]];
//            productRequest.delegate = self;
//            [productRequest start];
//        } else {
//            //[self buyAction];
//            [productRequest start];
//        }
		
	} 
}


- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    // Populate the inappBuy button with the received product info.
	SKProduct *validProduct = nil;
	int count = [response.products count];
	if (count>0) {
		validProduct = [response.products objectAtIndex:0];
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:validProduct.priceLocale];
        NSString *formattedString = [numberFormatter stringFromNumber:validProduct.price];
        [numberFormatter release];
        
        NSString *upgradeString = NSLocalizedString(@"UPGRADE", nil);
        NSString *fullString = [NSString stringWithFormat:@"%@ %@", upgradeString, formattedString];
        
        [upgradeBtn setTitle:fullString forState:UIControlStateNormal];

        
	}
	if (!validProduct) {
        //[self failedToUpgrade];
        [self prepareForPurchase];
		return;
	}

    //[self buyAction];
}

- (void) buyAction{
    // Replace "Your IAP Product ID" with your actual In-App Purchase Product ID.
	SKPayment *paymentRequest = [SKPayment paymentWithProductIdentifier: @"com.cultstory.photocalendar.item001"]; 
    
	// Assign an Observer class to the SKPaymentTransactionObserver,
	// so that it can monitor the transaction status.
	[[SKPaymentQueue defaultQueue] addTransactionObserver:_inappObserver];
	
	// Request a purchase of the selected item.
	[[SKPaymentQueue defaultQueue] addPayment:paymentRequest];

}


- (void) setProductPriceLabel:(NSDecimalNumber*)price{
    
    
}

#pragma mark - action for ads

- (void) removeAds{
    
    //[USER_DEFAULT setBool:YES forKey:@"hasUpgraded"];
    
    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    [appDelegate releaseAdView];
    [appDelegate removeAds];
    
}

- (void) addAds{
//    //[USER_DEFAULT setBool:NO forKey:@"hasUpgraded"];
//    
//    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
//    UINavigationController * navCon = [appDelegate navCon];
//    NSArray * controllers = [navCon childViewControllers];
//    for(UIViewController *vc in controllers){
////        vc.view.frame = ADS_FRAME;
////        vc.view.bounds = ADS_FRAME;
//        
//        if ([vc isKindOfClass:[RootViewController class]]) {
//            for(UIViewController* vcon in ((RootViewController*)vc).controllers){
//                for(id child in vcon.view.subviews){
//                    if ([child isKindOfClass:[UITableView class]]) {
//                        CGRect frame = ((UITableView*)child).frame;
//                        frame.size.height = frame.size.height - 50;
//                        [(UITableView*)child setFrame:frame];
//                    }    
//                }
//                
//            }    
//        }
//        
//    }
////    [appDelegate.rootViewController.view setFrame:ADS_FRAME];
//    
//    [appDelegate showAdView];
//    
    
}

#pragma mark - UIAlertViewDelegate Methods

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            [self upgrade];
            break;
            
    }
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)alertViewCancel:(UIAlertView *)alertView{

}


- (void)refresh{
    
}

#pragma mark - Ordering change

- (IBAction)orderSwitchChanged:(id)sender{
    SET_ORDER_BY_ASC(((UISwitch *)sender).on);
    SYNC_USER_DEFAULT;
}

#pragma mark - Select Albums

- (IBAction)selectAlbumTapped:(id)sender{
    
    AppDelegate * appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    if ([appDelegate isRunningBackgroundLoading]){
        
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Syncing Now", nil) 
                                                         message:NSLocalizedString(@"Try after finish sync photos", nil) 
                                                        delegate:nil 
                                               cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                               otherButtonTitles:nil] autorelease];
        [alert show];
        return;
    }
    
    ChoosingGroupViewController * cvc = [[ChoosingGroupViewController alloc] initWithNibName:@"ChoosingGroupViewController" bundle:nil];
    [self presentModalViewController:cvc animated:YES];
    [cvc release];
}

#pragma mark - facebook control

- (IBAction)facebookTurnOn:(BOOL)on{
    

}



@end
