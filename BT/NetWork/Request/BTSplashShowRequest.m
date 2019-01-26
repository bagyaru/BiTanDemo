//
//  BTSplashShowRequest.m
//  BT
//
//  Created by admin on 2018/6/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTSplashShowRequest.h"

@implementation BTSplashShowRequest
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return SPLASH_SHOW;
}
@end
