//
//  BTCancelAlertView.h
//  BT
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseAlertView.h"

typedef void (^DeleteRecoCompletionBlock)(NSString * str);
@interface BTCancelAlertView : BaseAlertView

+ (void)showWithTitle:(NSString *)title completion:(DeleteRecoCompletionBlock)block;

@end
