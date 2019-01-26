//
//  BTJingCaiMainView.m
//  BT
//
//  Created by admin on 2018/7/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTJingCaiMainView.h"

@implementation BTJingCaiMainView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.zfBtn.selected = YES;
    self.dfIndicator.hidden =YES;
    [self.zfBtn setTitleColor:kHEXCOLOR(0x999999)  forState:UIControlStateNormal];
    [self.zfBtn setTitleColor:kHEXCOLOR(0x108ee9) forState:UIControlStateSelected];
    [self.dfBtn setTitleColor:kHEXCOLOR(0x999999) forState:UIControlStateNormal];
    [self.dfBtn setTitleColor:kHEXCOLOR(0x108ee9)  forState:UIControlStateSelected];
}

- (void)setZfColor{
    self.zfBtn.selected =YES;
    self.dfBtn.selected =NO;
    self.zfIndicator.hidden =NO;
    self.dfIndicator.hidden =YES;
}

- (void)setDfColor{
    self.dfBtn.selected =YES;
    self.zfBtn.selected =NO;
    self.zfIndicator.hidden =YES;
    self.dfIndicator.hidden =NO;
}

@end
