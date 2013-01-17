//
//  CSLabel.h
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 20..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CSLabel : UILabel {
@private

    UIEdgeInsets _padding;
}


@property (nonatomic, assign) UIEdgeInsets padding;

@end
