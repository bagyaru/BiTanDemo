//
//  CurrencyRequest.h
//  BT
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface CurrencyRequest : BTBaseRequest

- (id)initWithCurrencyCode:(NSString *)currencyCode marketType:(NSInteger)marketType pageIndex:(NSInteger)pageIndex sortType:(NSInteger)sortType;

@end
