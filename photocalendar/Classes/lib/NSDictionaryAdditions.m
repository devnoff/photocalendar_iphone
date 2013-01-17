//
//  NSDictionaryAdditions.m
//  travelog
//
//  Created by Cho, Young-Un on 12. 2. 20..
//  Copyright (c) 2012 CultStory Inc. All rights reserved.
//

#import "NSDictionaryAdditions.h"


@implementation NSDictionary (Additions)

- (NSString *)stringForKey:(NSString *)key {
    id value = [self objectForKey:key];
    if (nil == value) {
        value = @"";
    }
    if ([NSNull null] == value) {
        value = @"";
    }
    
    return value;
}


- (BOOL)boolForKey:(NSString *)key {
    NSString *value = [self stringForKey:key];
    return [value boolValue];
}


- (NSInteger)integerForKey:(NSString *)key {
    NSString *value = [self stringForKey:key];
    return [value intValue];
}


- (double)doubleForKey:(NSString *)key {
    NSString *value = [self stringForKey:key];
    return [value doubleValue];
}

@end
