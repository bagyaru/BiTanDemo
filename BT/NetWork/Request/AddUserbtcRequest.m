//
//  AddUserbtcRequest.m
//  BT
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AddUserbtcRequest.h"

@implementation AddUserbtcRequest{
    NSString *_currencyCode;
    NSString *_currencyCodeRelation;
}

- (id)initWithCurrencyCode:(NSString *)currencyCode currencyCodeRelation:(NSString *)currencyCodeRelation{
    self = [super init];
    if (self) {
        _currencyCode = currencyCode;
        _currencyCodeRelation = currencyCodeRelation;
    }
    return self;
}


- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (id)requestArgument{
    return @{@"currencyCode":_currencyCode,@"currencyCodeRelation":_currencyCodeRelation};
}

- (NSString *)requestUrl{
    return ADDUSERBTC_URL;
}

@end
