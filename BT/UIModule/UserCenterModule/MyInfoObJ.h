//
//  MyInfoObJ.h
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface MyInfoObJ : BTBaseObject
@property (nonatomic,assign)NSInteger userId;
@property (nonatomic,strong)NSString *username;
@property (nonatomic,strong)NSString *mobile;
@property (nonatomic,strong)NSString *userAvatar;
@property (nonatomic,assign)NSInteger userRole;//用户角色
@property (nonatomic,strong)NSString *token;//认证token
@property (nonatomic,assign)BOOL userHavePassword;//用户是否设置密码 
@property (nonatomic,assign)double balance;//余额
@property (nonatomic,assign)double earnings;//收益
@property (nonatomic,assign)double currencyCount;//对应BTC数量 
@property (nonatomic,assign)BOOL isHavaData;//是否添加过数据
@property (nonatomic, copy) NSString * introductions;//个人简介

@property (nonatomic,assign)double positionCapital;// (number, optional): 持仓本金 ,
@property (nonatomic,assign)double positionCapitalization;// (number, optional): 持仓市值 ,
@property (nonatomic,assign)double positionGainAndLoss;// (number, optional): 持仓盈亏 ,
@property (nonatomic,assign)double totalGainAndLoss;// (number, optional): 累计盈亏

@property (nonatomic, assign)double positionGainAndLossCurrency;//持仓盈亏-对应BTC数量 ,
@property (nonatomic, assign)double positionCapitalizationCurrency;// (number, optional): 持仓市值-对应BTC数量 ,
@property (nonatomic, assign)double positionCapitalCurrency;// (number, optional): 持仓本金-对应BTC数量

@end
