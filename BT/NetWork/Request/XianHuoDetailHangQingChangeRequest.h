//
//  XianHuoDetailHangQingChangeRequest.h
//  BT
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface XianHuoDetailHangQingChangeRequest : BTBaseRequest
- (instancetype)initWithMarketType:(NSString *)exchangeCode kindList:(NSArray *)kindList;
@end
