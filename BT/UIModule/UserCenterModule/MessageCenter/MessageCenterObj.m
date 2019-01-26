//
//  MessageCenterObj.m
//  BT
//
//  Created by admin on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MessageCenterObj.h"

@implementation MessageCenterObj
+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"content" : @"content",
             @"messageCode" : @"messageCode",
             @"refId" : @"refId",
             @"title" : @"title",
             @"createdAt" : @"createdAt"
             };
}
@end
