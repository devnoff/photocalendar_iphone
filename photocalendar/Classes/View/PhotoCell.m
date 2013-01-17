//
//  PhotoCell.m
//  TechLibrary
//
//  Created by Yongnam Park on 11. 9. 29..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import "PhotoCell.h"
#import "AppDelegate.h"
#import "PhotoViewController.h"
#import "DateViewController.h"

@implementation PhotoCell
@synthesize btn1;
@synthesize btn2;
@synthesize btn3;
@synthesize btn4;
@synthesize delegate = _delegate;

- (void) drawRect:(CGRect)rect{
    
    CGSize rectSize = CGSizeMake(79, 79);
    
    CGRect firstRect = CGRectMake(3, 2 ,rectSize.width,rectSize.height);
    CGRect secondRect = CGRectMake(82, 2 ,rectSize.width,rectSize.height);
    CGRect thirdRect = CGRectMake(160, 2 ,rectSize.width,rectSize.height);
    CGRect fourthRect = CGRectMake(239, 2 ,rectSize.width,rectSize.height);
    
    UIImage *image = [UIImage imageNamed:@"Frame_Photo"];    
    if(!btn1.hidden) [image drawInRect:firstRect];
    if(!btn2.hidden) [image drawInRect:secondRect];
    if(!btn3.hidden) [image drawInRect:thirdRect];
    if(!btn4.hidden) [image drawInRect:fourthRect];
    

    [super drawRect:rect];
}

- (void)dealloc{
    [btn1 release];
    [btn2 release];
    [btn3 release];
    [btn4 release];
    [super dealloc];
}

- (void)initialize{
    [btn1 initialize];
    [btn2 initialize];
    [btn3 initialize];
    [btn4 initialize];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setImage:(UIImage*)image atIndex:(NSInteger)index andIndexForResultController:(NSInteger)index1{
    switch (index) {
        case 0:
            [btn1 setImage:image forState:UIControlStateNormal];
            [btn1 setIndex:index1];
            [btn1 setHidden:NO];
            break;
        case 1:
            [btn2 setImage:image forState:UIControlStateNormal];
            [btn2 setIndex:index1];
            [btn2 setHidden:NO];
            break;
        case 2:
            [btn3 setImage:image forState:UIControlStateNormal];
            [btn3 setIndex:index1];
            [btn3 setHidden:NO];
            break;
        case 3:
            [btn4 setImage:image forState:UIControlStateNormal];
            [btn4 setIndex:index1];
            [btn4 setHidden:NO];
        default:
            break;
    }
    
    
}

- (void) setDuration:(double)duration forIndex:(NSInteger)index{
    switch (index) {
        case 0:
            [btn1 setDuration:duration];
            break;
        case 1:
            [btn2 setDuration:duration];
            break;
        case 2:
            [btn3 setDuration:duration];
            break;
        case 3:
            [btn4 setDuration:duration];
        default:
            break;
    }
}



- (void) prepareForReuse{
    NSLog(@"prepare for reuse");
    [btn1 setHidden:YES];
    [btn2 setHidden:YES];
    [btn3 setHidden:YES];
    [btn4 setHidden:YES];
}

- (IBAction)imgButtonTapped:(id)sender{
    [(DateViewController*)_delegate photoButtonTapped:sender];
}

@end
