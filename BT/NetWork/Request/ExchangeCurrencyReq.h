//
//  ExchangeCurrencyReq.h
//  BT
//
//  Created by apple on 2018/5/6.
//  Copyright © 2018年 apple. All rights reserved.
//

//交易所行情数据
#import "BTBaseRequest.h"

@interface ExchangeCurrencyReq : BTBaseRequest

- (id)initWithCurrencyCode:(NSString *)currencyCode exchangeCode:(NSString*)exchangeCode pageIndex:(NSInteger)pageIndex sortType:(NSInteger)sortType;


@end
