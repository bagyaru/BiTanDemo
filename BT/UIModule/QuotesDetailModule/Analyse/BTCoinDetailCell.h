//
//  BTCoinDetailCell.h
//  BT
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTCoinDetailModel.h"
@interface BTCoinDetailCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) BTCoinDetailModel *model;

@end
