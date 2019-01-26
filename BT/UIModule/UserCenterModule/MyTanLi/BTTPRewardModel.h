//
//  BTTPRewardModel.h
//  BT
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTTPRewardModel : BTBaseObject

@property (nonatomic, assign) NSInteger articleId;
@property (nonatomic, copy) NSString *articleTitle;
@property (nonatomic, copy) NSString *datetime;
@property (nonatomic, assign) NSInteger articleType;
@property (nonatomic, copy) NSString * imageUrl;
@property (nonatomic, assign) NSInteger num;
@property (nonatomic, copy) NSString *  userName;
@property (nonatomic, copy) NSString * articlePic;
@property (nonatomic, assign) BOOL isDeleted;

@property (nonatomic,assign)NSInteger authStatus;//认证状态 1 待审核2已通过3未通过4已取消
@property (nonatomic,assign)NSInteger authType;//认证类型 1机构认证2社区达人3专栏作者
@end
