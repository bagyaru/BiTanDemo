//
//  BTGroupRankReq.m
//  BT
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTGroupRankReq.h"

@implementation BTGroupRankReq{
    NSArray *_arr;
}

- (instancetype)initWithData:(NSArray *)arr{
    if(self = [super init]){
        _arr = arr;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"market/market-rest/update-user-group-rank";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"userGroupVOList":_arr};
    
    return [self bodyRequestWithDic:dic];
}


@end
