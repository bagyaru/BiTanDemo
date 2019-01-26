//
//  MyTanLiViewController.m
//  BT
//
//  Created by apple on 2018/4/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyTanLiViewController.h"
#import "UIButton+Factory.h"
#import "LabelIndicatorView.h"
#import "BTMyCoinRequest.h"
#define wRatio (iPhoneX?1:ScreenWidth/375.0f)
#define hRatio (iPhoneX?1:ScreenHeight/667.0f)

@interface MyTanLiViewController ()<BTLoadingViewDelegate>
@property (nonatomic, strong) UIScrollView *mScrollView;
@property (nonatomic, strong) UILabel *lastTanLiLabel;
@property (nonatomic, strong) UILabel *totalTanLiLabel;
@property (nonatomic, strong) UILabel *tanLiNameL;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UILabel *infoL;//信息
@property (nonatomic, strong) UILabel *infoDetailL;
@property (nonatomic, strong) UIButton *mjBtn;//币探秘籍
@property (nonatomic, strong) BTLoadingView *loadingView;


@end

@implementation MyTanLiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [APPLanguageService wyhSearchContentWith:@"wodetanli"];
    [self addNavigationItemViewWithImageNames:@"tanli_prompt" isLeft:NO target:self action:@selector(ptomptBtnClick) tag:10000];
    [self createUI];
    [self loadData];
}

