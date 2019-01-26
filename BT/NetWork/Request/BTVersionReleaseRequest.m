//
//  BTVersionReleaseRequest.m
//  BT
//
//  Created by admin on 2018/1/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTVersionReleaseRequest.h"

@implementation BTVersionReleaseRequest{
    
    NSString *_appVersion;
    NSString *_device;
}
-(id)initWithBTVersionReleaseRequest {
    
    self = [super init];
    if (self) {
        
        _appVersion = VersionNumber;
        _device     = @"4";
    }
    return self;
}
- (NSString *)requestUrl {
    return VersionReleaseUrl;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodGET;
}
- (id)requestArgument {
    return @{
             @"appVersion": _appVersion,
             @"device": _device
             };
}
@end
