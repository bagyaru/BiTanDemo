//
//  BTCoinBaseInfo.h
//  BT
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTCoinBaseInfo : BTBaseObject

@property (nonatomic, assign) NSInteger addressNum;// (integer, optional): 持币地址数 ,
@property (nonatomic, copy) NSString *changeRate;//changeRate (string, optional): 换手率 ,

//
@property (nonatomic, assign) NSInteger totalDollar;
@property (nonatomic, assign) NSInteger totalRmb;// (integer, optional): 币的总市值—人民币

@property (nonatomic, assign) NSInteger costDollar;// (integer, optional): 币的市值—美元 ,
@property (nonatomic, copy) NSString * costRate;// (string, optional): 全球总市值占比（保留两位小数） ,
@property (nonatomic, assign)NSInteger costRmb;// (integer, optional): 币的市值—人民币 ,
@property (nonatomic, assign)NSInteger currencyAmount;// (integer, optional): 币的流通量 ,
@property (nonatomic, assign)NSInteger exchangeAmount;// (integer, optional): 上架交易所数量 ,
@property (nonatomic, copy) NSString *  floatRate;// (string, optional): 流通率 ,
@property (nonatomic, copy) NSString * maxAmount;// (string, optional): 币的最大量 ,
@property (nonatomic, assign)NSInteger maxAmountLong;// (integer, optional): 币的最大量long型 ,
@property (nonatomic, assign)NSInteger ranking;// ranking (integer, optional): 排名 ,
@property (nonatomic, copy) NSString *  topTenAddressRate;// (string, optional): 前十持币地址占比 ,
@property (nonatomic, assign)NSInteger topTenExchangeNum;// (integer, optional): 前十交易所数量
@property (nonatomic, copy) NSString *  totalAmount;// (string, optional): 总量
@property (nonatomic, copy) NSString * reputation;

@end
