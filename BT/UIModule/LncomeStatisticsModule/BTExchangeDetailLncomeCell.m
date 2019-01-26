//
//  BTExchangeDetailLncomeCell.m
//  BT
//
//  Created by admin on 2018/5/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTExchangeDetailLncomeCell.h"
#import "BTHelperMethod.h"
@implementation BTExchangeDetailLncomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.kind.text = dict[@"kind"];
    if (ISStringEqualToString([APPLanguageService readIsOrNoEyesType], @"闭")) {
        self.kyL.text  = @"******";
        self.kyValueL.text = @"******";
        self.djValueL.text = @"******";
        self.djL.text = @"******";
    }else {
        //可用数量
        self.kyL.text  =  @([SAFESTRING(dict[@"count"]) doubleValue]).p6fString;
        
        NSString *unit = [BTHelperMethod signStr];
        self.kyValueL.text = [NSString stringWithFormat:@"≈%@%@",unit,[DigitalHelperService isTransformWithDouble:[SAFESTRING(dict[@"legalTendePrice"]) doubleValue]]];
        
        self.djValueL.text = [NSString stringWithFormat:@"≈%@%@",unit,[DigitalHelperService isTransformWithDouble:[SAFESTRING(dict[@"freezeLegalTendePrice"]) doubleValue]]];
        self.djL.text = SAFESTRING(dict[@"freezeCount"]).length>0?SAFESTRING(dict[@"freezeCount"]):@"0";
    }
    
    
    //
    //
    //    count (number, optional): 可用数量 ,
    //    freezeCount (number, optional): 冻结数量 ,
    //    freezeLegalTendePrice (number, optional): 冻结数量对应法币价格 ,
    //    kind (string, optional): 币种 ,
    //    legalTendePrice (number, optional): 可用数量对应法币价格
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
