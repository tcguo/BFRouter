//
//  BFRouteRequest.m
//  BaiduFinance
//
//  Created by tcguo on 16/11/10.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "BFRouteRequest.h"

@interface BFRouteRequest ()

@property (nonatomic, strong, readwrite) NSURL *URL;
@property (nonatomic, copy, readwrite) NSArray *pathComponents;
@property (nonatomic, copy, readwrite) NSDictionary *queryParametres;

@end

@implementation BFRouteRequest

- (instancetype)initWithURL:(NSURL *)URL {
    self = [super init];
    if (self) {
        _URL = URL;
        [self parseURL:_URL];
    }
    return self;
}

- (void)parseURL:(NSURL *)URL {
    NSURLComponents *components = [NSURLComponents componentsWithString:[self.URL absoluteString]];
    if (components.host.length > 0 && ![components.host isEqualToString:@"localhost"]) {
        // convert the host to "/" so that the host is considered a path component
        NSString *host = [components.percentEncodedHost copy];
        components.host = @"/";
        components.percentEncodedPath = [host stringByAppendingPathComponent:(components.percentEncodedPath ?: @"")];
    }
    
    NSString *path = [components percentEncodedPath];
    
    /*
    // handle fragment if needed
    if (components.fragment != nil) {
        BOOL fragmentContainsQueryParams = NO;
        NSURLComponents *fragmentComponents = [NSURLComponents componentsWithString:components.percentEncodedFragment];
        
        if (fragmentComponents.query == nil && fragmentComponents.path != nil) {
            fragmentComponents.query = fragmentComponents.path;
        }
        
        if (fragmentComponents.queryItems.count > 0) {
            // determine if this fragment is only valid query params and nothing else
            fragmentContainsQueryParams = fragmentComponents.queryItems.firstObject.value.length > 0;
        }
        
        if (fragmentContainsQueryParams) {
            // include fragment query params in with the standard set
            components.queryItems = [(components.queryItems ?: @[]) arrayByAddingObjectsFromArray:fragmentComponents.queryItems];
        }
        
        if (fragmentComponents.path != nil && (!fragmentContainsQueryParams || ![fragmentComponents.path isEqualToString:fragmentComponents.query])) {
            // handle fragment by include fragment path as part of the main path
             path = [path stringByAppendingString:[NSString stringWithFormat:@"#%@", fragmentComponents.percentEncodedPath]];
        }
    }
    */
    
    // strip off leading slash so that we don't have an empty first path component
    if (path.length > 0 && [path characterAtIndex:0] == '/') {
        path = [path substringFromIndex:1];
    }
    
    // strip off trailing slash for the same reason
    if (path.length > 0 && [path characterAtIndex:path.length - 1] == '/') {
        path = [path substringToIndex:path.length - 1];
    }
    
    // split apart into path components
    self.pathComponents = [path componentsSeparatedByString:@"/"];
    
    // convert query items into a dictionary
    NSMutableDictionary *queryParams = [NSMutableDictionary dictionary];
    if ([components respondsToSelector:@selector(queryItems)]) {
        NSArray <NSURLQueryItem *> *queryItems = [components queryItems] ?: @[];
        for (NSURLQueryItem *item in queryItems) {
            if (item.value == nil) {
                continue;
            }
            
            if (queryParams[item.name] == nil) {
                // first time seeing a param with this name, set it
                queryParams[item.name] = item.value;
            } else if ([queryParams[item.name] isKindOfClass:[NSArray class]]) {
                // already an array of these items, append it
                NSArray *values = (NSArray *)(queryParams[item.name]);
                queryParams[item.name] = [values arrayByAddingObject:item.value];
            } else {
                // existing non-array value for this key, create an array
                id existingValue = queryParams[item.name];
                queryParams[item.name] = @[existingValue, item.value];
            }
        }

    } else {
        for (NSString *param in [components.query componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            if ([elts lastObject] && [elts firstObject]) {
                [queryParams setValue:[elts lastObject] forKey:[elts firstObject]];
            }
        }
    }
    
//    if ([queryParams.allKeys containsObject:@"url"] && components.fragment) {
//        NSString *url = [queryParams valueForKey:@"url"];
//        NSString *urlWithFragment = [NSString stringWithFormat:@"%@#%@", url, components.fragment];
//        [queryParams setValue:urlWithFragment forKey:@"url"];
//    }
    
    self.queryParametres = [queryParams copy];
}


@end
