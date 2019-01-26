//
//  QuotesDetailSectionView.m
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QuotesDetailSectionView.h"


@interface QuotesDetailSectionView ()


@end

@implementation QuotesDetailSectionView{
    UIView *ivLine;
    UIButton *priBtnSelect;
    UIButton *firstBtn;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = CGraySecionColor;
    for (NSInteger i = 100; i < 103; i++) {
        UIButton *btn = [self viewWithTag:i];
        if (i == 100) {
            btn.selected = YES;
            priBtnSelect = btn;
            firstBtn = btn;
        }
        [btn addTarget:self action:@selector(changeIndex:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:SecondTextColor forState:UIControlStateNormal];
        [btn setTitleColor:MainTextColor forState:UIControlStateSelected];
    }
    ivLine = [[UIView alloc] init];
    ivLine.backgroundColor = MainTextColor;
    [self addSubview:ivLine];
    [ivLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(firstBtn.mas_centerX);
        make.bottom.equalTo(self).offset(-2);
        make.height.mas_equalTo(2);
        make.width.mas_equalTo(40);
    }];
   
}

- (void)layoutSubviews{
    
}

- (void)changeIndex:(UIButton *)btn{
    if (![btn isEqual:priBtnSelect]) {
        priBtnSelect.selected = NO;
        btn.selected = YES;
        priBtnSelect = btn;
    }
    switch (btn.tag - 100) {
        case 0:
            [AnalysisService alaysisDetail_prospectus];
            //[AnalysisService alaysisDetail_market];
            break;
        case 1:
            [AnalysisService alaysisDetail_discussion];
            //[AnalysisService alaysisDetail_news];
            break;
        case 2:
            [AnalysisService alaysisDetail_market];
            break;
            //        case 3:
            //            [AnalysisService alaysisDetail_prospectus];
            //            break;
        default:
            break;
    }
    if (self.handleIndexBlock) {
        self.handleIndexBlock(btn.tag - 100);
    }
    [UIView animateWithDuration:0.25 animations:^{
        [ivLine mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btn).offset(-2);
            make.centerX.equalTo(btn);
            make.width.mas_equalTo(40);
            make.height.mas_equalTo(2);
        }];
        [ivLine.superview layoutIfNeeded];
    }];
   
}

@end
