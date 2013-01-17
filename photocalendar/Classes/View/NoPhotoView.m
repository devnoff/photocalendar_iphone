//
//  NoPhotoView.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 26..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "NoPhotoView.h"

@implementation NoPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImage * down = [UIImage imageNamed:@"RefArrow"];
        UIImageView * downImage = [[UIImageView alloc] initWithFrame:CGRectMake(83, 78, 155, 156)];
        downImage.image = down;
        [self addSubview:downImage];
        
        
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, downImage.frame.origin.y+downImage.frame.size.height+22, self.frame.size.width, 18)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:18.0];
        label.textColor = RGB(123, 123, 123);
        label.shadowColor = [UIColor colorWithWhite:0 alpha:.5];
        label.shadowOffset = CGSizeMake(0, -1);
        label.textAlignment = UITextAlignmentCenter;
        label.text = NSLocalizedString(@"NO_PHOTO_TITLE", nil);
        
        [self addSubview:label];
        
        


        
        UILabel * labelDesc = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.origin.y+label.frame.size.height+5, self.frame.size.width, 45)];
        labelDesc.backgroundColor = [UIColor clearColor];
        labelDesc.font = [UIFont boldSystemFontOfSize:12.0];
        labelDesc.textColor = RGB(123, 123, 123);
        labelDesc.shadowColor = [UIColor colorWithWhite:0 alpha:.5];
        labelDesc.shadowOffset = CGSizeMake(0, -1);
        labelDesc.textAlignment = UITextAlignmentCenter;
        labelDesc.text = NSLocalizedString(@"NO_PHOTO_DESC", nil);
        labelDesc.numberOfLines = 2;
        [self addSubview:labelDesc];
        
        
        [downImage release];
        [label release];
        [labelDesc release];
        
        
        self.backgroundColor = [UIColor clearColor];
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

@end
