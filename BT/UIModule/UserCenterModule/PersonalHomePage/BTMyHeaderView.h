//
//  BTMyPostHeaderView.h
//  BT
//
//  Created by apple on 2018/9/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"

@interface BTMyHeaderView : BTView

@property (weak, nonatomic) IBOutlet UILabel *fabuCountL;

@property (weak, nonatomic) IBOutlet UILabel *guanzhuCountL;

@property (weak, nonatomic) IBOutlet UILabel *fensiCountL;

@property (weak, nonatomic) IBOutlet UILabel *huozanCountL;

@property (weak, nonatomic) IBOutlet UIView *fabuView;

@property (weak, nonatomic) IBOutlet UIView *guanzhuView;

@property (weak, nonatomic) IBOutlet UIView *fensiView;
@property (weak, nonatomic) IBOutlet UIView *huozanView;


@end
