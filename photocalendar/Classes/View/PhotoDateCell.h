//
//  PhotoDateCell.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 16..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoDateCell : UITableViewCell{
    IBOutlet UIImageView * _photo;
    IBOutlet UILabel * _timeLabel;
    
    IBOutlet UIImageView * splitTopImg;
    IBOutlet UIView * _selectedBg;
    
    IBOutlet UIImageView * _movIcon;
    
}

@property(nonatomic,retain) IBOutlet UIImageView * photo;
@property(nonatomic,retain) IBOutlet UILabel * timeLabel;


- (void)setFirstRow:(BOOL)first;

- (void)showMovieIcon:(BOOL)movie;

@end
