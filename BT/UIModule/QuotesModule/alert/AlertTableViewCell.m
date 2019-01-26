//
//  AlertTableViewCell.m
//  BT
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AlertTableViewCell.h"

@interface AlertTableViewCell()


@end

@implementation AlertTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMoedl:(BTGroupListModel *)moedl{
    if(moedl){
        _moedl = moedl;
        _nameL.text = moedl.groupName;
    }
}

@end
