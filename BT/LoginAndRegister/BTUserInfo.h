//
//  BTUserInfo.h
//  BT
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseObject.h"

@interface BTUserInfo : BTBaseObject
@property (nonatomic,assign)NSInteger userId;
@property (nonatomic,strong)NSString *username;
@property (nonatomic,strong)NSString *mobile;
@property (nonatomic,strong)NSString *userAvatar;
@property (nonatomic,assign)NSInteger userRole;//用户角色
@property (nonatomic,strong)NSString *token;//认证token
@property (nonatomic,assign)BOOL userHavePassword;//用户是否设置密码 
@end
