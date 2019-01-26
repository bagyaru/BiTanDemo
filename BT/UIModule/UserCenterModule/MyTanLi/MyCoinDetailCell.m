//
//  MyCoinDetailCell.m
//  BT
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyCoinDetailCell.h"
#import "NSDate+Extent.h"
@interface MyCoinDetailCell()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UILabel *valueL;

@end
@implementation MyCoinDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(NSDictionary *)data{
    _data =data;
    self.nameL.text = ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans)?SAFESTRING(data[@"getway"]):SAFESTRING(data[@"getwayEn"]);
    self.valueL.text =[NSString stringWithFormat:@"+%@",SAFESTRING(data[@"coin"])];
    self.timeL.text = [NSDate getTimeStrFromInterval:SAFESTRING(data[@"dateTime"]) andFormatter:@"YYYY-MM-dd HH:mm"];
}
@end
