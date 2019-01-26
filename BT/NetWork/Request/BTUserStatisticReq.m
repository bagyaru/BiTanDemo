//
//  BTUserStatisticReq.m
//  BT
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTUserStatisticReq.h"

@implementation BTUserStatisticReq{
    NSInteger _userId;
    NSString *_userName;
}

- (instancetype)initWithUserId:(NSInteger)userId userName:(NSString *)userName{
    if(self = [super init]){
        _userId = userId;
        _userName = userName;
    }
    return self;
}

- (NSString *)requestUrl {
    return @"oauth/oauth-rest/userStatistic";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    NSDictionary *dic;
    if(_userId == 0){
        dic =  @{@"userName":SAFESTRING(_userName)};
    }else{
        dic =  @{@"userId":@(_userId),@"userName":SAFESTRING(_userName)};
    }
   
    return dic;
}

@end
