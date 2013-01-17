//
//  CSTextField.h
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 17..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CSTextField : UITextField {
@private
    UIEdgeInsets _padding;
}


@property (nonatomic, assign) UIEdgeInsets padding;

@end