#pragma mark --Create UI
- (void)createUI{
    [self setBgView];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:nil delegate:self];
}
- (void)setBgView{
    
    _mScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    _mScrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mScrollView];
    [_mScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    if(ScreenHeight<667.0f){
        _mScrollView.contentSize =CGSizeMake(ScreenWidth, 667.0f-(iPhoneX?88:64));
        _mScrollView.bounces = NO;
    }else{
        _mScrollView.contentSize =CGSizeMake(ScreenWidth, self.view.height -(iPhoneX?88:64));
        _mScrollView.bounces = NO;
    }
    UIView *view = _mScrollView;
    
    UIImageView *layerimageV =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tanli_layer"]];
    [view addSubview:layerimageV];
    layerimageV.userInteractionEnabled = YES;
    layerimageV.frame = CGRectMake(0, 0, ScreenWidth, _mScrollView.contentSize.height);
    
    UIImageView *headiamgeV =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tanli_background"]];
    [layerimageV addSubview:headiamgeV];
    headiamgeV.userInteractionEnabled =YES;
    //
    [headiamgeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(layerimageV).offset(20*wRatio);
        make.right.equalTo(layerimageV).offset(-20*wRatio);
        make.top.equalTo(layerimageV).offset(25*hRatio);
        make.height.mas_equalTo(192.0f*hRatio);
    }];
   
    UIFont *headerFont =nil;
    UIFont *headerFont1 =nil;
    UIFont *headerValueFont=nil;
    if(IOS_VERSION>=9.0){
        headerFont =[UIFont fontWithName:@"PingFangSC-Regular" size:12];
        headerFont1 =[UIFont fontWithName:@"PingFangSC-Regular" size:14];
        headerValueFont =[UIFont fontWithName:@"PingFangSC-Medium" size:36];
    }else{
        headerFont =[UIFont systemFontOfSize:12.0f];
        headerFont1 =[UIFont systemFontOfSize:14.0f];
        headerValueFont =[UIFont systemFontOfSize:36.0f];
    }
    LabelIndicatorView *recordView =[[LabelIndicatorView alloc] initWithFrame:CGRectZero invite:NO title:[APPLanguageService wyhSearchContentWith:@"lishijilu"] font:headerFont textColor:kHEXCOLOR(0xFFFFFF) alpha:0.8];
    LabelIndicatorView *yaoqingView =[[LabelIndicatorView alloc] initWithFrame:CGRectZero invite:NO title:[APPLanguageService wyhSearchContentWith:@"yaoqinghaoyoujisujiatanli"] font:headerFont1 textColor:kHEXCOLOR(0xFFFFFF) alpha:1];
    UITapGestureRecognizer *tapRecord =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRecord:)];
    UIGestureRecognizer *tapInvite = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapInvite:)];
    [recordView addGestureRecognizer:tapRecord];
    [yaoqingView addGestureRecognizer:tapInvite];
    
    _lastTanLiLabel =[UILabel labelWithFrame:CGRectZero title:[NSString stringWithFormat:@"%@：2",[APPLanguageService wyhSearchContentWith:@"zuoritanli"]] font:headerFont textColor:kHEXCOLOR(0xFFFFFF)];
    _totalTanLiLabel =[UILabel labelWithFrame:CGRectZero title:@"555" font:headerValueFont textColor:kHEXCOLOR(0xF3C52D)];
    _totalTanLiLabel.adjustsFontSizeToFitWidth = YES;
    _tanLiNameL = [UILabel labelWithFrame:CGRectZero title:[APPLanguageService wyhSearchContentWith:@"tanli"] font:[UIFont systemFontOfSize:16.0f] textColor:kHEXCOLOR(0xFFCE2A)];
    [headiamgeV addSubview:_lastTanLiLabel];
    [headiamgeV addSubview:_totalTanLiLabel];
    [headiamgeV addSubview:_tanLiNameL];
    [headiamgeV addSubview:recordView];
    [headiamgeV addSubview:yaoqingView];
    
    
    [_lastTanLiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headiamgeV).offset(15);
        make.top.equalTo(headiamgeV).offset(15);
    }];
    [recordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headiamgeV).offset(-15);
        make.centerY.equalTo(_lastTanLiLabel.mas_centerY);
        make.height.mas_equalTo(17);
        make.width.mas_equalTo(60.0f);
    }];
    [yaoqingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headiamgeV.mas_centerX);
        make.bottom.equalTo(headiamgeV.mas_bottom).offset(-17);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(125.0f);
    }];
    
    [_totalTanLiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headiamgeV.mas_centerX);
        make.top.equalTo(headiamgeV).offset(47);
    }];
    [_tanLiNameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(headiamgeV.mas_centerX);
        make.top.equalTo(_totalTanLiLabel.mas_bottom).offset(1);
    }];
    
    UIImageView *iconImageV =[[UIImageView alloc]initWithImage:IMAGE_NAMED(ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans)?@"tanli_coin":@"tanli_coin_EN")];
    [view addSubview:iconImageV];
    [iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view.mas_centerX);
        make.top.equalTo(headiamgeV.mas_bottom).offset(30.0f*hRatio);
        make.width.mas_equalTo(157.0f);
        make.height.mas_equalTo(100.0f);
    }];
    
    UIFont *nameFont =nil;
    UIFont *font =nil;
    if(IOS_VERSION>=9.0){
        nameFont = [UIFont fontWithName:@"PingFangSC-Medium" size:16];
        font =[UIFont fontWithName:@"PingFangSC-Medium" size:12];
        
    }else{
        font =[UIFont systemFontOfSize:12.0f];
        nameFont = [UIFont systemFontOfSize:16.0f];
    }
    _nameL = [UILabel labelWithFrame:CGRectZero title:[APPLanguageService wyhSearchContentWith:@"bitanbi"] font:nameFont textColor:kHEXCOLOR(0xFFCE2A)];
    _infoL = [UILabel labelWithFrame:CGRectZero title:@"" font:font textColor:kHEXCOLOR(0xFFCE2A)];

    _infoDetailL = [UILabel labelWithFrame:CGRectZero title:@"" font:font textColor:kHEXCOLOR(0xFFCE2A)];
    _infoL.numberOfLines = 0;
    _infoL.alpha = 0.8f;
    _infoDetailL.numberOfLines = 0;
    _infoL.lineBreakMode = NSLineBreakByCharWrapping;
    _infoDetailL.lineBreakMode =NSLineBreakByCharWrapping;
    _infoDetailL.alpha = 0.8f;
    
    _infoL.attributedText =[self attributeStr:[APPLanguageService wyhSearchContentWith:@"bitanbeizhu1"]];
    _infoDetailL.attributedText =[self attributeStr:[APPLanguageService wyhSearchContentWith:@"bitanbeizhu2"]];
    
    
    [layerimageV addSubview:_nameL];
    [layerimageV addSubview:_infoL];
    [layerimageV addSubview:_infoDetailL];

    [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.top.equalTo(iconImageV.mas_bottom).offset(15.0f*hRatio);
    }];
    [_infoL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameL.mas_bottom).offset(18.0f*hRatio);
        make.left.equalTo(layerimageV).offset(35*wRatio);
        make.right.equalTo(layerimageV).offset(-35*wRatio);
    }];
    [_infoDetailL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_infoL.mas_bottom).offset(10.0f*hRatio);
        make.left.equalTo(layerimageV).offset(35*wRatio);
        make.right.equalTo(layerimageV).offset(-49*wRatio);
    }];
    
    //
    _mjBtn = [UIButton buttonWithType:UIButtonTypeCustom size:CGSizeMake(157.0f, 46.0f) title:[APPLanguageService wyhSearchContentWith:@"bitanmiji"]  titleColor:kHEXCOLOR(0xFFCE2A)  titleFont:nameFont gradientColor:@[(__bridge id)kHEXCOLOR(0x1304B7).CGColor,(__bridge id)kHEXCOLOR(0xB808AD).CGColor] completionBlock:^{
        
        H5Node *node = [[H5Node alloc] init];
        node.title = [APPLanguageService wyhSearchContentWith:@"bitanmiji"];
        node.webUrl = myCoinSecretUrl;
        node.isNoLanguage = YES;
        
        [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
        
    }];
    _mjBtn.layer.cornerRadius = 23.0f;
    _mjBtn.layer.masksToBounds =YES;
    [layerimageV addSubview:_mjBtn];
    [_mjBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(layerimageV);
        make.width.mas_equalTo(157.0f);
        make.height.mas_equalTo(46.0f);
        make.bottom.equalTo(layerimageV.mas_bottom).offset(-34);
    }];
}

