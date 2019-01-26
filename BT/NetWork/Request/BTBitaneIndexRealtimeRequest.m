//
//  BTBitaneIndexRealtimeRequest.m
//  BT
//
//  Created by admin on 2018/6/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBitaneIndexRealtimeRequest.h"

@implementation BTBitaneIndexRealtimeRequest
{
    NSArray *_kindList;
}

- (instancetype)initWithKindList:(NSArray *)kindList{
    self = [super init];
    if (self) {
        _kindList = kindList;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return HOME_HEADDATA;
}

- (id)requestArgument{
    return @{@"kindList":[_kindList componentsJoinedByString:@","]};
}
@end
