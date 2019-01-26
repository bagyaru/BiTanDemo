//
//  MarketRealtimeRequest.m
//  BT
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MarketRealtimeRequest.h"

@implementation MarketRealtimeRequest{
    NSInteger _marketType;
    NSArray *_kindList;
}

- (instancetype)initWithMarketType:(NSInteger)marketType kindList:(NSArray *)kindList{
    self = [super init];
    if (self) {
        _marketType = marketType;
        _kindList = kindList;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return MARKEY_REALTIME_URL;
}

- (id)requestArgument{
    return @{@"marketType":@(_marketType),@"kindList":[_kindList componentsJoinedByString:@","]};
}

@end
