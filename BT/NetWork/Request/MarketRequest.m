//
//  MarketRequest.m
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MarketRequest.h"

@implementation MarketRequest{
    NSString *_currencyCode;
    NSInteger _marketType;
    NSInteger _pageIndex;
    NSInteger _pageSize;
    NSInteger _sortType;
}

- (instancetype)initWithCurrencyCode:(NSString *)currencyCode marketType:(NSInteger)marketType pageIndex:(NSInteger)pageIndex sortType:(NSInteger)sortType{
    self = [super init];
    if (self) {
        _currencyCode = currencyCode;
        _marketType = marketType;
        _pageIndex = pageIndex;
        _pageSize = BTPagesize;
        _sortType = sortType;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return MARKET_URL;
}


- (NSURLRequest *)buildCustomUrlRequest{
    //@"currencyCode":_currencyCode,
    NSDictionary *dic =  @{@"marketType":@(_marketType),@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize),@"sortType":@(_sortType)};
    return [self bodyRequestWithDic:dic];
}


@end
