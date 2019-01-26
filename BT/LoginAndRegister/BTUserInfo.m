//
//  BTUserInfo.m
//  BT
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTUserInfo.h"

@implementation BTUserInfo
+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"userId" : @"userId",
             @"username" : @"userName",
             @"mobile" : @"mobile",
             @"userAvatar" : @"userAvatar",
             @"userRole" : @"userRole",
             @"token" : @"token",
             @"userHavePassword" : @"userHavePassword"
             };
}
@end
