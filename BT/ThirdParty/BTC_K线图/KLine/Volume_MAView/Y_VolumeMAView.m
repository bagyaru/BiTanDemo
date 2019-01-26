//
//  Y_VolumeMAView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/5/3.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_VolumeMAView.h"
#import "Masonry.h"
#import "UIColor+Y_StockChart.h"
#import "Y_KLineModel.h"
@interface Y_VolumeMAView ()
@property (strong, nonatomic) UILabel *VolumeMA7Label;

@property (strong, nonatomic) UILabel *VolumeMA30Label;

@property (strong, nonatomic) UILabel *volumeDescLabel;

@end
@implementation Y_VolumeMAView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _VolumeMA7Label = [self private_createLabel];
        _VolumeMA30Label = [self private_createLabel];
        _volumeDescLabel = [self private_createLabel];

//        _VolumeMA7Label.textColor = [UIColor ma7Color];
//        _VolumeMA30Label.textColor = [UIColor ma30Color];
        
        [_volumeDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(15);
            make.centerY.equalTo(self);
        }];
        
        
        [_VolumeMA7Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-15);
            make.centerY.equalTo(self);
        }];
        
//        [_VolumeMA30Label mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(_VolumeMA7Label.mas_right);
//            make.centerY.equalTo(self);
//        }];
        
    }
    return self;
}

- (void)setRatio:(double)ratio{
    self.VolumeMA7Label.text = [NSString stringWithFormat:@"%@%@",[APPLanguageService sjhSearchContentWith:@"liangbi"],[DigitalHelperService isTransformWithDouble:ratio]];
}

+(instancetype)view
{
    Y_VolumeMAView *MAView = [[Y_VolumeMAView alloc]init];
    
    return MAView;
}
-(void)maProfileWithModel:(Y_KLineModel *)model
{

//VOL(7,30)
    _volumeDescLabel.text = [NSString stringWithFormat:@"%@:%.4f ",[APPLanguageService sjhSearchContentWith:@"chengjiaoliang"],model.Volume];//[NSString stringWithFormat:@"  MA7:%@",[DigitalHelperService isTransformWithDouble:model.Volume_MA7.floatValue]];
    _VolumeMA30Label.text = @"";//[NSString stringWithFormat:@"  MA30:%@",[DigitalHelperService isTransformWithDouble:model.Volume_MA30.floatValue]];
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
