//
//  NewCreateGroupAlert.h
//  BT
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 apple. All rights reserved.
//

//创建 新分组
#import "BaseAlertView.h"
#import "BTGroupListModel.h"

typedef void(^NewCreateGroupAlertBlock)(NSString *name);

@interface NewCreateGroupAlert : BaseAlertView

+ (void)showWithModel:(BTGroupListModel*)model completion:(NewCreateGroupAlertBlock)block;

@end
