//
//  CommentDetailObj.m
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CommentDetailObj.h"

@implementation CommentDetailObj
+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"commentId" : @"commentId",
             @"content" : @"content",
             @"createTime" : @"createTime",
             @"refId" : @"refId",
             @"userAvatar" : @"userAvatar",
             @"userId" : @"userId",
             @"userName" : @"userName"
             };
}
@end
