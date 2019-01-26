//
//  BTDeletePostAlertView.h
//  BT
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseAlertView.h"
#import "BTPostMainListModel.h"
typedef void (^DeleteRecoCompletionBlock)(BTPostMainListModel*model);
@interface BTDeletePostAlertView : BaseAlertView
+ (void)showWithRecordModel:(BTPostMainListModel *)model completion:(DeleteRecoCompletionBlock)block;
@end
