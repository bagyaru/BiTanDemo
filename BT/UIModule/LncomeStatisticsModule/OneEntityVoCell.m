//
//  OneEntityVoCell.m
//  BT
//
//  Created by admin on 2018/3/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OneEntityVoCell.h"
#import "BTHelperMethod.h"
@implementation OneEntityVoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.earningsBtn setTitleColor:FirstColor forState:UIControlStateNormal];
}
-(void)creatUIWith:(OneEntityVoObj *)obj {
    

     if (ISStringEqualToString([APPLanguageService readIsOrNoEyesType], @"闭")) {
         if (obj.jjsOrjjb == 20) {//交易币
             self.kindNameL.text = obj.kind;
             if([obj.kind isEqualToString:@"BTC"]){
                  self.unitPriceL.text = @"";
             }else{
                  self.unitPriceL.text = @"******";
             }
            
             
         }else {
             self.kindNameL.text = obj.exchangeName;
             if (!kIszh_hans) {
                 
                 if (ISStringEqualToString(obj.exchangeName, @"币安")) self.kindNameL.text = @"Binance";
                 if (ISStringEqualToString(obj.exchangeName, @"火币pro")) self.kindNameL.text = @"Houbi";
             }
              self.unitPriceL.text = @"";
         }
         [self.earningsBtn setTitle:@"******" forState:UIControlStateNormal];
         self.numberAndTotalPriceL.text = @"";
         
     }else {
//         NSString *unit = [BTHelperMethod signStr];
         
         if (obj.jjsOrjjb == 20) {//交易币
             self.topConst.constant = 23.0f;
             
             
             self.kindNameL.text = obj.kind;
            
             self.numberAndTotalPriceL.text =@""; //[NSString stringWithFormat:@"%@：%@%@",[APPLanguageService sjhSearchContentWith:@"chicangyingkui"],unit,[DigitalHelperService isTransformWithDouble:obj.positionGainAndLoss]];
             
             if([obj.kind isEqualToString:@"BTC"]){
                 self.countTopCons.constant = 23.0f;
                 self.unitPriceL.text = @"";
                  [self.earningsBtn setTitle:[NSString stringWithFormat:@"%@",@(obj.positionCount).p8fString] forState:UIControlStateNormal];
             }else{
                 self.countTopCons.constant = 12.0f;
                 self.unitPriceL.text = [NSString stringWithFormat:@"≈%@BTC",[DigitalHelperService isp8DataWithDouble:obj.positionCapitalizationCurrency]];
                 [self.earningsBtn setTitle:[NSString stringWithFormat:@"%@",@(obj.positionCount).p8fString] forState:UIControlStateNormal];
             }
         }else {//交易所
             
             self.topConst.constant = 23.0f;
             self.countTopCons.constant = 23.0f;
             self.kindNameL.text = obj.exchangeName;
             if (!kIszh_hans) {
                 
                 if (ISStringEqualToString(obj.exchangeName, @"币安")) self.kindNameL.text = @"Binance";
                 if (ISStringEqualToString(obj.exchangeName, @"火币pro")) self.kindNameL.text = @"Houbi";
             }
             [self.earningsBtn setTitle:[NSString stringWithFormat:@"%@%@",@(obj.btcCount).p8fString,@"BTC"] forState:UIControlStateNormal];
             self.numberAndTotalPriceL.text = @"";
             self.unitPriceL.text = @"";//[NSString stringWithFormat:@"≈%@%@",[BTHelperMethod signStr],kIsCNY? [self priceWeishuWith:obj.priceCny]:[self priceWeishuWith:obj.priceUsd]];
             
         }
     }
}
-(NSString *)priceWeishuWith:(double)nub {
    
    if (nub > 1 || nub < -1) {
        
        return [NSString stringWithFormat:@"%@",@(nub).p2fString];
    }else if(nub < 1 && nub >-1){
        
        return [NSString stringWithFormat:@"%@",@(nub).p8fString];
    }else{
        
        return  [NSString stringWithFormat:@"%.0f",nub];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
