//
//  BTVolumnRatioApi.m
//  BT
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTVolumnRatioApi.h"

@implementation BTVolumnRatioApi{
    NSString *_code;
    NSInteger _type;
    NSString *_exchangeCode;
}

- (instancetype)initWithCode:(NSString *)code exchangeCode:(NSString *)exchangeCode isFuture:(NSInteger)type{
    if(self = [super init]){
        _code = code;
        _type = type;
        _exchangeCode = exchangeCode;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"market/market-rest/volume-ratio";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    return @{@"kind":SAFESTRING(_code),@"futureExchangeType":@(_type),@"exchangeCode":SAFESTRING(_exchangeCode)};
}


@end
