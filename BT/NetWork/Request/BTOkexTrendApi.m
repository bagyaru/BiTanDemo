//
//  BTOkexTrendApi.m
//  BT
//
//  Created by apple on 2018/7/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTOkexTrendApi.h"

@implementation BTOkexTrendApi{
    NSString *_code;
    NSInteger _type;
}

- (instancetype)initWithCode:(NSString *)code type:(NSInteger)type{
    if(self = [super init]){
        _code = code;
        _type = type;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"market/market-rest/futures-okex-trend-indicator";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    return @{@"futureCode":SAFESTRING(_code),@"timeRange":@(_type)};
}

@end
