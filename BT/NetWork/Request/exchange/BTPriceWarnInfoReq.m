//
//  BTPriceWarnInfoReq.m
//  BT
//
//  Created by apple on 2018/5/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPriceWarnInfoReq.h"

@implementation BTPriceWarnInfoReq{
    NSString *_kind;
    NSString *_exCode;
}

- (instancetype)initWithKind:(NSString *)kind exchange:(NSString *)exCode{
    if(self = [super init]){
        _kind = kind;
        _exCode = exCode;
    }
    return self;
}
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
     return @"market/market-rest/price-warning-info";
}

- (id)requestArgument{
    return @{@"kind":SAFESTRING(_kind),
             @"exchangeCode":SAFESTRING(_exCode)
             };
}
@end
