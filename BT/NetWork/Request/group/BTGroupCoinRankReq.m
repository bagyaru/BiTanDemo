//
//  BTGroupCoinRankReq.m
//  BT
//
//  Created by apple on 2018/5/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTGroupCoinRankReq.h"

@implementation BTGroupCoinRankReq{
    NSArray *_arr;
}

- (instancetype)initWithData:(NSArray *)arr{
    if(self = [super init]){
        _arr = arr;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"market/market-rest/update-user-extend-group-rank";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"userExtendGroupVOList":_arr};
    return [self bodyRequestWithDic:dic];
}

@end
