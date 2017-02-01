//
//  BFRouteService.h
//  BaiduFinance
//
//  Created by tcguo on 16/11/11.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString * const BFRouteServiceWebView_Url;
extern NSString * const BFRouteServiceWebView_Title;
extern NSString * const BFRouteServiceWebView_Fixed;

typedef NS_ENUM(NSUInteger, BFNativeViewType) {
    BFNativeViewTypeHome                    = 0,
    BFNativeViewTypeInvestHome,
    BFNativeViewTypeMyHome,
    BFNativeViewTypeInvestFund,
};

@protocol BFRouteService <NSObject>

- (void)jumpToWebViewWithUserInfo:(NSDictionary *)userInfo;

- (void)jumpToNativeView:(BFNativeViewType)viewType;

@end
