//
//  NSDictionaryAdditions.h
//  travelog
//
//  Created by Cho, Young-Un on 12. 2. 20..
//  Copyright (c) 2012 CultStory Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (Additions)

- (NSString *)stringForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)key;
- (NSInteger)integerForKey:(NSString *)key;
- (double)doubleForKey:(NSString *)key;

@end
