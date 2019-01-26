//
//  BTExceptionalCeilingView.h
//  BT
//
//  Created by admin on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^BTPotTipViewCompletionBlock)(NSInteger status);
@interface BTPotTipView : BaseAlertView

+ (void)showBTPotTipView:(NSString *)content completion:(BTPotTipViewCompletionBlock)block;

@end

NS_ASSUME_NONNULL_END
