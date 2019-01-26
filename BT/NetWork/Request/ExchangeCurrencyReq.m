//
//  ExchangeCurrencyReq.m
//  BT
//
//  Created by apple on 2018/5/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ExchangeCurrencyReq.h"

@implementation ExchangeCurrencyReq{
    NSString *_currencyCode;
    NSString* _exchangeCode;
    NSInteger _pageIndex;
    NSInteger _pageSize;
    NSInteger _sortType;
}

- (id)initWithCurrencyCode:(NSString *)currencyCode exchangeCode:(NSString*)exchangeCode pageIndex:(NSInteger)pageIndex sortType:(NSInteger)sortType{
    self = [super init];
    if (self) {
        _currencyCode = currencyCode;
        _exchangeCode =exchangeCode ;
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
    return @"market/market-rest/exchange-market-list-sort";
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"currencyCode":_currencyCode,@"exchangeCode":SAFESTRING(_exchangeCode),@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize),@"sortType":@(_sortType)};
    return [self bodyRequestWithDic:dic];
}


@end
