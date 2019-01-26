//
//  BTColleageListReq.m
//  BT
//
//  Created by apple on 2018/11/27.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTColleageListReq.h"

@implementation BTColleageListReq

- (NSString *)requestUrl {
    return @"knowledge/info/guide-type-list";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
