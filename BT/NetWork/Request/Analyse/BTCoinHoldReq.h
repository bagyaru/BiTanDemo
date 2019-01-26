//
//  BTCoinHoldReq.h
//  BT
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 apple. All rights reserved.
//

//币分析持币情况
#import "BTBaseRequest.h"

@interface BTCoinHoldReq : BTBaseRequest

- (instancetype)initWithKindCode:(NSString*)kindCode;

@end
