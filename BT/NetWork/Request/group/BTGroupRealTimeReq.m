//
//  BTGroupRealTimeReq.m
//  BT
//
//  Created by apple on 2018/5/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTGroupRealTimeReq.h"

@implementation BTGroupRealTimeReq{
    NSArray *_coinList;
}

- (instancetype)initWithExchangeCoinList:(NSArray *)arr{
    if(self = [super init]){
        _coinList = arr;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return @"market/market-rest/exchange-kind-real-time";
}

- (id)requestArgument{
    return @{@"exchangeKindList":[_coinList componentsJoinedByString:@","]};
}

@end
