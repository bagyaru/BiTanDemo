//
//  ProfitRecordHeaderCell.m
//  BT
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ProfitRecordHeaderCell.h"
#import "BTSearchService.h"
@interface ProfitRecordHeaderCell()
//@property (weak, nonatomic) IBOutlet UILabel *avgBuyLabel;
//@property (weak, nonatomic) IBOutlet UILabel *avgSellLabel;

@end
@implementation ProfitRecordHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(id)data{
    _data =data;
    NSString *str = @"";
    if (kIsCNY) {
        str = @"¥";
    }else{
        str = @"$";
    }
//    self.avgBuyLabel.text = [NSString stringWithFormat:@"%@%.2f",str,[data[@"averageBuy"] floatValue] ];
//    self.avgSellLabel.text =[NSString stringWithFormat:@"%@%.2f",str,[data[@"averageSell"] floatValue] ];
    
//    self.avgBuyLabel.text = [NSString stringWithFormat:@"%@%@",str,[[DigitalHelper shareInstance] isTransformWithDouble:[data[@"averageBuy"] doubleValue]]];
//    self.avgSellLabel.text = [NSString stringWithFormat:@"%@%@",str,[[DigitalHelper shareInstance] isTransformWithDouble:[data[@"averageSell"] doubleValue]]];
    
}

//添加记录
- (IBAction)addRecord:(id)sender {
    
    [AnalysisService alaysisIncome_add_button];
    //[BTCMInstance pushViewControllerWithName:@"AddRecord" andParams:@{@"resultArray":@[],@"kind":self.kind,@"whereVC":@"详情"}];
    [BTCMInstance pushViewControllerWithName:@"BTNewAddRecord" andParams:@{@"kind":self.kind}];
}

@end
