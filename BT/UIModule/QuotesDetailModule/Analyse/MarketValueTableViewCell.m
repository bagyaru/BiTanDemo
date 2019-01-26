//
//  MarketValueTableViewCell.m
//  BT
//
//  Created by apple on 2018/6/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MarketValueTableViewCell.h"
#import "DetailHelper.h"
#import "BTHelperMethod.h"
@interface MarketValueTableViewCell ()

@property (nonatomic,strong) UILabel *rankLabel;

@property (nonatomic,strong) NSMutableArray *descLabelArr;

@end

@implementation MarketValueTableViewCell

-(NSMutableArray *)descLabelArr{
    if (!_descLabelArr) {
        _descLabelArr = [NSMutableArray array];
    }
    return _descLabelArr;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *topBgView = [UIView new];
        [self.contentView addSubview:topBgView];
        topBgView.backgroundColor = ViewBGDayColor;
        [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_offset(RELATIVE_WIDTH(6));
        }];
        
        UILabel *mainTipLable = [UILabel new];
        [self.contentView addSubview:mainTipLable];
        mainTipLable.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
        mainTipLable.textColor = kHEXCOLOR(0x111210);
        mainTipLable.text = [APPLanguageService wyhSearchContentWith:@"shizhishuju"];
        [mainTipLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topBgView.mas_bottom).offset(RELATIVE_WIDTH(10));
            make.left.equalTo(self).offset(15);
            make.height.mas_equalTo(RELATIVE_WIDTH(20));
        }];
        
        UILabel *rankLabel = [UILabel new];
        [self.contentView addSubview:rankLabel];
        rankLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
        rankLabel.textColor = kHEXCOLOR(0x111210);
        [rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topBgView.mas_bottom).offset(RELATIVE_WIDTH(10));
            make.right.equalTo(self).offset(-15);
            make.height.mas_equalTo(20);
        }];
        self.rankLabel =rankLabel;
        
        UIView *firstLineView = [UIView new];
        firstLineView.backgroundColor =  kHEXCOLOR(0xdddddd);
       
        [self.contentView addSubview:firstLineView];
        [firstLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(RELATIVE_WIDTH(15));
            make.right.equalTo(self);
            make.top.equalTo(mainTipLable.mas_bottom).offset(RELATIVE_WIDTH(9));
            make.height.mas_equalTo(RELATIVE_WIDTH(0.5));
        }];
        //[APPLanguageService sjhSearchContentWith:<#(NSString *)#> ]
        NSArray *tipTitleArr = @[[APPLanguageService wyhSearchContentWith:@"zongshizhi"],[APPLanguageService wyhSearchContentWith:@"liutongshizhi"],[APPLanguageService wyhSearchContentWith:@"zongshizhizhanbi"]];;
        NSArray *descTitleArr = @[@"--",@"--",@"--"];
        
        UIView *tempView = firstLineView;
        for (int i = 0; i<tipTitleArr.count; i++) {
            UILabel *tipLabel = [UILabel new];
            [self.contentView addSubview:tipLabel];
            tipLabel.font  = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
            tipLabel.textColor = kHEXCOLOR(0x666666);
            tipLabel.text = tipTitleArr[i];
            [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(RELATIVE_WIDTH(15));
                make.top.equalTo(tempView).offset(RELATIVE_WIDTH(7));
                make.height.mas_offset(RELATIVE_WIDTH(17));
            }];
            
            UILabel *descLabel = [UILabel new];
            [self.contentView addSubview:descLabel];
            descLabel.font  = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
            descLabel.textColor = kHEXCOLOR(0x111210);
            descLabel.text = descTitleArr[i];
            [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(RELATIVE_WIDTH(-15));
                make.centerY.equalTo(tipLabel);
                make.height.mas_offset(RELATIVE_WIDTH(17));
            }];
            
            [self.descLabelArr addObject:descLabel];
            
            
            if(i !=tipTitleArr.count -1){
                UIView *seprateLineView = [UIView new];
                seprateLineView.backgroundColor = SeparateColor;
                [self.contentView addSubview:seprateLineView];
                [seprateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self).offset(RELATIVE_WIDTH(15));
                    make.right.equalTo(self);
                    make.top.equalTo(tipLabel.mas_bottom).offset(RELATIVE_WIDTH(6));
                    make.height.mas_equalTo(RELATIVE_WIDTH(0.5));
                }];
                
                tempView = seprateLineView;
            }
            
            
        }
    }
    return self;
}


