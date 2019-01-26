//
//  BTICOListCell.m
//  BT
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTICOListCell.h"

@interface BTICOListCell()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *icoDegreL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *tagL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidthCons;

@end


@implementation BTICOListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.bgView.layer.cornerRadius = 8.0f;
    self.bgView.layer.masksToBounds = NO;
    
    self.bgView.layer.shadowColor = rgba(0, 0, 0, 1).CGColor;
    self.bgView.layer.shadowOpacity = 0.05f;
    self.bgView.layer.shadowRadius = 6.0f;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.imageV.layer.cornerRadius = 20.0f;
    self.imageV.layer.masksToBounds = YES;
    self.icoDegreL.textColor = FirstColor;
}

- (void)setModel:(BTICOListModel *)model{
    _model = model;
    if(model){
        _titleL.text = model.icoCode;
        _tagL.text = model.needIcoSignboard;
        _timeL.text = model.collectEndTime;
        
        CGSize size = [SAFESTRING(model.icoSignboardEn) boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:FONTOFSIZE(12.0f)} context:nil].size;
        _tagL.layer.cornerRadius = 2.0f;
        _tagL.layer.masksToBounds = YES;
        _tagL.layer.borderColor = SeparateColor.CGColor;
        _tagL.layer.borderWidth = 0.5;
        _tagL.textAlignment = NSTextAlignmentCenter;
        _iconWidthCons.constant = size.width + 10;
        
        if(SAFESTRING(model.collectProgress).length == 0 ||[SAFESTRING(model.collectProgress) containsString:@"nan"]){
            _icoDegreL.text = @"--";
        }else{
            if([model.collectProgress containsString:@"/"]){
                NSMutableAttributedString *mutaAttrStr = [[NSMutableAttributedString alloc] initWithString:model.collectProgress];
                NSString *leftStr = [model.collectProgress componentsSeparatedByString:@"/"].firstObject;
                [mutaAttrStr addAttributes:@{NSForegroundColorAttributeName:kHEXCOLOR(0x108ee9)} range:[model.collectProgress rangeOfString:leftStr]];
                _icoDegreL.attributedText = mutaAttrStr;
            }else{
                _icoDegreL.text = model.collectProgress;
            }
        }
        model.icoIcon = SAFESTRING(model.icoIcon);
        [_imageV sd_setImageWithURL:[NSURL URLWithString:[model.icoIcon hasPrefix:@"http"]?model.icoIcon:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.icoIcon]] placeholderImage:[UIImage imageNamed:@"Mask_list"]];
    }
}

@end
