//
//  FenshiModel.h
//  BT
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface FenshiModel : BTBaseObject<YYModel>

@property (nonatomic, assign) double price;

@property (nonatomic, assign) double priceCNY;

@property (nonatomic, assign) double priceUSD;

@property (nonatomic, assign) double maxPriceCNY;
@property (nonatomic, assign) double maxPriceUSD;
@property (nonatomic, assign) double minPriceCNY;
@property (nonatomic, assign) double minPriceUSD;
@property (nonatomic, assign) long long time;

@property (nonatomic, assign) double volum;

@property (nonatomic, assign) BOOL isCurrency;//是否为交易对

@property (nonatomic, assign) double  minPrice;

@property (nonatomic, assign) double  maxPrice;

@property (nonatomic, assign) double totalVolum;//和volum等同 最初的值

@property (nonatomic, strong) NSString *lineTime;

//所有点的集合
@property (nonatomic, assign) double pointMaxPrice;//点的最高价

@property (nonatomic, assign) double pointMinPrice;//点的最低价

@property (nonatomic, assign) double pointMaxVolum;//点的最大量

@property (nonatomic, assign) double pointMinVolum;//点的最小量

@property (nonatomic, assign) double pointVolum;//点的量

@property (nonatomic, assign) double pointAvgPrice;//点的平均价格

@property (nonatomic, assign) double pointValuePrice;//点的价格比例

@property (nonatomic, assign) double pointValueAvgPrice;//点的平均价格比例

@property (nonatomic, assign) double pointValueVolum;//点的量的比例

@property (nonatomic, assign) CGFloat pXOffset;

@property (nonatomic, assign) CGFloat pYOffset;

@property (nonatomic, assign) BOOL rise;



@end
