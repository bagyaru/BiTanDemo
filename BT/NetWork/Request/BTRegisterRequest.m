//
//  BTRegisterRequest.m
//  BT
//
//  Created by admin on 2018/7/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTRegisterRequest.h"

@implementation BTRegisterRequest{
    NSDictionary *_dict;
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        _dict = dict;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"oauth/oauth-rest/register";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =_dict ;
    return [self bodyRequestWithDic:dic];
}

@end
