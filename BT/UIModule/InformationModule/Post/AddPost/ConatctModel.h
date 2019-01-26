//
//  ConatctModel.h
//  BT
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface ConatctModel : BTBaseObject

@property (nonatomic,assign)NSInteger authStatus;//认证状态 1 待审核2已通过3未通过4已取消
@property (nonatomic,assign)NSInteger authType;//认证类型 1机构认证2社区达人3专栏作者
@property (nonatomic, copy) NSString *avatar; // 头像
@property (nonatomic, copy) NSString *nickName;     // 姓名
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) BOOL followed;



@end
