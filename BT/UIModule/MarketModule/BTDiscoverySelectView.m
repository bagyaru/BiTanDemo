//
//  BTDiscoverySelectView.m
//  BT
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTDiscoverySelectView.h"

@implementation BTDiscoverySelectView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.zfBtn.selected = YES;
    self.dfIndicator.hidden =YES;
    [self.zfBtn setTitle:[APPLanguageService wyhSearchContentWith:@"zhangfubang"] forState:UIControlStateNormal];
    [self.dfBtn setTitle:[APPLanguageService wyhSearchContentWith:@"diefubang"] forState:UIControlStateNormal];
    [self.zfBtn setTitleColor:kHEXCOLOR(0xAAAAAA)  forState:UIControlStateNormal];
    [self.zfBtn setTitleColor:kHEXCOLOR(0x151419) forState:UIControlStateSelected];
    [self.dfBtn setTitleColor:kHEXCOLOR(0xAAAAAA) forState:UIControlStateNormal];
    [self.dfBtn setTitleColor:kHEXCOLOR(0x151419)  forState:UIControlStateSelected];
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
