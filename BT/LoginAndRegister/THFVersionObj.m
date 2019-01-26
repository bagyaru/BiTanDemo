//
//  THFVersionObj.m
//  淘海房
//
//  Created by admin on 2017/8/18.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "THFVersionObj.h"

@implementation THFVersionObj
+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"buildVersion" : @"buildVersion",
             @"createdAt" : @"createdAt",
             @"descriptionStr" : @"description",
             @"device" : @"device",
             @"downloadUrl" : @"downloadUrl",
             @"forceUpdate" : @"forceUpdate",
             @"issueDate" : @"issueDate",
             @"releaseVersion" : @"releaseVersion"
             };
}
@end
