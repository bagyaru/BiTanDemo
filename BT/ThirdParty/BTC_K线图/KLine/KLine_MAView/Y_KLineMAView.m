//
//  Y_KLineMAView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/5/2.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_KLineMAView.h"
#import "Masonry.h"
#import "UIColor+Y_StockChart.h"
#import "Y_KLineModel.h"
@interface Y_KLineMAView ()

@property (strong, nonatomic) UILabel *MA7Label;

@property (nonatomic, strong) UILabel *MA10Label;

@property (strong, nonatomic) UILabel *MA30Label;

@property (strong, nonatomic) UILabel *dateDescLabel;

@property (strong, nonatomic) UILabel *openDescLabel;

@property (strong, nonatomic) UILabel *closeDescLabel;

@property (strong, nonatomic) UILabel *highDescLabel;

@property (strong, nonatomic) UILabel *lowDescLabel;

@property (strong, nonatomic) UILabel *openLabel;

@property (strong, nonatomic) UILabel *closeLabel;

@property (strong, nonatomic) UILabel *highLabel;

@property (strong, nonatomic) UILabel *lowLabel;

@end

@implementation Y_KLineMAView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _MA7Label = [self private_createLabel];
        _MA10Label = [self private_createLabel];
        _MA30Label = [self private_createLabel];
        _MA7Label.textColor = [UIColor ma7Color];
        _MA10Label.textColor = [UIColor ma10Color];
        _MA30Label.textColor = [UIColor ma30Color];

//        _dateDescLabel = [self private_createLabel];
//        _openDescLabel = [self private_createLabel];
//        _openDescLabel.text = @" 开:";
//        _closeDescLabel = [self private_createLabel];
//        _closeDescLabel.text = @" 收:";
//
//        _highDescLabel = [self private_createLabel];
//        _highDescLabel.text = @" 高:";
//
//        _lowDescLabel = [self private_createLabel];
//        _lowDescLabel.text = @" 低:";
//
//        _openLabel = [self private_createLabel];
//        _closeLabel = [self private_createLabel];
//        _highLabel = [self private_createLabel];
//        _lowLabel = [self private_createLabel];
//
//
//
//        _openLabel.textColor = [UIColor assistTextColor];
//        _highLabel.textColor = [UIColor assistTextColor];
//        _lowLabel.textColor = [UIColor assistTextColor];
//        _closeLabel.textColor = [UIColor assistTextColor];
        
//        [_dateDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.mas_left).offset(15);
//            make.top.equalTo(self.mas_top);
//        }];
//
//        [_openDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_dateDescLabel.mas_right);
//            make.top.equalTo(self.mas_top);
//        }];
//
//        [_openLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_openDescLabel.mas_right);
//            make.top.equalTo(self.mas_top);
//        }];
//
//        [_highDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_openLabel.mas_right);
//            make.top.equalTo(self.mas_top);
//        }];
//
//        [_highLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_highDescLabel.mas_right);
//            make.top.equalTo(self.mas_top);
//        }];
//
//        [_lowDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_highLabel.mas_right);
//            make.top.equalTo(self.mas_top);
//        }];
//
//        [_lowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_lowDescLabel.mas_right);
//            make.top.equalTo(self.mas_top);
//        }];
//
//        [_closeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_lowLabel.mas_right);
//            make.top.equalTo(self.mas_top);
//        }];
//
//        [_closeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_closeDescLabel.mas_right);
//            make.top.equalTo(self.mas_top);
//        }];
//
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
//        [self addSubview:lineView];
//        lineView.backgroundColor = [UIColor lineColor];
//        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).offset(20);
//            make.right.equalTo(self);
//            make.left.equalTo(self).offset(15);
//            make.height.mas_equalTo(0.5);
//        }];
        
        [_MA7Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            // make.top.equalTo(lineView.mas_bottom).offset(5);
            make.centerY.equalTo(self.mas_centerY);
        }];
        [_MA10Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_MA7Label.mas_right);
            make.centerY.equalTo(_MA7Label.mas_centerY);
        }];
        
        [_MA30Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_MA10Label.mas_right);
            make.centerY.equalTo(_MA7Label.mas_centerY);
        }];
        
    }
    return self;
}

+(instancetype)view
{
    Y_KLineMAView *MAView = [[Y_KLineMAView alloc]init];

    return MAView;
}

-(void)maProfileWithModel:(Y_KLineModel *)model
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.time/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [formatter stringFromDate:date];
    _dateDescLabel.text = [@" " stringByAppendingString: dateStr];
    _openLabel.text = [NSString stringWithFormat:@"%@", [DigitalHelperService isTransformWithDouble:model.Open.doubleValue]];
    _highLabel.text = [NSString stringWithFormat:@"%@",[DigitalHelperService iskLineDataWithDouble:model.High.doubleValue]];
    _lowLabel.text = [NSString stringWithFormat:@"%@",[DigitalHelperService iskLineDataWithDouble:model.Low.doubleValue]];
    _closeLabel.text = [NSString stringWithFormat:@"%@",[DigitalHelperService iskLineDataWithDouble:model.Close.doubleValue]];
    if(self.targetLineStatus == Y_StockChartTargetLineStatusMA){
        _MA7Label.text = [NSString stringWithFormat:@" MA5:%@ ",[DigitalHelperService iskLineDataWithDouble:model.MA7.doubleValue]];
        _MA10Label.text = [NSString stringWithFormat:@" MA10:%@ ",[DigitalHelperService iskLineDataWithDouble:model.MA10.doubleValue]];
        _MA30Label.text = [NSString stringWithFormat:@" MA30:%@",[DigitalHelperService iskLineDataWithDouble:model.MA30.doubleValue]];
    }else if(self.targetLineStatus == Y_StockChartTargetLineStatusEMA){
        _MA7Label.text = [NSString stringWithFormat:@" EMA5:%@ ",[DigitalHelperService iskLineDataWithDouble:model.EMA7.doubleValue]];
        _MA10Label.text = [NSString stringWithFormat:@" EMA10:%@ ",[DigitalHelperService iskLineDataWithDouble:model.EMA10.doubleValue]];
        _MA30Label.text = [NSString stringWithFormat:@" EMA30:%@",[DigitalHelperService iskLineDataWithDouble:model.EMA30.doubleValue]];
    }else if(self.targetLineStatus == Y_StockChartTargetLineStatusBOLL){
        _MA7Label.text = [NSString stringWithFormat:@"MB:%@ ",[DigitalHelperService iskLineDataWithDouble:model.BOLL_MB.doubleValue]];
        _MA10Label.text = [NSString stringWithFormat:@"UP:%@ ",[DigitalHelperService iskLineDataWithDouble:model.BOLL_UP.doubleValue]];
        _MA30Label.text = [NSString stringWithFormat:@"DN:%@",[DigitalHelperService iskLineDataWithDouble:model.BOLL_DN.doubleValue]];
    }else{
        _MA7Label.text = @""; //[NSString stringWithFormat:@"MB：%.2f ",model.BOLL_MB.floatValue];
        _MA10Label.text = @"";
        _MA30Label.text = @""; //[NSString stringWithFormat:@"UP：%.2f",model.BOLL_UP.floatValue];
    }
}

- (UILabel *)private_createLabel
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor assistTextColor];
    label.adjustsFontSizeToFitWidth = YES;
    [self addSubview:label];
    return label;
}
@end
