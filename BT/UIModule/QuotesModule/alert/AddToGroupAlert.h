//
//  AddToGroupAlert.h
//  BT
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseAlertView.h"
#import "BTGroupListModel.h"

typedef void(^AddToGroupAlertBlock)(NSString *groupName);

@interface AddToGroupAlert : BaseAlertView

+ (void)showWithArr:(NSArray*)arr completion:(AddToGroupAlertBlock)block;


@end
