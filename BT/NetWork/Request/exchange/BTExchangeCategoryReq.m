//
//  BTExchangeCategoryReq.m
//  BT
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTExchangeCategoryReq.h"

@implementation BTExchangeCategoryReq

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return  @"market/market-rest/listExchangeCategory";
}

@end
