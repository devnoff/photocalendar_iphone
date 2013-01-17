//
//  PPCaptionView.m
//  PhotoCal
//
//  Created by Park Yongnam on 11. 11. 29..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "PPCaptionView.h"
#import "CSBarButtonItemUtils.h"


//#ifdef PRO_VERSION
//#define ADS_HEIGHT 0
//#else
//#define ADS_HEIGHT 50
//#endif

@interface PPCaptionView()


@end



@implementation PPCaptionView
@synthesize delegate=_delegate;
@synthesize hidden=_hidden;
@synthesize modifyButton=_modifyButton;

- (void)dealloc{
    [_bgView release];
    [_timeLabel release];
    [_locationLabel release];
    [_modifyButton release];
    _delegate = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImage * bg = [UIImage imageNamed:@"ToolBottomBg"];
        _bgView = [[UIImageView alloc] initWithImage:bg];
        _bgView.frame = CGRectMake(0, 0, bg.size.width, bg.size.height);
        [_bgView setContentMode:UIViewContentModeScaleToFill];
        [self addSubview:_bgView];
        
        
        
        
        UIImage * shareImg = [UIImage imageNamed:@"C2_BtnShare"];
        UIImage * shareImgOver = [UIImage imageNamed:@"C2_BtnShare_On"];
        
        
        _modifyButton = [[UIButton alloc]initWithFrame:CGRectMake(8,8, shareImg.size.width, shareImg.size.height)];
        [_modifyButton setImage:shareImg forState:UIControlStateNormal];
        [_modifyButton setImage:shareImgOver forState:UIControlStateHighlighted];
        [_modifyButton addTarget:self action:@selector(modifyButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_modifyButton];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + _modifyButton.frame.size.width, 15, 320-_modifyButton.frame.size.width - 10, 14)];
        _timeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textAlignment = UITextAlignmentRight;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.shadowColor = [UIColor colorWithWhite:0 alpha:.25];
        _timeLabel.shadowOffset = CGSizeMake(0, -1);
        _timeLabel.font = [UIFont systemFontOfSize:10.0f];

        [self addSubview:_timeLabel];
        
//        _locationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10 + _modifyButton.frame.size.width, 8, 320-_modifyButton.frame.size.width, 12)];
//        _timeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//        _locationLabel.backgroundColor = [UIColor clearColor];
//        _locationLabel.textAlignment = UITextAlignmentRight;
//        _locationLabel.textColor = [UIColor whiteColor];
//        _locationLabel.shadowColor = [UIColor colorWithWhite:0 alpha:.25];
//        _locationLabel.shadowOffset = CGSizeMake(0, -1);
//        _locationLabel.font = [UIFont boldSystemFontOfSize:11.0f];
//        [self addSubview:_locationLabel];
        
        

        if(HAS_UPGRADED){
            ads = 0;
        } else {
            ads = 50;
        }
        
        
        ads_height = ads;
        
        

    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

- (void) modifyButtonTapped:(id)sender{
    //    [_delegate modifyButtonTapped];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PhotoViewShareActionNotification" object:nil];
}

- (void) fitToView:(UIInterfaceOrientation)orientation{
    
    int width;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        ads_height = ads;
        _landscape = NO;
        width = 320;
        
        //        _modifyButton.hidden = NO;
    } else {
        ads_height = 0;
        _landscape = YES;
        width = 480;
        
        //        _modifyButton.hidden = YES;
    }
    _bgView.frame = CGRectMake(0, 0, self.frame.size.width, _bgView.frame.size.height);
    //    _modifyButton.frame = CGRectMake(_modifyButton.frame.size.width-8,8, _modifyButton.frame.size.width, _modifyButton.frame.size.height);
    _timeLabel.frame = CGRectMake(10 + _modifyButton.frame.size.width, _timeLabel.frame.origin.y, width - 10 - _modifyButton.frame.size.width - 10, _timeLabel.frame.size.height);
//    _locationLabel.frame = CGRectMake(10 + _modifyButton.frame.size.width, _locationLabel.frame.origin.y, width - 10 - _modifyButton.frame.size.width, _locationLabel.frame.size.height);
    
    if (_hidden) {
        [self hideView];
    } else {
        [self showView];
    }
}


- (void) setLocationString:(NSString *)locationStr andTimestamp:(NSDate *)datetime{
    
    //    _modifyButton.enabled = locationStr?YES:NO;
//    if (!locationStr) {
//        return;
//    }
    
    
    
    // location string
//    [_locationLabel setText:locationStr];
    
    if (!datetime) {
        _timeLabel.text = @"";
        return;
    }
    
    
    // timestamp
    NSDateFormatter * formmater = [[NSDateFormatter alloc] init];
    //[formmater setDateFormat:NSLocalizedString(@"FORMAT_CAPTION", nil)];
    [formmater setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formmater setDateStyle:NSDateFormatterFullStyle];
    [formmater setTimeStyle:NSDateFormatterLongStyle];
    NSString * dateTime = [formmater stringFromDate:datetime];
    [_timeLabel setText:[NSString stringWithFormat:@"%@ ",dateTime?dateTime:@""]];
    [formmater release];
    
    
}


#define SHOWING_OFFSET (480-44)
#define HIDING_OFFSET 480
#define SHOWING_OFFSET_LANDSCAPE (320-44)
#define HIDING_OFFSET_LANDSCAPE 320

- (void) hideView{
    
    CGRect bounds = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame];
    int y = _landscape?bounds.size.width:bounds.size.height;//_landscape?HIDING_OFFSET_LANDSCAPE:HIDING_OFFSET;
    NSLog(@"hide y : %d",y);
    
    CGRect rect = self.frame;
    rect.origin.y = y;
    self.frame = rect;
    _hidden = YES;
}
- (void) showView{
    
    CGRect bounds = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] frame];
    int y = _landscape?bounds.size.width - 44:bounds.size.height - 44;//_landscape?SHOWING_OFFSET_LANDSCAPE:SHOWING_OFFSET;
    
    NSLog(@"show y : %d",y);
    
    CGRect rect = self.frame;
    rect.origin.y = y-ads_height;
    self.frame = rect;
    _hidden = NO;
}

- (void) setModifyButtonText:(NSString *)text{
    for(UIView *v in [_modifyButton subviews]){
        if ([v isKindOfClass:[UILabel class]]) {
            [(UILabel *)v setText:text];
            break;
        }
    }
    
}



@end
