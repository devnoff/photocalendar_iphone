//
//  CSNavigationView.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 5..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CSNavigationViewDelegate;
@interface CSNavigationView : UIView{
    NSInteger _currentIndex;
    NSMutableArray * _buttons;
    NSMutableArray * _viewControllers;
    
    id<CSNavigationViewDelegate> _delegate;
}

@property (nonatomic,assign) NSInteger currentIndex;
@property (nonatomic,retain) NSMutableArray * buttons;
@property (nonatomic,retain) NSMutableArray * viewControllers;
@property (nonatomic,retain) id<CSNavigationViewDelegate> delegate;

- (void) selectedIndex:(NSInteger)index;
- (id)initWithFrame:(CGRect)frame withLabelTexts:(NSArray*)texts;
@end


@protocol CSNavigationViewDelegate<NSObject>
@optional
- (void) didSelectedViewController:(UIViewController*)viewController atIndex:(NSInteger)index;
@end
