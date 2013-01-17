//
//  AlbumListCell.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 5..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import "AlbumListCell.h"

@interface AlbumListCell()

@end
@implementation AlbumListCell
@synthesize _thumb;
@synthesize _title;
@synthesize _subtitle;
@synthesize delegate;
@synthesize group = _group;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initCell{
    _type = AlbumListCellTypeNormal;
}

- (void) initForCellModeSelect{
    _checkBtn.hidden = NO;
    _type = AlbumListCellTypeChoosing;
    _arrow.hidden = YES;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
}

- (NSString*)reuseIdentifier{
    
    
    return [super reuseIdentifier];
}


- (void) dealloc{
    [_thumb release];
    [_selectedBg release];
    [_title release];
    [_subtitle release];
    [splitTopImg release];
    delegate = nil;
    [_checkBtn release];
    [_group release];
    [_arrow release];
    [super dealloc];
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    _selectedBg.hidden = !selected;
    
    
    if (selected) {
        _checkBtn.selected = _checkBtn.selected?NO:YES;
        if (_type==AlbumListCellTypeChoosing) {
            if (_checkBtn.selected) {
                [delegate didSelectedGroup:_group];
            } else {
                [delegate didDeselectedGroup:_group];
            }
        }    
    }
    
}

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    _selectedBg.hidden = !highlighted;
    
    
    
}


- (void) setThumb:(UIImage*)thumb title:(NSString*)title subTitle:(NSString*)subTitle{
    
    _thumb.image = thumb;
    
    CGRect currTitleRect = _title.frame;
    CGRect currSubTitleRect;
    
    CGSize labelSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:17.0f]];
    CGSize labelSize1 = [subTitle sizeWithFont:[UIFont boldSystemFontOfSize:17.0f]];
    
    
    if (labelSize.width>170) {
        labelSize.width = 170;
        [_title setLineBreakMode:UILineBreakModeTailTruncation];
    } else {
        labelSize.width = labelSize.width+2;
//        [_title setLineBreakMode:UILineBreakModeClip];    
    }
    
    
    currTitleRect.size = labelSize;
    currSubTitleRect = CGRectMake(currTitleRect.origin.x+labelSize.width+2, currTitleRect.origin.y, labelSize1.width, labelSize1.height);
    
    _title.frame = currTitleRect;
    _subtitle.frame = currSubTitleRect;
    
    _title.text = title;
    _subtitle.text = subTitle;
    
    
    

    
}

- (void) setFirstRow:(BOOL)first{
    splitTopImg.hidden = first;
}


- (void) setThumb:(UIImage*)thumb{
    _thumb.image = thumb;
}

@end
