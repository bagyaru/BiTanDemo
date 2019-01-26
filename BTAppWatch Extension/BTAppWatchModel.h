//
//  BTAppWatchModel.h
//  BTAppWatch Extension
//
//  Created by admin on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTAppWatchBaseModel.h"
typedef NS_ENUM(NSInteger,BTAppWatchBaseModelUpAndDownType) {
    BTAppWatchBaseModelUpAndDownTypeNoUpAndDown = 0,
    BTAppWatchBaseModelUpAndDownTypeUp = 1,
    BTAppWatchBaseModelUpAndDownTypeDown = 2,
};
@interface BTAppWatchModel : BTAppWatchBaseModel
@property (nonatomic, assign) double capitalization;

@property (nonatomic, assign) NSInteger capitalizationSort;

@property (nonatomic, strong) NSString *exchangeCode;
@property (nonatomic, copy)  NSString  *exchangeName;

@property (nonatomic, strong) NSString *kind;

@property (nonatomic, strong) NSString *kindCode;

@property (nonatomic, strong) NSString *kindName;

@property (nonatomic, assign) double legalTendeCNY;

@property (nonatomic, assign) double legalTendeUSD;

@property (nonatomic, assign) double maxPrice;

@property (nonatomic, assign) double minPrice;

@property (nonatomic, strong) NSString *priceCNY;

@property (nonatomic, strong) NSString *priceUSD;

@property (nonatomic, assign) double  rose;

@property (nonatomic, assign) double turnover;

@property (nonatomic, assign) double turnoverCNY;

@property (nonatomic, assign) double turnoverUSD;

@property (nonatomic, assign) double volume;

@property (nonatomic, assign) BTAppWatchBaseModelUpAndDownType type;
@end
