//
//  BTValidateSplashVersionRequest.m
//  BT
//
//  Created by admin on 2018/6/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTValidateSplashVersionRequest.h"

@implementation BTValidateSplashVersionRequest{
    
    NSInteger _splashVersion;
    NSInteger _splashId;
}

-(instancetype)initWithSplashVersion:(NSInteger)splashVersion splashId:(NSInteger)splashId {
    
    self = [super init];
    if (self) {
        _splashVersion = splashVersion;
        _splashId      = splashId;
    }
    return self;
}
- (NSString *)requestUrl {
    return VALIDATE_SPLASHVERSION;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    return @{
             @"splashVersion":@(_splashVersion),
             @"splashId":@(_splashId)
             };
}


@end
