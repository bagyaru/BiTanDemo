//
//  CurrencyListRequest.m
//  BT
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CurrencyListRequest.h"

@implementation CurrencyListRequest{
    NSString *_exchangeCode;
}

- (instancetype)initWithExchangeCode:(NSString *)exchangeCode{
    if(self = [super init]){
        _exchangeCode = exchangeCode;
    }
    return  self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return CURRENCY_LIST_URL;
}

- (id)requestArgument{
    return @{@"exchangeCode":SAFESTRING(_exchangeCode)};
}

@end
