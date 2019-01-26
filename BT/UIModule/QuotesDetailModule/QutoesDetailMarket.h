//
//  QutoesDetailMarket.h
//  BT
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

typedef NS_ENUM(NSInteger,DisCoveryUpAndDownType) {
    D_UpAndDownTypeNoUpAndDown = 0,
    D_UpAndDownTypeUp = 1,
    D_UpAndDownTypeDown = 2,
};

@interface QutoesDetailMarket : BTBaseObject

@property (nonatomic, assign) NSInteger capitalization;

@property (nonatomic, assign) NSInteger capitalizationSort;

@property (nonatomic, assign) long long currentTime;

@property (nonatomic, strong) NSString *exchangeCode;

@property (nonatomic, strong) NSString *exchangeName;

@property (nonatomic, strong) NSString *kind;

@property (nonatomic, strong) NSString *kindCode;

@property (nonatomic, strong) NSString *kindName;

@property (nonatomic, assign) double legalTendeCNY;

@property (nonatomic, assign) double legalTendeUSD;

@property (nonatomic, assign) double maxPrice;

@property (nonatomic, assign) double minPrice;

@property (nonatomic, assign) double price;

@property (nonatomic, strong) NSString *priceCNY;

@property (nonatomic, strong) NSString *priceUSD;

@property (nonatomic, assign) double rose;

@property (nonatomic, assign) double turnover;

@property (nonatomic, assign) double turnoverCNY;

@property (nonatomic, assign) double turnoverUSD;

@property (nonatomic, assign) double volume;
@property (nonatomic, assign) DisCoveryUpAndDownType type;
//热门币种
@property (nonatomic, strong) NSString *currencyCode;

@property (nonatomic, assign) NSInteger hotPower;

@property (nonatomic, assign) double increaseRate;

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, assign) BOOL isNoImage;

@end
