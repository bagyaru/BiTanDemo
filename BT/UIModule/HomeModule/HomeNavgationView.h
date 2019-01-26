//
//  HomeNavgationView.h
//  BT
//
//  Created by admin on 2018/9/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"

@interface HomeNavgationView : BTView

@property (weak, nonatomic) IBOutlet UIButton *groupBtn;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (weak, nonatomic) IBOutlet BTLabel *titleL;
@property (weak, nonatomic) IBOutlet UIView *clearView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageV;

@end
