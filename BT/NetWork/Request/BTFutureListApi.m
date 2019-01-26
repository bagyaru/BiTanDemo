//
//  BTFutureListApi.m
//  BT
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTFutureListApi.h"

@implementation BTFutureListApi

- (NSString *)requestUrl {
    return @"market/market-rest/show-futures-exchange-list";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
