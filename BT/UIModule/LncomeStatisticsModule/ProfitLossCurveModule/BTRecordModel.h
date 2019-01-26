//
//  BTRecordModel.h
//  BT
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTRecordModel : BTBaseObject

@property (nonatomic, copy) NSString * bookkeepingId;
@property (nonatomic, copy) NSString * buy;
@property (nonatomic, assign)double  count;
@property (nonatomic, copy) NSString *kind;
@property (nonatomic, copy) NSString * relevantKind;
@property (nonatomic, copy) NSString * note;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * priceAmount;
@property (nonatomic, copy) NSString *recordDate;
@property (nonatomic, copy) NSString * capitalization;//市值
@property (nonatomic, assign) NSInteger  dealSource;//交易来源 0未知 1交易所 2钱包
@property (nonatomic, copy) NSString *dealSourceInfo;//来源信息
@property (nonatomic, copy) NSString *dealSourceExchangeCode;//来源信息 交易所Code 
@property (nonatomic, assign)NSInteger totalCount;

@property (nonatomic, assign)double totalPrice;// (number, optional): 总价 ,
@property (nonatomic, assign)double totalPriceLegalTende;// (number, optional): 总价对应法币 ,
@property (nonatomic, assign)double unitPrice;// (number, optional): 单价 ,
@property (nonatomic, assign)double unitPriceLegalTende;// (number, optional): 单价对应法币

@end
