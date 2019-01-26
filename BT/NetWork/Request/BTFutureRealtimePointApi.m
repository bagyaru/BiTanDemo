//
//  BTFutureRealtimePointApi.m
//  BT
//
//  Created by apple on 2018/7/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTFutureRealtimePointApi.h"

@implementation BTFutureRealtimePointApi{
    NSString* _futureCode;
    NSArray *_kindList;
}

- (instancetype)initWithFutureCode:(NSString*)futureCode kindList:(NSArray *)kindList{
    self = [super init];
    if (self) {
        _futureCode = futureCode;
        _kindList = kindList;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return @"market/market-rest/futures-realtime-one-point";
}

- (id)requestArgument{
    return @{@"futureExchangeCode":SAFESTRING(_futureCode),@"kindList":[_kindList componentsJoinedByString:@","]};
}

@end
