//
//  BTRealTimeSeachRequest.m
//  BT
//
//  Created by admin on 2018/5/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTRealTimeSeachRequest.h"

@implementation BTRealTimeSeachRequest{
    
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
    return REAL_TIME_SEACH;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
- (id)requestArgument {
    return @{
             @"SearchDTO":@{@"input":_input,
                            @"pageIndex":@(_pageIndex),
                            @"pageSize":@(_pageSize)
                            }
             };
}
- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"input":_input,
                           @"pageIndex":@(_pageIndex),
                           @"pageSize":@(_pageSize)
                           };
    return [self bodyRequestWithDic:dic];
}

@end
