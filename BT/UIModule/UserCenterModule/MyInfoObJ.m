//
//  MyInfoObJ.m
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyInfoObJ.h"

@implementation MyInfoObJ
+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"userId" : @"userId",
             @"username" : @"userName",
             @"mobile" : @"mobile",
             @"userAvatar" : @"userAvatar",
             @"userRole" : @"userRole",
             @"token" : @"token",
             @"userHavePassword" : @"userHavePassword",
             @"balance" : @"balance",
             @"earnings" : @"earnings"
             };
}
@end
