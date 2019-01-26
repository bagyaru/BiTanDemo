//
//  BTProfitLossCurveHeaderView.m
//  BT
//
//  Created by apple on 2018/3/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTProfitLossCurveHeaderView.h"

@interface BTProfitLossCurveHeaderView()


@property (weak, nonatomic) IBOutlet UILabel *totolPrice;
@property (weak, nonatomic) IBOutlet UILabel *profitLossLabel;

//@property (weak, nonatomic) IBOutlet UIImageView *indicator;

@end

@implementation BTProfitLossCurveHeaderView

- (void)setDetailObj:(LncomeStatisticsMainObj *)detailObj{
    _detailObj =detailObj;
//    NSString *str = @"";
//    if (kIsCNY) {
//        str = @"¥";
//    }else{
//        str = @"$";
//    }
    NSString *str = @"";
    if (kIsCNY) {
        str = @"CNY";
    }else{
        str = @"USD";
    }
//    if (self.detailObj.balance > 1 || self.detailObj.balance < -1) {
//        self.totolPrice.text = [NSString stringWithFormat:@"%@%@",str,@(self.detailObj.balance).p2fString];
//    }else if(self.detailObj.balance < 1 && self.detailObj.balance >-1){
//        self.totolPrice.text = [NSString stringWithFormat:@"%@%@",str,@(self.detailObj.balance).p8fString];
//    }else{
//        self.totolPrice.text = [NSString stringWithFormat:@"%@%f",str,self.detailObj.balance];
//    }
//    if (self.detailObj.earnings > 1 || self.detailObj.earnings < -1) {
//        self.profitLossLabel.text =[NSString stringWithFormat:@"%@%@",str,@(self.detailObj.earnings).p2fString];
//
//    }else if(self.detailObj.earnings < 1 && self.detailObj.earnings > -1){
//        self.profitLossLabel.text =[NSString stringWithFormat:@"%@%@",str,@(self.detailObj.earnings).p8fString];
//    }else{
//        self.profitLossLabel.text =[NSString stringWithFormat:@"%@%f",str,self.detailObj.earnings];
//    }
//    if (self.detailObj.earnings > 0) {
//        self.profitLossLabel.textColor = CGreenColor;
//        self.indicator.image =[UIImage imageNamed:@"green.png"];
//
//    }else {
//        self.profitLossLabel.textColor =CRedColor;
//        self.indicator.image =[UIImage imageNamed:@"red.png"];
//    }
//    self.profitLossLabel.text = [self.profitLossLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    
    self.totolPrice.text =[NSString stringWithFormat:@"%@BTC",@(detailObj.currencyCount).p8fString];
    self.profitLossLabel.text =[NSString stringWithFormat:@"≈%@%@",[[DigitalHelper shareInstance] isTransformWithDouble:detailObj.balance],str];
}
- (NSString*)decimalNumberWithDouble:(double)conversionValue{
    NSString *doubleString        = [NSString stringWithFormat:@"%lf", conversionValue];
    NSDecimalNumber *decNumber    = [NSDecimalNumber decimalNumberWithString:doubleString];
    return [decNumber stringValue];
}

@end
