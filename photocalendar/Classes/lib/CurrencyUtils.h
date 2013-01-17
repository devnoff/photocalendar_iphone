//
//  CurrencyUtils.h
//  travelog
//
//  Created by Cho, Young-Un on 11. 9. 27..
//  Copyright 2011 cultstory.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CurrencyUtils : NSObject {
    
}


+ (NSArray *)getCurrencies;

+ (NSUInteger)count;
+ (NSString *)textAtIndex:(NSUInteger)index;
+ (NSString *)codeAtIndex:(NSUInteger)index;
+ (NSUInteger)indexOfUSD;

@end
