//
//  BTDiscoveryMainCell.h
//  BT
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QutoesDetailMarket.h"
@interface BTDiscoveryMainCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) QutoesDetailMarket *model;
@property (nonatomic, assign) NSInteger selectedIndex;

@end
