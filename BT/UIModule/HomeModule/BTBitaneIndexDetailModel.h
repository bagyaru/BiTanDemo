//
//  BTBitaneIndexDetailModel.h
//  BT
//
//  Created by admin on 2018/6/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTBitaneIndexDetailModel : BTBaseObject

@property (nonatomic, strong) NSString *code;//code值

@property (nonatomic, strong) NSString *exchangeCode;//交易所code

@property (nonatomic, strong) NSString *exchangeName;//交易所名字

@property (nonatomic, assign) double increaseRate;//价格增长率

@property (nonatomic, assign) double priceCN;//人民币价格

@property (nonatomic, assign) double priceUS;//美元价格

@property (nonatomic, assign) double volume;//量

@property (nonatomic, assign) double weight;//权重
@end
