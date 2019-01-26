//
//  GroupSideView.h
//  BT
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BTGroupListModel.h"
typedef void(^GroupSideViewBlock)(BTGroupListModel *model);
@interface GroupSideView : UIView

+ (void)show;

+ (void)showWithArr:(NSArray*)arr completion:(GroupSideViewBlock)block;

@end
