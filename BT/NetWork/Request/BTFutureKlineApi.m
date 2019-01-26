//
//  BTFutureKlineApi.m
//  BT
//
//  Created by apple on 2018/7/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTFutureKlineApi.h"

@implementation BTFutureKlineApi{
    NSString *_kind;
    NSInteger _klineType;
    NSString *_futureExchangeCode;
}

- (instancetype)initWithKind:(NSString *)kind klineType:(NSInteger)klineType futureCode:(NSString*)futureExchangeCode{
    self = [super init];
    if (self) {
        _kind = kind;
        _klineType = klineType;
        _futureExchangeCode = futureExchangeCode;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return @"market/market-rest/futures-kline";
}

- (id)requestArgument{
    NSDictionary *d = @{@"kind":_kind,@"klineType":@(_klineType),@"futureExchangeCode":SAFESTRING(_futureExchangeCode)};
    return d;
}


@end
