//
//  BFRouteResponse.m
//  BaiduFinance
//
//  Created by tcguo on 16/11/10.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "BFRouteResponse.h"

@interface BFRouteResponse ()

@property (nonatomic, copy, readwrite) NSString *scheme;
@property (nonatomic, copy, readwrite) NSString *pattern;
@property (nonatomic, assign, readwrite) NSUInteger priority;

@property (nonatomic, assign, readwrite) BOOL isMatch;
@property (nonatomic, strong, readwrite) NSDictionary *queryParametres;
@property (nonatomic, strong, readwrite) NSArray *pathComponents;

@end

@implementation BFRouteResponse

+ (instancetype)invalidMatchResponse {
    BFRouteResponse *response = [[[self class] alloc] init];
    response.isMatch = NO;
    return response;
}
+ (instancetype)validMatchResponseWithScheme:(NSString *)scheme
                                     pattern:(NSString *)pattern
                                    priority:(NSUInteger)priority
                           queryParametres:(NSDictionary *)queryParametres
                              pathComponents:(NSArray *)pathComponents
{
    BFRouteResponse *response = [[[self class] alloc] init];
    response.scheme = scheme;
    response.pattern = pattern;
    response.priority = priority;
    response.isMatch = YES;
    response.queryParametres = queryParametres;
    response.pathComponents = pathComponents;
    return response;
}

@end
