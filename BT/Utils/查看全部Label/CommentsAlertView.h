//
//  CommentsAlertView.h
//  BT
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseAlertView.h"
#import "BTGroupListModel.h"
typedef void(^CommentsAlertBlock)(NSString *groupName);
@interface CommentsAlertView : BaseAlertView
+ (void)showWithArr:(NSArray*)arr type:(NSInteger)type completion:(CommentsAlertBlock)block;
@end
