//
//  AlertView.h
//  BT
//
//  Created by admin on 2018/1/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"

@interface AlertView : BTView

@property (weak, nonatomic) IBOutlet UIButton *shouzhiBtn;

@property (weak, nonatomic) IBOutlet BTLabel *labelL1;
@property (weak, nonatomic) IBOutlet BTLabel *labelL2;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout;

@end
