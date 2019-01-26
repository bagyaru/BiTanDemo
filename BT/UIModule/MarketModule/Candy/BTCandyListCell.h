//
//  BTInfomationSameCell.h
//  BT
//
//  Created by admin on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastInfomationObj.h"
@interface BTCandyListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageIVWight;

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *sourceL;
@property (weak, nonatomic) IBOutlet UIButton *viewCountL;

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;

-(void)creatUIWith:(FastInfomationObj *)obj;
@end
