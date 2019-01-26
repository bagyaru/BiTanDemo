//
//  LncomeStatisticsMainHeadView.m
//  BT
//
//  Created by admin on 2018/3/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ProfitHeadView.h"

@implementation ProfitHeadView

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
    
    NSString *currentUnit =@"";
    NSString *currentStr =@"";
    if([self.obj.currencySymbol isEqualToString:@"CNY"] ||[self.obj.currencySymbol isEqualToString:@"USD"]){
        currentUnit = [BTHelperMethod signStr];
        currentStr = @"";
    }else{
        currentUnit = @"";
        currentStr = self.obj.currencySymbol;
    }
    [self.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-zhengyan"] forState:UIControlStateNormal];
    if (ISNSStringValid([APPLanguageService readIsOrNoEyesType])) {
        
        if (ISStringEqualToString([APPLanguageService readIsOrNoEyesType], @"闭")) {
            
            self.shiZhiL.text = @"******";
            self.benjinL.text = @"******";
            self.fitLosL.text = @"******";
            self.totalLosL.text = @"******";
            [self.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-biyan"] forState:UIControlStateNormal];
            
        } else {
            
             if([self.obj.currencySymbol isEqualToString:@"CNY"] ||[self.obj.currencySymbol isEqualToString:@"USD"]){
                 self.shiZhiL.text = [NSString stringWithFormat:@"%@%@%@",currentUnit,[DigitalHelperService transformWith:_obj.positionCapitalizationCurrency],currentStr];
                 self.benjinL.text = [NSString stringWithFormat:@"%@%@%@",currentUnit,[DigitalHelperService transformWith:_obj.positionCapitalCurrency],currentStr];
                 self.fitLosL.text =[NSString stringWithFormat:@"%@%@%@",currentUnit,[DigitalHelperService transformWith:_obj.positionGainAndLossCurrency],currentStr];
                 
             }else{
                 self.shiZhiL.text = [NSString stringWithFormat:@"%@%@%@",currentUnit,[DigitalHelperService isp8DataWithDouble:_obj.positionCapitalizationCurrency],currentStr];
                 self.benjinL.text = [NSString stringWithFormat:@"%@%@%@",currentUnit,[DigitalHelperService isp8DataWithDouble:_obj.positionCapitalCurrency],currentStr];
                 self.fitLosL.text =[NSString stringWithFormat:@"%@%@%@",currentUnit,[DigitalHelperService isp8DataWithDouble:_obj.positionGainAndLossCurrency],currentStr];
             }
            
            
            
            
//            self.totalLosL.text =[NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService transformWith:_obj.totalGainAndLoss]];
            [self.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-zhengyan"] forState:UIControlStateNormal];
            
            //            self.costL.text = [NSString stringWithFormat:@"%@：%@%@",[APPLanguageService sjhSearchContentWith:@"chengbenjia"],unit,[DigitalHelperService isTransformWithDouble:_obj.costPrice]];
            
            self.currentPriceL.text = [NSString stringWithFormat:@"%@：%@%@%@",[APPLanguageService wyhSearchContentWith:@"dangqianjia"],currentUnit,[DigitalHelperService isTransformWithDouble:_obj.currentPriceCurrency],currentStr];
            //            self.countL.text = [NSString stringWithFormat:@"%@：%@",[APPLanguageService sjhSearchContentWith:@"chicangshuliang"],[DigitalHelperService isp6DataWithDouble:_obj.positionCount]];
        }
    }else {
        if([self.obj.currencySymbol isEqualToString:@"CNY"] ||[self.obj.currencySymbol isEqualToString:@"USD"]){
            self.shiZhiL.text = [NSString stringWithFormat:@"%@%@%@",currentUnit,[DigitalHelperService transformWith:_obj.positionCapitalizationCurrency],currentStr];
            self.benjinL.text = [NSString stringWithFormat:@"%@%@%@",currentUnit,[DigitalHelperService transformWith:_obj.positionCapitalCurrency],currentStr];
            self.fitLosL.text =[NSString stringWithFormat:@"%@%@%@",currentUnit,[DigitalHelperService transformWith:_obj.positionGainAndLossCurrency],currentStr];
            
        }else{
            self.shiZhiL.text = [NSString stringWithFormat:@"%@%@%@",currentUnit,[DigitalHelperService isp8DataWithDouble:_obj.positionCapitalizationCurrency],currentStr];
            self.benjinL.text = [NSString stringWithFormat:@"%@%@%@",currentUnit,[DigitalHelperService isp8DataWithDouble:_obj.positionCapitalCurrency],currentStr];
            self.fitLosL.text =[NSString stringWithFormat:@"%@%@%@",currentUnit,[DigitalHelperService isp8DataWithDouble:_obj.positionGainAndLossCurrency],currentStr];
        }
        [self.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-zhengyan"] forState:UIControlStateNormal];
        
        self.currentPriceL.text = [NSString stringWithFormat:@"%@：%@%@%@",[APPLanguageService wyhSearchContentWith:@"dangqianjia"],currentUnit,[DigitalHelperService isTransformWithDouble:_obj.currentPriceCurrency],currentStr];
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
