//
//  BFRouteRegistry.m
//  BaiduFinance
//
//  Created by tcguo on 16/11/11.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "BFRouteRegistry.h"
#import "BFRouter.h"
#import "BFRouteService.h"
//#import "BFH5RequestUrlDefine.h"
#import "BFRouteConstantsDefine.h"
#import "NSDictionary+KVC.h"
#include <objc/runtime.h>

// 判断obj 不为空
#define OBJHASVALUE(obj) (obj!=nil&&![obj isKindOfClass:[NSNull class]])
// 判断对象是否为null值
#define OBJECTISNULL(obj)       [obj isEqual:[NSNull null]]
// 判断字符串是否有值
#define STRINGHASVALUE(str)		(str && [str isKindOfClass:[NSString class]] && [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)
#define isEmptyString(s)  (((s) == nil) || ([(s) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0))
#define NilToEmptyString(str)  ((isEmptyString((str))) ? @"" : (str))
// 判断字典是否有值
#define DICTIONARYHASVALUE(dic)    (dic && [dic isKindOfClass:[NSDictionary class]] && [dic count] > 0)
// 判断数组是否有值
#define ARRAYHASVALUE(array)    (array && [array isKindOfClass:[NSArray class]] && [array count] > 0)

static id<BFRouteService> defaultRouteService = nil;
@implementation BFRouteRegistry

+ (id<BFRouteService>)getRouteServiceByClassName:(NSString *)className {
    Class service = NSClassFromString(className);
    id<BFRouteService> concreteService = nil;
    if (service) {
        concreteService = [[service alloc] init];
    }
    
    return concreteService;
}

+ (id<BFRouteService>)defaultRouteService {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!defaultRouteService) {
            defaultRouteService = [self getRouteServiceByClassName:@"BFRouteDefaultService"];
        }
    });
    
    return defaultRouteService;
}

+ (NSDictionary *)buildWebViewParametresWithUrl:(NSString *)url title:(NSString *)title isFixed:(BOOL)fixed {
    return @{ BFRouteServiceWebView_Url: url ?: @"",
              BFRouteServiceWebView_Title: title ?: @"",
              BFRouteServiceWebView_Fixed: [NSNumber numberWithBool:fixed]};
}

