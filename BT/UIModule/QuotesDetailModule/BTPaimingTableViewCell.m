//
//  BTPaimingTableViewCell.m
//  BT
//
//  Created by apple on 2018/9/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPaimingTableViewCell.h"

@interface BTPaimingTableViewCell()
@property (weak, nonatomic) IBOutlet BTLabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConst;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heigthConst;

@end


@implementation BTPaimingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentL.layer.cornerRadius = 4.0f;
    self.contentL.layer.masksToBounds = YES;
}

//
- (void)setModel:(BTJianjieModel *)model{
    if(model){
        if(model.isNoEn){
            _nameL.text = SAFESTRING(model.name);
        }else{
            _nameL.fixText = SAFESTRING(model.name);
        }
        _contentL.text = SAFESTRING(model.content);
        NSDictionary *wordDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]};
        NSMutableAttributedString *wordLabelAttStr = [[NSMutableAttributedString alloc] initWithString:model.content  attributes:wordDic];
        _widthConst.constant =  wordLabelAttStr.size.width + 12.0f;
        if(wordLabelAttStr.size.width + 12 > 30){
            _heigthConst.constant = 24.0f;
        }
    }
}


@end
