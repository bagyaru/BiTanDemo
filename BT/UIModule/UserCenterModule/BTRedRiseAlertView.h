//
//  BTRedRiseAlertView.h
//  BT
//
//  Created by apple on 2018/11/27.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BaseAlertView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^BTRedRiseAlertViewCompletion)(void);

@interface BTRedRiseAlertView : BaseAlertView

+ (void)showWithTitle:(NSString *)title completion:(BTRedRiseAlertViewCompletion)block;

@end

NS_ASSUME_NONNULL_END
