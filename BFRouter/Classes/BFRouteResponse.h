//
//  BFRouteResponse.h
//  BaiduFinance
//
//  Created by tcguo on 16/11/10.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFRouteResponse : NSObject

@property (nonatomic, assign, readonly) BOOL isMatch;
@property (nonatomic, strong, readonly) NSDictionary *queryParametres;
@property (nonatomic, strong) NSDictionary *additionalParametres;
@property (nonatomic, strong, readonly) NSArray *pathComponents;

@property (nonatomic, copy, readonly) NSString *scheme;
@property (nonatomic, copy, readonly) NSString *pattern;
@property (nonatomic, assign, readonly) NSUInteger priority;

+ (instancetype)invalidMatchResponse;

+ (instancetype)validMatchResponseWithScheme:(NSString *)scheme
                                     pattern:(NSString *)pattern
                                    priority:(NSUInteger)priority
                             queryParametres:(NSDictionary *)queryParametres
                              pathComponents:(NSArray *)pathComponents;

@end
