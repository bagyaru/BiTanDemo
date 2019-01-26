//
//  BTChangePasswordRequest.m
//  BT
//
//  Created by admin on 2018/7/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTChangePasswordRequest.h"

@implementation BTChangePasswordRequest{
    NSDictionary *_dict;
}

- (instancetype)initWithDict:(NSDictionary *)dict{
    if(self = [super init]){
        _dict = dict;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"oauth/oauth-rest/update-password";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return _dict;
}

@end
