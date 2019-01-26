//
//  CountryCodeTableViewCell.m
//  BT
//
//  Created by apple on 2018/5/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CountryCodeTableViewCell.h"

@interface CountryCodeTableViewCell ()

@property (nonatomic,strong) UILabel *countryLabel;
@property (nonatomic,strong) UILabel *countryCodeLabel;
@property (nonatomic,strong) UIView  *lineView;

@end

@implementation CountryCodeTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.countryLabel = [[UILabel alloc] init];
        [self addSubview:self.countryLabel];
        self.countryLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(16)];
        self.countryLabel.textColor = FirstColor;
        self.countryLabel.text = @"中国";
        
        self.countryCodeLabel = [[UILabel alloc] init];
        [self addSubview:self.countryCodeLabel];
        self.countryCodeLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
        self.countryCodeLabel.textColor = SecondColor;
        self.countryCodeLabel.text = @"+86";
        
        self.lineView = [[UIView alloc] init];
        [self addSubview:self.lineView];
        self.lineView.backgroundColor = SeparateColor;
        
        
    }
    
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.countryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(RELATIVE_WIDTH(15));
        make.centerY.equalTo(self);
        make.height.mas_equalTo(RELATIVE_WIDTH(22));
    }];
    
    [self.countryCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(RELATIVE_WIDTH(-15));
        make.centerY.equalTo(self);
        make.height.mas_equalTo(RELATIVE_WIDTH(20));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(RELATIVE_WIDTH(15));
        make.right.equalTo(self).offset(RELATIVE_WIDTH(-15));
        make.bottom.equalTo(self);
        make.height.mas_equalTo(RELATIVE_WIDTH(0.5));
    }];
    
}

-(void)parseData:(NSString *)str{
    NSArray *array = [str componentsSeparatedByString:@"+"];
    self.countryLabel.text = array.firstObject;
    NSString *codeStr = [NSString stringWithFormat:@"+%@",array.lastObject];
    codeStr = [codeStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    codeStr = [codeStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.countryCodeLabel.text = codeStr;
}


@end
