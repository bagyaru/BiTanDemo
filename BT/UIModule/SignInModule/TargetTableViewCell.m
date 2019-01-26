//
//  TargetTableViewCell.m
//  BT
//
//  Created by apple on 2018/5/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TargetTableViewCell.h"

@interface TargetTableViewCell ()


@property (nonatomic,strong) UILabel *tipLabel;

@property (nonatomic,strong) UILabel *mainTitleLabel;

@property (nonatomic,strong) UILabel *subTitleLabel;

@property (nonatomic,strong) UIButton *btn;

@property (nonatomic,strong) UIView *myProgressView;

@property (nonatomic,strong) UIView *myProgeressValueView;

@property (nonatomic,strong) MASConstraint *progressConstraint;

@property (nonatomic,strong) MASConstraint *btnTopConstraint;

@property (nonatomic,strong) TargetBtnClickBlock btnBlock;

@end

@implementation TargetTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        
        self.tipLabel = [UILabel new];
        [self.contentView addSubview:self.tipLabel];
        self.tipLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(16)];
        self.tipLabel.textColor = FirstColor;
        self.tipLabel.text = [NSString stringWithFormat:@"%@",[APPLanguageService wyhSearchContentWith:@"huodeTP"]];
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(RELATIVE_WIDTH(15));
            make.height.mas_equalTo(RELATIVE_WIDTH(22));
        }];
        
        
        self.mainTitleLabel = [UILabel new];
        [self.contentView addSubview:self.mainTitleLabel];
        self.mainTitleLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
        self.mainTitleLabel.textColor = FirstColor;
        self.mainTitleLabel.text = @"登录";
        [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(RELATIVE_WIDTH(15));
            make.top.equalTo(self).offset(RELATIVE_WIDTH(14));
            make.height.mas_equalTo(RELATIVE_WIDTH(20));
        }];
        
        self.subTitleLabel = [UILabel new];
        [self.contentView addSubview:self.subTitleLabel];
        self.subTitleLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
        self.subTitleLabel.textColor = SecondColor;
        self.subTitleLabel.text = @"每日登录+2TP";
        [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mainTitleLabel);
            make.bottom.equalTo(self).offset(RELATIVE_WIDTH(-12));
            make.height.mas_equalTo(RELATIVE_WIDTH(17));
        }];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:self.btn];
        [self.btn setImage:[UIImage imageNamed:@"ic_yiwancheng"] forState:UIControlStateSelected];
        [self.btn setTitle:[APPLanguageService wyhSearchContentWith:@"wancheng"] forState:UIControlStateSelected];
        [self.btn setTitle:[APPLanguageService wyhSearchContentWith:@"quwancheng"] forState:UIControlStateNormal];
        [self.btn setTitleColor:kHEXCOLOR(0xffffff) forState:UIControlStateSelected];
        [self.btn setTitleColor:SecondColor forState:UIControlStateNormal];
        self.btn.titleLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
        ViewBorderRadius(self.btn, RELATIVE_WIDTH(2), RELATIVE_WIDTH(1), SecondColor);
        [self.btn addTarget:self action:@selector(cancelHighLight:) forControlEvents:UIControlEventAllEvents];
        [self.btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            self.btnTopConstraint = make.centerY.equalTo(self);
            make.right.equalTo(self).offset(RELATIVE_WIDTH(-15));
            make.width.mas_equalTo(RELATIVE_WIDTH(72));
            make.height.mas_equalTo(RELATIVE_WIDTH(28));
        }];
        
        
        
        UIView *lineView = [UIView new];
        [self addSubview:lineView];
        lineView.backgroundColor = SeparateColor;
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(RELATIVE_WIDTH(15));
            make.right.equalTo(self);
            make.bottom.equalTo(self).offset(RELATIVE_WIDTH(-0.5));
            make.height.mas_equalTo(RELATIVE_WIDTH(0.5));
            
        }];
        
        
        self.myProgressView = [[UIView alloc] init];
        [self addSubview:self.myProgressView];
        self.myProgressView.backgroundColor = ViewBGColor;
        ViewRadius(self.myProgressView, RELATIVE_WIDTH(2));
        [self.myProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.btn);
            make.height.mas_offset(RELATIVE_WIDTH(4));
            make.top.equalTo(self.btn.mas_bottom).offset(RELATIVE_WIDTH(5));
        }];
        
        self.myProgressView.hidden = YES;
        
        self.myProgeressValueView = [UIView new];
        [self.myProgressView addSubview:self.myProgeressValueView];
        self.myProgeressValueView.backgroundColor = kHEXCOLOR(0x108EE9);
        ViewRadius(self.myProgeressValueView, RELATIVE_WIDTH(2));
        [self.myProgeressValueView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.myProgressView);
            self.progressConstraint = make.width.equalTo(self.myProgressView).multipliedBy(1);
        }];
        
        
        self.tipLabel.hidden = YES;
        self.mainTitleLabel.hidden = YES;
        self.subTitleLabel.hidden = YES;
        self.btn.hidden = YES;
        
        
    }
    return self;
}


