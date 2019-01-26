//
//  NewDianZanAndReplayCell.h
//  BT
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZanAndReplayListModel.h"
typedef void (^NewDianZanAndReplayCellGotToDetailBlock)(ZanAndReplayListModel *model);
@interface NewDianZanAndReplayCell : UITableViewCell

@property (nonatomic,strong)NSString *type;

@property (nonatomic,copy)NewDianZanAndReplayCellGotToDetailBlock goToDetailBlock;

+ (instancetype)shareInstance;

- (void)configWithDiscussModel:(ZanAndReplayListModel *)model;

+ (CGFloat)cellHeightWithDiscussModel:(ZanAndReplayListModel *)model;
@end
