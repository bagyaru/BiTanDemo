//
//  LncomeStatisticsMainObj.h
//  BT
//
//  Created by admin on 2018/3/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface LncomeStatisticsMainObj : BTBaseObject

@property (nonatomic,assign)double balance;//余额
@property (nonatomic,assign)double earnings;//收益
@property (nonatomic,assign)double currencyCount;//对应BTC数量 
@property (nonatomic,strong)NSMutableArray *detailVOList;

@property (nonatomic,assign)double positionCapital;// (number, optional): 持仓本金 ,
@property (nonatomic,assign)double positionCapitalization;// (number, optional): 持仓市值 ,
@property (nonatomic,assign)double positionGainAndLoss;// (number, optional): 持仓盈亏 ,
@property (nonatomic,assign)double totalGainAndLoss;// (number, optional): 累计盈亏
@property (nonatomic, assign)double positionCount;

@property (nonatomic, assign)double costPrice;
@property (nonatomic, assign)double currentPrice;

@property (nonatomic, copy) NSString * currencySymbol;//对应货币标志 ,

@property (nonatomic, strong) NSString *kind;

@property (nonatomic, assign)double positionGainAndLossCurrency;//持仓盈亏-对应BTC数量 ,
@property (nonatomic, assign)double positionCapitalizationCurrency;// (number, optional): 持仓市值-对应BTC数量 ,
@property (nonatomic, assign)double positionCapitalCurrency;// (number, optional): 持仓本金-对应BTC数量
@property (nonatomic, assign)double currentPriceCurrency;//当前价-对应货币数量





@end
