//
//  BTZFFBDetailCell.h
//  BT
//
//  Created by admin on 2018/7/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTZFFFModel.h"
@interface BTZFFBDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet BTLabel *typeL;
@property (weak, nonatomic) IBOutlet UILabel *qjL;
@property (weak, nonatomic) IBOutlet UILabel *numbL;
@property (nonatomic,strong) BTZFFFModel *model;
@end
