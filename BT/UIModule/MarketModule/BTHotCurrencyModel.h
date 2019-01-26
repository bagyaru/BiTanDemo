//
//  BTHotCurrencyModel.h
//  BT
//
//  Created by admin on 2018/6/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTHotCurrencyModel : BTBaseObject
@property (nonatomic, assign) double     increaseRate;//热度增长率，每周
@property (nonatomic, copy)   NSString * currencyCode;//币种编码
@property (nonatomic, assign) NSInteger  hotPower;//热度值
@end
