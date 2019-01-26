//
//  TimerRequest.m
//  BT
//
//  Created by apple on 2018/1/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TimerRequest.h"

@implementation TimerRequest


- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return TIMER_URL;
}


@end
