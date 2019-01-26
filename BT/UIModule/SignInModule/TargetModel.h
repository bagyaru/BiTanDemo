//
//  TargetModel.h
//  BT
//
//  Created by apple on 2018/5/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TargetModel : NSObject

/**主标题*/
@property (nonatomic,copy) NSString *name;
/**主标题英文*/
@property (nonatomic,copy) NSString *nameEn;
/**副标题*/
@property (nonatomic,copy) NSString *describe;
/**副标题英文*/
@property (nonatomic,copy) NSString *describeEn;
/**奖励探力数额*/
@property (nonatomic,assign) NSInteger reward;
/**活动类型1登录2签到3邀请好友4阅读资讯5评论资讯6分享资讯7使用收益统计*/
@property (nonatomic,assign) NSInteger type;
/**每天已操作次数*/
@property (nonatomic,assign) NSInteger useNum;
/**每天总次数*/
@property (nonatomic,assign) NSInteger totalNum;
/**是否是第一个cell*/
@property (nonatomic,assign) BOOL isFirstRow;


@end