- (NSAttributedString*)attributeStr:(NSString*)str {
    UIFont *font =nil;
    if(IOS_VERSION>=9.0){
        font =[UIFont fontWithName:@"PingFangSC-Medium" size:12];
    }else{
        font =[UIFont systemFontOfSize:12.0f];
    }
    NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
    wordStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *wordDic = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:wordStyle};
    NSMutableAttributedString *wordLabelAttStr = [[NSMutableAttributedString alloc] initWithString:str attributes:wordDic];
    return wordLabelAttStr;
}
#pragma mark -- Load Data
- (void)loadData{
    [self requestData];
}

- (void)requestData{
    [self.loadingView showLoading];
    BTMyCoinRequest *api = [[BTMyCoinRequest alloc]init];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if(request.data&&[request.data isKindOfClass:[NSDictionary class]]){
            self.lastTanLiLabel.text =[NSString stringWithFormat:@"%@：%@",[APPLanguageService wyhSearchContentWith:@"zuoritanli"], SAFESTRING(request.data[@"yesterdayCoin"])];
            self.totalTanLiLabel.text =[NSString stringWithFormat:@"%@", SAFESTRING(request.data[@"totalCoin"])];
            
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
#pragma mark -- Event Response
//币探秘籍
- (void)ptomptBtnClick{
    H5Node *node = [[H5Node alloc] init];
    node.title = [APPLanguageService wyhSearchContentWith:@"bitanmiji"];
    node.webUrl = myCoinSecretUrl;
    node.isNoLanguage = YES;
    
    [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
}
//历史记录
- (void)tapRecord:(UIGestureRecognizer*)gesture{
    [BTCMInstance pushViewControllerWithName:@"MyTanLiDetailVC" andParams:nil];
}
//邀请好友
- (void)tapInvite:(UIGestureRecognizer*)gesture{
    [BTCMInstance pushViewControllerWithName:@"InviteFriendVC" andParams:nil];
}

- (void)refreshingData{
    [self requestData];
}
@end
