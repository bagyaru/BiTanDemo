//
//  BTDeleteGroupRequest.m
//  BT
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTDeleteGroupRequest.h"

@implementation BTDeleteGroupRequest{
    NSInteger _mID;
}

- (instancetype)initWithGroupId:(NSInteger)Id{
    if(self = [super init]){
        _mID = Id;
    }
    return self;
    
    
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return @"market/market-rest/del-user-group";
}

- (id)requestArgument{
    return @{@"groupId":@(_mID)};
}


@end
