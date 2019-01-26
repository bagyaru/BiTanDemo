//
//  MarketRequest.h
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface MarketRequest : BTBaseRequest

- (instancetype)initWithCurrencyCode:(NSString *)currencyCode marketType:(NSInteger)marketType pageIndex:(NSInteger)pageIndex sortType:(NSInteger)sortType;

@end
