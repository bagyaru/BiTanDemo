//
//  BTProfitLossHeaderView.m
//  BT
//
//  Created by apple on 2018/3/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTProfitLossHeaderView.h"

@interface BTProfitLossHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *shizhiL;

@property (weak, nonatomic) IBOutlet UILabel *cnyL;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;

@end

@implementation BTProfitLossHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
}

- (void)setData:(id)data{
    NSString *str = @"";
    if (kIsCNY) {
        str = @"CNY";
    }else{
        str = @"USD";
    }
    _data = data;
    
   // NSString *balance = [self decimalNumberWithDouble:[SAFESTRING(data[@"balance"]) doubleValue]];
    [self.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-zhengyan"] forState:UIControlStateNormal];
    if (ISNSStringValid([APPLanguageService readIsOrNoEyesType])) {
        
        if (ISStringEqualToString([APPLanguageService readIsOrNoEyesType], @"闭")) {
            
            self.cnyL.text = @"******";
            self.shizhiL.text = @"******";
            [self.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-biyan"] forState:UIControlStateNormal];
            
        } else {
            self.cnyL.text =[NSString stringWithFormat:@"≈%@%@",[[DigitalHelper shareInstance] isTransformWithDouble:[data[@"balance"] doubleValue]],str];
            self.shizhiL.text =[NSString stringWithFormat:@"%@BTC", @([SAFESTRING(data[@"currencyCount"]) doubleValue]).p8fString];
        }
    }else {
        
        self.cnyL.text =[NSString stringWithFormat:@"≈%@%@",[[DigitalHelper shareInstance] isTransformWithDouble:[data[@"balance"] doubleValue]],str];
        self.shizhiL.text =[NSString stringWithFormat:@"%@BTC", @([SAFESTRING(data[@"currencyCount"]) doubleValue]).p8fString];
    }
    
    //    if ([data[@"earnings"] floatValue] > 0) {
    //        self.amountLabel.textColor = CGreenColor;
    //        self.indicatorImgV.image =[UIImage imageNamed:@"green.png"] ;
    //    }else {
    //        
    //        self.amountLabel.textColor= CRedColor;
    //        self.indicatorImgV.image = [UIImage imageNamed:@"red.png"];
    //    }
    //    self.amountLabel.text =[NSString stringWithFormat:@"%@%@",str,[[DigitalHelper shareInstance] isTransformWithDouble:[data[@"earnings"] doubleValue]]];
    //    //[NSString stringWithFormat:@"%@%.2f",str,[data[@"earnings"] doubleValue] ];
    //    self.amountLabel.text = [self.amountLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    //
    //    self.shizhiLabel.text = [NSString stringWithFormat:@"%@%@",str,[[DigitalHelper shareInstance] isTransformWithDouble:[data[@"balance"] doubleValue]]];
    //self.chengbenLabel.text = [NSString stringWithFormat:@"%@%@",str,[[DigitalHelper shareInstance] isTransformWithDouble:([data[@"balance"] doubleValue]- [data[@"earnings"] doubleValue])]];
    //    self.amountL.text =[NSString stringWithFormat:@"数量:%.3f",[data[@"count"] doubleValue] ];
}
- (IBAction)eyeBtnClick:(UIButton *)sender {
    
    if (ISNSStringValid([APPLanguageService readIsOrNoEyesType])) {
        
        if (ISStringEqualToString([APPLanguageService readIsOrNoEyesType], @"闭")) {
            
            [self.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-zhengyan"] forState:UIControlStateNormal];
            [APPLanguageService writeIsOrNoEyesType:@"睁"];
        } else {
            [AnalysisService alaysisMine_income_card_behind];
            [self.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-biyan"] forState:UIControlStateNormal];
            [APPLanguageService writeIsOrNoEyesType:@"闭"];
        }
    }else {
        [AnalysisService alaysisMine_income_card_behind];
        [self.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-biyan"] forState:UIControlStateNormal];
        [APPLanguageService writeIsOrNoEyesType:@"闭"];
    }
    self.data = _data;
    [[NSNotificationCenter  defaultCenter] postNotificationName:NSNotification_HiddenAssets object:nil];
}

- (NSString*)decimalNumberWithDouble:(double)conversionValue{
    NSString *doubleString        = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

@end
