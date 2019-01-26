//
//  ConfirmSelectAlert.m
//  BT
//
//  Created by apple on 2018/4/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ConfirmSelectAlert.h"

@interface ConfirmSelectAlert()

@property (nonatomic, strong) BTLabel *titleLabel;
@property (nonatomic, strong) BTButton *selectBtn;
@property(nonatomic,strong) BTButton *cancelBtn;//取消
@property(nonatomic,strong) BTButton *confimBtn;//确定
@property (nonatomic, copy) ConfirmSelectAlertBlock block;

@end

@implementation ConfirmSelectAlert

+ (void)showWithCompletion:(ConfirmSelectAlertBlock)block{
    ConfirmSelectAlert *alert = [[ConfirmSelectAlert alloc]initWithFrame:[self frameOfAlert]];
    alert.cancelBtn.fixTitle =@"cancel";
    alert.confimBtn.fixTitle =@"confirm";
    
    alert.titleLabel.fixText = @"deleteFromGroup";
    alert.selectBtn.fixTitle =@"deleteFromGroupTime";
    alert.block = block;
    [alert show];
}

+ (CGRect)frameOfAlert{
    return CGRectMake(0, 0, 300.0f, 160.0f);
}

- (void)createView{
    self.layer.cornerRadius = 4.0f;
    self.layer.masksToBounds = YES;
    
    _titleLabel = [[BTLabel alloc]initWithFrame:CGRectZero];
    _titleLabel.font = [UIFont systemFontOfSize:20.0f];
    _titleLabel.textColor = MainTextColor;
    
    _cancelBtn = [BTButton buttonWithType:UIButtonTypeCustom];
    _confimBtn = [BTButton buttonWithType:UIButtonTypeCustom];
    
    ////////
    _selectBtn = [BTButton buttonWithType:UIButtonTypeCustom];
    [_selectBtn setImage:[UIImage imageNamed:@"choose-nor"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"choose-sel"] forState:UIControlStateSelected];
    [_selectBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, -8, 0.0, 0.0)];
    
    _cancelBtn.titleLabel.font = MainTextFont;
    _confimBtn.titleLabel.font = MainTextFont;
    _selectBtn.titleLabel.font = MainTextFont;
    
    [_cancelBtn setTitleColor:MainTextColor forState:UIControlStateNormal];
    [_confimBtn setTitleColor:MainBg_Color forState:UIControlStateNormal];
    [_selectBtn setTitleColor:MainTextColor forState:UIControlStateNormal];
    
    WS(weakSelf)
    [_selectBtn bk_addEventHandler:^(id  _Nonnull sender) {
        weakSelf.selectBtn.selected =!weakSelf.selectBtn.isSelected;
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    [_cancelBtn bk_addEventHandler:^(id  _Nonnull sender) {
        [weakSelf __hide];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    [_confimBtn bk_addEventHandler:^(id  _Nonnull sender) {
        [weakSelf __hide];
        if(weakSelf.block){
            weakSelf.block(weakSelf.selectBtn.isSelected);
        }
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_titleLabel];
    [self addSubview:_selectBtn];
    [self addSubview:_cancelBtn];
    [self addSubview:_confimBtn];
    
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(24.0f);
    }];
    
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20.0f);
        make.top.equalTo(_titleLabel.mas_bottom).offset(18.0f);
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
}



@end
