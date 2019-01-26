//
//  BTAddPostRequest.m
//  BT
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTAddPostRequest.h"

@implementation BTAddPostRequest{
NSDictionary *_dict;
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        _dict = dict;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"knowledge/posts/add";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic = _dict ;
    return [self bodyRequestWithDic:dic];
}

@end
