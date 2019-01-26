//
//  BTOnlineExchangeReq.m
//  BT
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTOnlineExchangeReq.h"

@implementation BTOnlineExchangeReq{
    NSString *_category;
    NSString *_keywords;
    NSInteger _index;
}

- (instancetype)initWithIndex:(NSInteger)index category:(NSString *)category keywords:(NSString *)keywords{
    if (self = [super init]) {
        _index = index;
        _category = category;
        _keywords = keywords;
    }
    return self;
}
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return  @"market/market-rest/list-online-exchange";
    
}

- (id)requestArgument{
    return @{@"index":@(_index),@"pageSize":@(30),@"category":SAFESTRING(_category),@"keywords":SAFESTRING(_keywords)};
}

@end
