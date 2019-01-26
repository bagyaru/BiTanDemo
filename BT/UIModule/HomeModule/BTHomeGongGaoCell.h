//
//  BTHomeGongGaoCell.h
//  BT
//
//  Created by admin on 2018/7/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastInfomationObj.h"
@interface BTHomeGongGaoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *sourceL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (nonatomic,strong) FastInfomationObj *model;
@end
