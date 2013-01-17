//
//  CSNavigationView.m
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 5..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import "CSNavigationView.h"



@interface CSNavigationView()
- (void) buttonTapped:(UIButton *)button;
@end

@implementation CSNavigationView

@synthesize currentIndex=_currentIndex,buttons=_buttons;
@synthesize delegate=_delegate;
@synthesize viewControllers=_viewControllers;

- (id)initWithFrame:(CGRect)frame withLabelTexts:(NSArray*)texts
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        [view release];
        
        // Container
        _buttons = [[NSMutableArray alloc] init];
        
        // Source Images
        UIImage * album_img_on = [UIImage imageNamed:@"SubTabRed_Left"];
        UIImage * album_img_over = [UIImage imageNamed:@"SubTabRed_Left_On"];
        UIImage * month_img_on = [UIImage imageNamed:@"SubTabRed_Center"];
        UIImage * month_img_over = [UIImage imageNamed:@"SubTabRed_Center_On"];
        UIImage * calendar_img_on = [UIImage imageNamed:@"SubTabRed_Center"];
        UIImage * calendar_img_over = [UIImage imageNamed:@"SubTabRed_Center_On"];
        
        UIImage * map_img_on = [UIImage imageNamed:@"SubTabRed_Right"];
        UIImage * map_img_over = [UIImage imageNamed:@"SubTabRed_Right_On"];
        
        UIImage * setting_img_on = [UIImage imageNamed:@"NavBar_BtnSetting_Red"];
        UIImage * setting_img_over = [UIImage imageNamed:@"NavBar_BtnSetting_On"];
        
        UIImage * splitImg1 = [UIImage imageNamed:@"SubTab_Split_Red"];
        UIImage * splitImg2 = [UIImage imageNamed:@"SubTab_Split_Red"];
        UIImage * splitImg3 = [UIImage imageNamed:@"SubTab_Split_Red"];        
        
        // Source figures
        float btn_width = map_img_on.size.width;
        float split_width = splitImg1.size.width;
        float top_margin = 7.0;
        float common_height = album_img_on.size.height;
        float set_btn_width = setting_img_on.size.width;
        float set_btn_height = setting_img_on.size.height;
        float left_margin;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"5")) {
            left_margin = 0.0;
        } else {
            left_margin = 1.0;
        }
        
        
        
        // Setting for Album 
        UIButton * album_btn = [[[UIButton alloc] initWithFrame:CGRectMake(left_margin+0, top_margin, btn_width, common_height)] autorelease];
        [album_btn setBackgroundImage:album_img_on forState:UIControlStateNormal];
        [album_btn setBackgroundImage:album_img_over forState:UIControlStateSelected];
        [album_btn setAdjustsImageWhenHighlighted:NO];
        [album_btn setShowsTouchWhenHighlighted:YES];
        [album_btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        UILabel * label_album = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btn_width, common_height)];
        label_album.backgroundColor = [UIColor clearColor];
        label_album.font = [UIFont boldSystemFontOfSize:13.0];
        label_album.textColor = [UIColor whiteColor];
        label_album.shadowColor = [UIColor colorWithWhite:.2 alpha:.3];
        label_album.shadowOffset = CGSizeMake(0, -1.1);
        label_album.textAlignment = UITextAlignmentCenter;
        label_album.text = [texts objectAtIndex:0];
        [album_btn addSubview:label_album];
        [label_album release];
        [_buttons addObject:album_btn];
        [self addSubview:album_btn];
        
        
        // Splitter1
        UIImageView * split = [[[UIImageView alloc] initWithImage:splitImg1] autorelease];
        split.frame = CGRectMake(left_margin+btn_width, top_margin, split_width, common_height);
        [self addSubview:split];
        
        
        // Setting for Month
        UIButton * month_btn = [[[UIButton alloc] initWithFrame:CGRectMake(left_margin+btn_width+split_width, top_margin,btn_width, common_height)] autorelease];
        [month_btn setBackgroundImage:month_img_on forState:UIControlStateNormal];
        [month_btn setBackgroundImage:month_img_over forState:UIControlStateSelected];
        [month_btn setAdjustsImageWhenHighlighted:NO];
        [month_btn setShowsTouchWhenHighlighted:YES];
        [month_btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        UILabel * label_month = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btn_width, common_height)];
        label_month.backgroundColor = [UIColor clearColor];
        label_month.font = [UIFont boldSystemFontOfSize:13.0];
        label_month.textColor = [UIColor whiteColor];
        label_month.shadowColor = [UIColor colorWithWhite:.2 alpha:.3];
        label_month.shadowOffset = CGSizeMake(0, -1.1);
        label_month.textAlignment = UITextAlignmentCenter;
        label_month.text = [texts objectAtIndex:1];
        [month_btn addSubview:label_month];
        [label_month release];
        [_buttons addObject:month_btn];
        [self addSubview:month_btn];
        
        
        // Splitter2
        UIImageView * split1 = [[[UIImageView alloc] initWithImage:splitImg2] autorelease];
        split1.frame = CGRectMake(left_margin+(btn_width*2)+split_width, top_margin, split_width, common_height);
        [self addSubview:split1];
        
        
        // Setting for Calendar
        UIButton * calendar_btn = [[[UIButton alloc] initWithFrame:CGRectMake(left_margin+(btn_width*2)+(split_width*2), top_margin,btn_width, common_height)] autorelease];
        [calendar_btn setBackgroundImage:calendar_img_on forState:UIControlStateNormal];
        [calendar_btn setBackgroundImage:calendar_img_over forState:UIControlStateSelected];
        [calendar_btn setAdjustsImageWhenHighlighted:NO];
        [calendar_btn setShowsTouchWhenHighlighted:YES];
        [calendar_btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        UILabel * label_calendar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btn_width, common_height)];
        label_calendar.backgroundColor = [UIColor clearColor];
        label_calendar.font = [UIFont boldSystemFontOfSize:13.0];
        label_calendar.textColor = [UIColor whiteColor];
        label_calendar.shadowColor = [UIColor colorWithWhite:.2 alpha:.3];
        label_calendar.shadowOffset = CGSizeMake(0, -1.1);
        label_calendar.textAlignment = UITextAlignmentCenter;
        label_calendar.text = [texts objectAtIndex:2];
        [calendar_btn addSubview:label_calendar];
        [label_calendar release];
        [_buttons addObject:calendar_btn];
        [self addSubview:calendar_btn];
        
        
        // Splitter3
        UIImageView * split2 = [[[UIImageView alloc] initWithImage:splitImg3] autorelease];
        split2.frame = CGRectMake(left_margin+(btn_width*3)+split_width+1, top_margin, split_width, common_height);
        [self addSubview:split2];
        
        
        // Setting for Map
        UIButton * map_btn = [[[UIButton alloc] initWithFrame:CGRectMake(left_margin+(btn_width*3)+(split_width*3), top_margin,btn_width, common_height)] autorelease];
        [map_btn setBackgroundImage:map_img_on forState:UIControlStateNormal];
        [map_btn setBackgroundImage:map_img_over forState:UIControlStateSelected];
        [map_btn setAdjustsImageWhenHighlighted:NO];
        [map_btn setShowsTouchWhenHighlighted:YES];
        [map_btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        UILabel * label_map = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btn_width, common_height)];
        label_map.backgroundColor = [UIColor clearColor];
        label_map.font = [UIFont boldSystemFontOfSize:13.0];
        label_map.textColor = [UIColor whiteColor];
        label_map.shadowColor = [UIColor colorWithWhite:.2 alpha:.3];
        label_map.shadowOffset = CGSizeMake(0, -1.1);
        label_map.textAlignment = UITextAlignmentCenter;
        label_map.text = [texts objectAtIndex:3];
        [map_btn addSubview:label_map];
        [label_map release];
        [_buttons addObject:map_btn];
        [self addSubview:map_btn];
        
        
        
        // Setting for Settings
        UIButton * setting_btn = [[[UIButton alloc] initWithFrame:CGRectMake(left_margin+(btn_width*4)+(split_width*3)+8, top_margin+3,set_btn_width, set_btn_height)] autorelease];
        [setting_btn setImage:setting_img_on forState:UIControlStateNormal];
        [setting_btn setImage:setting_img_over forState:UIControlStateSelected];
        [setting_btn setAdjustsImageWhenHighlighted:NO];
        [setting_btn setShowsTouchWhenHighlighted:YES];
        [setting_btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_buttons addObject:setting_btn];
        [self addSubview:setting_btn];
        
        // init view controllers
        
        
        //
        _currentIndex = -1;
        
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

- (void) buttonTapped:(UIButton *)button{
    
    [self selectedIndex:[_buttons indexOfObject:button]];
}

- (void) selectedIndex:(NSInteger)index{
    
    if(_currentIndex==index) 
        return;
    
    _currentIndex = index;
    
    // Change current button as selected 
    for(int i = 0; i<[_buttons count] ;i++){
        UIButton * btn = [_buttons objectAtIndex:i];
        btn.selected = i==_currentIndex?YES:NO;
    }
    NSLog(@"selected : %d", _currentIndex);
    
    // show view controller of curren index
    [_delegate didSelectedViewController:[_viewControllers objectAtIndex:_currentIndex] atIndex:_currentIndex];
}

@end
