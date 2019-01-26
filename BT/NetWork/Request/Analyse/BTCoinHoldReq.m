//
//  BTCoinHoldReq.m
//  BT
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTCoinHoldReq.h"

@implementation BTCoinHoldReq{
    NSString *_kindCode;
}

- (instancetype)initWithKindCode:(NSString *)kindCode{
    if(self = [super init]){
        _kindCode = kindCode;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return @"market/market-rest/currency-analyze-address";
}

- (id)requestArgument{
    NSString *kind;
    if([SAFESTRING(_kindCode) containsString:@"/"]){
        kind = [[SAFESTRING(_kindCode) componentsSeparatedByString:@"/"] firstObject];
    }else{
        kind = SAFESTRING(_kindCode);
    }
    return @{@"currencyCode":SAFESTRING(kind)};
}



@end
