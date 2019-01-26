//
//  BTCandyListHotApi.m
//  BT
//
//  Created by apple on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTCandyListHotApi.h"

@implementation BTCandyListHotApi

- (NSString *)requestUrl {
    return @"knowledge/info/listHots";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"currentPage":@(1),@"pageSize":@(6),@"type":@(7)};
    return [self bodyRequestWithDic:dic];
}
@end
