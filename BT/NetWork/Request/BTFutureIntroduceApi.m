//
//  BTFutureIntroduceApi.m
//  BT
//
//  Created by apple on 2018/7/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTFutureIntroduceApi.h"

@implementation BTFutureIntroduceApi{
    NSString *_futureCode;
    NSString *_code;
}

- (instancetype)initWithFutureCode:(NSString *)futureCode code:(NSString *)code{
    if(self = [super init]){
        _futureCode = futureCode;
        _code = code;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"market/market-rest/futures-exchange-info";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    return @{@"futureExchangeCode":SAFESTRING(_futureCode),@"futureCode":SAFESTRING(_code)};
}

@end
