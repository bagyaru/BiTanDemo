//
//  BTDeletePostAlertView.h
//  BT
//
//  Created by admin on 2018/9/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseAlertView.h"
#import "BTPostMainListModel.h"
typedef void (^CompletionBlock)(NSInteger status);
@interface BTUserAlertView : BaseAlertView
+ (void)showWithTitle:(NSString *)title content:(NSString*)content completion:(CompletionBlock)block;
@end
