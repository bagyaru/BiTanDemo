//
//  XHMiddeCell.h
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XianHuoMainObj.h"
@interface XHMiddeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BTLabel *chengjiaoliangL1;

@property (weak, nonatomic) IBOutlet BTLabel *chengjiaoliangL2;

@property (weak, nonatomic) IBOutlet UILabel *guanwangdizhiL;
@property (weak, nonatomic) IBOutlet UILabel *goujiaL;

@property (weak, nonatomic) IBOutlet UILabel *paimingL;

@property (weak, nonatomic) IBOutlet UIButton *goGuanWangBtn;

-(void)creatUIWith:(XianHuoMainObj *)obj;
@end
