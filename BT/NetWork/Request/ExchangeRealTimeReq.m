//
//  ExchangeRealTimeReq.m
//  BT
//
//  Created by apple on 2018/5/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ExchangeRealTimeReq.h"

@implementation ExchangeRealTimeReq{
    NSString* _exchangeCode;
    NSArray *_kindList;
}

- (instancetype)initWithExchangeCode:(NSString *)exchangeCode kindList:(NSArray *)kindList{
    self = [super init];
    if (self) {
        _exchangeCode = exchangeCode;
        _kindList = kindList;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return @"market/market-rest/exchange-market-real-time";
}

- (id)requestArgument{
    return @{@"exchangeCode":SAFESTRING(_exchangeCode),@"kindList":[_kindList componentsJoinedByString:@","]};
}
@end
