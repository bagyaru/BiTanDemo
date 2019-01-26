//
//  BTListLikedApi.m
//  BT
//
//  Created by apple on 2018/10/22.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTListLikedApi.h"

@implementation BTListLikedApi{
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
    return @"oauth/oauth-rest/listLiked";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic;
    dic =  @{@"pageSize":@(_pageSize),@"pageIndex":@(_currentPage),@"userId":@(_userId)};
    return [self bodyRequestWithDic:dic];
}


@end
