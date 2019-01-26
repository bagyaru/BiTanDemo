//
//  KLineRequest.h
//  BT
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface KLineRequest : BTBaseRequest

//- (instancetype)initWithKind:(NSString *)kind klineType:(NSInteger)klineType;

- (instancetype)initWithKind:(NSString *)kind klineType:(NSInteger)klineType exchangeCode:(NSString*)exchangeCode;

@end
