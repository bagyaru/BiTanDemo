//
//  BTICOItemView.m
//  BT
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTICOItemView.h"

@interface BTICOItemView()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *tagL;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

@end

@implementation BTICOItemView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setViewRadius:self];
    self.imageV.layer.cornerRadius = 18.0f;
    self.imageV.layer.masksToBounds = YES;
}

- (void)setViewRadius:(UIView*)view{
    view.layer.cornerRadius = 8.0f;
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = kHEXCOLOR(0x000000).CGColor;
    if(isNightMode){
        view.layer.shadowOpacity = 0.31f;
    }else{
        view.layer.shadowOpacity = 0.05f;
    }
    view.layer.shadowRadius = 6.0f;
    view.layer.shadowOffset = CGSizeMake(0, 0);
}

- (void)setModel:(BTICOListModel *)model{
    _model = model;
    if(model){
        _titleL.text = model.icoCode;
        _tagL.text = model.icoSignboardEn;
        _status.text = model.collectEndTime;
        model.icoIcon = SAFESTRING(model.icoIcon);
        [_imageV sd_setImageWithURL:[NSURL URLWithString:[model.icoIcon hasPrefix:@"http"]?model.icoIcon:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.icoIcon]] placeholderImage:[UIImage imageNamed:@"Mask_list"]];
    }
}
@end
