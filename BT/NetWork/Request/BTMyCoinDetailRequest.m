//
//  BTMyCoinDetailRequest.m
//  BT
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTMyCoinDetailRequest.h"


@implementation BTMyCoinDetailRequest{
    NSInteger _currentPage;
    NSInteger _pageSize;
}

- (instancetype)initWithCurrentPage:(NSInteger)currentPage pageSize:(NSInteger)pageSize{
    if(self =[super init]){
        _currentPage =currentPage;
        _pageSize = pageSize;
    }
    return self;
}
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString*)requestUrl{
    return MyCoinDetailUrl;
}
- (id)requestArgument{
    NSDictionary *dic = @{@"pageIndex":@(_currentPage),@"pageSize":@(_pageSize)};
    return dic;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic = @{@"pageIndex":@(_currentPage),@"pageSize":@(_pageSize)};
    return  [self bodyRequestWithDic:dic];
}

@end
