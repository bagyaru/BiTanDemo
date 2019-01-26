//
//  BTTPDetailReq.m
//  BT
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTTPDetailReq.h"

@implementation BTTPDetailReq{
    NSInteger _pageSize;
    NSInteger _pageIndex;
    NSInteger _type;
}

- (instancetype)initWithType:(NSInteger)type pageIndex:(NSInteger)pageIndex{
    if(self = [super init]){
        _pageSize    = BTPagesize;
        _pageIndex = pageIndex;
        _type = type;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"oauth/oauth-rest/new-coin-detail";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    NSDictionary *dic;
    dic =  @{@"pageSize":@(_pageSize),@"pageIndex":@(_pageIndex),@"type":@(_type)};
    return dic;
}


@end
