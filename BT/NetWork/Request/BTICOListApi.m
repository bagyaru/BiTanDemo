//
//  BTICOListApi.m
//  BT
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTICOListApi.h"

@implementation BTICOListApi{
    NSInteger _type;
    NSInteger _pageIndex;
}

- (instancetype)initWithType:(NSInteger)type pageIndex:(NSInteger)pageIndex{
    if(self = [super init]){
        _type = type;
        _pageIndex = pageIndex;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"market/market-rest/select-ico-list";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    return @{@"type":@(_type),@"pageIndex":@(_pageIndex),@"pageSize":@(BTPagesize)};
}


@end
