//
//  OneEntityVoObj.m
//  BT
//
//  Created by admin on 2018/3/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OneEntityVoObj.h"

@implementation OneEntityVoObj
+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"balance" : @"balance",
             @"countNumb" : @"count",
             @"earnings" : @"earnings",
             @"earningsPercent" : @"earningsPercent",
             @"kind" : @"kind",
             @"note" : @"note",
             @"realPrice" : @"realPrice",
             @"currencyCount" : @"currencyCount",
             @"exchange" : @"exchange",
             @"btcCount" : @"btcCount",
             @"priceCny" : @"priceCny",
             @"priceUsd" : @"priceUsd"
             };
}
@end
