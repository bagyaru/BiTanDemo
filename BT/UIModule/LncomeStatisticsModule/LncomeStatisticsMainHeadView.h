//
//  LncomeStatisticsMainHeadView.h
//  BT
//
//  Created by admin on 2018/3/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"
#import "LncomeStatisticsMainObj.h"
@interface LncomeStatisticsMainHeadView : UIView

@property (weak, nonatomic) IBOutlet UIButton *paixunBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;
@property (weak, nonatomic) IBOutlet UIButton *paixuSJb;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet BTLabel *titleL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConst;

@property (weak, nonatomic) IBOutlet BTLabel *shiZhiL;

@property (weak, nonatomic) IBOutlet BTLabel *shizhiMoneyL;

@property (weak, nonatomic) IBOutlet BTLabel *benjinL;
@property (weak, nonatomic) IBOutlet BTLabel *fitLosL;

@property (weak, nonatomic) IBOutlet BTLabel *totalLosL;

@property (nonatomic, strong) LncomeStatisticsMainObj *obj;



@end
