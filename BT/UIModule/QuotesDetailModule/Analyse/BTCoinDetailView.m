//
//  BTCoinDetailView.m
//  BT
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTCoinDetailView.h"
#import "NSDate+Extent.h"
@interface BTCoinDetailView()

@property (weak, nonatomic) IBOutlet BTLabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;

@property (weak, nonatomic) IBOutlet BTLabel *countL;
@property (weak, nonatomic) IBOutlet UILabel *eL;

@end

@implementation BTCoinDetailView

- (void)setDetailModel:(BTAddressDetailModel *)detailModel{
    _detailModel = detailModel;
    if(detailModel){
        NSString *dateStr = [NSDate getTimeStrFromInterval:SAFESTRING(detailModel.date) andFormatter:@"yyyy"];
        NSDate *nowDate = [NSDate date];
        NSString *nowDateStr = SAFESTRING(@(nowDate.year));
        if([dateStr isEqualToString:nowDateStr]){ //本年的去掉年份
            self.timeL.text = [NSDate getTimeStrFromInterval:SAFESTRING(detailModel.date) andFormatter:@"MM-dd HH:mm"];
        }else{
            self.timeL.text = [NSDate getTimeStrFromInterval:SAFESTRING(detailModel.date) andFormatter:@"yyyy-MM-dd HH:mm"];
        }
        self.priceL.text = [DigitalHelperService transformWith:detailModel.price];
        self.countL.text = [DigitalHelperService transformWith:detailModel.quantity];
        self.eL.text = [DigitalHelperService transformWith:detailModel.turnover];
        UIColor *color;
        if([[SAFESTRING(detailModel.direction) lowercaseString] isEqualToString:@"in"]){//买入
            color = kHEXCOLOR(0x18c051);
        }else{
            color = kHEXCOLOR(0xe63a1a);
        }
        self.timeL.textColor = color;
        self.priceL.textColor = color;
        self.countL.textColor = color;
        self.eL.textColor = color;
    }
}

@end
