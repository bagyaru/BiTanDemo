//
//  BTHoldingCountApi.m
//  BT
//
//  Created by apple on 2018/7/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTHoldingCountApi.h"

@implementation BTHoldingCountApi{
    NSString *_code;
}

- (instancetype)initWithCode:(NSString *)code{
    if(self = [super init]){
        _code = code;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"market/market-rest/futures-okex-tp-ranklist";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    return @{@"futureCode":SAFESTRING(_code)};
}

@end
