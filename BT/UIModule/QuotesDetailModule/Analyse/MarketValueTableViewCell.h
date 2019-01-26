//
//  MarketValueTableViewCell.h
//  BT
//
//  Created by apple on 2018/6/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTCoinBaseInfo.h"

@interface MarketValueTableViewCell : UITableViewCell

@property (nonatomic, strong) BTCoinBaseInfo *info;

@property (nonatomic, strong) NSString *kind;

@end