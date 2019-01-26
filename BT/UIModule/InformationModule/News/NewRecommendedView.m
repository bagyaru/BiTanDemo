//
//  NewRecommendedView.m
//  BT
//
//  Created by admin on 2018/4/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewRecommendedView.h"

@implementation NewRecommendedView

-(void)setModel:(FastInfomationObj *)model {
    _model = model;
    ViewRadius(self.iconIV, 3);
    self.titleL.text = model.title;
    [getUserCenter setLabelSpace:self.titleL withValue:model.title withFont:FONT(@"PingFangSC-Medium", 16) withHJJ:4.0 withZJJ:0.0];
    self.sourceL.text = [NSString stringWithFormat:@"%@：%@ ·%@",[APPLanguageService wyhSearchContentWith:@"source"],model.source,model.timeFormat];
    self.viewCountL.text = [NSString stringWithFormat:@"%ld%@",(long)model.viewCount,[APPLanguageService wyhSearchContentWith:@"yuedu"]];
    model.imgUrl = SAFESTRING(model.imgUrl);
    [self.iconIV sd_setImageWithURL:[NSURL URLWithString:[model.imgUrl hasPrefix:@"http"]?model.imgUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.imgUrl]] placeholderImage:[UIImage imageNamed:@"Mask_list"]];
}
-(CGFloat)getHeadViewHeight {
    
    CGFloat H = [getUserCenter getSpaceLabelHeight:_model.title withFont:FONT(@"PingFangSC-Medium", 16) withWidth:ScreenWidth-30 withHJJ:4.0 withZJJ:0.0]+1;
    return H+254;
}
@end
