//
//  
//    ___  _____   ______  __ _   _________ 
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_| 
//
//  Created by Bart Claessens. bart (at) revolver . be
//

#import "REVClusterAnnotationView.h"


@implementation REVClusterAnnotationView

@synthesize coordinate;
@synthesize delegate=_delegate;
@synthesize pin=_pin;

- (id) initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if ( self )
    {
        self.alpha = 0.0f;
        self.frame = CGRectMake(0, 0, 40, 43);
        self.centerOffset = CGPointMake(0, 0);
        
        _imageView = [[UIButton alloc] initWithFrame:CGRectMake(3, 6, 34, 34)];
        _imageView.userInteractionEnabled = NO;
//        [_imageView addTarget:self action:@selector(photoThumbTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_imageView];
        
        _frame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NewMapPin"]];
        _frame.frame = CGRectMake(0, 0, 40, 43);
        
        [self addSubview:_frame];

        
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 26, 26)];
        [self addSubview:label];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:11]; 
        label.textAlignment = UITextAlignmentCenter;
        label.shadowColor = [UIColor blackColor];
        label.shadowOffset = CGSizeMake(0,-1);
        
        

    }
    return self;
}



- (void) setClusterText:(NSString *)text
{
    label.text = text;
}

- (void) setPhotoThumb:(UIImage *)thumb{
    
    self.alpha = 0.0f;
    
    [_imageView setImage:thumb forState:UIControlStateNormal];
    
    [UIView animateWithDuration:.5 
                     animations:^{
                         self.alpha = 1.0f;
                     } 
                     completion:^(BOOL finished){
                         
                     }];
}

- (void) photoThumbTapped:(id)sender{
    NSLog(@"photo thumb tapped");
    
    [self setSelected:YES animated:YES];
    [_delegate didSelectAnnotationView:self];
}

- (void) resetAnnotationView{
    
    [UIView animateWithDuration:.5 
                     animations:^{
                         self.alpha = 0.0f;
                     } 
                     completion:^(BOOL finished){
                         
                     }];

}

- (void) dealloc
{
    [label release], label = nil;
    [_frame release], _frame = nil;
    [_imageView release], _imageView = nil;
    [_pin release], _pin = nil;
    [super dealloc];
}

@end
