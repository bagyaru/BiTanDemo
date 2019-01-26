//
//  BTHoldRankTableViewCell.m
//  BT
//
//  Created by apple on 2018/7/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTHoldRankTableViewCell.h"

@interface BTHoldRankTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *sortL;

@property (weak, nonatomic) IBOutlet UILabel *leftL;

@property (weak, nonatomic) IBOutlet UILabel *centerL;

@property (weak, nonatomic) IBOutlet UILabel *rightL;

@end

@implementation BTHoldRankTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setArrData:(NSArray *)arrData{
    _arrData = arrData;
    if(arrData){
        self.sortL.text = SAFESTRING(@(self.row +1));
        NSDictionary *dict1 = self.arrData[0];
        NSDictionary *dict2 = self.arrData[1];
        NSDictionary *dict3 = self.arrData[2];
        
        self.leftL.text = [DigitalHelperService isTransformWithDouble:[SAFESTRING(dict1[@"data"]) doubleValue]];
        self.centerL.text =[DigitalHelperService isTransformWithDouble:[SAFESTRING(dict2[@"data"]) doubleValue]];
        self.rightL.text = [DigitalHelperService isTransformWithDouble:[SAFESTRING(dict3[@"data"]) doubleValue]];
    }
}
@end
