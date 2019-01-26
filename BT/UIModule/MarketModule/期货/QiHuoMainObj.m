//
//  QiHuoMainObj.m
//  BT
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QiHuoMainObj.h"

@implementation QiHuoMainObj
+ (NSDictionary *)propertyAndKeyMap
{
    return @{
             @"bailRate" : @"bailRate",
             @"balance" : @"balance",
             @"contractCode" : @"contractCode",
             @"contractName" : @"contractName",
             @"contractUnit" : @"contractUnit",
             @"futuresId" : @"futuresId",
             @"language" : @"language",
             @"lastTradeDate" : @"lastTradeDate",
             @"listingContract" : @"listingContract",
             @"positionLimit" : @"positionLimit",
             @"productCode" : @"productCode",
             @"quotePrice" : @"quotePrice",
             @"suspendTrade" : @"suspendTrade",
             @"tradeDate" : @"tradeDate",
             @"tradeThreshold" : @"tradeThreshold",
             @"twistingMin" : @"twistingMin"
             };
}
@end
