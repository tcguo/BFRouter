//
//  NSDictionary+KVC.h
//  BaiduFinance
//
//  Created by zhouzhenhua on 14-8-22.
//  Copyright (c) 2014年 jiangxiaolong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (KVC)

- (BOOL)isNull:(id)value;
- (id)objectForKeySafely:(id)aKey;
- (id)valueForKeySafely:(NSString *)key;
- (id)valueForKeyPathSafely:(NSString *)keyPath;

- (NSString *)stringValueForKeySafely:(NSString *)key;

@end
