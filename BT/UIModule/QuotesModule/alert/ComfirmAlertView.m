//
//  ComfirmAlertView.m
//  BT
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ComfirmAlertView.h"

@interface ComfirmAlertView()

@property (nonatomic, strong) BTLabel *titleLabel;
@property(nonatomic,strong) BTButton *cancelBtn;//取消
@property(nonatomic,strong) BTButton *confimBtn;//确定

@property (nonatomic, copy) ComfirmAlertViewBlock block;
@end

@implementation ComfirmAlertView

+ (void)showWithTitle:(NSString *)title Completion:(ComfirmAlertViewBlock)block{
    ComfirmAlertView *alert = [[ComfirmAlertView alloc]initWithFrame:[self frameOfAlert]];
    alert.cancelBtn.fixTitle =@"cancel";
    alert.confimBtn.fixTitle =@"confirm";
    alert.titleLabel.text = title;
    alert.block = block;
    
    [alert show];
    
}

+ (CGRect)frameOfAlert{
    return CGRectMake(0, 0, 300.0f, 136.0f);
}

- (void)createView{
    self.layer.cornerRadius = 4.0f;
    self.layer.masksToBounds = YES;
    
    _titleLabel = [[BTLabel alloc]initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont systemFontOfSize:20.0f];
    _titleLabel.textColor = MainTextColor;
    
    _cancelBtn = [BTButton buttonWithType:UIButtonTypeCustom];
    _confimBtn =[BTButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.titleLabel.font = MainTextFont;
    _confimBtn.titleLabel.font = MainTextFont;
    
    [_cancelBtn setTitleColor:MainTextColor forState:UIControlStateNormal];
    [_confimBtn setTitleColor:MainBg_Color forState:UIControlStateNormal];
    
    WS(weakSelf)
    [_cancelBtn bk_addEventHandler:^(id  _Nonnull sender) {
        [weakSelf __hide];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    [_confimBtn bk_addEventHandler:^(id  _Nonnull sender) {
        [weakSelf __hide];
        if(weakSelf.block){
            weakSelf.block();
        }
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_titleLabel];
    [self addSubview:_cancelBtn];
    [self addSubview:_confimBtn];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-77);
        make.top.equalTo(self).offset(31.0f);
    }];
    
    UIView *hLine = [[UIView alloc] initWithFrame:CGRectZero];
    hLine.backgroundColor = kHEXCOLOR(0xdddddd);
    
    UIView *vLine = [[UIView alloc] initWithFrame:CGRectZero];
    vLine.backgroundColor = kHEXCOLOR(0xdddddd);
    
    [self addSubview:hLine];
    [self addSubview:vLine];
    [hLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(0.5);
        make.bottom.equalTo(self.mas_bottom).offset(-44);
    }];
    
    [vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(hLine.mas_bottom);
        make.bottom.equalTo(self);
        make.width.mas_equalTo(0.5);
    }];
    
    
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self);
        make.height.mas_offset(44.0f);
        make.width.mas_offset(150);
    }];
    [_confimBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.equalTo(self);
        make.height.mas_offset(44.0f);
         make.width.mas_offset(150);
    }];
}

@end
