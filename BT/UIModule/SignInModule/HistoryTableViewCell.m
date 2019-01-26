//
//  HistoryTableViewCell.m
//  BT
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HistoryTableViewCell.h"

@interface HistoryTableViewCell ()

@property (nonatomic,strong) UILabel *mainLabel;

@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) UILabel *tpLabel;

@end
@implementation HistoryTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.mainLabel = [UILabel new];
        [self.contentView addSubview:self.mainLabel];
        self.mainLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
        self.mainLabel.textColor = kHEXCOLOR(0x111210);
        self.mainLabel.text = @"邀请好友";
        
        self.timeLabel = [UILabel new];
        [self.contentView addSubview:self.timeLabel];
        self.timeLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
        self.timeLabel.textColor = kHEXCOLOR(0x666666);
        self.timeLabel.text = @"2018-05-30 08:00";
        
        self.tpLabel = [UILabel new];
        [self.contentView addSubview:self.tpLabel];
        self.tpLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(20)];
        self.tpLabel.textColor = kHEXCOLOR(0x108EE9);
        self.tpLabel.text = @"+20";
        
        UIView *lineView = [UIView new];
        [self.contentView addSubview:lineView];
        lineView.backgroundColor = kHEXCOLOR(0xdddddd);
        
        [self.mainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(RELATIVE_WIDTH(15));
            make.top.equalTo(self).offset(RELATIVE_WIDTH(14));
            make.height.mas_equalTo(RELATIVE_WIDTH(20));
        }];
        
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mainLabel);
            make.top.equalTo(self.mainLabel.mas_bottom).offset(RELATIVE_WIDTH(5));
            make.height.mas_equalTo(RELATIVE_WIDTH(17));
        }];
        
        [self.tpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(RELATIVE_WIDTH(-15));
            make.height.mas_equalTo(RELATIVE_WIDTH(28));
        }];
        
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(RELATIVE_WIDTH(15));
            make.right.equalTo(self);
            make.bottom.equalTo(self).offset(RELATIVE_WIDTH(-0.5));
            make.height.mas_offset(RELATIVE_WIDTH(0.5));
        }];
        
    }
    return self;
}

-(void)parseData:(HistoryModel*)model{
    
    if ([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]) {
        self.mainLabel.text = model.getway;
    }else{
        self.mainLabel.text = model.getwayEn;
    }
    
    self.timeLabel.text = [getUserCenter NewTimePresentationStringWithTimeStamp:[NSString stringWithFormat:@"%ld",model.dateTime]];
    if(!self.isIncome){
        self.tpLabel.text = [NSString stringWithFormat:@"+%ld",model.coin];
    }else{
        self.tpLabel.text = [NSString stringWithFormat:@"%ld",model.coin];
    }
    
}


@end
