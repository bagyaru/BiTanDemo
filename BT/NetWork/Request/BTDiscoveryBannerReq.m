//
//  BTDiscoveryBannerReq.m
//  BT
//
//  Created by apple on 2018/4/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTDiscoveryBannerReq.h"

@implementation BTDiscoveryBannerReq{
    NSInteger _poisition;
}

- (instancetype)initWithType:(NSInteger)type{
    if(self =[super init]){
        _poisition = type;
    }
    return self;
}
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString*)requestUrl{
    return DISCOVERSY_BANNER_URL;
}

- (id)requestArgument{
    return @{@"position":@(_poisition)};
}
@end
