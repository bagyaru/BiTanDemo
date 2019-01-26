//
//  BTHomeGongGaoCell.m
//  BT
//
//  Created by admin on 2018/7/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTHomeGongGaoCell.h"

@implementation BTHomeGongGaoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(FastInfomationObj *)model {
    
    if (model) {
        _model = model;
        self.titleL.text = model.title;
        self.sourceL.text = model.source;
        self.timeL.text = model.timeFormat;
        [getUserCenter setLabelSpace:self.timeL withValue:model.timeFormat withFont:SYSTEMFONT(12) withHJJ:6.0 withZJJ:0.0];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
