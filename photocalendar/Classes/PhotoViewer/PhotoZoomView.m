//
//  PhotoZoomView.m
//  travelog
//
//  Created by Cho, Young-Un on 11. 10. 4..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import "PhotoZoomView.h"


@implementation PhotoZoomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollEnabled = YES;
		self.pagingEnabled = NO;
		self.clipsToBounds = NO;
		self.maximumZoomScale = 3.0f;
		self.minimumZoomScale = 1.0f;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		self.alwaysBounceVertical = NO;
		self.alwaysBounceHorizontal = NO;
		self.bouncesZoom = YES;
		self.bounces = YES;
		self.scrollsToTop = NO;
		self.backgroundColor = [UIColor blackColor];
		self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
		self.decelerationRate = UIScrollViewDecelerationRateFast;
        
        
        UITapGestureRecognizer *newTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapZoom)];
        
        newTapGestureRecognizer.numberOfTouchesRequired = 1;
        newTapGestureRecognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:newTapGestureRecognizer];
        [newTapGestureRecognizer release];
        
        UITapGestureRecognizer *newTapGestureRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleBars)];
        
        newTapGestureRecognizer1.numberOfTouchesRequired = 1;
        newTapGestureRecognizer1.numberOfTapsRequired = 1;
        [self addGestureRecognizer:newTapGestureRecognizer1];
        [newTapGestureRecognizer1 release];
        
        // 롱 터치 공유
        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressDetected:)];
        longPress.minimumPressDuration = 0.6f;
        
        [self addGestureRecognizer:longPress];
        [longPress release];
        
    }
    return self;
}


- (void)dealloc
{
    [super dealloc];
}


#pragma mark -
#pragma mark Touches

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	[super touchesEnded:touches withEvent:event];
    
//	UITouch *touch = [touches anyObject];
//	if (touch.tapCount == 1) {
//		[self performSelector:@selector(toggleBars) withObject:nil afterDelay:.2];
//	}
}


- (void)doubleTapZoom{
    
    UIImageView *imageView;
    for (id view in self.subviews){
        imageView = view;
    }
    
    if (imageView){
        if (imageView.contentMode==UIViewContentModeScaleAspectFit){
            [UIView animateWithDuration:.3 
                             animations:^{
                                 imageView.contentMode = UIViewContentModeScaleAspectFill;
                             } 
                             completion:^(BOOL finished){
                                 
                             }];

            return;
        }
        
    }
    
    [UIView animateWithDuration:.5 
                     animations:^{
                         if (self.zoomScale<3) {
                             self.zoomScale =  3.0f;    
                         } else {
                             self.zoomScale = 1.0f;
                         }
                         
                     } 
                     completion:^(BOOL finished){
                     }];
}

- (void)toggleBars {
	[[NSNotificationCenter defaultCenter] postNotificationName:@"PhotoViewToggleBarNotification" object:nil];
}


- (void)longPressDetected:(UILongPressGestureRecognizer *)gesture{
    
    
    
    if(UIGestureRecognizerStateBegan == gesture.state) {
        // Do initial work here
        NSLog(@"LongPress has called");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PhotoViewShareActionNotification" object:nil];
    }
    
    if(UIGestureRecognizerStateChanged == gesture.state) {
        // Do repeated work here (repeats continuously) while finger is down
        
    }
    
    if(UIGestureRecognizerStateEnded == gesture.state) {
        // Do end work here when finger is lifted
    }
    
    
}
@end
