//
//  BFRouteTask.m
//  BaiduFinance
//
//  Created by tcguo on 16/11/10.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "BFRouteTask.h"
#import "BFRouteResponse.h"
#import "BFRouteRequest.h"

@interface BFRouteTask ()
@property (nonatomic, copy) BOOL(^handlerBlock)(__kindof BFRouteResponse *routeResponse);
@property (nonatomic, strong) NSArray *patternComponents;
@end

@implementation BFRouteTask

- (instancetype)initWithScheme:(NSString *)scheme
                       pattern:(NSString *)routePattern
                      priority:(NSUInteger)priority
                       handler:(BOOL(^)(__kindof BFRouteResponse *routeTask))handlerBlock
{
    self = [super init];
    if (self) {
        _scheme = scheme;
        _pattern = routePattern;
        _priority = priority;
        self.handlerBlock = handlerBlock;
        
        if ([routePattern characterAtIndex:0] == '/') {
            routePattern = [routePattern substringFromIndex:1];
        }
        _patternComponents = [routePattern componentsSeparatedByString:@"/"];
    }
    return self;
}

- (BFRouteResponse *)routeResponseForRequest:(BFRouteRequest *)request {
    // not contains Wildcard and no match Task
    if (![self.patternComponents containsObject:@"*"] && self.patternComponents.count != request.pathComponents.count) {
        return [BFRouteResponse invalidMatchResponse];
    }
    
    
    BFRouteResponse *routeResponse = [BFRouteResponse invalidMatchResponse];
    BOOL isMatch = YES;
    NSUInteger index = 0;
    NSArray *pathComponents = nil;
    
    // compare all patterns in pattenComponents;
    for (NSString *partinalpattern in self.patternComponents) {
         NSString *urlComponent = nil;
        if (index < [request.pathComponents count]) {
            urlComponent = request.pathComponents[index];
        } else if ([partinalpattern isEqualToString:@"*"]) {
            // match /foo by /foo/*
            urlComponent = [request.pathComponents lastObject];
        }
        
        if ([partinalpattern isEqualToString:@"*"]) {
            // match wildcards
            NSUInteger minRequiredParams = index;
            if (request.pathComponents.count >= minRequiredParams) {
                // match: /a/b/c/* has to be matched by at least /a/b/c
               pathComponents = [request.pathComponents subarrayWithRange:NSMakeRange(index, request.pathComponents.count - index)];
                isMatch = YES;
            } else {
                // not a match: /a/b/c/* cannot be matched by URL /a/b/
                isMatch = NO;
            }
            break;
        } else if (![partinalpattern isEqualToString:urlComponent]) {
            isMatch = NO;
            break;
        }
        
        index++;
    }
    
    if (isMatch) {
        routeResponse = [BFRouteResponse validMatchResponseWithScheme:self.scheme
                                                              pattern:self.pattern
                                                             priority:self.priority
                                                    queryParametres:request.queryParametres
                                                     pathComponents:pathComponents];
    }
    
    return routeResponse;
}

- (BOOL)executeHandlerBlockWithRouteResponse:(BFRouteResponse *)routeResponse addtionalParametres:(NSDictionary *)additionalParams {
    if (self.handlerBlock) {
        routeResponse.additionalParametres = additionalParams;
        return self.handlerBlock(routeResponse);
    }
    return YES;
}


@end
