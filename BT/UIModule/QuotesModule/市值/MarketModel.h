//
//  MarketModel.h
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,UpAndDownType) {
    UpAndDownTypeNoUpAndDown = 0,
    UpAndDownTypeUp = 1,
    UpAndDownTypeDown = 2,
};

@interface MarketModel : NSObject

@property (nonatomic, assign) double capitalization;
@property (nonatomic, assign) double capitalizationUSD;
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

@property (nonatomic, assign) UpAndDownType type;

@property (nonatomic, assign) double highLimit;
@property (nonatomic, assign) double lowLimit;
@property (nonatomic, copy) NSString * icon;

@end
