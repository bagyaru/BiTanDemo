//
//  JJSSQCell.m
//  BT
//
//  Created by admin on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "JJSSQCell.h"
#import "BTExchangeModel.h"
#import "BTSearchService.h"
@implementation JJSSQCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.sqBtn setTitleColor:SecondColor forState:UIControlStateNormal];
}
-(void)setExchangeName:(NSString *)exchangeName {
    NSArray *exchangeArray = [exchangeName componentsSeparatedByString:@" "];
    _exchangeName = exchangeName;
    self.jjsNameL.text = exchangeArray[0];
    if (!kIszh_hans) {
        
        if (ISStringEqualToString(exchangeArray[0], @"币安")) self.jjsNameL.text = @"Binance";
        if (ISStringEqualToString(exchangeArray[0], @"火币pro")) self.jjsNameL.text = @"Houbi";
    }
    if ([[BTSearchService sharedService] readExchangeAuthorizedWithExchangeName:exchangeArray[0] userId:[NSString stringWithFormat:@"%ld",getUserCenter.userInfo.userId]]) {
        ViewBorderRadius(self.sqBtn, 2, 0.0, kHEXCOLOR(0x00ac1e));
        [self.sqBtn setTitle:[APPLanguageService wyhSearchContentWith:@"yishouquan"] forState:UIControlStateNormal];
        [self.sqBtn setBackgroundColor:kHEXCOLOR(0x108EE9)];
        [self.sqBtn setTitleColor:kHEXCOLOR(0xffffff) forState:UIControlStateNormal];
        [self.sqBtn setImage:IMAGE_NAMED(@"ic_yiwancheng") forState:UIControlStateNormal];
    }else {
        ViewBorderRadius(self.sqBtn, 2, 0.5, SecondColor);
        [self.sqBtn setBackgroundColor:isNightMode? ViewContentBgColor :CWhiteColor];
        [self.sqBtn setTitleColor:SecondColor forState:UIControlStateNormal];
        [self.sqBtn setImage:IMAGE_NAMED(@"") forState:UIControlStateNormal];
        [self.sqBtn setTitle:[APPLanguageService wyhSearchContentWith:@"dianjishouquan"] forState:UIControlStateNormal];
    }
}
- (IBAction)authorizedClick:(BTButton *)sender {
    
    NSArray *exchangeArray = [_exchangeName componentsSeparatedByString:@" "];
    if (ISStringEqualToString(exchangeArray[0], @"币安")) [AnalysisService alaysisClick_Authorization_bian];
    if (ISStringEqualToString(exchangeArray[0], @"火币pro")) [AnalysisService alaysisClick_Authorization_huobi];
    if (ISStringEqualToString(exchangeArray[0], @"OKEx")) [AnalysisService alaysisClick_Authorization_OKex];
    if ([[BTSearchService sharedService] readExchangeAuthorizedWithExchangeName:exchangeArray[0] userId:[NSString stringWithFormat:@"%ld",getUserCenter.userInfo.userId]]) {
        
        BTExchangeModel *model = [[BTSearchService sharedService] readExchangeAuthorizedBackWithExchangeName:exchangeArray[0]];
        //[[BTSearchService sharedService] writeExchangeAuthorized:model];
        [BTCMInstance pushViewControllerWithName:@"BTExchangeAuthorization" andParams:@{@"model":model}];
        
    }else {
        
        BTExchangeModel *model = [[BTExchangeModel alloc] init];
        model.exchangeName     = exchangeArray[0];
        model.exchangeCode     = exchangeArray[1];
        model.userId = SAFESTRING(@(getUserCenter.userInfo.userId));
        model.exchangeKey      = @"";
        model.exchangeSecret   = @"";
        model.isOrNoAuthorized = YES;
       // [[BTSearchService sharedService] writeExchangeAuthorized:model];
        [BTCMInstance pushViewControllerWithName:@"BTExchangeAuthorization" andParams:@{@"model":model}];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
