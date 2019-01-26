//
//  XianHuoMainObj.m
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "XianHuoMainObj.h"

@implementation XianHuoMainObj
+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"chineseName" : @"chineseName",
             @"englishName" : @"englishName",
             @"countryName" : @"countryName",
             @"exchangeAbstract" : @"exchangeAbstract",
             @"exchangeId" : @"exchangeId",
             @"exchangeName" : @"exchangeName",
             @"exchangeCode" : @"exchangeCode",
             @"exchangeWebsiteAddress" : @"exchangeWebsiteAddress",
             @"ranking" : @"ranking",
             @"tradePairAmount" : @"tradePairAmount",
             @"createTime" : @"createTime",
             @"volume" : @"volume",
             @"turnoverCNY" : @"turnoverCNY",
             @"turnoverUSD" : @"turnoverUSD"
             };
}
@end
