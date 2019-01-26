//
//  CurrencyModel.h
//  BT
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger,UpAndDownType) {
    UpAndDownTypeNoUpAndDown = 0,
    UpAndDownTypeUp = 1,
    UpAndDownTypeDown = 2,
};

@interface CurrencyModel : NSObject<NSCopying>

@property (nonatomic, assign) double capitalization;

@property (nonatomic, assign) NSInteger capitalizationSort;

@property (nonatomic, strong) NSString *exchangeCode;
@property (nonatomic, strong) NSString *exchangeName;

@property (nonatomic, assign) double highLimit;
@property (nonatomic, assign) double lowLimit;

@property (nonatomic, strong) NSString *kind;

@property (nonatomic, strong) NSString *kindName;

@property (nonatomic, strong) NSString *kindCode;

@property (nonatomic, assign) double legalTendeCNY;

@property (nonatomic, assign) double legalTendeUSD;

@property (nonatomic, assign) double maxPrice;

@property (nonatomic, assign) double minPrice;

@property (nonatomic, assign) double price;

@property (nonatomic, assign) double  maxPriceCNY;

@property (nonatomic, assign) double  maxPriceUSD;

@property (nonatomic, assign) double minPriceCNY;

@property (nonatomic, assign) double minPriceUSD;

@property (nonatomic, strong) NSString *priceCNY;

@property (nonatomic, strong) NSString *priceUSD;

@property (nonatomic, assign) double  rose;

@property (nonatomic, assign) double turnover;

@property (nonatomic, assign) double turnoverCNY;

@property (nonatomic, assign) double turnoverUSD;

@property (nonatomic, assign) double volume;

@property (nonatomic, assign) UpAndDownType type;
@property (nonatomic, copy) NSString * icon;

@end
