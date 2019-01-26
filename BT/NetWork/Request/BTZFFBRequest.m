//
//  BTZFFBRequest.m
//  BT
//
//  Created by admin on 2018/6/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTZFFBRequest.h"

@implementation BTZFFBRequest
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return HOME_ZFFB;
}
@end
