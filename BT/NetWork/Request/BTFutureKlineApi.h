//
//  BTFutureKlineApi.h
//  BT
//
//  Created by apple on 2018/7/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTFutureKlineApi : BTBaseRequest

- (instancetype)initWithKind:(NSString *)kind klineType:(NSInteger)klineType futureCode:(NSString*)futureExchangeCode;

@end
