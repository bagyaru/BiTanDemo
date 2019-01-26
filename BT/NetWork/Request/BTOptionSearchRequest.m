//
//  BTOptionSearchRequest.m
//  BT
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTOptionSearchRequest.h"

@implementation BTOptionSearchRequest{
    
    NSString *_input;
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

- (instancetype)initWithInput:(NSString *)input pageIndex:(NSInteger)pageIndex{
    if(self = [super init]){
        _input = input;
        _pageIndex = pageIndex;
        _pageSize = BTPagesize;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"market/market-rest/search-user-group-info";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"input":_input,
                           @"pageIndex":@(_pageIndex),
                           @"pageSize":@(_pageSize)
                           };
    return [self bodyRequestWithDic:dic];
}


@end
