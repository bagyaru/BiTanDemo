//
//  QianDaoTableViewCell.m
//  BT
//
//  Created by apple on 2018/5/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QianDaoTableViewCell.h"

@interface QianDaoTableViewCell ()

/**签到第几天label*/
@property (nonatomic,strong) UILabel *qianDaoDayLabel;
/**签到图数组*/
@property (nonatomic,strong) NSMutableArray *imgBgViewArr;
/**探力数值数组*/
@property (nonatomic,strong) NSArray *tpNumArr;

@end
@implementation QianDaoTableViewCell

- (NSArray *)tpNumArr{
    if (!_tpNumArr) {
        _tpNumArr = @[@"3",@"3",@"5",@"8",@"12",@"20",@"30"];
    }
    return _tpNumArr;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //顶部签到的视图部分
        UIView *topView = [[UIView alloc] init];
        [self addSubview:topView];
        
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.mas_equalTo(RELATIVE_WIDTH(138));
        }];
        
//        topView.backgroundColor = [UIColor redColor];
        
        
        UILabel *topTipLabel  = [[UILabel alloc] init];
        [topView addSubview:topTipLabel];
        topTipLabel.text = [APPLanguageService wyhSearchContentWith:@"meiriqiandao"];
        topTipLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(16)];
        topTipLabel.textColor = kHEXCOLOR(0x111210);
        [topTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topView).offset(RELATIVE_WIDTH(16));
            make.top.equalTo(topView).offset(RELATIVE_WIDTH(13));
            make.height.mas_equalTo(RELATIVE_WIDTH(22));
        }];
        
        
        self.qianDaoDayLabel = [[UILabel alloc] init];
        [topView addSubview:self.qianDaoDayLabel];
        self.qianDaoDayLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
        self.qianDaoDayLabel.textColor = kHEXCOLOR(0x666666);
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[APPLanguageService wyhSearchContentWith:@"diyitian"]];
        [attributedString setAttributes:@{NSForegroundColorAttributeName:kHEXCOLOR(0x108ee9)} range:NSMakeRange(2, 1)];
        self.qianDaoDayLabel.attributedText = attributedString;
        
        [self.qianDaoDayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(topView).offset(RELATIVE_WIDTH(14));
            make.right.equalTo(topView).offset(RELATIVE_WIDTH(-15));
            make.height.mas_equalTo(RELATIVE_WIDTH(20));
        }];
        
        UIView *topViewLineView = [[UIView alloc] init];
        [topView addSubview:topViewLineView];
        topViewLineView.backgroundColor = kHEXCOLOR(0xdddddd);
        [topViewLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(topView).offset(RELATIVE_WIDTH(15));
            make.right.equalTo(topView);
            make.top.equalTo(topTipLabel.mas_bottom).offset(RELATIVE_WIDTH(13));
            make.height.mas_equalTo(RELATIVE_WIDTH(0.5));
        }];
        
        
        UIView *qianDaoImgBgView = [UIView new];
        [topView addSubview:qianDaoImgBgView];
        [qianDaoImgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(topView);
            make.top.equalTo(topViewLineView.mas_bottom);
        }];
        //    qianDaoImgBgView.backgroundColor = [UIColor redColor];
        
        self.imgBgViewArr = [NSMutableArray array];
        for (int i = 0; i < 7; i++) {
            UIView *customImgBgView = [[UIView alloc] init];
            customImgBgView.tag = 1000+i;
            [qianDaoImgBgView addSubview:customImgBgView];
            //签到探力奖励label
            UILabel *qianDaoTpLabel = [UILabel new];
            [customImgBgView addSubview:qianDaoTpLabel];
            qianDaoTpLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
            qianDaoTpLabel.textColor = kHEXCOLOR(0x999999);
            qianDaoTpLabel.textAlignment = NSTextAlignmentCenter;
            qianDaoTpLabel.text = [NSString stringWithFormat:@"+%@",self.tpNumArr[i]];
            qianDaoTpLabel.tag = 2000+i;
            
            [qianDaoTpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(customImgBgView);
                make.bottom.equalTo(customImgBgView).offset(RELATIVE_WIDTH(-19));
                make.height.mas_equalTo(RELATIVE_WIDTH(17));
            }];
            
            UIImageView *imgView = [[UIImageView alloc] init];
            [customImgBgView addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(customImgBgView);
                make.bottom.equalTo(qianDaoTpLabel.mas_top).offset(RELATIVE_WIDTH(-5));
            }];
            
            imgView.tag = 3000+i;
            if (i != 6) {
                imgView.image = [UIImage imageNamed:@"ic_tanli-weilingqu"];
            }else{
                imgView.image = [UIImage imageNamed:@"ic_bigtanli-weilingqu"];
            }
            
            //        customImgBgView.backgroundColor = [UIColor blueColor];
            
            [self.imgBgViewArr addObject:customImgBgView];
            
        }
        
        
        [self.imgBgViewArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:RELATIVE_WIDTH(32) leadSpacing:RELATIVE_WIDTH(16) tailSpacing:RELATIVE_WIDTH(16)];

        [self.imgBgViewArr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(qianDaoImgBgView);
        }];
        
        
        //下面的分割线
        UIView *topViewBottomLineView = [UIView new];
        [topView addSubview:topViewBottomLineView];
        topViewBottomLineView.backgroundColor = kHEXCOLOR(0xdddddd);
        [topViewBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(topView);
            make.bottom.equalTo(topView).offset(RELATIVE_WIDTH(-0.5));
            make.height.mas_equalTo(RELATIVE_WIDTH(0.5));
        }];
        
        
        //连续签到提醒界面
        UIView *continueCallView = [UIView new];
        [topView addSubview:continueCallView];
        //    continueCallView.backgroundColor = [UIColor redColor];
        [continueCallView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(qianDaoImgBgView.mas_bottom);
            make.width.equalTo(self);
            make.height.mas_equalTo(RELATIVE_WIDTH(68));
        }];
        
        UILabel *continueTipLabel = [UILabel new];
        [continueCallView addSubview:continueTipLabel];
        continueTipLabel.text = [APPLanguageService wyhSearchContentWith:@"lianxuqiandao"];
        continueTipLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(16)];
        continueTipLabel.textColor = kHEXCOLOR(0x111210);
        [continueTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(continueCallView).offset(RELATIVE_WIDTH(16));
            make.centerY.equalTo(continueCallView);
            make.height.mas_equalTo(RELATIVE_WIDTH(22));
        }];
        
        
        UIButton *continueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:continueBtn];
        [continueBtn setImage:[UIImage imageNamed:@"switch-close"] forState:UIControlStateNormal];
        [continueBtn setImage:[UIImage imageNamed:@"switch-open"] forState:UIControlStateSelected];
        [continueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(continueCallView).offset(RELATIVE_WIDTH(-5));
            make.centerY.equalTo(continueCallView);
            make.width.mas_equalTo(RELATIVE_WIDTH(48));
            make.height.mas_equalTo(RELATIVE_WIDTH(32));
        }];
        
        continueBtn.selected = [[NSUserDefaults standardUserDefaults] boolForKey:continueQianDao];
        
        [continueBtn addTarget:self action:@selector(continueBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [continueBtn addTarget:self action:@selector(cancelHighLight:) forControlEvents:UIControlEventAllEvents];
        
        
        //添加下面的下划线
        UIView *continueCallViewLineView = [[UIView alloc] init];
        [continueCallView addSubview:continueCallViewLineView];
        continueCallViewLineView.backgroundColor =kHEXCOLOR(0xdddddd);
        [continueCallViewLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(continueCallView);
            make.bottom.equalTo(continueCallView).offset(RELATIVE_WIDTH(-0.5));
            make.height.mas_equalTo(RELATIVE_WIDTH(0.5));
        }];
        
        //签到规则界面
        UIView *qianDaoRuleBgView = [UIView new];
        [self addSubview:qianDaoRuleBgView];
        [qianDaoRuleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(continueCallView.mas_bottom);
            make.bottom.equalTo(self);
            make.width.equalTo(self);
        }];
        //    qianDaoRuleBgView.backgroundColor = [UIColor redColor];
        
        
        UILabel *qiandaoTipLabel = [UILabel new];
        [qianDaoRuleBgView addSubview:qiandaoTipLabel];
        qiandaoTipLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(16)];
        qiandaoTipLabel.textColor = kHEXCOLOR(0x111210);
        qiandaoTipLabel.text = [APPLanguageService wyhSearchContentWith:@"qiandaoguize"];
        [qiandaoTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(qianDaoRuleBgView).offset(RELATIVE_WIDTH(16));
            make.top.equalTo(qianDaoRuleBgView).offset(RELATIVE_WIDTH(13));
            make.height.mas_equalTo(RELATIVE_WIDTH(22));
        }];
        
        UIView *qiandaoRuleLineView = [UIView new];
        [qianDaoRuleBgView addSubview:qiandaoRuleLineView];
        qiandaoRuleLineView.backgroundColor = kHEXCOLOR(0xdddddd);
        [qiandaoRuleLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(qianDaoRuleBgView).offset(RELATIVE_WIDTH(15));
            make.right.equalTo(qianDaoRuleBgView);
            make.top.equalTo(qiandaoTipLabel.mas_bottom).offset(RELATIVE_WIDTH(13));
            make.height.mas_equalTo(RELATIVE_WIDTH(0.5));
        }];
        
        
        NSArray *ruletitleArr = @[[APPLanguageService wyhSearchContentWith:@"qiandaoguize1"],
                                  [APPLanguageService wyhSearchContentWith:@"qiandaoguize2"],
                                  [APPLanguageService wyhSearchContentWith:@"qiandaoguize3"],
                                  [APPLanguageService wyhSearchContentWith:@"qiandaoguize4"],
                                  [APPLanguageService wyhSearchContentWith:@"qiandaoguize5"]];
        
        CGFloat margin = RELATIVE_WIDTH(10);
        UIView *tempView = qiandaoRuleLineView;
        for (int i = 0; i< ruletitleArr.count; i++) {
            UILabel *ruleLabel = [UILabel new];
            [qianDaoRuleBgView addSubview:ruleLabel];
            ruleLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
            ruleLabel.textColor = kHEXCOLOR(0x666666);
            ruleLabel.numberOfLines = 0;
            ruleLabel.text = ruletitleArr[i];
            
            [ruleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(qianDaoRuleBgView).offset(RELATIVE_WIDTH(16));
                make.right.equalTo(qianDaoRuleBgView).offset(RELATIVE_WIDTH(-16));
                make.top.equalTo(tempView.mas_bottom).offset(margin);
//                make.height.mas_equalTo(RELATIVE_WIDTH(17));
            }];
            
            tempView = ruleLabel;
            margin = RELATIVE_WIDTH(5);
        }
        

        
    }
    
    return self;
}

