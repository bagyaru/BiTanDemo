//
//  QiHuoMainCell.m
//  BT
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QiHuoMainCell.h"

@interface QiHuoMainCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation QiHuoMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.bgView.layer.shadowColor = kHEXCOLOR(0x20212A).CGColor;
    self.bgView.layer.shadowOpacity = 0.06f;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    
}
-(void)creatUIWith:(QiHuoMainObj *)obj {
    
    self.titleL.text = obj.contractCode;
    self.heyuemingchengL.text = obj.contractName;
    self.changpingdaimaL.text = obj.productCode;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
