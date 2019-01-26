//
//  BTFutureIntroduceApi.h
//  BT
//
//  Created by apple on 2018/7/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTFutureIntroduceApi : BTBaseRequest

- (instancetype)initWithFutureCode:(NSString*)futureCode code:(NSString*)code;

@end
