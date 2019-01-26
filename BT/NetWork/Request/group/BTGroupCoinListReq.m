//
//  BTGroupCoinListReq.m
//  BT
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTGroupCoinListReq.h"

@implementation BTGroupCoinListReq{
    NSString * _groupName;
}

- (instancetype)initWithGroupName:(NSString *)name{
    if(self = [super init]){
        _groupName = name;
    }
    return self;
}


- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return @"market/market-rest/user-extend-group-list";
}

- (id)requestArgument{
    return @{@"groupName":SAFESTRING(_groupName)};
}


///market-rest/user-extend-group-list

@end
