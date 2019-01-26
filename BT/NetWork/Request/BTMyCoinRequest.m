//
//  BTMyCoinRequest.m
//  BT
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTMyCoinRequest.h"

@implementation BTMyCoinRequest

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString*)requestUrl{
    return MyCoinUrl;
}

@end
