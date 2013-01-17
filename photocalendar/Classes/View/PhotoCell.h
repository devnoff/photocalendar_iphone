//
//  PhotoCell.h
//  TechLibrary
//
//  Created by Yongnam Park on 11. 9. 29..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoModel.h"
#import "PhotoButton.h"

@interface PhotoCell : UITableViewCell
{
    
    IBOutlet PhotoButton * btn1;
    IBOutlet PhotoButton * btn2;
    IBOutlet PhotoButton * btn3;
    IBOutlet PhotoButton * btn4;
    
    id _delegate;
}

@property(nonatomic,retain) IBOutlet PhotoButton * btn1;
@property(nonatomic,retain) IBOutlet PhotoButton * btn2;
@property(nonatomic,retain) IBOutlet PhotoButton * btn3;
@property(nonatomic,retain) IBOutlet PhotoButton * btn4;
@property(nonatomic,assign) id delegate;

- (void)initialize;

- (void)setImage:(UIImage*)image atIndex:(NSInteger)index andIndexForResultController:(NSInteger)index1;

- (IBAction)imgButtonTapped:(id)sender;

- (void) setDuration:(double)duration forIndex:(NSInteger)index;
@end
