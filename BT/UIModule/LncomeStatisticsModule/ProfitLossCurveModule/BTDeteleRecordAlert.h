//
//  BTDeteleRecordAlert.h
//  BT
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseAlertView.h"
#import "BTRecordModel.h"
typedef void (^DeleteRecoCompletionBlock)(BTRecordModel*model);
@interface BTDeteleRecordAlert : BaseAlertView

+ (void)showWithRecordModel:(BTRecordModel *)model completion:(DeleteRecoCompletionBlock)block;
@end
