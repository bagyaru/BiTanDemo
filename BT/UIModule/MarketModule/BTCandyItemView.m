//
//  NewRecommendedView.m
//  BT
//
//  Created by admin on 2018/4/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTCandyItemView.h"

@implementation BTCandyItemView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setViewRadius:self];
}

- (void)setModel:(FastInfomationObj *)model {
    _model = model;
    //    ViewRadius(self.iconIV, 3);
    self.iconIV.contentMode = UIViewContentModeScaleAspectFill;
    CGRect frame = CGRectMake(0, 0, VIEW_W(self), VIEW_H(self.iconIV));
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8,8)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = frame;
    maskLayer.path = maskPath.CGPath;
    self.iconIV.layer.mask = maskLayer;
    
    [getUserCenter setLabelSpace:self.titleL withValue:model.title withFont:SYSTEMFONT(14) withHJJ:4.0 withZJJ:0.0];
    self.sourceL.text = [getUserCenter NewTimePresentationStringWithTimeStamp:model.issueDate];
    
    //[NSString stringWithFormat:@"%ld %@",model.receiveNum,[APPLanguageService sjhSearchContentWith:@"renyiling"]];
//    self.viewCountL.text = [NSString stringWithFormat:@"%@",model.timeFormat];
    self.viewCountL.text = @"";
    model.imgUrl = SAFESTRING(model.imgUrl);
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:[model.imgUrl hasPrefix:@"http"]?model.imgUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.imgUrl]] placeholderImage:[UIImage imageNamed:@"Mask_list"]];
}
- (CGFloat)getHeadViewHeight {
    
    CGFloat H = [getUserCenter getSpaceLabelHeight:_model.title withFont:SYSTEMFONT(16) withWidth:ScreenWidth-30 withHJJ:4.0 withZJJ:0.0]+1;
    return H+254;
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

@end
