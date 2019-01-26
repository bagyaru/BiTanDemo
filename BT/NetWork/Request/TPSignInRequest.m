//
//  TPSignInRequest.m
//  BT
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TPSignInRequest.h"

@implementation TPSignInRequest

- (NSString *)requestUrl {
    return TP_SIGN;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
