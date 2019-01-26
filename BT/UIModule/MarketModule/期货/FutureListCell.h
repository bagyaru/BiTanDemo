//
//  MarketCell.h
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarketModel.h"

@interface FutureListCell : UITableViewCell

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) MarketModel *model;

@property (nonatomic, assign) NSInteger row;

@property (nonatomic, assign) BOOL isCNY;


@end
