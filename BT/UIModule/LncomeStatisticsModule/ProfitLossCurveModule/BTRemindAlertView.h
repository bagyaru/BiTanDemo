//
//  BTRemindAlertView.h
//  BT
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseAlertView.h"
#import "BTRemindModel.h"
typedef void (^remindCompletionBlcok)(BTRemindModel *model);
@interface BTRemindAlertView : BaseAlertView

+ (void)showWithRemindModel:(BTRemindModel*)model completion:(remindCompletionBlcok)block;
@end
