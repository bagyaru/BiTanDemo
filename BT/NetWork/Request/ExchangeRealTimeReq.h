//
//  ExchangeRealTimeReq.h
//  BT
//
//  Created by apple on 2018/5/6.
//  Copyright © 2018年 apple. All rights reserved.
//

//实时行情数据
#import "BTBaseRequest.h"

@interface ExchangeRealTimeReq : BTBaseRequest

- (instancetype)initWithExchangeCode:(NSString*)exchangeCode kindList:(NSArray *)kindList;

@end
