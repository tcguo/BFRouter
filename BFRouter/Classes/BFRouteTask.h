//
//  BFRouteTask.h
//  BaiduFinance
//
//  Created by tcguo on 16/11/10.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFRouteRequest;
@class BFRouteResponse;

@interface BFRouteTask : NSObject

@property (nonatomic, copy, readonly) NSString *scheme;
@property (nonatomic, copy, readonly) NSString *pattern;
@property (nonatomic, assign, readonly) NSUInteger priority;

- (instancetype)initWithScheme:(NSString *)scheme
                       pattern:(NSString *)routePattern
                      priority:(NSUInteger)priority
                       handler:(BOOL(^)(__kindof BFRouteResponse *routeTask))handlerBlock;

- (BFRouteResponse *)routeResponseForRequest:(BFRouteRequest *)request;

- (BOOL)executeHandlerBlockWithRouteResponse:(BFRouteResponse *)routeResponse addtionalParametres:(NSDictionary *)additionalParams;

@end
