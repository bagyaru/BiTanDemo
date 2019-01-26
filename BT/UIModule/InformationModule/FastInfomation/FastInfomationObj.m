//
//  FastInfomationObj.m
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FastInfomationObj.h"

@implementation FastInfomationObj
+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"content" : @"content",
             @"source" : @"source",
             @"imgUrl" : @"imgUrl",
             @"title" : @"title",
             @"createdAt" : @"createdAt",
             @"updatedAt" : @"updatedAt",
             @"issueDate" : @"issueDate",
             @"timeFormat" : @"timeFormat",
             @"viewCount" : @"viewCount",
             @"type" : @"type",
             @"infoID" : @"id",
             @"keywords" : @"keywords"
             };
}
@end
