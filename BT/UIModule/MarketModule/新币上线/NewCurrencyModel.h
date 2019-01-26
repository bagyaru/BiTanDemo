//
//  NewCurrencyModel.h
//  BT
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"
typedef NS_ENUM(NSInteger,DisCoveryUpAndDownType) {
    D_UpAndDownTypeNoUpAndDown = 0,
    D_UpAndDownTypeUp = 1,
    D_UpAndDownTypeDown = 2,
};
@interface NewCurrencyModel : BTBaseObject

@property (nonatomic, assign) NSInteger capitalization;

@property (nonatomic, assign) NSInteger capitalizationSort;

@property (nonatomic, assign) long long issueDate;

@property (nonatomic, strong) NSString *exchangeCode;

@property (nonatomic, assign) NSInteger has;

@property (nonatomic, strong) NSString *exchangeName;

@property (nonatomic, strong) NSString *kind;

@property (nonatomic, strong) NSString *kindCode;

@property (nonatomic, strong) NSString *kindName;

@property (nonatomic, assign) double legalTendeCNY;

@property (nonatomic, assign) double legalTendeUSD;

@property (nonatomic, assign) double maxPrice;

@property (nonatomic, assign) double minPrice;

@property (nonatomic, assign) double price;

@property (nonatomic, assign) double priceCNY;

@property (nonatomic, assign) double priceUSD;

@property (nonatomic, assign) double rose;

@property (nonatomic, assign) double turnover;

@property (nonatomic, assign) double turnoverCNY;

@property (nonatomic, assign) double turnoverUSD;

@property (nonatomic, assign) double volume;
@property (nonatomic, assign) DisCoveryUpAndDownType type;
@end
