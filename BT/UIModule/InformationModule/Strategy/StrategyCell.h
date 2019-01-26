//
//  StrategyCell.h
//  BT
//
//  Created by admin on 2018/1/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastInfomationObj.h"
@interface StrategyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *sourceL;
@property (weak, nonatomic) IBOutlet UIButton *viewCountL;
-(void)creatUIWith:(FastInfomationObj *)obj;
@end
