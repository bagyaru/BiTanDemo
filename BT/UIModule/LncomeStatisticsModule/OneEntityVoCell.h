//
//  OneEntityVoCell.h
//  BT
//
//  Created by admin on 2018/3/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OneEntityVoObj.h"
@interface OneEntityVoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *kindNameL;
@property (weak, nonatomic) IBOutlet UILabel *numberAndTotalPriceL;
@property (weak, nonatomic) IBOutlet UILabel *unitPriceL;
@property (weak, nonatomic) IBOutlet UIButton *earningsBtn;
@property (weak, nonatomic) IBOutlet UILabel *lineL;
@property (nonatomic,assign) NSInteger setion;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countTopCons;

-(void)creatUIWith:(OneEntityVoObj *)obj;
@end
