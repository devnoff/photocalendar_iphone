//
//  PhotoButton.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 10..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import "PhotoButton.h"

#define TIMEVIEW_HEIGHT 15

@implementation PhotoButton
@synthesize index;

- (void)dealloc{
    [_durationLabel release];
    [_timeView release];
    [super dealloc];
}

- (void)initialize{
    if (!_timeView) {
        _timeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-TIMEVIEW_HEIGHT, self.frame.size.width, TIMEVIEW_HEIGHT)];
        _timeView.backgroundColor = [UIColor colorWithWhite:0 alpha:.4];
        UIImage * movIco = [UIImage imageNamed:@"PLVideoCameraPreview"];
        UIImageView *icon = [[UIImageView alloc]initWithImage:movIco];
        icon.frame = CGRectMake(2, 3, movIco.size.width, movIco.size.height);
        [_timeView addSubview:icon];
        [icon release];
        
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(movIco.size.width, 0, _timeView.frame.size.width-movIco.size.width, TIMEVIEW_HEIGHT)];
        _durationLabel.backgroundColor = [UIColor clearColor];
        _durationLabel.textAlignment = UITextAlignmentRight;
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.font = [UIFont boldSystemFontOfSize:12];
        [_timeView addSubview:_durationLabel];
        
        [self addSubview:_timeView];
        
        _timeView.hidden = YES;
        

        
    }
}

- (void) setDuration:(double)duration{
    if (duration) {
        NSLog(@"duration %f",duration);
        int min = floor(duration/60);
        int sec = duration-(min*60);
        _durationLabel.text= [NSString stringWithFormat:@"%d:%02d",min,sec];
        _timeView.hidden = NO;
    } else {
        _timeView.hidden = YES;
    }
    
}
@end
