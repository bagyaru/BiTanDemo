//
//  BTInfomationSameCell.h
//  BT
//
//  Created by admin on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FastInfomationObj.h"
@interface BTInfomationSameCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageIVWight;

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *sourceL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIButton *viewCountL;

@property (weak, nonatomic) IBOutlet UIImageView *iconIV;
@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoIVW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *left;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downHeight;

@property (weak, nonatomic) IBOutlet UILabel *lineL;
@property (nonatomic,strong)FastInfomationObj *model;
@property (nonatomic,strong)NSString *whereVC;
-(void)creatUIWith:(FastInfomationObj *)obj;
@end
