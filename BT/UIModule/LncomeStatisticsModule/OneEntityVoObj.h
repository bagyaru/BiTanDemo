//
//  OneEntityVoObj.h
//  BT
//
//  Created by admin on 2018/3/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface OneEntityVoObj : BTBaseObject
@property (nonatomic,assign)double balance;//余额
@property (nonatomic,assign)double earnings;//收益
@property (nonatomic,assign)double countNumb;//数量
@property (nonatomic,assign)double earningsPercent;//收益百分比
@property (nonatomic,assign)double realPrice;//市值
@property (nonatomic,strong)NSString *kind;//种类
@property (nonatomic,strong)NSString *note;//备注
@property (nonatomic,assign)double currencyCount;//对应BTC数量
//交易所
@property (nonatomic,strong)NSString *exchangeName;//交易所名称
@property (nonatomic,strong)NSString *exchange;//交易所code
@property (nonatomic,assign)double btcCount;//对应BTC数量
@property (nonatomic,assign)double priceCny;//对应人民币
@property (nonatomic,assign)double priceUsd;//对应美元

@property (nonatomic,assign)NSInteger jjsOrjjb;//交易所或者交易币

@property (nonatomic, assign) double positionCapitalization;// (number, optional): 持仓市值 ,
@property (nonatomic, assign) double positionCount;// (number, optional): 持仓数量 ,
@property (nonatomic, assign) double positionGainAndLoss;// (number, optional): 持仓盈亏

@property (nonatomic, assign) double positionCapitalizationCurrency;// (number, optional): 持仓市值-对应BTC数量 ,

@end
