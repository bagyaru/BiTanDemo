//
//  BTContactUsCell.h
//  BT
//
//  Created by admin on 2018/9/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTContactUsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BTContactUsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *typeL;
@property (weak, nonatomic) IBOutlet BTCopyLabel *contentL;

@property (nonatomic, strong) BTContactUsModel *model;
@end

NS_ASSUME_NONNULL_END
