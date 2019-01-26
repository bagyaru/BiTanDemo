//
//  TradePointModel.h
//  BT
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradePointModel : NSObject

@property (nonatomic, assign) double maxPrice;
@property (nonatomic, assign) double minPrice;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double pointValue;
@property (nonatomic, assign) double avgPointValue;
@property (nonatomic, assign) double avgPrice;
@property (nonatomic, assign) double volume;
@property (nonatomic, assign) double maxVolum;
@property (nonatomic, assign) double minVolum;
@property (nonatomic, assign) double pointValueVolum;
@property (nonatomic, assign) BOOL rise;
@property (nonatomic, strong) NSString *time;

@property (nonatomic, assign) long long realTime;

@property (nonatomic, strong) NSString *lineTime;

@property (nonatomic, assign) CGFloat pXOffset;

@property (nonatomic, assign) CGFloat pYOffset;

@property (nonatomic, assign) double totalVolum;


@property (nonatomic, assign) double avgYellow;

@property (nonatomic, assign) double pointValueYellow;

@property (nonatomic, assign) double avgMaxYellow;

@property (nonatomic, assign) double avgMinYellow;

@end
