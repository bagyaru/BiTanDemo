//
//  MyOptionCell.h
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyModel.h"
#import "QutoesDetailMarket.h"


@interface MyOptionCell : UITableViewCell

@property (nonatomic, strong) CurrencyModel *model;

@property (nonatomic, strong) QutoesDetailMarket *marketModel;

@property (nonatomic, assign) BOOL noShowKindName;

@property (nonatomic, assign) BOOL isCNY;

@property (nonatomic, assign) BOOL isZiXuan;

@property (nonatomic, assign) BOOL isShiChang;

@property (nonatomic, assign) BOOL isShiZhi;//是否是市值

@property (nonatomic, assign) BOOL isFuture;

@property (nonatomic, assign) BOOL hideLine;

@end
