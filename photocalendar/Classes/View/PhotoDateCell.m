//
//  PhotoDateCell.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 16..
//  Copyright (c) 2011 CultStory Inc. All rights reserved.
//

#import "PhotoDateCell.h"

@implementation PhotoDateCell
@synthesize photo = _photo, timeLabel = _timeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    _selectedBg.hidden = !selected;
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    _selectedBg.hidden = !highlighted;
}

- (void) setFirstRow:(BOOL)first{
    splitTopImg.hidden = first;
}


- (void)showMovieIcon:(BOOL)movie{
    _movIcon.hidden = !movie;
}

- (void)dealloc{
    [_photo release];
    [_timeLabel release];
    [splitTopImg release];
    [super dealloc];
}




@end
