//
//  BTPromptUpdateView.m
//  BT
//
//  Created by admin on 2018/9/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPromptUpdateView.h"

@implementation BTPromptUpdateView

+ (void)showWithRecordModel:(THFVersionObj *)model completion:(BTPromptUpdateViewCompletionBlock)block{
    NSArray *nib =[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil];
    BTPromptUpdateView *alertView;
    if(nib){
        alertView = [nib lastObject];
        alertView.frame = [self frameOfAlert];
    }
    ViewRadius(alertView, 10);
    ViewRadius(alertView.updateBtn, 2);
    alertView.block = block;
    alertView.model = model;
    [alertView creatUI];
    [alertView show];
}

+ (CGRect)frameOfAlert{
    CGFloat width = 280;
    return CGRectMake(0, 0, width, 488);
}
-(void)creatUI {
    self.scrollView.scrollsToTop = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.titleL.text = [NSString stringWithFormat:@"%@%@",[APPLanguageService wyhSearchContentWith:@"faxianxinbanben"],self.model.releaseVersion];
    if (self.model.forceUpdate == 1) {
        self.cancelBtn.hidden = YES;
        self.isClickable = YES;
    }else {
        self.cancelBtn.hidden = NO;
        self.isClickable = NO;
    }
    NSArray *contentArray = [self.model.descriptionStr componentsSeparatedByString:@"\n"];
    CGFloat totalH = 0.0;
    CGFloat JianJu = 20;
    for (int i = 0; i < contentArray.count; i++) {
        UILabel *contentL = [[UILabel alloc] init];
        contentL.numberOfLines = 0;
        contentL.text = contentArray[i];
        CGFloat H = [getUserCenter getSpaceLabelHeight:contentArray[i] withFont:SYSTEMFONT(14) withWidth:250 withHJJ:10 withZJJ:0.0];
        contentL.frame    = CGRectMake(15, i*JianJu+totalH, 250, H);
        [getUserCenter setLabelSpace:contentL withValue:contentArray[i] withFont:SYSTEMFONT(14) withHJJ:10 withZJJ:0.0];
        [self.scrollView addSubview:contentL];
        
        totalH += H;
    }
    self.scrollView.contentSize = CGSizeMake(0, totalH+JianJu*contentArray.count);
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 280, 63) byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, 280, 63);
    maskLayer.path = maskPath.CGPath;
    self.downView.layer.mask = maskLayer;
}
- (IBAction)updateBtnClick:(UIButton *)sender {
    [self __hide];
    if (self.model.forceUpdate == 1) {
        
        NSLog(@"强制更新");
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.model.downloadUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        dispatch_async(dispatch_get_main_queue(), ^
                       {
                           exit(0);
                       });
        
    }else {
        //[self writeDatatime]; obj.releaseVersion obj.descriptionStr
        NSLog(@"提示更新");
       
       [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.model.downloadUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
    }
}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self __hide];
}
@end
