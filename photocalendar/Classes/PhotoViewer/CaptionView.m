//
//  CaptionView.m
//  travelog
//
//  Created by Cho, Young-Un on 11. 10. 4..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import "CaptionView.h"


@implementation CaptionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.3);
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        int offsetX = 10;
        int offsetY = 10;
        int thumbSize = 36;
        int margin = 6;
        
        _profileImageView = [[EGOImageView alloc] initWithPlaceholderImage:[UIImage imageNamed:@"NoProfileImage.png"]];
        _profileImageView.frame = CGRectMake(offsetX, offsetY, thumbSize, thumbSize);
        _profileImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:_profileImageView];
        
        offsetX += thumbSize + margin;
        offsetY = 12;
        
        _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake(offsetX, offsetY, 240, 12)];
        _nicknameLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        _nicknameLabel.backgroundColor = [UIColor clearColor];
        _nicknameLabel.textColor = [UIColor whiteColor];
        _nicknameLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        [self addSubview:_nicknameLabel];
        
        offsetY += 12 + margin;
        
        _placeLabel = [[CSLabel alloc] initWithFrame:CGRectMake(offsetX, offsetY, 240, 12)];
        _placeLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        _placeLabel.backgroundColor = [UIColor clearColor];
        _placeLabel.textColor = [UIColor whiteColor];
        _placeLabel.font = [UIFont boldSystemFontOfSize:14.0f];
        _placeLabel.padding = UIEdgeInsetsMake(0, 12, 0, 0);
        _placeLabel.hidden = YES;
        [self addSubview:_placeLabel];
        
        UIImageView *placeIcon = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 9, 12)] autorelease];
        placeIcon.image = [UIImage imageNamed:@"PhotoViewIconPlace.png"];
        [_placeLabel addSubview:placeIcon];
        
//        UIImageView *indicatorView = [[[UIImageView alloc] initWithFrame:CGRectMake(300, 20, 10, 14)] autorelease];
//        indicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//        indicatorView.image = [UIImage imageNamed:@"PhotoViewIndicator.png"];
//        [self addSubview:indicatorView];
    }
    return self;
}


- (void)dealloc
{
    [_profileImageView release];
    [_nicknameLabel release];
    [_placeLabel release];
    [super dealloc];
}


- (void)setProfileImage:(NSString *)profileImageUrl {
    [_profileImageView cancelImageLoad];
    _profileImageView.imageURL = [NSURL URLWithString:profileImageUrl];
}


- (void)setNickname:(NSString *)nickname {
    _nicknameLabel.text = nickname;
}


- (void)setPlace:(NSString *)place {
    _placeLabel.text = place;
    if (0 < [place length]) {
        _placeLabel.hidden = NO;
    } else {
        _placeLabel.hidden = YES;
    }
}


- (void)setHidden:(BOOL)hidden {
    [UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2f];
	
	if (hidden) {
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		
        self.frame = CGRectMake(0.0f, self.superview.frame.size.height, self.frame.size.width, self.frame.size.height);
	} else {
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		
		self.frame = CGRectMake(0.0f, self.superview.frame.size.height - self.frame.size.height, self.frame.size.width, self.frame.size.height);
        
	}
	
	[UIView commitAnimations];
}

@end
