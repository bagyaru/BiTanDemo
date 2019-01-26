//
//  LncomeStatisticsMainHeadView.m
//  BT
//
//  Created by admin on 2018/3/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ExchangeProfitHeadView.h"

@implementation ExchangeProfitHeadView

- (IBAction)goBackBtnClick:(UIButton *)sender {
    
    [BTCMInstance popViewController:nil];
}

- (void)setObj:(LncomeStatisticsMainObj *)obj{
    _obj = obj;
    if(obj){
        [self refreshUI];
    }
}

- (void)setInfo:(NSDictionary *)info{
    _info = info;
    if(info){
        [self refreshUI];
    }
}
- (void)refreshUI{
    
    NSString *shiZhi = [DigitalHelperService isp8DataWithDouble:[_info[@"legalTendeCurrency"] doubleValue]];
    NSArray *exchangeVOList = _info[@"exchangeVOList"];
    NSDictionary *detailInfo = [exchangeVOList firstObject];
    
    NSString *kyValue = [DigitalHelperService isp8DataWithDouble:[detailInfo[@"legalTendeCurrency"] doubleValue]];
    NSString *djValue = [DigitalHelperService isp8DataWithDouble:[detailInfo[@"freezeLegalTendeCurrency"] doubleValue]];
    
    [self.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-zhengyan"] forState:UIControlStateNormal];
    if (ISNSStringValid([APPLanguageService readIsOrNoEyesType])) {
        
        if (ISStringEqualToString([APPLanguageService readIsOrNoEyesType], @"闭")) {
            
            self.shiZhiL.text = @"******";
            self.benjinL.text = @"******";
            self.fitLosL.text = @"******";
//            self.totalLosL.text = @"******";
            [self.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-biyan"] forState:UIControlStateNormal];
            
        } else {
            self.shiZhiL.text = [NSString stringWithFormat:@"%@BTC",shiZhi];
            self.benjinL.text = [NSString stringWithFormat:@"%@BTC",kyValue];
            self.fitLosL.text =[NSString stringWithFormat:@"%@BTC",djValue];
            [self.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-zhengyan"] forState:UIControlStateNormal];
        }
    }else {
        
        self.shiZhiL.text = [NSString stringWithFormat:@"%@BTC",shiZhi];
        self.benjinL.text = [NSString stringWithFormat:@"%@BTC",kyValue];
        self.fitLosL.text =[NSString stringWithFormat:@"%@BTC",djValue];
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