-(void)parseData:(TargetModel*)model row:(NSInteger)row btnClick:(TargetBtnClickBlock)btnBlock{
    
    
    self.btnBlock = btnBlock;
    self.btn.tag = row;
    
    if (model.isFirstRow) {
        self.tipLabel.hidden = NO;
        self.mainTitleLabel.hidden = YES;
        self.subTitleLabel.hidden = YES;
        self.btn.hidden = YES;
    }else{
        self.tipLabel.hidden = YES;
        self.mainTitleLabel.hidden = NO;
        self.subTitleLabel.hidden = NO;
        self.btn.hidden = NO;
    }
    
    
    if ([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]) {
        self.mainTitleLabel.text = model.name;
        self.subTitleLabel.text = model.describe;
    }else{
        self.mainTitleLabel.text = model.nameEn;
        self.subTitleLabel.text = model.describeEn;
    }
    
    if (model.totalNum < 2) {
        //不显示进度条
        if (model.totalNum == 1) {
            if (model.useNum == model.totalNum) {
                self.btn.selected = YES;
            }else{
                self.btn.selected = NO;
            }
            
            //完成无上限
        }else if(model.totalNum == 0){
            self.btn.selected = NO;
        }
        self.myProgressView.hidden = YES;
        
        [self.btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
        }];
        
    }else{
        
        //显示进度条
        self.myProgressView.hidden = NO;
        CGFloat scaleValue = (CGFloat)model.useNum/(CGFloat)model.totalNum;
        [self.myProgeressValueView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.myProgressView);
            make.width.equalTo(self.myProgressView).multipliedBy(scaleValue);
        }];
        
       
        //完成任务
        if (model.useNum == model.totalNum) {
            self.myProgressView.hidden = YES;
            self.btn.selected = YES;
            [self.btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self);
            }];
        }else{
            self.btn.selected = NO;
            [self.btn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self).offset(RELATIVE_WIDTH(-5));
            }];
        }
        
    }
    
    if (self.btn.selected) {
        self.btn.backgroundColor = kHEXCOLOR(0x108EE9);
        self.btn.titleEdgeInsets = UIEdgeInsetsMake(0, RELATIVE_WIDTH(5), 0, 0);
        ViewBorderRadius(self.btn, RELATIVE_WIDTH(2), 0, kHEXCOLOR(0x666666));
    }else{
        self.btn.backgroundColor = isNightMode?ViewContentBgColor:CWhiteColor;
        self.btn.titleEdgeInsets = UIEdgeInsetsZero;
        ViewBorderRadius(self.btn, RELATIVE_WIDTH(2), RELATIVE_WIDTH(1), SecondColor);
    }
    
}


-(void)cancelHighLight:(UIButton*)btn{
    btn.highlighted = NO;
}

-(void)btnClick:(UIButton*)btn{
    
    if (!btn.selected) {
        NSLog(@"按钮点击");
        if (self.btnBlock) {
            self.btnBlock(btn);
        }
    }
}


@end
