//
//  CaptionView.h
//  travelog
//
//  Created by Cho, Young-Un on 11. 10. 4..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "CSLabel.h"


@interface CaptionView : UIView {
@private
    EGOImageView *_profileImageView;
    UILabel *_nicknameLabel;
    CSLabel *_placeLabel;
}


- (void)setProfileImage:(NSString *)profileImageUrl;
- (void)setNickname:(NSString *)nickname;
- (void)setPlace:(NSString *)place;

@end
