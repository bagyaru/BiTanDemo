//
//  MessageCenterObj.h
//  BT
//
//  Created by admin on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface MessageCenterObj : BTBaseObject
@property (nonatomic,strong)NSString *content;//内容
@property (nonatomic,strong)NSString *createdAt;//时间
@property (nonatomic,strong)NSString *messageCode;//类型 系统消息还是资讯消息
@property (nonatomic,strong)NSString *title;//标题
@property (nonatomic,strong)NSString *refId;//资讯id
@property (nonatomic,strong)NSString *messageId;//消除未读消息用到的
@property (nonatomic,strong)NSString *feedBackcontent;//反馈内容
@property (nonatomic,assign)NSInteger label;// 标签 1=快讯2要闻3奖励4攻略5话题
@property (nonatomic,strong)NSDictionary *sourceInfo;//源信息
@property (nonatomic,assign)BOOL unread;//是否已读
@property (nonatomic,assign)BOOL IsOrNoLookDetail;//是否查看详情
@end
