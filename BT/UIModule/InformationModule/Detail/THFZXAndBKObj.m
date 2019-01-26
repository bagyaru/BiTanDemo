//
//  THFZXAndBKObj.m
//  BT
//
//  Created by admin on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "THFZXAndBKObj.h"

@implementation THFZXAndBKObj
+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"content" : @"content",
             @"source" : @"source",
             @"imgUrl" : @"imgUrl",
             @"title" : @"title",
             @"createdAt" : @"createdAt",
             @"updatedAt" : @"updatedAt",
             @"timeFormat" : @"timeFormat",
             @"viewCount" : @"viewCount",
             @"infoID" : @"id",
             @"keywords" : @"keywords",
             @"bad" : @"bad",
             @"good" : @"good",
             @"likeStatus" : @"likeStatus"
             };
}
@end