+ (void)registeGlobalRoutes {
    /***  Domain: Common ***/
    [[BFRouter routerForScheme:kScheme_bdlicai] addRoute:kRoutePattern_Common_Native_Tab handler:^BOOL(__kindof BFRouteResponse *routeResponse) {
        NSString *tabIdx = [routeResponse.additionalParametres stringValueForKeySafely:@"tabIdx"];
        if (STRINGHASVALUE(tabIdx)) {
            [[self defaultRouteService] jumpToNativeView:[tabIdx integerValue]];
        }
        
        return YES;
    }];
    [[BFRouter routerForScheme:kScheme_bdlicai] addRoute:kRoutePattern_Common_Native_Fund handler:^BOOL(__kindof BFRouteResponse *routeResponse) {
        [[self defaultRouteService] jumpToNativeView:BFNativeViewTypeInvestFund];
        return YES;
    }];
    
    
    [[BFRouter routerForScheme:kScheme_bdlicai] addRoute:kRoutePattern_Common_WebView handler:^BOOL(__kindof BFRouteResponse *routeResponse) {
        if (!DICTIONARYHASVALUE(routeResponse.additionalParametres)) {
            return NO;
        }
        
        NSString *url = [routeResponse.additionalParametres stringValueForKeySafely:@"url"];
        if (!url || url.length == 0) {
            return NO;
        }
        
        NSString *title = [routeResponse.additionalParametres stringValueForKeySafely:@"title"];
        BOOL fixed = NO;
        if ([routeResponse.additionalParametres valueForKeySafely:@"fixed"]) {
            fixed = [[routeResponse.additionalParametres valueForKeySafely:@"fixed"] boolValue];
        }
        
        NSString *encodeUrlString =  [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *userInfo = [self buildWebViewParametresWithUrl:encodeUrlString title:title isFixed:fixed];
        [[self defaultRouteService] jumpToWebViewWithUserInfo:userInfo];
        
        return YES;
    }];
    
    /*** Domain: finance ***/
    
    // bdlicai://finance/home
    // bdlicai://finance/activitydetail?url=xxx
    // bdlicai://finance/activitylist
    // bdlicai://finance/messagedetail?id=xxx&title=xxx
    [[BFRouter routerForScheme:kScheme_bdlicai] addRoute:@"/finance/home" handler:^BOOL(__kindof BFRouteResponse *routeResponse) {
        [[self defaultRouteService] jumpToNativeView:BFNativeViewTypeHome];
        return YES;
    }];
    
    [[BFRouter routerForScheme:kScheme_bdlicai] addRoute:@"/finance/activitydetail" handler:^BOOL(__kindof BFRouteResponse *routeResponse) {
        NSString *url = [routeResponse.queryParametres stringValueForKeySafely:@"url"];
        if (url.length == 0) {
            return NO;
        }
        
        NSString *codeUrl = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *userInfo = [self buildWebViewParametresWithUrl:codeUrl title:nil isFixed:NO];
        [[self defaultRouteService] jumpToWebViewWithUserInfo:userInfo];
        return YES;
    }];
    
    [[BFRouter routerForScheme:kScheme_bdlicai] addRoute:@"/finance/activitylist" handler:^BOOL(__kindof BFRouteResponse *routeResponse) {
        NSDictionary *userInfo = [self buildWebViewParametresWithUrl:@"" title:@"活动" isFixed:NO];
        [[self defaultRouteService] jumpToWebViewWithUserInfo:userInfo];
        return YES;
    }];
    
    [[BFRouter routerForScheme:kScheme_bdlicai] addRoute:@"/finance/messagedetail" handler:^BOOL(__kindof BFRouteResponse *routeResponse) {
        NSString *title = [routeResponse.queryParametres stringValueForKeySafely:@"title"];
        NSString *msgId = [routeResponse.queryParametres stringValueForKeySafely:@"id"];
        if (msgId.length == 0) {
            return NO;
        }
        
        NSDictionary *userInfo = [self buildWebViewParametresWithUrl:@"" title:title isFixed:NO];
        [[self defaultRouteService] jumpToWebViewWithUserInfo:userInfo];
        return YES;
    }];
    
    /*** Domain: licai.baidu.com ***/
    [[BFRouter routerForScheme:kScheme_https] addRoute:@"/licai.baidu.com/link/webview/*" handler:^BOOL(__kindof BFRouteResponse *routeResponse) {
        NSString *url = [routeResponse.additionalParametres stringValueForKeySafely:@"url"];
        if (url.length == 0) {
            return NO;
        }
        
        NSString *encodeUrlString =  [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *userInfo = [self buildWebViewParametresWithUrl:encodeUrlString title:nil isFixed:NO];
        [[self defaultRouteService] jumpToWebViewWithUserInfo:userInfo];
        return YES;
    }];
    
    [[BFRouter routerForScheme:kScheme_https] addRoute:@"/licai.baidu.com/link/native/*" handler:^BOOL(__kindof BFRouteResponse *routeResponse) {
        
        NSArray *paths = routeResponse.pathComponents;
        if (paths.count == 0) {
            return NO;
        }
        
        NSString *path = paths.firstObject;
        if ([path isEqualToString:@"finance"]) {
            [[self defaultRouteService] jumpToNativeView:BFNativeViewTypeInvestHome];
            return YES;
        }
        if ([path isEqualToString:@"home"]) {
            [[self defaultRouteService] jumpToNativeView:BFNativeViewTypeHome];
            return YES;
        }
        if ([path isEqualToString:@"fund"]) {
            [[self defaultRouteService] jumpToNativeView:BFNativeViewTypeInvestFund];
            return YES;
        }
        
        return NO;
    }];
    
}

@end
