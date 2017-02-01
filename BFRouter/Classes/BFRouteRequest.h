//
//  BFRouteRequest.h
//  BaiduFinance
//
//  Created by tcguo on 16/11/10.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BFRouteRequest : NSObject

@property (nonatomic, strong, readonly) NSURL *URL;
@property (nonatomic, copy, readonly) NSArray *pathComponents;
@property (nonatomic, copy, readonly) NSDictionary *queryParametres;

- (instancetype)initWithURL:(NSURL *)URL;

@end
