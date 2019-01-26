//
//  BTSplashScreenModel.m
//  BT
//
//  Created by admin on 2018/6/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTSplashScreenModel.h"

@implementation BTSplashScreenModel
+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"offlineTime" : @"offlineTime",
             @"onlineTime" : @"onlineTime",
             @"pic1" : @"pic1",
             @"pic2" : @"pic2",
             @"pic3" : @"pic3",
             @"pic4" : @"pic4",
             @"redirectInfo" : @"redirectInfo",
             @"redirectType" : @"redirectType",
             @"showDuration" : @"showDuration",
             @"showInterval" : @"showInterval",
             @"splashId" : @"splashId",
             @"splashVersion" : @"splashVersion"
             };
}
@end
