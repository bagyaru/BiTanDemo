//
//  BTZFFBDetailCell.m
//  BT
//
//  Created by admin on 2018/7/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTZFFBDetailCell.h"

@implementation BTZFFBDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(BTZFFFModel *)model {
    
    if (model) {
        _model = model;
        NSLog(@"=====%ld",model.riseDistributionType);
        if (model.riseDistributionType <= 5) {
            self.typeL.text = [NSString stringWithFormat:@"%@ %@",[APPLanguageService wyhSearchContentWith:@"zhangfu"],model.riseDistributionType == 0 ? @">" : @""];
            self.qjL.textColor = CRiseColor;
        }else {
            self.typeL.text = [NSString stringWithFormat:@"%@ %@",[APPLanguageService wyhSearchContentWith:@"diefu"],model.riseDistributionType == 11 ? @">" : @""];
            self.qjL.textColor = CFallColor;
        }
        
        self.qjL.text = model.qujian;
        self.numbL.text = [NSString stringWithFormat:@"%ld%@",model.number,[APPLanguageService wyhSearchContentWith:@"ge"]];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
