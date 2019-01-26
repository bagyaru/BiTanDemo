//
//  BTRepliedListRequest.m
//  BT
//
//  Created by admin on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTRepliedListRequest.h"

@implementation BTRepliedListRequest{
    NSInteger _pageSize;
    NSInteger _currentPage;
}

- (id)initWithPageIndex:(NSInteger)pageIndex{
    self = [super init];
    if (self) {
        
        _pageSize = BTPagesize;
        _currentPage = pageIndex;
    }
    return self;
}
- (NSString *)requestUrl {
    return RepliedListUrl;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"pageSize":@(_pageSize),@"pageIndex":@(_currentPage)};
    return [self bodyRequestWithDic:dic];
}

- (id)requestArgument {
    return @{
             @"commentListRequest":@{@"pageSize":@(_pageSize),@"pageIndex":@(_currentPage)}
             };
}

@end
