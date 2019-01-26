//
//  SelectMemberCollectionCell.m
//  BT
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SelectMemberCollectionCell.h"

@implementation SelectMemberCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.backgroundColor = isNightMode?ViewContentBgColor:CWhiteColor;
    self.bgView.layer.cornerRadius = 4.0f;
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.borderWidth = 1.0f;
    self.bgView.layer.borderColor = isNightMode? SeparateLineNightColor.CGColor: kHEXCOLOR(0xE6E6E6).CGColor;
    self.memberHeadImg.layer.masksToBounds = YES;
    self.memberHeadImg.layer.cornerRadius = 18;
    self.memberHeadImg.contentMode = UIViewContentModeScaleAspectFill;
    self.nameL.textColor = FirstColor;
}

- (void)setModel:(ConatctModel *)model{
    _model = model;
    if(model){
        _nameL.text = model.nickName;
        //[_memberHeadImg setImageWithURL:[NSURL URLWithString:[SAFESTRING(model.avatar) hasPrefix:@"http"]?model.avatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.avatar]] placeholder:[UIImage imageNamed:@"morentouxiang"]];
        [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:model.avatar andImageView:_memberHeadImg andAuthStatus:model.authStatus andAuthType:model.authType addSuperView:self.contentView];
    }
}

@end
