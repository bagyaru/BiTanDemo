//
//  BTIsSignInRequest.m
//  BT
//
//  Created by apple on 2018/5/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTIsSignInRequest.h"

@implementation BTIsSignInRequest

- (NSString *)requestUrl {
    return TP_IsSignIn;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
