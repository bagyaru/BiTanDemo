//
//  TPGetTPRequest.m
//  BT
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TPGetTPRequest.h"

@implementation TPGetTPRequest

- (NSString *)requestUrl {
    return TP_GETTP;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
