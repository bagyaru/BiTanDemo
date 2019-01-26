//
//  QiHuoMainObj.h
//  BT
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface QiHuoMainObj : BTBaseObject
@property (nonatomic,strong)NSString *bailRate;//保证金比例
@property (nonatomic,strong)NSString *balance;//结算
@property (nonatomic,strong)NSString *contractCode;//合约简称
@property (nonatomic,strong)NSString *contractName;//合约名称
@property (nonatomic,strong)NSString *contractUnit;//合约单位
@property (nonatomic,strong)NSString *futuresId;//期货编号
@property (nonatomic,strong)NSString *language;//语言类型
@property (nonatomic,strong)NSString *lastTradeDate;//最后交易日
@property (nonatomic,strong)NSString *listingContract;//挂牌合约
@property (nonatomic,strong)NSString *positionLimit;//仓位限制
@property (nonatomic,strong)NSString *productCode;//产品代码
@property (nonatomic,strong)NSString *quotePrice;//报价
@property (nonatomic,strong)NSString *suspendTrade;//价格限制与暂停交易
@property (nonatomic,strong)NSString *tradeDate;//交易时间
@property (nonatomic,strong)NSString *tradeThreshold;//大宗交易门槛
@property (nonatomic,strong)NSString *twistingMin;//最小价格波动
@end