- (void)setInfo:(BTCoinBaseInfo *)info{
    _info = info;
    if(!info) return;
   
    NSString *text = @"";
    if (ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans)) {
        text = [NSString stringWithFormat:@"第 %@ 名", [DetailHelper processData:SAFESTRING(@(info.ranking))]];
    }else {
        
        text = [NSString stringWithFormat:@"No. %@", [DetailHelper processData:SAFESTRING(@(info.ranking))]];
    }
    
    NSString *rank = SAFESTRING(@(info.ranking));
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:text];
    [attributed addAttribute:NSForegroundColorAttributeName value:kHEXCOLOR(0x108ee9) range:[text rangeOfString:rank]];
    self.rankLabel.attributedText = attributed;
    NSString *shizhiValue =  @"";
    NSString *totalShiZhiValue =@"";
    if (kIsCNY) {
        if (info.costRmb > 0) {
            if (info.costRmb >= YI) {
                shizhiValue = [NSString stringWithFormat:@"¥%.2f%@",info.costRmb/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
                
            }else {
                
                shizhiValue  = [NSString stringWithFormat:@"¥%.2f%@",info.costRmb/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
            }
        }
        
        if (info.totalRmb > 0) {
            if (info.totalRmb >= YI) {
                totalShiZhiValue = [NSString stringWithFormat:@"¥%.2f%@",info.totalRmb/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
                
            }else {
                
                totalShiZhiValue  = [NSString stringWithFormat:@"¥%.2f%@",info.totalRmb/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
            }
        }
        
    }else{
        if (info.costDollar > 0) {
            
            if (info.costDollar >= YI) {
                shizhiValue = [NSString stringWithFormat:@"$%.2f%@",info.costDollar/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
                
            }else {
                
                shizhiValue  = [NSString stringWithFormat:@"$%.2f%@",info.costDollar/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
            }
            
        }
        
        if (info.totalDollar > 0) {
            if (info.totalDollar >= YI) {
                totalShiZhiValue = [NSString stringWithFormat:@"$%.2f%@",info.totalDollar/YI,[APPLanguageService sjhSearchContentWith:@"yi"]];
                
            }else {
                
                totalShiZhiValue  = [NSString stringWithFormat:@"$%.2f%@",info.totalDollar/WAN,[APPLanguageService sjhSearchContentWith:@"wan"]];
            }
        }
    }
    
    //
    if(shizhiValue.length>0){
        shizhiValue = [NSString stringWithFormat:@"%@≈%@%@",shizhiValue,[DigitalHelperService transformWith: [@(info.currencyAmount) doubleValue]],self.kind];
    }
    if(totalShiZhiValue.length >0){
        totalShiZhiValue = [NSString stringWithFormat:@"%@≈%@%@",totalShiZhiValue,[DigitalHelperService transformWith: [@(info.maxAmountLong) doubleValue]],self.kind];
    }
    //rate
    NSString * shizhiRate = @"";
    if([info.costRate isEqualToString:@"0.0%"]){
        shizhiRate = [NSString stringWithFormat:@"<0.01%%"];
    }else{
        shizhiRate = [DetailHelper processData:[NSString stringWithFormat:@"%@",SAFESTRING(info.costRate)]];
    }
    
    NSArray *arr = @[[DetailHelper processData:SAFESTRING(totalShiZhiValue)],[DetailHelper processData:SAFESTRING(shizhiValue)],[DetailHelper processData:SAFESTRING(shizhiRate)]];
    for (int i =0;i<self.descLabelArr.count;i++) {
        UILabel *label = self.descLabelArr[i];
        label.text = arr[i];
    }
}


@end
