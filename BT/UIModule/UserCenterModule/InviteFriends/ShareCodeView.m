//
//  ShareCodeView.m
//  BT
//
//  Created by apple on 2018/5/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShareCodeView.h"

@interface ShareCodeView ()

@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation ShareCodeView


-(instancetype)initWithCodeStr:(NSString *)codeStr reward:(NSInteger)reward{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        [self createUI:codeStr reward:reward];
    }
    
    return self;
}

-(void)createUI:(NSString*)codeStr reward:(NSInteger)reward{
    
    self.scrollView = [UIScrollView new];
    [self addSubview:self.scrollView];
    self.scrollView.backgroundColor = kHEXCOLOR(0xf5f5f5);
    
    UIView *navView = [UIView new];
    [self.scrollView addSubview:navView];
    navView.backgroundColor = [UIColor whiteColor];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(64);
    }];
    
    UIView *topView = [UIView new];
    [self.scrollView addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(navView.mas_bottom);
        make.height.mas_equalTo(RELATIVE_WIDTH(RELATIVE_WIDTH(188)));
    }];
    
    UIImageView *imgBgView = [UIImageView new];
    [topView addSubview:imgBgView];
    imgBgView.image = [UIImage imageNamed:@"bg_01"];
    [imgBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topView);
        //make.left.right.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    
    UIImageView *iconImgView = [UIImageView new];
    [topView addSubview:iconImgView];
    iconImgView.image = [UIImage imageNamed:@"ic_touxiang"];
    iconImgView.backgroundColor = [UIColor whiteColor];
    ViewBorderRadius(iconImgView, RELATIVE_WIDTH(8), RELATIVE_WIDTH(1), kHEXCOLOR(0xdddddd));
    [iconImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topView);
        make.top.equalTo(topView).offset(RELATIVE_WIDTH(32));
        make.width.height.mas_equalTo(RELATIVE_WIDTH(60));
    }];
    
    UILabel *topTipLabel = [UILabel new];
    [topView addSubview:topTipLabel];
    topTipLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(24) weight:UIFontWeightMedium];
    topTipLabel.textColor = kHEXCOLOR(0x111210);
    topTipLabel.text = [APPLanguageService wyhSearchContentWith:@"bitan"];
    [topTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImgView.mas_bottom).offset(RELATIVE_WIDTH(5));
        make.centerX.equalTo(topView);
        make.height.mas_equalTo(RELATIVE_WIDTH(33));
    }];
    
    UILabel *topDescLabel = [UILabel new];
    [topView addSubview:topDescLabel];
    topDescLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
    topDescLabel.textColor = kHEXCOLOR(0x111210);
    topDescLabel.numberOfLines = 0;
    topDescLabel.textAlignment = NSTextAlignmentCenter;
    topDescLabel.text = [APPLanguageService wyhSearchContentWith:@"fenxiangTopDesc"];
    [topDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topTipLabel.mas_bottom).offset(RELATIVE_WIDTH(5));
        make.left.equalTo(topView).offset(RELATIVE_WIDTH(15));
        make.right.equalTo(topView).offset(RELATIVE_WIDTH(-15));
    }];
    
    
    
    //底部视图
    UIView *bottomView = [UIView new];
    [self.scrollView addSubview:bottomView];
    bottomView.backgroundColor = [UIColor clearColor];
    ViewRadius(bottomView, RELATIVE_WIDTH(6));
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(RELATIVE_WIDTH(27));
        make.right.equalTo(self).offset(RELATIVE_WIDTH(-27));
        make.top.equalTo(topView.mas_bottom).offset(RELATIVE_WIDTH(16));
        make.height.mas_equalTo([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]?RELATIVE_WIDTH(376):RELATIVE_WIDTH(400));
    }];
    
    UIView *bottomTopBgView = [UIView new];
    [bottomView addSubview:bottomTopBgView];
    bottomTopBgView.backgroundColor = [UIColor whiteColor];
    [bottomTopBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(bottomView);
        make.height.mas_equalTo(RELATIVE_WIDTH(230));
    }];
    
    UILabel *inviteTipLabel = [UILabel new];
    [bottomTopBgView addSubview:inviteTipLabel];
    inviteTipLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(16) weight:UIFontWeightMedium];
    inviteTipLabel.textColor = kHEXCOLOR(0x111210);
    inviteTipLabel.text = [APPLanguageService wyhSearchContentWith:@"yaoqingma"];
    [inviteTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomTopBgView);
        make.top.equalTo(bottomTopBgView).offset(RELATIVE_WIDTH(72));
        make.height.mas_equalTo(RELATIVE_WIDTH(22));
    }];
    
    
    UILabel *inviteCodeLabel = [UILabel new];
    [bottomTopBgView addSubview:inviteCodeLabel];
    inviteCodeLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(48) weight:UIFontWeightMedium];
    inviteCodeLabel.textColor = kHEXCOLOR(0x108ee9);
    [inviteCodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomTopBgView);
        make.top.equalTo(inviteTipLabel.mas_bottom).offset(RELATIVE_WIDTH(15));
        make.height.mas_equalTo(RELATIVE_WIDTH(67));
    }];
    inviteCodeLabel.text = codeStr;
    
    UIImageView *separateImgView = [UIImageView new];
    [bottomView addSubview:separateImgView];
    separateImgView.image = [UIImage imageNamed:@"ic_yaoqingye-fenge"];
    [separateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView);
        make.top.equalTo(bottomTopBgView.mas_bottom).offset(RELATIVE_WIDTH(-1));
        make.height.mas_equalTo(RELATIVE_WIDTH(34));
    }];
    
    
    UIView *bottomUnderBgView = [UIView new];
    [bottomView addSubview:bottomUnderBgView];
    bottomUnderBgView.backgroundColor = [UIColor whiteColor];
    [bottomUnderBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bottomView);
        make.top.equalTo(separateImgView.mas_bottom).offset(RELATIVE_WIDTH(-1));
    }];
    
    
    UILabel *bottomDescLabel = [UILabel new];
    [bottomUnderBgView addSubview:bottomDescLabel];
    bottomDescLabel.textColor= kHEXCOLOR(0x111210);
    bottomDescLabel.numberOfLines = 0;
    NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] init];
    
    NSArray *strArr = @[[APPLanguageService wyhSearchContentWith:@"fenxiangBottomDesc1"],[APPLanguageService wyhSearchContentWith:@"fenxiangBottomDesc2"],[APPLanguageService wyhSearchContentWith:@"fenxiangBottomDesc3"]];
    NSArray *fontArr = @[[UIFont systemFontOfSize:RELATIVE_WIDTH(16) weight:UIFontWeightMedium],
                         [UIFont systemFontOfSize:RELATIVE_WIDTH(12)],
                         [UIFont systemFontOfSize:RELATIVE_WIDTH(14) weight:UIFontWeightMedium]];

    for (int i = 0; i<3; i++) {
        
        NSString *descTitle = strArr[i];
        if (i == 0) {
            descTitle = [descTitle stringByReplacingOccurrencesOfString:@"20" withString:[NSString stringWithFormat:@"%ld",reward]];
        }
        NSMutableAttributedString *subArrributed = [[NSMutableAttributedString alloc] initWithString:descTitle];
        [subArrributed addAttributes:@{NSFontAttributeName:fontArr[i]} range:NSMakeRange(0, [descTitle length])];
        
        [attributed appendAttributedString:subArrributed];
    }
    
    
    //添加间距
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setLineSpacing:[[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]?RELATIVE_WIDTH(8):0];
    attributed.paragraphStyle = paragraphStyle;

    bottomDescLabel.attributedText = attributed;
    [bottomDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomUnderBgView).offset(RELATIVE_WIDTH(15));
        make.left.equalTo(bottomUnderBgView).offset(RELATIVE_WIDTH(15));
        make.width.mas_equalTo(RELATIVE_WIDTH(180));
    }];
    
    
    UIImageView *qrCodeImgView = [UIImageView new];
    [bottomView addSubview:qrCodeImgView];
    qrCodeImgView.image = [UIImage imageNamed:@"shareQRCode"];
    [qrCodeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomUnderBgView).offset(RELATIVE_WIDTH(-15));
        make.top.equalTo(bottomUnderBgView).offset(RELATIVE_WIDTH(10));
        make.width.height.mas_equalTo(RELATIVE_WIDTH(80));
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.bottom.equalTo(bottomView.mas_bottom).offset(RELATIVE_WIDTH(25));
    }];
    
}

-(CGFloat)scrollViewContentSizeH{
    return self.scrollView.contentSize.height;
}


@end
