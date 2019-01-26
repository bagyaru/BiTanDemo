//
//  StrategyCell.m
//  BT
//
//  Created by admin on 2018/1/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "StrategyCell.h"

@implementation StrategyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)creatUIWith:(FastInfomationObj *)obj {
    
    self.titleL.text = obj.title;
    [getUserCenter getLabelHight:self.titleL Float:4 AddImage:NO];
    self.sourceL.text = [NSString stringWithFormat:@"%@：%@ ·%@",[APPLanguageService wyhSearchContentWith:@"source"],obj.source,obj.timeFormat];
    [self.viewCountL setTitle:[NSString stringWithFormat:@"%ld%@",(long)obj.viewCount,[APPLanguageService wyhSearchContentWith:@"yuedu"]] forState:UIControlStateNormal];
   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
