//
//  BTCoinHolderHeader.m
//  BT
//
//  Created by apple on 2018/6/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FutureHolderHeader.h"

@interface FutureHolderHeader()

@property (nonatomic, strong) UIButton *priBtn;
@end

@implementation FutureHolderHeader

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setStyleWithBtn:self.fiveBtn];
    [self setStyleWithBtn:self.fiftyBtn];
    [self setStyleWithBtn:self.hourBtn];
    self.fiveBtn.layer.borderColor = MainBg_Color.CGColor;
    self.fiveBtn.selected = YES;
    self.priBtn = self.fiveBtn;
}

- (void)setStyleWithBtn:(UIButton *)btn{
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = ThirdColor.CGColor;
    btn.layer.cornerRadius = 12.0f;
    btn.layer.masksToBounds = YES;
}


- (IBAction)clickBtn:(id)sender {
    UIButton *btn = (UIButton*)sender;
    if(self.priBtn){
        self.priBtn.selected = NO;
        self.priBtn.layer.borderColor = ThirdColor.CGColor;
    }
    btn.selected = YES;
    self.priBtn = btn;
    btn.layer.borderColor = MainBg_Color.CGColor;
    if(self.completion){
        self.completion(btn.tag);
    }
    
}



@end
