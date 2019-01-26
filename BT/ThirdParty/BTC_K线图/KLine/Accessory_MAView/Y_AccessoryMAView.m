//
//  Y_AccessoryMAView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/5/4.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_AccessoryMAView.h"
#import "Masonry.h"
#import "UIColor+Y_StockChart.h"
#import "Y_KLineModel.h"

@interface Y_AccessoryMAView()

@property (strong, nonatomic) UILabel *accessoryDescLabel;

@property (strong, nonatomic) UILabel *DIFLabel;

@property (strong, nonatomic) UILabel *DEALabel;

@property (strong, nonatomic) UILabel *MACDLabel;

@end
@implementation Y_AccessoryMAView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _DIFLabel = [self private_createLabel];
        _DEALabel = [self private_createLabel];
        _MACDLabel = [self private_createLabel];
        _accessoryDescLabel = [self private_createLabel];
        
        _DIFLabel.textColor = [UIColor ma7Color];
        _DEALabel.textColor = [UIColor ma10Color];
        _MACDLabel.textColor = [UIColor ma30Color];
        
        
        [_accessoryDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.top.equalTo(self.mas_top);
             make.centerY.equalTo(self);
        }];
        
        
        [_DIFLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_accessoryDescLabel.mas_right).offset(1);
            make.top.equalTo(self.mas_top);
            make.centerY.equalTo(self);
        }];
        
        [_DEALabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_DIFLabel.mas_right).offset(1);
            make.top.equalTo(self.mas_top);
            make.centerY.equalTo(self);
        }];
        
        [_MACDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_DEALabel.mas_right).offset(1);
            make.top.equalTo(self.mas_top);
             make.centerY.equalTo(self);
        }];
    }
    return self;
}

+(instancetype)view
{
    Y_AccessoryMAView *MAView = [[Y_AccessoryMAView alloc]init];
    
    return MAView;
}

-(void)maProfileWithModel:(Y_KLineModel *)model{
    if(self.targetLineStatus == Y_StockChartTargetLineStatusMACD)
    {
        _DIFLabel.textColor = [UIColor ma7Color];
        _accessoryDescLabel.text = @" MACD(12,26,9)";
        _DIFLabel.text = [NSString stringWithFormat:@"DIF:%.5f ",model.DIF.doubleValue];
        _DEALabel.text = [NSString stringWithFormat:@"DEA:%.5f",model.DEA.doubleValue];
        _MACDLabel.text = [NSString stringWithFormat:@"MACD:%.5f",model.MACD.doubleValue];
    } else  if(self.targetLineStatus == Y_StockChartTargetLineStatusKDJ){
        _DIFLabel.textColor = [UIColor ma7Color];
        _accessoryDescLabel.text = @" KDJ(9,3,3)";
        _DIFLabel.text = [NSString stringWithFormat:@"K:%.5f ",model.KDJ_K.doubleValue];
        _DEALabel.text = [NSString stringWithFormat:@"D:%.5f",model.KDJ_D.doubleValue];
        _MACDLabel.text = [NSString stringWithFormat:@"J:%.5f",model.KDJ_J.doubleValue];
    } else  if(self.targetLineStatus == Y_StockChartTargetLineStatusRSI){
        _DIFLabel.textColor = [UIColor ma7Color];
        _accessoryDescLabel.text = @" RSI(6,12,24)";
        _DIFLabel.text = [NSString stringWithFormat:@"RSI6:%.5f ",model.RSI_6.doubleValue];
        _DEALabel.text = [NSString stringWithFormat:@"RSI12:%.5f",model.RSI_12.doubleValue];
        _MACDLabel.text = [NSString stringWithFormat:@"RSI24:%.5f",model.RSI_24.doubleValue];
        
    }else  if(self.targetLineStatus == Y_StockChartTargetLineStatusNetCapital){
        _DIFLabel.textColor = [UIColor ma30Color];
        _accessoryDescLabel.text =[NSString stringWithFormat:@" %@",[APPLanguageService sjhSearchContentWith:@"NetFlow"]];
        
        if(model.netInflow.doubleValue < 0){
            _DIFLabel.text = [NSString stringWithFormat:@"  %@:%@ ",[APPLanguageService sjhSearchContentWith:@"jingliuchu"],[NSString stringWithFormat:@"%@",[DigitalHelperService transformWith:ABS(model.netInflow.doubleValue)]]];
            
        }else{
            _DIFLabel.text = [NSString stringWithFormat:@"  %@:%@ ",[APPLanguageService sjhSearchContentWith:@"jingliuru"],[NSString stringWithFormat:@"%@",[DigitalHelperService transformWith:model.netInflow.doubleValue]]];
        }
        
        _DEALabel.text = @"";
        _MACDLabel.text = @"";
    }
}

- (UILabel *)private_createLabel
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor assistTextColor];
    [self addSubview:label];
    return label;
}

@end
