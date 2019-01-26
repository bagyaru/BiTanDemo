//
//  BTUserFollowListReq.m
//  BT
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTUserFollowListReq.h"

@implementation BTUserFollowListReq{
    NSInteger _pageSize;
    NSInteger _currentPage;
    NSInteger _userId;
}

- (instancetype)initWithUserId:(NSInteger)userId CurrentPage:(NSInteger)currentPage{
    if(self = [super init]){
        _pageSize    = BTPagesize;
        _currentPage = currentPage;
        _userId = userId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"oauth/oauth-rest/userFollowList";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic;
    dic =  @{@"pageSize":@(_pageSize),@"pageIndex":@(_currentPage),@"userId":@(_userId),@"refUserName": @""};
    return [self bodyRequestWithDic:dic];
}


@end
