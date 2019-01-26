//
//  XianHuoMainObj.h
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface XianHuoMainObj : BTBaseObject
@property (nonatomic,strong)NSString *chineseName;//交易所所属国家中文名字
@property (nonatomic,strong)NSString *englishName;//交易所所属国家英文名字
@property (nonatomic,strong)NSString *countryName;//交易所所属国家名字(后台处理)
@property (nonatomic,strong)NSString *exchangeAbstract;//交易所简介
@property (nonatomic,assign)NSInteger exchangeId;//交易所id
@property (nonatomic,strong)NSString *exchangeName;//交易所名称
@property (nonatomic, copy) NSString * exchangeLabel;//标签
@property (nonatomic,strong)NSString *exchangeCode;//交易所代码
@property (nonatomic,strong)NSString *exchangeWebsiteAddress;//交易所官网地址 
@property (nonatomic,assign)NSInteger ranking;//交易所排名
@property (nonatomic,assign)NSInteger tradePairAmount;//交易所交易对的数量
@property (nonatomic,strong)NSString *createTime;//创建时间
@property (nonatomic,assign)double volume;//24h成交额
@property (nonatomic,assign)double turnoverCNY;//24h成交额人民币
@property (nonatomic,assign)double turnoverUSD;//24h成交额美元
@property (nonatomic, copy) NSString * icon;//图标
@property (nonatomic, copy) NSString * category;

@property (nonatomic, copy) NSString *  exchangeContact;
@property (nonatomic, copy) NSString * exchangeDownloads;
@property (nonatomic, copy) NSString * exchangePoundage;

@end
