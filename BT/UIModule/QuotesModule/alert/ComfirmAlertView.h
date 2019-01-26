//
//  ComfirmAlertView.h
//  BT
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseAlertView.h"

typedef void(^ComfirmAlertViewBlock)(void);

@interface ComfirmAlertView : BaseAlertView

+ (void)showWithTitle:(NSString*)title Completion:(ComfirmAlertViewBlock)block;


@end
