//
//  XHMiddeCell.m
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "XHMiddeCell.h"

@implementation XHMiddeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)creatUIWith:(XianHuoMainObj *)obj {
    
    self.guanwangdizhiL.text = obj.exchangeWebsiteAddress;
    self.goujiaL.text = obj.countryName;
    self.paimingL.text = [NSString stringWithFormat:@"NO.%ld",obj.ranking];
    
    if (obj.turnoverCNY >= YI) {//大于1亿
        
        self.chengjiaoliangL1.text = [NSString stringWithFormat:@"¥%.2f%@",obj.turnoverCNY/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
    }else if (obj.turnoverCNY > 0 && obj.turnoverCNY < YI){//大于0 且小于1亿
        
        self.chengjiaoliangL1.text = [NSString stringWithFormat:@"¥%.2f%@",obj.turnoverCNY/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
    }else {
        
        self.chengjiaoliangL1.text = [APPLanguageService wyhSearchContentWith:@"zanwushuju"];
    }
    if (obj.turnoverUSD >= YI) {
        
        self.chengjiaoliangL2.text = [NSString stringWithFormat:@"%@%.2f%@",[APPLanguageService wyhSearchContentWith:@"yue"],obj.turnoverUSD/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
    }else  if (obj.turnoverUSD > 0 && obj.turnoverUSD < YI){
        
        self.chengjiaoliangL2.text = [NSString stringWithFormat:@"%@%.2f%@",[APPLanguageService wyhSearchContentWith:@"yue"],obj.turnoverUSD/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
    }else {
        
        self.chengjiaoliangL2.text = [APPLanguageService wyhSearchContentWith:@"zanwushuju"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
