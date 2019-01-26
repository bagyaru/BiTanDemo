//
//  NewsModel.m
//  BT
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"oid":@"id"};
}

@end
