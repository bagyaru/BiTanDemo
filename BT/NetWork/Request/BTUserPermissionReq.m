//
//  BTUserPermissionReq.m
//  BT
//
//  Created by apple on 2018/10/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTUserPermissionReq.h"

@implementation BTUserPermissionReq

- (NSString *)requestUrl {
    return @"oauth/oauth-rest/userPermission";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
