//
//  BFRouter.h
//  BaiduFinance
//
//  Created by tcguo on 16/11/10.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BFRouteResponse.h"

// frequently used schemes
extern NSString * const kScheme_bdlicai;
extern NSString * const kScheme_https;
extern NSString * const kScheme_http;


typedef BOOL(^BFRouteHandlerBlock)(__kindof BFRouteResponse *routeResponse);

@interface BFRouter : NSObject

+ (instancetype)routerForScheme:(NSString *)scheme;

+ (void)unregisterRouteScheme:(NSString *)scheme;

+ (void)unregisterAllRouteSchemes;

- (void)addRoute:(NSString *)routePattern handler:(BFRouteHandlerBlock)handlerBlock;

+ (BOOL)routeURL:(NSURL *)URL;

+ (BOOL)routeURL:(NSURL *)URL withAdditionalParametres:(NSDictionary *)parametres;

- (BOOL)routeURL:(NSURL *)URL;

- (BOOL)routeURL:(NSURL *)URL withAdditionalParametres:(NSDictionary *)parametres;

@end
