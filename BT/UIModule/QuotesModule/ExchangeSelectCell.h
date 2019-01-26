//
//  ExchangeSelectCell.h
//  BT
//
//  Created by apple on 2018/5/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTExchangeListModel.h"

@interface ExchangeSelectCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) BTExchangeListModel *model;

@end
