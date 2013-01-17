#import "CustomStatusBar.h"
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>


// Our conversion definition
#define DEGREES_TO_RADIANS(angle) (angle / 180.0 * M_PI)

#define SPIN_CLOCK_WISE 1
#define SPIN_COUNTERCLOCK_WISE -1

@interface CustomStatusBar()
- (void)showCompleteMessage;
- (void)hideSyncMessage;

- (void)hideBoxWithCompView:(UIView*)view;

- (void)showBox;

- (void)showHideView:(UIView *)view;

- (void)spinLayer:(CALayer *)inLayer duration:(CFTimeInterval)inDuration direction:(int)direction;
@end
@implementation CustomStatusBar

- (void)dealloc{
    [_compView release], _compView = nil;
    [_syncView release], _syncView = nil;
    [super dealloc];
}

-(id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		// Place the window on the correct level & position
		self.windowLevel = UIWindowLevelStatusBar + 1.0f;
        CGRect frame = [UIApplication sharedApplication].statusBarFrame;
        showingFrame = frame;
        hidingFrame = frame;
        hidingFrame.origin.y = -20;
        
        self.frame = hidingFrame;
        self.backgroundColor = [UIColor blackColor];
        
        _syncView = nil;
        _compView = nil;
        
        
	}
	return self;
}


- (void)showBox{
    self.hidden = NO;
    
    NSLog(@"CustomStatusBar showBox");
    [UIView animateWithDuration:.5 
                     animations:^{
                         self.frame = showingFrame;
                     } 
                     completion:^(BOOL finished){
                         
                     }];
    
    
    if (_syncView!=nil){
        [_syncView release];
        _syncView = nil;
    }
    
    // 동기화 애니메이션 상자
    UIView *syncView = [[UIView alloc] initWithFrame:self.frame];
    syncView.backgroundColor = [UIColor blackColor];
    
    // 동기화 애니메이션 아이콘
    UIImage *img = [UIImage imageNamed:@"ani_refresh"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    
    
    // 동기화 메세지 상자
    NSString *syncMsg = NSLocalizedString(@"Syncing Photos", nil);
    CGSize syncSize = [syncMsg sizeWithFont:[UIFont boldSystemFontOfSize:11.0f]];
    
    UILabel *_statusLabel = [[UILabel alloc] init];
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textColor = [UIColor whiteColor];
    _statusLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    _statusLabel.text = syncMsg;
    
    int left = (self.frame.size.width / 2) - ((img.size.width + syncSize.width)/2);
    imgView.frame = CGRectMake(left, 3, img.size.width, img.size.height);
    _statusLabel.frame = CGRectMake(left+img.size.width+2, 0, syncSize.width, self.frame.size.height);
    
    [syncView addSubview:imgView];
    [syncView addSubview:_statusLabel];
    [self spinLayer:imgView.layer duration:1.0 direction:SPIN_CLOCK_WISE];
    [imgView release];
    [_statusLabel release];
    
    syncView.alpha = .0f;
    [self addSubview:syncView];
    
    
    [UIView animateWithDuration:.5 
                     animations:^{
                         syncView.alpha = 1.0f;
                     } 
                     completion:^(BOOL finished){
                         _syncView = syncView;
                     }];
    
}

- (void)hideSyncMessage{
    [UIView animateWithDuration:.3 
                     animations:^{
                         _syncView.alpha = 0.0f;
                     } 
                     completion:^(BOOL finished){
                         [self performSelector:@selector(showCompleteMessage)];
                     }];
    
//    [self showCompleteMessage];
}

- (void)showCompleteMessage{


    // 완료 상자
    
    UIView *compView = [[[UIView alloc] initWithFrame:self.frame]autorelease];
    compView.backgroundColor = [UIColor blackColor];
    
    UILabel *compLabel = [[UILabel alloc] initWithFrame:compView.frame];
    compLabel.textAlignment = UITextAlignmentCenter;
    compLabel.backgroundColor = [UIColor clearColor];
    compLabel.textColor = [UIColor whiteColor];
    compLabel.font = [UIFont boldSystemFontOfSize:11.0f];
    compLabel.text = NSLocalizedString(@"Complete Syncing", nil);
    
    compView.alpha = 0.0f;
    [compView addSubview:compLabel];
    [self addSubview:compView];

        
        

    
    [UIView animateWithDuration:.3 
                     animations:^{
                         compView.alpha = 1.0f;
                     } 
                     completion:^(BOOL finished){
                         [self performSelector:@selector(hideBoxWithCompView:) withObject:compView afterDelay:1.5];
                     }];
    
    
}




- (void)hideBoxWithCompView:(UIView*)view{

    [UIView animateWithDuration:.5 
                     animations:^{
                         self.frame = hidingFrame;
                     } 
                     completion:^(BOOL finished){
                         _syncView.alpha = 0.0f;
                         [view removeFromSuperview];
                         self.hidden = YES;
                     }];
}



- (void)showHideView:(UIView *)view{
    
}


-(void)start;
{
    [self showBox];

}

-(void)finish
{
    [self hideSyncMessage];
}

-(void)updateCurrentProcess:(NSString*)percent{
    
    if (_syncView!=nil){
        UILabel *label;
        UIImageView *imgView;
        for (id view in _syncView.subviews){
            if ([view isKindOfClass:[UILabel class]]) {
                label = (UILabel *)view;
            }
            else if ([view isKindOfClass:[UIImageView class]]){
                imgView = (UIImageView *)view;
            }
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [label setText:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"Syncing Photos", nil), percent]];
            
            CGSize syncSize = [label.text sizeWithFont:[UIFont boldSystemFontOfSize:11.0f]];
            
            int left = (self.frame.size.width / 2) - ((imgView.image.size.width + syncSize.width)/2);
            imgView.frame = CGRectMake(left, 3, imgView.image.size.width, imgView.image.size.height);
            label.frame = CGRectMake(left+imgView.image.size.width+2, 0, syncSize.width, self.frame.size.height);    
        }); 

        
        

    }
}


- (void)spinLayer:(CALayer *)inLayer duration:(CFTimeInterval)inDuration direction:(int)direction
{
    CABasicAnimation* rotationAnimation;
    
    // Rotate about the z axis
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // Rotate 360 degress, in direction specified
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * direction];
    
    // Perform the rotation over this many seconds
    rotationAnimation.duration = inDuration;
    
    rotationAnimation.repeatCount = HUGE_VALF;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.cumulative = YES;
    rotationAnimation.fillMode = kCAFillModeForwards;

    
    // Set the pacing of the animation
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // Add animation to the layer and make it so
    [inLayer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

@end