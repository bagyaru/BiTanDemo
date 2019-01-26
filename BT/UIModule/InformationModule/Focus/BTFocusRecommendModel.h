//
//  BTFocusRecommendModel.h
//  BT
//
//  Created by admin on 2018/11/26.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTFocusRecommendModel : BTBaseObject
@property (nonatomic,assign)NSInteger userId;
@property (nonatomic,assign)NSInteger authStatus;//认证状态 1 待审核2已通过3未通过4已取消
@property (nonatomic,assign)NSInteger authType;//认证类型 1机构认证2社区达人3专栏作者
@property (nonatomic,strong)NSString *avatar;
@property (nonatomic,strong)NSString *nickName;
@property (nonatomic,strong)NSString *introductions;//个人介绍
@property (nonatomic,strong)NSString *homePageImg;//主页图片
@property (nonatomic,assign)BOOL followed;//是否关注
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,assign)NSInteger fansNum;//粉丝数
@property (nonatomic,assign)NSInteger articleNum;//文章数 

@end

NS_ASSUME_NONNULL_END
