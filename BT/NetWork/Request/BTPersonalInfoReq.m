//
//  BTPersonalInfoReq.m
//  BT
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPersonalInfoReq.h"

@implementation BTPersonalInfoReq{
    NSInteger _userId;
}

- (instancetype)initWithUserId:(NSInteger)userId{
    if(self = [super init]){
        _userId = userId;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"oauth/oauth-rest/user-info";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    NSDictionary *dic;
    dic =  @{@"userId":@(_userId)};
    return dic;
}

@end
