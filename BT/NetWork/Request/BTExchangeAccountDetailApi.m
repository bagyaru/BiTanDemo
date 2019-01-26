//
//  BTExchangeAccountDetailApi.m
//  BT
//
//  Created by apple on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTExchangeAccountDetailApi.h"

@implementation BTExchangeAccountDetailApi{
    NSArray *_data;
}

- (instancetype)initWithAccountData:(NSArray *)data{
    if(self = [super init]){
        _data = data;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return @"market/market-rest/user-exchange-account-v2";
}

- (NSURLRequest *)buildCustomUrlRequest{
    return  [self bodyRequestWithDic:_data];
}

@end
