//
//  HomeSelectView.m
//  BT
//
//  Created by admin on 2018/6/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HomeSelectView.h"

@implementation HomeSelectView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.rsBtn.selected      = YES;
    self.zfIndicator.hidden  = YES;
    self.dfIndicator.hidden  =YES;
    self.cjeIndicator.hidden = YES;
    self.hslIndicator.hidden = YES;
    self.downViewHeight.constant = 30;
    self.DqjAndRdL.localText  = @"redu";
    self.downView.backgroundColor = isNightMode ? ViewBGNightColor : ViewBGDayColor;
    [self.rsBtn setTitleColor:kHEXCOLOR(0x999999)  forState:UIControlStateNormal];
    [self.rsBtn setTitleColor:kHEXCOLOR(0x108ee9) forState:UIControlStateSelected];
    [self.zfBtn setTitleColor:kHEXCOLOR(0x999999)  forState:UIControlStateNormal];
    [self.zfBtn setTitleColor:kHEXCOLOR(0x108ee9) forState:UIControlStateSelected];
    [self.dfBtn setTitleColor:kHEXCOLOR(0x999999) forState:UIControlStateNormal];
    [self.dfBtn setTitleColor:kHEXCOLOR(0x108ee9)  forState:UIControlStateSelected];
    [self.cjeBtn setTitleColor:kHEXCOLOR(0x999999) forState:UIControlStateNormal];
    [self.cjeBtn setTitleColor:kHEXCOLOR(0x108ee9)  forState:UIControlStateSelected];
    [self.hslBtn setTitleColor:kHEXCOLOR(0x999999) forState:UIControlStateNormal];
    [self.hslBtn setTitleColor:kHEXCOLOR(0x108ee9)  forState:UIControlStateSelected];
}
- (void)setRSColor{
    
    self.rsBtn.selected = YES;
    self.rsIndicator.hidden = NO;
    self.downViewHeight.constant = 30;
    
    self.zfBtn.selected =NO;
    self.dfBtn.selected =NO;
    self.cjeBtn.selected =NO;
    self.zfIndicator.hidden =YES;
    self.dfIndicator.hidden =YES;
    self.cjeIndicator.hidden =YES;
    self.ZoDAndCjeL.fixText = @"24hzhangdie";
    self.DqjAndRdL.localText  = @"redu";
    self.hslBtn.selected = NO;
    self.hslIndicator.hidden = YES;
}
- (void)setZfColor{
    self.zfBtn.selected =YES;
    self.dfBtn.selected =NO;
    self.cjeBtn.selected =NO;
    self.zfIndicator.hidden =NO;
    self.dfIndicator.hidden =YES;
    self.cjeIndicator.hidden =YES;
    self.ZoDAndCjeL.fixText = @"24hzhangdie";
    self.DqjAndRdL.localText  = @"dangqianjia";
    self.rsBtn.selected = NO;
    self.rsIndicator.hidden = YES;
    self.downViewHeight.constant = 30;
    
    self.hslBtn.selected = NO;
    self.hslIndicator.hidden = YES;
}

- (void)setDfColor{
    self.dfBtn.selected =YES;
    self.zfBtn.selected =NO;
    self.cjeBtn.selected =NO;
    self.dfIndicator.hidden =NO;
    self.zfIndicator.hidden =YES;
    self.cjeIndicator.hidden =YES;
    self.ZoDAndCjeL.fixText = @"24hzhangdie";
    self.DqjAndRdL.localText  = @"dangqianjia";
    self.rsBtn.selected = NO;
    self.rsIndicator.hidden = YES;
    self.downViewHeight.constant = 30;
    
    self.hslBtn.selected = NO;
    self.hslIndicator.hidden = YES;
}
- (void)setCJEColor{
    self.cjeBtn.selected =YES;
    self.zfBtn.selected =NO;
    self.dfBtn.selected =NO;
    self.cjeIndicator.hidden =NO;
    self.zfIndicator.hidden =YES;
    self.dfIndicator.hidden =YES;
    self.ZoDAndCjeL.fixText = @"chengjiaoe";
    self.DqjAndRdL.localText  = @"dangqianjia";
    self.rsBtn.selected = NO;
    self.rsIndicator.hidden = YES;
    self.downViewHeight.constant = 30;
    
    self.hslBtn.selected = NO;
    self.hslIndicator.hidden = YES;
}
-(void)setHSLColor{
    self.hslBtn.selected = YES;
    self.hslIndicator.hidden = NO;
    
    self.cjeBtn.selected =NO;
    self.zfBtn.selected =NO;
    self.dfBtn.selected =NO;
    self.cjeIndicator.hidden =YES;
    self.zfIndicator.hidden =YES;
    self.dfIndicator.hidden =YES;
    self.ZoDAndCjeL.fixText = @"huanshoulv";
    self.DqjAndRdL.localText  = @"dangqianjia";
    self.rsBtn.selected = NO;
    self.rsIndicator.hidden = YES;
    self.downViewHeight.constant = 30;
}
@end
