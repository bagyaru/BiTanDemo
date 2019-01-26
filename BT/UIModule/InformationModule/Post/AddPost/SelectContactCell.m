//
//  SelectContactCell.h
//  BT
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SelectContactCell.h"

@implementation SelectContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _selectedBtn.userInteractionEnabled = NO;
    _contactAvatarImg.contentMode = UIViewContentModeScaleAspectFill;
    _contactAvatarImg.layer.cornerRadius = 18;
    _contactAvatarImg.layer.masksToBounds = YES;
}

- (void)setModel:(ConatctModel *)model{
    _model = model;
    if(model){
        _contactNameLabel.text = model.nickName;
        //[_contactAvatarImg setImageWithURL:[NSURL URLWithString:[SAFESTRING(model.avatar) hasPrefix:@"http"]?model.avatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.avatar]] placeholder:[UIImage imageNamed:@"morentouxiang"]];
        [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:model.avatar andImageView:_contactAvatarImg andAuthStatus:model.authStatus andAuthType:model.authType addSuperView:self.contentView];
        if(model.isSelected){
            [self.selectedBtn setImage:[UIImage imageNamed:@"select_user"] forState:(UIControlStateNormal)];
        }else {
            [self.selectedBtn setImage:[UIImage imageNamed:@"unselect_user"] forState:(UIControlStateNormal)];
        }
    }
}

@end
