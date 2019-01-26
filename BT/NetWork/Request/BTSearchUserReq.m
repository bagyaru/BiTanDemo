//
//  BTSearchUserReq.m
//  BT
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTSearchUserReq.h"

@implementation BTSearchUserReq{
    NSString  *_name;
    NSInteger _currentPage;
    NSInteger _pageSize;
}

- (instancetype)initWithUserName:(NSString *)name currentPage:(NSInteger)currentPage{
    if(self = [super init]){
        _name = name;
        _currentPage = currentPage;
        _pageSize    = BTPagesize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"oauth/oauth-rest/queryByUserName";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    NSDictionary *dic;
    dic =  @{@"pageSize":@(_pageSize),@"pageIndex":@(_currentPage),@"userName":SAFESTRING(_name)};
    return dic;
}

@end
