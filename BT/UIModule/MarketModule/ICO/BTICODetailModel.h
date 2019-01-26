//
//  BTICODetailModel.h
//  BT
//
//  Created by apple on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTICODetailModel : BTBaseObject

@property (nonatomic, strong)NSArray *datasInfo;
@property (nonatomic, copy) NSString *  audioIntro;// (string, optional): 影音介绍 ,
@property (nonatomic, copy) NSString *codeName;// (string, optional): 代码名称 ,
@property (nonatomic, copy) NSString *collectEndTime;// (string, optional): 募集结束时间 ,
@property (nonatomic, copy) NSString *collectProgress;// (string, optional): 募集进度 ,
@property (nonatomic, copy) NSString * icoChineseName;// (string, optional): ico中文名 ,
@property (nonatomic, copy) NSString *icoCode;// (string, optional): ico的code ,
@property (nonatomic, copy) NSString *icoEnglishName;// (string, optional): ico的英文名 ,
@property (nonatomic, copy) NSString *icoIcon; //(string, optional): ico图标 ,
@property (nonatomic, copy) NSString *icoIntro; //(string, optional): ico信息介绍 ,
@property (nonatomic, copy) NSString *icoIntroEn; //(string, optional): ico信息英文介绍 ,
@property (nonatomic, copy) NSString *icoSignboard;// (string, optional): ico标识 ,
@property (nonatomic, copy) NSString *icoSignboardEn;// (string, optional): ico英文标识 ,
@property (nonatomic, assign)NSInteger icoType;// (integer, optional): ico类型 ,
@property (nonatomic, copy) NSString * importantNews;// (string, optional): ico重要消息 ,
@property (nonatomic, copy) NSString *importantNewsEn;// (string, optional): ico英文重要消息 ,
@property (nonatomic, copy) NSString *otherLinks; //(string, optional): 其他链接 ,
@property (nonatomic, strong) NSArray *otherLinksInfo;
@property (nonatomic, copy) NSString *relatedLinks;// (string, optional): 相关链接 ,
@property (nonatomic, copy) NSString *relatedShot;// (string, optional): 相关截图 ,
@property (nonatomic, strong) NSArray *relatedShotInfo;

@property (nonatomic, copy) NSString *saleTimeArea;// (string, optional): 交易时间区间 ,
@property (nonatomic, copy) NSString *websiteAddress;// (string, optional): 官网 ,
@property (nonatomic, copy) NSString *whiteBookAddress;// (string, optional): 白皮书
@property (nonatomic, strong)NSArray *relatedLinksInfo;
@property (nonatomic, copy) NSString * progressRate;



@end
