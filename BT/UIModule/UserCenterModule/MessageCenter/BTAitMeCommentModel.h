//
//  BTAitMeCommentModel.h
//  BT
//
//  Created by admin on 2018/10/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTAitMeCommentModel : BTBaseObject
@property (nonatomic,strong)NSString *content;
@property (nonatomic,strong)NSString *userAvatar;
@property (nonatomic,strong)NSString *date;
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,strong)NSString *imgUrl;
@property (nonatomic,strong)NSString *refId;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSString *userName;
@property (nonatomic,strong)NSString *sourceInfoUserName;
@property (nonatomic,assign)NSInteger jumpType;//跳转类型
@property (nonatomic,assign)BOOL unread;//未读
@property (nonatomic,assign)BOOL IsOrNoLookDetail;//是否查看详情
@property (nonatomic,assign)BOOL isAddOneLine;//是否多一行展示 查看全文按钮
@property (nonatomic,assign)BOOL IsOrNoLookSourceDetail;//是否查看详情
@property (nonatomic,assign)NSInteger authStatus;//认证状态 1 待审核2已通过3未通过4已取消
@property (nonatomic,assign)NSInteger authType;//认证类型 1机构认证2社区达人3专栏作者
@end

NS_ASSUME_NONNULL_END
