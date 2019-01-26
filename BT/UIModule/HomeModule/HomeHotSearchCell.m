//
//  HomeHotSearchCell.m
//  BT
//
//  Created by admin on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HomeHotSearchCell.h"

@implementation HomeHotSearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.rateBtn, 1);
    self.rateBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.rateBtn.titleLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
    [self.rateBtn setTitleColor:CWhiteColor forState:UIControlStateNormal];
    // Initialization code
}
- (void)setModel:(QutoesDetailMarket *)model{
    if(model){
        _model = model;
        self.starView.currentScore = model.hotPower/2.0;
        self.nameL.text = model.currencyCode;
        self.sortL.text = SAFESTRING(@(self.index +1));
        model.icon = SAFESTRING(model.icon);
        [self.iconIV sd_setImageWithURL:[NSURL URLWithString:[model.icon hasPrefix:@"http"]?model.icon:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.icon]] placeholderImage:[UIImage imageNamed:@"default_coin"]];
        if (model.increaseRate <  0) {
            [self.rateBtn setTitle:[NSString stringWithFormat:@"-%@%%",@(-model.increaseRate).p2fString] forState:UIControlStateNormal];
            self.rateBtn.backgroundColor = CFallColor;
            
        }else{
            [self.rateBtn setTitle:[NSString stringWithFormat:@"+%@%%",@(model.increaseRate).p2fString] forState:UIControlStateNormal];
            self.rateBtn.backgroundColor = CRiseColor;
            if (model.increaseRate < 0.01) {
                self.rateBtn.backgroundColor = CNoChangeColor;
                [self.rateBtn setTitle:[NSString stringWithFormat:@"%@%%",@(-model.increaseRate).p2fString] forState:UIControlStateNormal];
            }
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
