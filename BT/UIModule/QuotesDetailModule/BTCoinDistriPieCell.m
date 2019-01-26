//
//  BTCoinDistriPieCell.m
//  BT
//
//  Created by apple on 2018/9/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTCoinDistriPieCell.h"
#import "BTCoinDistriPieChart.h"
#import "DVFoodPieModel.h"
#import "UIColor+expanded.h"
@interface BTCoinDistriPieCell()

@property (weak, nonatomic) IBOutlet UIView *descView;
@property (weak, nonatomic) IBOutlet UIView *pieView;

@property (nonatomic, strong) UILabel *lastLabel;

@end

@implementation BTCoinDistriPieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setLabels:(NSArray *)labels{
    _labels = labels;
    if(_labels.count >0){
        [self setChart];
        for(UIView *view in self.descView.subviews){
            [view removeFromSuperview];
        }
    }
    NSArray *colorArr = @[
                          [UIColor colorWithHexString:@"3A99DE" andAlpha:1.0],
                          [UIColor colorWithHexString:@"F99E5E" andAlpha:1.0],
                          [UIColor colorWithHexString:@"72D555" andAlpha:1.0],
                          [UIColor colorWithHexString:@"F2C74D" andAlpha:1.0],
                          [UIColor colorWithHexString:@"F2C74D" andAlpha:0.8],
                          [UIColor colorWithHexString:@"F2C74D" andAlpha:0.6],
                          [UIColor colorWithHexString:@"F2C74D" andAlpha:0.6]
                          ];
    
    for(NSUInteger i = 0 ; i <labels.count; i++){
        NSDictionary *dict = labels[i];
        NSString *foundation = SAFESTRING(dict[@"foundation"]);
        NSString *ico = SAFESTRING(dict[@"ico"]);
        UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        if(i < colorArr.count){
            colorLabel.backgroundColor = colorArr[i];
        }else{
            colorLabel.backgroundColor = [UIColor blackColor];
        }
        UILabel *nameLabel = [UILabel labelWithFrame:CGRectZero title:@"" font:FONTOFSIZE(12) textColor:FirstColor];
        [self.descView addSubview:colorLabel];
        [self.descView addSubview:nameLabel];
        
        if(i/2 == 0){
            [colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                if(i%2 == 0){
                    make.left.equalTo(self.descView);
                }else{
                    make.left.equalTo(self.lastLabel.mas_right).offset(15.0f);
                }
                make.top.equalTo(self.descView).offset(50);
                make.width.height.mas_equalTo(12.0f);
            }];
        }else{
            [colorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                if(i%2 == 0){
                    make.left.equalTo(self.descView);
                }else{
                    make.left.equalTo(self.lastLabel.mas_right).offset(15.0f);
                }
                if(i>3){
                   make.top.equalTo(self.descView).offset(106);
                }else{
                   make.top.equalTo(self.descView).offset(78);
                }
                
                make.width.height.mas_equalTo(12.0f);
            }];
        }
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(colorLabel.mas_centerY);
            make.left.equalTo(colorLabel.mas_right).offset(10);
        }];
        self.lastLabel = nameLabel;
        nameLabel.text = [NSString stringWithFormat:@"%@:%@%%",ico,foundation];
        
    }
}
//
- (void)setChart{
    BTCoinDistriPieChart *chart = [[BTCoinDistriPieChart alloc] initWithFrame:CGRectZero];
    [self.pieView addSubview:chart];
    [chart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.pieView);
    }];
    NSMutableArray *dataArr = @[].mutableCopy;
    for(NSDictionary *dict in _labels){
        NSString *foundation = SAFESTRING(dict[@"foundation"]);
        DVFoodPieModel *model = [[DVFoodPieModel alloc] init];
        model.rate = [foundation floatValue]/100;
        model.afterRate = model.rate;
        [dataArr addObject:model];
    }
    
    chart.dataArray = dataArr;
    [chart draw];
}


@end