//连续签到几天  1到7
-(NSString *)parseData:(QianDaoModel*)model{
    if (model.day > 0 && model.day <= 7) {
        for (int i = 0; i<model.day; i++) {
            UIImageView *imgView = [self.imgBgViewArr[i] viewWithTag:3000+i];
            if (i != 6) {
                imgView.image = [UIImage imageNamed:@"ic_tanli-yilingqu"];
            }else{
                imgView.image = [UIImage imageNamed:@"ic_bigtanli-yilingqu"];
            }
            
            UILabel *label = [self.imgBgViewArr[i] viewWithTag:2000+i];
            label.text = [APPLanguageService wyhSearchContentWith:@"yiling"];
            label.textColor = kHEXCOLOR(0x111210);
        }
        
        
        NSString *dayStr = [[APPLanguageService wyhSearchContentWith:@"diyitian"] stringByReplacingOccurrencesOfString:@"0" withString:[NSString stringWithFormat:@"%ld",model.day]];
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:dayStr];
        [attributed setAttributes:@{NSForegroundColorAttributeName:kHEXCOLOR(0x108ee9)} range:[dayStr rangeOfString:[NSString stringWithFormat:@"%ld",model.day]]];
        self.qianDaoDayLabel.attributedText = attributed;
        
        return @"";
    }
    
    return @"";
}

-(void)cancelHighLight:(UIButton*)btn{
    btn.highlighted = NO;
}

-(void)continueBtnClick:(UIButton *)btn{
    
    btn.selected = !btn.selected;
    //连续签到按钮点击
    [[NSUserDefaults standardUserDefaults] setBool:btn.selected forKey:continueQianDao];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
