//
//  ConfirmSelectAlert.h
//  BT
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseAlertView.h"

typedef void(^ConfirmSelectAlertBlock)(BOOL isAll);
@interface ConfirmSelectAlert : BaseAlertView

+ (void)showWithCompletion:(ConfirmSelectAlertBlock)block;

@end
