//
//  BTJingCaiMainCell.m
//  BT
//
//  Created by admin on 2018/7/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTJingCaiMainCell.h"

@implementation BTJingCaiMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setSelectIndex:(NSInteger)selectIndex {
    
    _selectIndex = selectIndex;
}
-(void)setModel:(BTjingcaiMainModel *)model {
    
    if (model) {
        _model = model;
        if (self.selectIndex == 1) {
            self.JCZ_View.hidden = NO;
            self.YKJ_View.hidden = YES;
            self.JCZ_View_Height.constant = 78;
            self.YKJ_View_Height.constant = 0;
        }else {
            
            self.JCZ_View.hidden = YES;
            self.YKJ_View.hidden = NO;
            self.JCZ_View_Height.constant = 0;
            self.YKJ_View_Height.constant = 40;
        }
    }
    
}
- (IBAction)zhiciOrFanduiBtnClick:(UIButton *)sender {
   
    if (self.JCBlock) {
        self.JCBlock(sender.tag, self.model);
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
