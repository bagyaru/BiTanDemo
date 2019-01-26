//
//  LncomeStatisticsMainHeadView.m
//  BT
//
//  Created by admin on 2018/3/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LncomeStatisticsMainHeadView.h"

@implementation LncomeStatisticsMainHeadView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.paixunBtn setTitleColor:FirstColor forState:UIControlStateNormal];
    self.backgroundColor = ViewBGColor;
    [self.paixuSJb setImage:[UIImage imageNamed:@"Shape"] forState:UIControlStateNormal];
}

- (IBAction)goBackBtnClick:(UIButton *)sender {
    
    [BTCMInstance popViewController:nil];
}

- (void)setObj:(LncomeStatisticsMainObj *)obj{
    _obj = obj;
    if(obj){
        [self refreshUI];
    }
}

- (void)refreshUI{
    [self.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-zhengyan"] forState:UIControlStateNormal];
    if (ISNSStringValid([APPLanguageService readIsOrNoEyesType])) {
        
        if (ISStringEqualToString([APPLanguageService readIsOrNoEyesType], @"闭")) {
            
            self.shiZhiL.text = @"******";
            self.benjinL.text = @"******";
            self.fitLosL.text = @"******";
            self.totalLosL.text = @"******";
            self.shizhiMoneyL.text = @"******";
            [self.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-biyan"] forState:UIControlStateNormal];
            
        } else {
            
            NSString *unit = [BTHelperMethod signStr];
            self.shiZhiL.text = [NSString stringWithFormat:@"%@BTC",[DigitalHelperService isp8DataWithDouble:_obj.positionCapitalizationCurrency]];
            self.benjinL.text = [NSString stringWithFormat:@"%@BTC",[DigitalHelperService isp8DataWithDouble:_obj.positionCapitalCurrency]];
            self.fitLosL.text =[NSString stringWithFormat:@"%@BTC",[DigitalHelperService isp8DataWithDouble:_obj.positionGainAndLossCurrency]];
            
            self.shizhiMoneyL.text = [NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService transformWith:_obj.positionCapitalization]];
            
            //            self.totalLosL.text =[NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService transformWith:_obj.totalGainAndLoss]];
            [self.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-zhengyan"] forState:UIControlStateNormal];
            
        }
    }else {
        
        NSString *unit = [BTHelperMethod signStr];
        self.shiZhiL.text = [NSString stringWithFormat:@"%@BTC",[DigitalHelperService isp8DataWithDouble:_obj.positionCapitalizationCurrency]];
        self.benjinL.text = [NSString stringWithFormat:@"%@BTC",[DigitalHelperService isp8DataWithDouble:_obj.positionCapitalCurrency]];
        self.fitLosL.text =[NSString stringWithFormat:@"%@BTC",[DigitalHelperService isp8DataWithDouble:_obj.positionGainAndLossCurrency]];
        
        self.shizhiMoneyL.text = [NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService transformWith:_obj.positionCapitalization]];
    }
}
- (IBAction)btnClick:(id)sender {
    
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
    [self refreshUI];
    [[NSNotificationCenter  defaultCenter] postNotificationName:NSNotification_HiddenAssets object:nil];
}

@end
