//
//  IntrodueceRequest.m
//  BT
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "IntrodueceRequest.h"

@implementation IntrodueceRequest{
    NSString *_currencySimpleName;
}

- (instancetype)initWithCurrencySimpleName:(NSString *)currencySimpleName{
    self = [super init];
    if (self) {
        _currencySimpleName = currencySimpleName;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return INTRODUCE_URL;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic = @{@"currencySimpleName":_currencySimpleName};
    return [self bodyRequestWithDic:dic];
}

@end
