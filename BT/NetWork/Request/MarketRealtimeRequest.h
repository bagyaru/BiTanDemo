//
//  MarketRealtimeRequest.h
//  BT
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface MarketRealtimeRequest : BTBaseRequest

- (instancetype)initWithMarketType:(NSInteger)marketType kindList:(NSArray *)kindList;


@end
