
//
//  BTBatchFollowRequest.m
//  BT
//
//  Created by admin on 2018/11/28.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTBatchFollowRequest.h"

@implementation BTBatchFollowRequest{
    NSDictionary *_dict;
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        _dict = dict;
    }
    return self;
}

- (NSString *)requestUrl {//批量关注/取消关注
    return @"oauth/oauth-rest/batchFollow";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic = _dict ;
    return [self bodyRequestWithDic:dic];
}


@end
