//
//  BTSplashScreenModel.h
//  BT
//
//  Created by admin on 2018/6/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTSplashScreenModel : BTBaseObject
@property (nonatomic,strong)NSString *offlineTime;//下线时间
@property (nonatomic,strong)NSString *onlineTime;//上线时间
@property (nonatomic,strong)NSString *pic1;//750*1334
@property (nonatomic,strong)NSString *pic2;//1242*2208
@property (nonatomic,strong)NSString *pic3;//1125*2436
@property (nonatomic,strong)NSString *pic4;//720*1280(Android)
@property (nonatomic,strong)NSString *redirectInfo;//跳转地址
@property (nonatomic,assign)NSInteger redirectType;//跳转类型 1活动 2页面
@property (nonatomic,assign)NSInteger showDuration;//显示时长 1.3s 2.4s 4.5s
@property (nonatomic,assign)NSInteger showInterval;//显示间隔 1每天第一次启动 2每次启动 3点击后不再显示
@property (nonatomic,assign)NSInteger splashId;//pk
@property (nonatomic,assign)NSInteger splashVersion;//splash版本

@property (nonatomic,strong)NSString *localPic;//根据机型本地存储的图片
@end
