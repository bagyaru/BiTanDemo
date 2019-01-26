//
//  BTAddGroupRequest.m
//  BT
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTAddGroupRequest.h"

@implementation BTAddGroupRequest{
    NSString * _groupName;
}

- (instancetype)initWithGroupName:(NSString *)name{
    if(self = [super init]){
        _groupName = name;
    }
    return self;
}


- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return @"market/market-rest/save-user-group";
}

- (id)requestArgument{
    return @{@"groupName":SAFESTRING(_groupName)};
}



@end
