//
//  BTUserExchangeAccountApi.m
//  BT
//
//  Created by apple on 2018/5/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTUserExchangeAccountApi.h"

@implementation BTUserExchangeAccountApi{
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
    return USER_EXCHANGE_ACCOUNT;
}

- (NSURLRequest *)buildCustomUrlRequest{
    return  [self bodyRequestWithDic:_data];
}

@end
