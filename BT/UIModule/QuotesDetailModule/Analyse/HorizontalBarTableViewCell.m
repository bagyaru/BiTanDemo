//
//  HorizontalBarTableViewCell.m
//  BT
//
//  Created by apple on 2018/6/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HorizontalBarTableViewCell.h"
#import "GradualChange.h"

@interface HorizontalBarTableViewCell ()


/**最上面的第一个界面 交易所成交占比 只显示一次*/
@property (nonatomic,strong) UIView *firstBgView;

/**币种label*/
@property (nonatomic,strong) UILabel *mainTitleLabel;
/**成交量label*/
@property (nonatomic,strong) UILabel *tradeAmountLabel;
/**比例label*/
@property (nonatomic,strong) UILabel *proportionlabel;
/**条状图背景图*/
@property (nonatomic,strong) UIView *progressBgView;
/**条状图*/
@property (nonatomic,strong) UIImageView *progressView;

@property (nonatomic, strong) UILabel * rightL;

@end

@implementation HorizontalBarTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *firstBgView = [UIView new];
        [self.contentView addSubview:firstBgView];
        firstBgView.backgroundColor = [UIColor whiteColor];
        [firstBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_offset(RELATIVE_WIDTH(46));
        }];
        
        UIView *topBgView = [UIView new];
        topBgView.backgroundColor = kHEXCOLOR(0xf5f5f5);
        [firstBgView addSubview:topBgView];
        [topBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(firstBgView);
            make.height.mas_offset(RELATIVE_WIDTH(6));
        }];
        
        UILabel *mainTipLabel = [UILabel new];
        [firstBgView addSubview:mainTipLabel];
        mainTipLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
        mainTipLabel.textColor = kHEXCOLOR(0x111210);
        mainTipLabel.text = [APPLanguageService wyhSearchContentWith:@"jiaoyisouchengjiaozhanbi24h"];
        [mainTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(firstBgView).offset(RELATIVE_WIDTH(15));
            make.top.equalTo(topBgView.mas_bottom).offset(RELATIVE_WIDTH(10));
            make.height.mas_equalTo(RELATIVE_WIDTH(20));
        }];
        
        UILabel *rightVolumeLabel  = [UILabel new];
        [firstBgView addSubview:rightVolumeLabel];
        rightVolumeLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
        rightVolumeLabel.textColor = kHEXCOLOR(0x111210);
        rightVolumeLabel.text = @"总成交量 75,596.00";
        [rightVolumeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(firstBgView).offset(RELATIVE_WIDTH(-15));
            make.centerY.equalTo(mainTipLabel);
            make.height.mas_equalTo(RELATIVE_WIDTH(17));
        }];
        self.rightL = rightVolumeLabel;
        
        
        UIView *separateLineView = [UIView new];
        [firstBgView addSubview:separateLineView];
        separateLineView.backgroundColor = kHEXCOLOR(0xdddddd);
        [separateLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(firstBgView).offset(RELATIVE_WIDTH(15));
            make.bottom.equalTo(firstBgView);
            make.right.equalTo(firstBgView);
            make.height.mas_equalTo(RELATIVE_WIDTH(0.5));
        }];
        
        self.firstBgView = firstBgView;
        self.mainTitleLabel = [UILabel new];
        [self.contentView addSubview:self.mainTitleLabel];
        self.mainTitleLabel.font = [UIFont systemFontOfSize:12];
        self.mainTitleLabel.textColor = kHEXCOLOR(0x111210);
        self.mainTitleLabel.text = @"BitMEX";
        [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(16);
            make.top.equalTo(self).offset(7);
            make.height.mas_equalTo(17);
        }];
        
        self.tradeAmountLabel = [UILabel new];
        [self.contentView addSubview:self.tradeAmountLabel];
        self.tradeAmountLabel.font = [UIFont systemFontOfSize:12];
        self.tradeAmountLabel.textColor = kHEXCOLOR(0x108ee9);
        self.tradeAmountLabel.text = @"29,822.00";
        [self.tradeAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.mainTitleLabel);
            make.height.equalTo(self.mainTitleLabel);
        }];
        
        self.proportionlabel = [UILabel new];
        [self.contentView addSubview:self.proportionlabel];
        self.proportionlabel.font = [UIFont systemFontOfSize:12];
        self.proportionlabel.textColor = kHEXCOLOR(0x108ee9);
        self.proportionlabel.text = @"50.11%";
        [self.proportionlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-16);
            make.top.equalTo(self.mainTitleLabel);
            make.height.equalTo(self.mainTitleLabel);
        }];
        
        self.progressBgView = [UIView new];
        [self addSubview:self.progressBgView];
        self.progressBgView.backgroundColor = kHEXCOLOR(0x108EE9);
        self.progressBgView.alpha = 0.1;
        self.progressBgView.layer.cornerRadius = 5;
        self.progressBgView.layer.masksToBounds = YES;
        [self.progressBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mainTitleLabel);
            make.right.equalTo(self.proportionlabel);
            make.top.equalTo(self.mainTitleLabel.mas_bottom);
            make.height.mas_equalTo(10);
        }];
        
        self.progressView = [UIImageView new];
        [self.contentView addSubview:self.progressView];
        [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.progressBgView);
        }];
    }
    return self;
}

//
-(void)parseData:(HorizontalBarModel*)model row:(NSInteger)row{
    
    self.firstBgView.hidden = row == 0?NO:YES;
    
    self.mainTitleLabel.hidden = row == 0?YES:NO;
    self.tradeAmountLabel.hidden = row == 0?YES:NO;
    self.proportionlabel.hidden = row == 0?YES:NO;
    self.progressBgView.hidden = row == 0?YES:NO;
    if (row == 0) {
        self.rightL.text = [NSString stringWithFormat:@"%@ %@",[APPLanguageService wyhSearchContentWith:@"zongchengjiaoliang"],[DigitalHelperService analyseTransformWith:[SAFESTRING(model.mainTitle) doubleValue]]];
        return;
    }
    if([model.mainTitle isEqualToString:@"other"]){
        model.mainTitle = [APPLanguageService sjhSearchContentWith:@"qita"];
    }
    self.mainTitleLabel.text = model.mainTitle;
    self.tradeAmountLabel.text = [NSString stringWithFormat:@"%@", [DigitalHelperService analyseTransformWith:model.tradeAmount]];
    if(model.proportion*100 <0.01){
        self.proportionlabel.text = [NSString stringWithFormat:@"<0.01%%"];
    }else{
        self.proportionlabel.text = [NSString stringWithFormat:@"%.2f%%",(model.proportion*100)];
    }
    
    
    [self.progressView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.progressBgView).multipliedBy(model.progressScale);
    }];
    
    [self.progressView setNeedsLayout];
    [self.progressView layoutIfNeeded];
    self.progressView.image = [GradualChange viewChangeImg:self.progressView.bounds isVerticalBar:NO];
}

@end
