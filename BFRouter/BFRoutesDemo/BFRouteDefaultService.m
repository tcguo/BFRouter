//
//  BFRouteDefaultService.m
//  BaiduFinance
//
//  Created by tcguo on 16/11/11.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "BFRouteDefaultService.h"
#import "AppDelegate.h"
//#import "UIViewController+BFWebContainer.h"
//#import "BFInvestHomeViewController.h"
#import "NSDictionary+KVC.h"

NSString * const BFRouteServiceWebView_Url = @"BFRouteServiceWebView_Url";
NSString * const BFRouteServiceWebView_Title = @"BFRouteServiceWebView_Title";
NSString * const BFRouteServiceWebView_Fixed = @"BFRouteServiceWebView_Fixed";

@interface BFRouteDefaultService ()

@property (nonatomic, weak) AppDelegate *appDelegate;

@end

@implementation BFRouteDefaultService

- (id)init {
    if ((self = [super init])) {
        _appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    }
    return self;
}

- (void)jumpToWebViewWithUserInfo:(NSDictionary *)userInfo {
    NSParameterAssert(userInfo);
    
    NSString *title = [userInfo stringValueForKeySafely:BFRouteServiceWebView_Title];
    NSString *url = [userInfo stringValueForKeySafely:BFRouteServiceWebView_Url];
    BOOL titleIsFixed = [[userInfo objectForKeySafely:BFRouteServiceWebView_Fixed] boolValue];
    if (url) {
    }
}

- (void)jumpToNativeView:(BFNativeViewType)viewType {
    switch (viewType) {
        case BFNativeViewTypeHome:
        case BFNativeViewTypeMyHome:
        {
        }
            break;
        case BFNativeViewTypeInvestHome:
        {
            
        }
            break;
        case BFNativeViewTypeInvestFund:
        {
           
        }
            break;
            
        default:
            break;
    }
}

@end
