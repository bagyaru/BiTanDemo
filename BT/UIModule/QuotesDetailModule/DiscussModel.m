//
//  DiscussModel.m
//  BT
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DiscussModel.h"

@implementation DiscussModel

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    NSNumber *timestamp = dic[@"createTime"];
    if (![timestamp isKindOfClass:[NSNumber class]]) return NO;
    _createTime = [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue / 1000.0];
    return YES;
}

@end
