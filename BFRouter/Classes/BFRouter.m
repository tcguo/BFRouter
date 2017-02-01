//
//  BFRouter.m
//  BaiduFinance
//  
//  Created by tcguo on 16/11/10.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "BFRouter.h"
#import "BFRouteTask.h"
#import "BFRouteRequest.h"

NSString * const kScheme_bdlicai = @"bdlicai";
NSString * const kScheme_https = @"https";
NSString * const kScheme_http = @"http";

static NSMutableDictionary *routeControllersMap = nil;

@interface BFRouter ()

@property (nonatomic, strong) NSMutableArray *routes;
@property (nonatomic, copy) NSString *scheme;

@end

@implementation BFRouter

- (id)init {
    self = [super init];
    if (self) {
        _routes = [NSMutableArray array];
    }
    return self;
}

#pragma mark - public

+ (instancetype)routerForScheme:(NSString *)scheme {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!routeControllersMap) {
            routeControllersMap = [[NSMutableDictionary alloc] init];
        }
    });
    
    BFRouter *routeController = routeControllersMap[scheme];
    if (!routeController) {
        routeController = [[BFRouter alloc] init];
        routeController.scheme = scheme;
        [routeControllersMap setObject:routeController forKey:scheme];
    }
    
    return routeController;
}

+ (void)unregisterRouteScheme:(NSString *)scheme {
    [routeControllersMap removeObjectForKey:scheme];
}

+ (void)unregisterAllRouteSchemes {
    [routeControllersMap removeAllObjects];
}

- (void)addRoute:(NSString *)routePattern handler:(BFRouteHandlerBlock)handlerBlock {
    [self registerRoute:routePattern priority:0 handler:handlerBlock];
}

- (void)addRoute:(NSString *)routePattern priority:(NSUInteger)priority handler:(BFRouteHandlerBlock)handlerBlock {
    [self registerRoute:routePattern priority:priority handler:handlerBlock];
}

+ (BOOL)routeURL:(NSURL *)URL {
   return [[self routeControllerForURL:URL] routeURL:URL];
}

+ (BOOL)routeURL:(NSURL *)URL withAdditionalParametres:(NSDictionary *)parametres {
    return [[self routeControllerForURL:URL] routeURL:URL withAdditionalParametres:parametres];
}

- (BOOL)routeURL:(NSURL *)URL {
    return [self routeURL:URL withAdditionalParametres:nil executeRouteBlock:YES];
}

- (BOOL)routeURL:(NSURL *)URL withAdditionalParametres:(NSDictionary *)parametres {
    return [self routeURL:URL withAdditionalParametres:parametres executeRouteBlock:YES];
}

#pragma mark - private

+ (instancetype)routeControllerForURL:(NSURL *)URL {
    if (URL == nil) {
        return nil;
    }
    
    return routeControllersMap[URL.scheme]?: nil;
}

- (void)registerRoute:(NSString *)routePattern priority:(NSUInteger)priority handler:(BFRouteHandlerBlock)handlerBlock {
    BFRouteTask *routeTask = nil;
    routeTask = [[BFRouteTask alloc] initWithScheme:self.scheme pattern:routePattern priority:priority handler:handlerBlock];
    if (self.routes.count == 0 || priority == 0) {
        [self.routes addObject:routeTask];
    } else {
        BOOL hasAdded = NO;
        NSInteger index = 0;
        for (BFRouteTask *existRouteTask in [self.routes copy]) {
            if (existRouteTask.priority < priority) {
                [self.routes insertObject:routeTask atIndex:index];
                hasAdded = YES;
                break;
            }
            index++;
        }
        
        if (!hasAdded) {
            [self.routes addObject:routeTask];
        }
    }
}

- (BOOL)routeURL:(NSURL *)url withAdditionalParametres:(NSDictionary *)parametres executeRouteBlock:(BOOL)executeBlock {
    if (!url) {
        return NO;
    }
    
    BOOL didRoute = NO;
    for (BFRouteTask *routeTask in self.routes) {
        BFRouteRequest *routeRequest = [[BFRouteRequest alloc] initWithURL:url];
        BFRouteResponse *routeResponse = [routeTask routeResponseForRequest:routeRequest];
        if (routeResponse.isMatch) {
            didRoute = [routeTask executeHandlerBlockWithRouteResponse:routeResponse addtionalParametres:parametres];
            break;
        }
    }
    
    return didRoute;
}

@end
