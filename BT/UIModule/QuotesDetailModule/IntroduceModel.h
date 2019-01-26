//
//  IntroduceModel.h
//  BT
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface IntroduceModel : BTBaseObject

@property (nonatomic, strong) NSString *abstractType;
@property (nonatomic, strong) NSString *abstractValue;
@property (nonatomic, copy) NSString * changeRate;//换手率
@property (nonatomic, copy) NSString * coinDistribute;//代币分配
@property (nonatomic, copy) NSString * collectFundAmount;//募集资金量 ,
@property (nonatomic, copy) NSString  *convertRate;//兑换比例
@property (nonatomic, assign) NSInteger  costDollar;//币的市值—美元
@property (nonatomic, copy) NSString*  costRate;//全球总市值占比（保留两位小数）
@property (nonatomic, assign) NSInteger  costRmb;//币的市值—人民币
@property (nonatomic, copy) NSString * counselor;//顾问
@property (nonatomic, assign) NSInteger  currencyAmount;//币的流通量

@property (nonatomic, copy) NSString * currencyChineseName;//币的中文名
@property (nonatomic, copy) NSString *currencyCode;

@property (nonatomic, copy) NSString * currencySimpleName;//简称
@property (nonatomic, assign) NSInteger  exchangeAmount;//上架交易所数量
@property (nonatomic, copy) NSString * explorerAddress;//explorer地址
@property (nonatomic, copy)NSString *floatRate;//流通率
@property (nonatomic, copy) NSString * fundUse; //资金使用
@property (nonatomic, copy) NSString * hardTop;//硬顶
@property (nonatomic, copy) NSString * icoCost;//
@property (nonatomic, copy) NSString * icoTime;
@property (nonatomic, copy) NSString * maxAmount;//币的最大量
@property (nonatomic, assign) NSInteger ranking;
@property (nonatomic, copy) NSString * refWebsite;//相关网站
@property (nonatomic, copy) NSString * relatedNotion;//币的相关概念
@property (nonatomic, copy) NSString * supportWallet;//支持的钱包
@property (nonatomic, copy) NSString * totalAmount;//总量

@property (nonatomic, copy) NSString * websiteAddress; // 网址 ,
@property (nonatomic, copy) NSString *whiteBookAddress;// 白皮书地址

@property (nonatomic, strong) NSString *currencyEnglishName;

@property (nonatomic, assign) NSInteger costDoller;

@property (nonatomic, assign) long long createTime;

@property (nonatomic, assign) NSInteger createUserId;

@property (nonatomic, assign) NSInteger currencyId;

@property (nonatomic, strong) NSString *currencyName;

@property (nonatomic, assign) BOOL isDeleted;

@property (nonatomic, assign) BOOL isShowIndex;
@property (nonatomic, strong) NSDictionary *conceptInfo;
@property (nonatomic, strong) NSDictionary *returns;

@property (nonatomic, strong) NSArray *webInfo;//web 信息

//
@property (nonatomic, copy) NSString *baseInfo;
@property (nonatomic, copy) NSString *gitHubInfo;
@property (nonatomic, copy) NSString * privateInfo;
@property (nonatomic, copy) NSString * teamIntro;//团队介绍

//
@property (nonatomic, strong)NSDictionary *baseInfoObj;
@property (nonatomic, strong)NSDictionary *privateInfoObj;
@property (nonatomic, strong)NSDictionary *gitHubInfoObj;
@property (nonatomic, strong)NSArray * teamInfoObj;
@property (nonatomic, copy)NSString *reputation;

@end
