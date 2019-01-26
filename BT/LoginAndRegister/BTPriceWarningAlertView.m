//
//  BTPriceWarningAlertView.m
//  BT
//
//  Created by admin on 2018/11/28.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTPriceWarningAlertView.h"

@implementation BTPriceWarningAlertView
-(void)awakeFromNib {
    
    [super awakeFromNib];
    self.anamationIV.image = [UIImage imageNamed:@"预警箭头01"];
    NSMutableArray *loadingImages = @[].mutableCopy;
    for (NSInteger i = 1; i < 4; i++) {
        [loadingImages addObject:[UIImage imageNamed:[NSString stringWithFormat:@"预警箭头0%ld",i]]];
    }
    [self.anamationIV setAnimationImages:loadingImages];
    [self.anamationIV setAnimationDuration:loadingImages.count * 0.3];
    [self.anamationIV setAnimationRepeatCount:0];
    
}
-(void)setTitle:(NSString *)title {
    
    if (title) {
        [self.anamationIV startAnimating];
        _title = title;
        ViewRadius(self, 8);
        if (ISNSStringValid(SAFESTRING(title))) {
            NSArray *titleArr = [title componentsSeparatedByString:@"|"];
            self.labelTitle.text    = titleArr[1];
            self.labelContent.text    = titleArr[2];
            if ([titleArr[0] integerValue] == 1) {//涨
                self.zhangOrDieIV.image = IMAGE_NAMED(@"预警弹窗-涨");
            }else {
                self.zhangOrDieIV.image = IMAGE_NAMED(@"预警弹窗-跌");
            }
        }
    }
    
}
-(void)setDict:(NSDictionary *)dict {
    
    if (dict) {
        _dict = dict;
    }
    
}

- (IBAction)goDetailBtnClick:(UIButton *)sender {
    if (self.dict.count > 0) {
        [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:self.dict];
    }
}
@end
