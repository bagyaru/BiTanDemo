//
//  BTContactUsCell.m
//  BT
//
//  Created by admin on 2018/9/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTContactUsCell.h"

@implementation BTContactUsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(BTContactUsModel *)model {
    
    if (model) {
        _model = model;
        self.typeL.text = kIszh_hans ? model.nameCN : model.nameEN;
        self.contentL.text = model.value;
        self.contentL.textColor = model.opType == 1 ? CFontColor16 : MainBg_Color;
        if (model.opType == 2) {//链接
            self.contentL.copyBlock = ^(NSString *commentID, NSString *userName) {
                
                [self jumpH5];
            };
        }
    }
}
- (void)jumpH5 {
    
    H5Node *node =[[H5Node alloc] init];
    node.webUrl  = [NSString stringWithFormat:@"%@%@",_model.urlHead,_model.value];
    [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
