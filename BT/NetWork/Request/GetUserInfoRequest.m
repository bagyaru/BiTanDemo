//
//  GetUserInfoRequest.m
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "GetUserInfoRequest.h"

@implementation GetUserInfoRequest
-(id)initWithUserInfo {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (NSString *)requestUrl {
    return UserInfoUrl;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodGET;
}
@end
