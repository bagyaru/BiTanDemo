//
//  BTDiscoveryRMBZCell.m
//  BT
//
//  Created by admin on 2018/6/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTDiscoveryRMBZCell.h"
#import "BTHotCurrencyModel.h"
@implementation BTDiscoveryRMBZCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSArray *viewArray = @[self.VIEW_1,self.VIEW_2,self.VIEW_3,self.VIEW_4,self.VIEW_5,self.VIEW_6];
    
    for (UIView *subView in viewArray) {
        
        ViewBorderRadius(subView, 4, 0.5, kHEXCOLOR(0xdddddd));
    }
}
-(void)setArray:(NSMutableArray *)array {
    _array = array;
    if (array) {
        NSArray *a1 = @[self.VIEW_1_1,self.VIEW_2_1,self.VIEW_3_1,self.VIEW_4_1,self.VIEW_5_1,self.VIEW_6_1];
        NSArray *a2 = @[self.VIEW_1_2,self.VIEW_2_2,self.VIEW_3_2,self.VIEW_4_2,self.VIEW_5_2,self.VIEW_6_2];
        NSArray *a3 = @[self.VIEW_1_3,self.VIEW_2_3,self.VIEW_3_3,self.VIEW_4_3,self.VIEW_5_3,self.VIEW_6_3];
        NSLog(@"%@",array);
        
        for (int i = 0; i < array.count; i++) {
            BTHotCurrencyModel *model = array[i];
            UILabel *L1 = a1[i];
            UILabel *L2 = a2[i];
            UILabel *L3 = a3[i];
            L1.text     = model.currencyCode;
            L3.text     = [NSString stringWithFormat:@"%@%ld",[APPLanguageService wyhSearchContentWith:@"redu"],model.hotPower];
            if (model.increaseRate <  0) {
                L2.textColor =CRedColor;
                L2.text =[NSString stringWithFormat:@"-%@%%",@(-model.increaseRate).p2fString];
            }else{
                L2.textColor =CGreenColor;
                L2.text =[NSString stringWithFormat:@"+%@%%",@(model.increaseRate).p2fString];
                
                if (model.increaseRate == 0) {
                    L2.textColor = CBlackColor;
                    
                }
            }
            
        }
    }
}
- (IBAction)goDetailBtnClick:(UIButton *)sender {
    
    if (_array) {
        [AnalysisService alaysis_hot_currencies];
        BTHotCurrencyModel *model = _array[sender.tag-100];
        NSData *data = [model modelToJSONData];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:dic];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
