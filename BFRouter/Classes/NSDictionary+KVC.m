//
//  NSDictionary+KVC.m
//  BaiduFinance
//
//  Created by zhouzhenhua on 14-8-22.
//  Copyright (c) 2014年 jiangxiaolong. All rights reserved.
//

#import "NSDictionary+KVC.h"

@implementation NSDictionary (KVC)

- (BOOL)isNull:(id)value
{
    if([value isEqual:[NSNull null]]) {
        return YES;
    }
    
    return NO;
}

- (id)objectForKeySafely:(id)aKey
{
    NSParameterAssert(aKey);
    // akey对应的value为null 或 akey在jsonDictionary中不存在，则值==nil
    if ([self isNull:[self objectForKey:aKey]] || [self objectForKey:aKey] == nil) {
        return nil;
    }
    return [self objectForKey:aKey];
}

- (id)valueForKeySafely:(NSString *)key
{
    NSParameterAssert(key);
    if ([self isNull:[self valueForKey:key]] || [self valueForKey:key] == nil) {
        return nil;
    }
    return [self valueForKey:key];
}

- (NSString *)stringValueForKeySafely:(NSString *)key
{
    NSParameterAssert(key);
    id value = [self valueForKey:key];
    if (value == nil || [self isNull:value]) {
        return @"";
    } else if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"%@", [self valueForKey:key]];
    }
    
    return @"";
}

- (id)valueForKeyPathSafely:(NSString *)keyPath
{
    NSParameterAssert(keyPath);
    if ([self isNull:[self valueForKeyPath:keyPath]]) {
        return nil;
    }
    return [self valueForKeyPath:keyPath];
}

@end
