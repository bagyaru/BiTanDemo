//
//  BTSignInDetailRequest.m
//  BT
//
//  Created by apple on 2018/5/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTSignInDetailRequest.h"

@implementation BTSignInDetailRequest

- (NSString *)requestUrl {
    return TP_SignInDetail;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
