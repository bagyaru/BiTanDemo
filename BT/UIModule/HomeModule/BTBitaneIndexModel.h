//
//  BTBitaneIndexModel.h
//  BT
//
//  Created by admin on 2018/6/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"
typedef NS_ENUM(NSInteger,BTBitaneIndexUpAndDownType) {
    BTBitaneIndexUpAndDownTypeNoUpAndDown = 0,
    BTBitaneIndexUpAndDownTypeUp = 1,
    BTBitaneIndexUpAndDownTypeDown = 2,
};
@interface BTBitaneIndexModel : BTBaseObject

@property (nonatomic, strong) NSString *code;//code值

@property (nonatomic, strong) NSString *exchangeCode;//exchangeCode

@property (nonatomic, strong) NSString *name;//名称

@property (nonatomic, strong) NSString *englishname;//名称(英文)

@property (nonatomic, assign) double increaseRateIndex;//价格增长率指数

@property (nonatomic, assign) double priceCNIndex;//人民币价格指数

@property (nonatomic, assign) double priceUSIndex;//美元价格指数

@property (nonatomic, assign) BTBitaneIndexUpAndDownType type;

@property (nonatomic, strong) NSMutableArray *indexDetailListArray;
@end
