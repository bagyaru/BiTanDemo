//
//  FastInfomationObj.h
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface FastInfomationObj : BTBaseObject
@property (nonatomic,strong)NSString *content;//内容
@property (nonatomic,strong)NSString *source;//来源地
@property (nonatomic,strong)NSString *imgUrl;//图片地址
@property (nonatomic,strong)NSString *title;//标题
@property (nonatomic,strong)NSString *createdAt;//创建日期(时间戳)
@property (nonatomic,strong)NSString *updatedAt;//更新日期(时间戳)
@property (nonatomic,strong)NSString *issueDate;//发行时间(时间戳)
@property (nonatomic,strong)NSString *timeFormat;//几分钟之前
@property (nonatomic,assign)NSInteger viewCount;//观点数
@property (nonatomic,strong)NSString *infoID;//资讯id
@property (nonatomic,strong)NSString *keywords;//标签 关键词
@property (nonatomic,assign)NSInteger type;//类型
@property (nonatomic, assign) NSInteger receiveNum;//糖果领取数量
@property (nonatomic,assign)BOOL favor;//是否收藏
@property (nonatomic,assign)BOOL hotRecommend;//是否收藏
@property (nonatomic,assign)BOOL IsOrNoLookDetail;//是否查看详情

@property (nonatomic,strong)NSString *avatar;//头像图片地址
@property (nonatomic,assign)BOOL followed;//是否关注
@property (nonatomic,assign)NSInteger userId;//糖果领取数量
@property (nonatomic,strong)NSString *introductions;//个人介绍
@property (nonatomic,strong)NSString *nickName;//昵称

@property (nonatomic,assign)NSInteger commentCount;//回答数

@property (nonatomic,assign)NSInteger authStatus;//认证状态 1 待审核2已通过3未通过4已取消

@property (nonatomic,assign)NSInteger authType;//认证类型 1机构认证2社区达人3专栏作者
@end
