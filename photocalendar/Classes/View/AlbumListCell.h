//
//  AlbumListCell.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 5..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOGroup.h"


typedef enum {
    AlbumListCellTypeNormal,
    AlbumListCellTypeChoosing
} AlbumListCellType;

@protocol AlbumListCellDelegate;
@interface AlbumListCell : UITableViewCell{
    
    IBOutlet UIImageView * _thumb;
    IBOutlet UILabel * _title;
    IBOutlet UILabel * _subtitle;
    
    IBOutlet UIImageView * splitTopImg;
    IBOutlet UIView * _selectedBg;
    
    IBOutlet UIButton * _checkBtn;
    IBOutlet UIImageView * _arrow;
    
    
    id <AlbumListCellDelegate> delegate;
    DOGroup * _group;
    AlbumListCellType _type;
}

@property (nonatomic,retain) IBOutlet UIImageView * _thumb;
@property (nonatomic,retain) IBOutlet UILabel * _title;
@property (nonatomic,retain) IBOutlet UILabel * _subtitle;

@property (nonatomic,retain) id<AlbumListCellDelegate> delegate;

@property (nonatomic,retain) DOGroup *group;


- (void) initCell;
- (void) initForCellModeSelect;
- (void) setThumb:(UIImage*)thumb title:(NSString*)title subTitle:(NSString*)subTitle;
- (void) setFirstRow:(BOOL)first;
- (void) setThumb:(UIImage*)thumb;
//- (void) setCellModeSelect;
@end


@protocol AlbumListCellDelegate <NSObject>

- (void) didSelectedGroup:(DOGroup *)group;
- (void) didDeselectedGroup:(DOGroup *)group;

@end