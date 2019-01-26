//
//  BTGroupManageCell.h
//  BT
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TopGroupBlock)(void);
#import "BTGroupListModel.h"

@protocol BTGroupManageCellDelegate<NSObject>

- (void)refreshData;

@end

@interface BTGroupManageCell : UITableViewCell

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, assign) BOOL isAllEdit;

@property (nonatomic, strong) BTGroupListModel *model;

@property (nonatomic, weak) id<BTGroupManageCellDelegate>delegate;
@property (nonatomic, copy) TopGroupBlock groupBlock;

@end
