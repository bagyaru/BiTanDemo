//
//  QueryUserBtcRequest.m
//  BT
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QueryUserBtcRequest.h"

@implementation QueryUserBtcRequest


- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return QUERYUSERBTC_URL;
}

@end
