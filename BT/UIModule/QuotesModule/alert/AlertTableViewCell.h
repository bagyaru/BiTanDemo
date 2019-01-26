//
//  AlertTableViewCell.h
//  BT
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTGroupListModel.h"
@interface AlertTableViewCell : UITableViewCell

@property (nonatomic, strong)BTGroupListModel *moedl;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@end
