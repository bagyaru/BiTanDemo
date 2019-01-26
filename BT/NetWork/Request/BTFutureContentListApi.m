//
//  BTFutureContentListApi.m
//  BT
//
//  Created by apple on 2018/7/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTFutureContentListApi.h"

@implementation BTFutureContentListApi{
    NSString *_code;
}

- (instancetype)initWithCode:(NSString *)code{
    if(self = [super init]){
        _code = code;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"market/market-rest/futures-exchange-market-info-list";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    return @{@"futureExchangeCode":SAFESTRING(_code)};
}
@end
