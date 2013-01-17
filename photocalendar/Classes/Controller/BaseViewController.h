//
//  BaseViewController.h
//  photocalendar
//
//  Created by Yongnam Park on 11. 10. 7..
//  Copyright 2011 CultStory Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController{
    BOOL resized;
    
}


- (NSManagedObjectContext*) _context;
- (UINavigationController*) _navigation;
- (void)refresh;
@end
