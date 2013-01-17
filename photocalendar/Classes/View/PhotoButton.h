//
//  PhotoButton.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 10..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"

@protocol PhotoButtonDelegate;
@interface PhotoButton : UIButton{
    NSInteger index;
    
    UIView * _timeView;
    UILabel * _durationLabel;
}

@property (nonatomic,assign) NSInteger index;
- (void)initialize;
- (void) setDuration:(double)duration;

@end


@protocol PhotoButtonDelegate <NSObject>
- (void) photoButtonTapped:(id)sender;

@end