//
//  BTGetTanLiAlertView.h
//  BT
//
//  Created by admin on 2018/9/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"

@interface BTGetTanLiAlertView : BaseAlertView

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *label_TP;
@property (nonatomic,strong) NSDictionary *dict;

@end
