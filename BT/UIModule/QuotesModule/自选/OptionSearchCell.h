//
// OptionSearchCell.h
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrentcyModel.h"
#import "QutoesDetailMarket.h"

@protocol OptionSearchCellDelegate<NSObject>

- (void)clickWithModel:(CurrentcyModel*)model;

@end

@interface OptionSearchCell : UITableViewCell

@property (nonatomic, strong) CurrentcyModel *model;

@property (nonatomic, assign) BOOL noShowKindName;

@property (nonatomic, assign) BOOL isCNY;

@property (nonatomic, assign) BOOL isZiXuan;

@property (nonatomic, assign) BOOL isShiChang;

@property (nonatomic, assign) BOOL isShiZhi;//是否是市值

@property (nonatomic, weak) id<OptionSearchCellDelegate>delegate;

@end
