//
//  ExchangeListRequest.m
//  BT
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ExchangeListRequest.h"

@implementation ExchangeListRequest

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return  @"market/market-rest/list-online-exchange";
   
}

- (id)requestArgument{
    return @{@"index":@(0),
             @"pageSize":@(10)
             };
}

@end
