//
//  HomeSelectView.h
//  BT
//
//  Created by admin on 2018/6/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTView.h"

@interface HomeSelectView : BTView
@property (weak, nonatomic) IBOutlet BTButton *rsBtn;
@property (weak, nonatomic) IBOutlet BTButton *zfBtn;
@property (weak, nonatomic) IBOutlet BTButton *dfBtn;
@property (weak, nonatomic) IBOutlet BTButton *cjeBtn;
@property (weak, nonatomic) IBOutlet BTButton *hslBtn;

@property (weak, nonatomic) IBOutlet UILabel *rsIndicator;
@property (weak, nonatomic) IBOutlet UILabel *zfIndicator;
@property (weak, nonatomic) IBOutlet UILabel *dfIndicator;
@property (weak, nonatomic) IBOutlet UILabel *cjeIndicator;
@property (weak, nonatomic) IBOutlet UILabel *hslIndicator;


@property (weak, nonatomic) IBOutlet BTLabel *ZoDAndCjeL;
@property (weak, nonatomic) IBOutlet BTLabel *DqjAndRdL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downViewHeight;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *downView;

- (void)setRSColor;
- (void)setZfColor;
- (void)setDfColor;
- (void)setCJEColor;
- (void)setHSLColor;
@end
