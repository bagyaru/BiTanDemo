//
//  CurrencyListRequest.h
//  BT
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface CurrencyListRequest : BTBaseRequest

- (instancetype)initWithExchangeCode:(NSString *)exchangeCode;

@end
