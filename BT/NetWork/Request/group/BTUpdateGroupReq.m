//
//  BTUpdateGroupReq.m
//  BT
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTUpdateGroupReq.h"

@implementation BTUpdateGroupReq{
    NSString *_name;
    NSString * _newName;
}

- (instancetype)initWithGroupName:(NSString *)name newName:(NSString *)newName{
    if(self = [super init]){
        _name = name;
        _newName = newName;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return @"market/market-rest/update-user-group";
}

- (id)requestArgument{
    return @{@"groupName":SAFESTRING(_name),
             @"newGroupName":SAFESTRING(_newName)
             };
}

@end
