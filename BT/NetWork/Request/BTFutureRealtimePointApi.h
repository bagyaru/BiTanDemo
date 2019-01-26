//
//  BTFutureRealtimePointApi.h
//  BT
//
//  Created by apple on 2018/7/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTFutureRealtimePointApi : BTBaseRequest

- (instancetype)initWithFutureCode:(NSString*)futureCode kindList:(NSArray *)kindList;

@end
