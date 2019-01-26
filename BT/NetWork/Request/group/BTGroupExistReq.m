//
//  BTGroupExistReq.m
//  BT
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTGroupExistReq.h"

@implementation BTGroupExistReq{
    NSString *_code;
    NSString *_exchangeCode;
}

- (instancetype)initWithCode:(NSString *)code exchangeCode:(NSString *)exchangeCode{
    if(self = [super init]){
        _exchangeCode = exchangeCode;
        _code = code;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return @"market/market-rest/find-user-extend-group-exist";
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"code":SAFESTRING(_code),@"exchangeCode":SAFESTRING(_exchangeCode)};
    return [self bodyRequestWithDic:dic];
}

@end
