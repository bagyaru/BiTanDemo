//
//  BTInfomationSameCell.m
//  BT
//
//  Created by admin on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTCandyListCell.h"

@implementation BTCandyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)creatUIWith:(FastInfomationObj *)obj {
    
    self.titleL.text = obj.title;
    ViewRadius(self.iconIV, 2);
    [getUserCenter getLabelHight:self.titleL Float:4 AddImage:NO];
    self.sourceL.text = [getUserCenter NewTimePresentationStringWithTimeStamp:obj.issueDate];
    [self.viewCountL setTitle:[NSString stringWithFormat:@"%ld %@",(long)obj.receiveNum,[APPLanguageService sjhSearchContentWith:@"renyiling"]] forState:UIControlStateNormal];
    obj.imgUrl = SAFESTRING(obj.imgUrl);
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:[obj.imgUrl hasPrefix:@"http"]?obj.imgUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,obj.imgUrl]] placeholderImage:[UIImage imageNamed:@"Mask_list"]];
    
    if (ISNSStringValid(obj.imgUrl)) {
        
        self.imageIVWight.constant = 88;
    }else {
        
        self.imageIVWight.constant = 0;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
