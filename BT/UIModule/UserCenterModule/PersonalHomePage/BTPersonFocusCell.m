//
//  SelectContactCell.h
//  BT
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPersonFocusCell.h"

@implementation BTPersonFocusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _selectedBtn.userInteractionEnabled = NO;
    _contactAvatarImg.contentMode = UIViewContentModeScaleAspectFill;
    _contactAvatarImg.layer.cornerRadius = 18;
    _contactAvatarImg.layer.masksToBounds = YES;
    [self.selectedBtn setImage:[UIImage imageNamed:@"R箭头"] forState:UIControlStateNormal];
}

- (void)setModel:(ConatctModel *)model{
    _model = model;
    if(model){
        _contactNameLabel.text = model.nickName;
        //[_contactAvatarImg setImageWithURL:[NSURL URLWithString:[SAFESTRING(model.avatar) hasPrefix:@"http"]?model.avatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.avatar]] placeholder:[UIImage imageNamed:@"morentouxiang"]];
        
        [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:model.avatar andImageView:_contactAvatarImg andAuthStatus:model.authStatus andAuthType:model.authType addSuperView:self.contentView];
    }
}

@end
