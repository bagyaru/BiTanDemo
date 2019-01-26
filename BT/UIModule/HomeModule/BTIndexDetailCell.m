//
//  BTIndexDetailCell.m
//  BT
//
//  Created by admin on 2018/6/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTIndexDetailCell.h"

@implementation BTIndexDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.sortL, 1);
    self.priceLeftConstant.constant = RELATIVE_WIDTH(168);
    // Initialization code
}
-(void)setModel:(BTBitaneIndexDetailModel *)model {
    
    if (model) {
        _model = model;
        self.sortL.text = SAFESTRING(@(self.index+1));
        self.hslL.text  = [NSString stringWithFormat:@"%@%%",@(model.weight*100).p2fString];
        
        if (!ISStringEqualToString(self.exchangeCode, @"BITANE")) {
            if (ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans)) {
              self.nameL.text = model.exchangeName;
            }else {
              self.nameL.text = model.exchangeCode;
            }
        }else {
            self.nameL.text = model.code;
        }
        NSString *unit = @"";
        if(kIsCNY){
            unit =@"¥";
            self.priceL.text =[NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService isTransformWithDouble:model.priceCN]];
            self.bottomPriceL.text=[NSString stringWithFormat:@"%@%@",@"$",[DigitalHelperService isTransformWithDouble:model.priceUS]];
        }else{
            unit =@"$";
            self.priceL.text =[NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService isTransformWithDouble:model.priceUS]];
            self.bottomPriceL.text=[NSString stringWithFormat:@"%@%@",@"¥",[DigitalHelperService isTransformWithDouble:model.priceCN]];
            }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
