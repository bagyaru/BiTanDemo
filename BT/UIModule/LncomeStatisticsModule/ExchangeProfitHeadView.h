//
//  LncomeStatisticsMainHeadView.h
//  BT
//
//  Created by admin on 2018/3/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"
#import "LncomeStatisticsMainObj.h"
@interface ExchangeProfitHeadView : UIView

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightLayout;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet BTLabel *titleL;

@property (weak, nonatomic) IBOutlet BTLabel *shiZhiL;
@property (weak, nonatomic) IBOutlet BTLabel *benjinL;
@property (weak, nonatomic) IBOutlet BTLabel *fitLosL;

@property (weak, nonatomic) IBOutlet BTLabel *totalLosL;

@property (weak, nonatomic) IBOutlet UILabel *costL;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceL;
@property (weak, nonatomic) IBOutlet UILabel *countL;

@property (nonatomic, strong) LncomeStatisticsMainObj *obj;

@property (nonatomic, strong) NSDictionary *info;


@end
