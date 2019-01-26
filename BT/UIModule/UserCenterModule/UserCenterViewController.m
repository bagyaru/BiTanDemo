//
//  UserCenterViewController.m
//  BT
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UserCenterViewController.h"
#import "GetUserInfoRequest.h"
#import "MyInfoObJ.h"
#import "XianHuoSeachAllRequest.h"
#import "BTConfig.h"
#import "MyInfoObJ.h"
#import "UserAccountMainRequest.h"
#import "TPSignInRequest.h"
#import "BTIsSignInRequest.h"
#import "TPAlertView.h"
#import "QianDaoModel.h"
#import "BTSearchService.h"
#import "OneEntityVoObj.h"
#import "CheckMessageUnreadRequest.h"
#import "MessageModel.h"

#import "BTHelperMethod.h"
#import "TPGetTPRequest.h"
#import "BTMyTPModel.h"
#import "BTPersonViewController.h"
#import "BTUserStatisticReq.h"
#import "NSString+Utils.h"
#import "BTRedRiseAlertView.h"
@interface UserCenterViewController ()<UIActionSheetDelegate>{
    
    
    HYShareActivityView *_shareView;
    MyInfoObJ  *_detailMyInfo;
}
@property (weak, nonatomic) IBOutlet UIImageView *userIV;
@property (weak, nonatomic) IBOutlet BTLabel *noLoginAndNikeNameL;
@property (weak, nonatomic) IBOutlet BTLabel *moreL;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (nonatomic, strong) NSDictionary *userInfo;


@property (weak, nonatomic) IBOutlet BTLabel *shizhiL;

@property (weak, nonatomic) IBOutlet BTLabel *shizhiMoneyL;


@property (weak, nonatomic) IBOutlet BTLabel *benjinL;

@property (weak, nonatomic) IBOutlet BTLabel *profitLosL;

@property (weak, nonatomic) IBOutlet BTLabel *totalLosL;
@property (weak, nonatomic) IBOutlet UIView *myZCBackV;
@property (weak, nonatomic) IBOutlet UIImageView *freeGetTP;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (weak, nonatomic) IBOutlet BTButton *qbBtn;
@property (weak, nonatomic) IBOutlet UILabel *qbRoundL;
@property (weak, nonatomic) IBOutlet BTLabel *currencyContentL;

@property (weak, nonatomic) IBOutlet UIButton *redRiseGreenFallSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QbWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QbHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *QbTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *QbImgView;
@property (weak, nonatomic) IBOutlet UILabel *messageL;

@property (nonatomic, strong) NSMutableArray *JJSArray;

@property (nonatomic, assign) BOOL isOrNoQD;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContraint;

@property (weak, nonatomic) IBOutlet UILabel *getTanLiLabel;

@property (weak, nonatomic) IBOutlet UILabel *fabuCountL;

@property (weak, nonatomic) IBOutlet UILabel *guanzhuCountL;

@property (weak, nonatomic) IBOutlet UILabel *fensiCountL;

@property (weak, nonatomic) IBOutlet UILabel *huozanCountL;

@property (weak, nonatomic) IBOutlet UIView *fabuView;

@property (weak, nonatomic) IBOutlet UIView *guanzhuView;

@property (weak, nonatomic) IBOutlet UIView *fensiView;
@property (weak, nonatomic) IBOutlet UIView *huozanView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unreadLabel;

@property (weak, nonatomic) IBOutlet UIButton *NightModeOrDayModeSwitch;

@property (weak, nonatomic) IBOutlet UIButton *nightBtn_1;
@property (weak, nonatomic) IBOutlet UIButton *nightBtn_2;
@property (weak, nonatomic) IBOutlet UIButton *nightBtn_3;
@property (weak, nonatomic) IBOutlet UIButton *nightBtn_4;
@property (weak, nonatomic) IBOutlet UIButton *nightBtn_5;
@property (weak, nonatomic) IBOutlet UIButton *nightBtn_6;

@property (weak, nonatomic) IBOutlet UIImageView *imageView_1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_4;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_5;
@property (weak, nonatomic) IBOutlet UIImageView *imageView_6;

@property (nonatomic, strong) UIView *messageView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verifyBtnWidth;

@property (weak, nonatomic) IBOutlet UIView *avatarBgView;
@property (weak, nonatomic) IBOutlet UIButton *jzRightBtn;

@property (weak, nonatomic) IBOutlet UIButton *fbRightBtn;

@end

@implementation UserCenterViewController
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (!ISNSStringValid([BTConfig sharedInstance].Post_h5domain)) {
        [[BTConfigureService shareInstanceService] getGlobal_HTML_configuration];
    }
    //    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if (isNightMode) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }else {
        
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];//去掉阴影线
    [self checkIs0rNoLogin];
    [self checkUserAccount];
    [self checkMessageCenter];
    [self checkIsSignIn];
    [self requestTPAmount];
    [self requestUserInfo:RefreshStateNormal];
}
-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    //    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:SeparateColor size:CGSizeMake(ScreenWidth, 0.5)]];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [AnalysisService alaysisMine_page];
//    self.tableView.backgroundColor = KWhiteColor;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.nightBtn_1 setImage:IMAGE_NAMED(@"个人-币记账") forState:UIControlStateNormal];
    [self.nightBtn_2 setImage:IMAGE_NAMED(@"ic_hongchanglvdie") forState:UIControlStateNormal];
    [self.nightBtn_3 setImage:IMAGE_NAMED(@"ic_fabixianshi") forState:UIControlStateNormal];
    [self.nightBtn_4 setImage:IMAGE_NAMED(@"个人-夜间模式") forState:UIControlStateNormal];
    [self.nightBtn_5 setImage:IMAGE_NAMED(@"个人-消息") forState:UIControlStateNormal];
    [self.nightBtn_6 setImage:IMAGE_NAMED(@"settings") forState:UIControlStateNormal];
    
    self.imageView_1.image = IMAGE_NAMED(@"my_tanli_icon");
    self.imageView_2.image = IMAGE_NAMED(@"addWechat");
    self.imageView_3.image = IMAGE_NAMED(@"邀请好友");
    self.imageView_4.image = IMAGE_NAMED(@"我的收藏");
    self.imageView_5.image = IMAGE_NAMED(@"意见反馈");
    self.imageView_6.image = IMAGE_NAMED(@"help_center");
    ViewRadius(self.userIV, 33);
    ViewRadius(self.myZCBackV, 4);
    ViewRadius(self.qbRoundL, 5);
    ViewRadius(self.messageL, 6);
    ViewRadius(self.verifyBtn, 11.0f);
    [self.verifyBtn setTitle:[APPLanguageService sjhSearchContentWith:@"shenqingrenzheng"] forState:UIControlStateNormal];
    CGSize verifySize = [[APPLanguageService sjhSearchContentWith:@"shenqingrenzheng"] calculateSizeWithFont:12 height:30.0f];
    self.verifyBtnWidth.constant = verifySize.width + 20;

    self.qbBtn.titleLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
    [self isSignIn:NO];
    ViewBorderRadius(self.qbBtn, 14, 1, [UIColor colorWithHexString:@"72C4FF"]);
    
    self.redRiseGreenFallSwitch.selected = isRedRise;
    [self.redRiseGreenFallSwitch setImage:IMAGE_NAMED(@"个人-开关-关闭") forState:UIControlStateNormal];
    [self.redRiseGreenFallSwitch setImage:IMAGE_NAMED(@"个人-开关-开启") forState:UIControlStateSelected];
    
    self.NightModeOrDayModeSwitch.selected = isNightMode;
    [self.NightModeOrDayModeSwitch setImage:IMAGE_NAMED(@"个人-开关-关闭") forState:UIControlStateNormal];
    [self.NightModeOrDayModeSwitch setImage:IMAGE_NAMED(@"个人-开关-开启") forState:UIControlStateSelected];
    
    [self.fbRightBtn setImage:[UIImage imageNamed:@"R箭头"] forState:UIControlStateNormal];
    [self.jzRightBtn setImage:[UIImage imageNamed:@"R箭头"] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(JiGuangTuiSong) name:@"JiGuangTuiSong" object:nil];
    
    if (ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans)) {
        
        self.freeGetTP.image = IMAGE_NAMED(@"free_coin.png");
    }else {
        
        self.freeGetTP.image = IMAGE_NAMED(@"free_coin_EN.png");
    }
    if ([[APPLanguageService readLegalTendeType] isEqualToString:@"1"]) {
        
        self.currencyContentL.text = [APPLanguageService wyhSearchContentWith:@"renmingbi"];
    }else {
        
        self.currencyContentL.text = [APPLanguageService wyhSearchContentWith:@"dollar"];
    }
    //self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:self.tableView delegate:self];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, iPhoneX?83:49, 0);
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
//        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, iPhoneX?83:49, 0);
    }
    self.topContraint.constant = iPhoneX?24:20;
    
    [self configPersonalView];
    

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    
    [btn bk_addEventHandler:^(id  _Nonnull sender) {
        [AnalysisService alaysisMine_set];
        [BTCMInstance pushViewControllerWithName:@"SystemSetting" andParams:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:self.messageBtn];
    [self.messageBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    
}
//收到推送通知 刷新未读消息列表
-(void)JiGuangTuiSong {
    
    [self checkMessageCenter];
}
- (void)configPersonalView{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [self.fabuView addGestureRecognizer:tap];
    [self.guanzhuView addGestureRecognizer:tap1];
    [self.fensiView addGestureRecognizer:tap2];
    [self.huozanView addGestureRecognizer:tap3];
}

- (void)requestUserInfo:(RefreshState)state{
    if (![getUserCenter isLogined]) {
        self.fabuCountL.text =  @"--";
        self.guanzhuCountL.text =  @"--";
        self.fensiCountL.text = @"--";
        self.huozanCountL.text =  @"--";
        [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:@"" andImageView:_userIV andAuthStatus:0 andAuthType:0 addSuperView:self.avatarBgView];
        self.moreL.hidden = NO;
        self.verifyBtn.hidden = YES;
        return;
    }
    NSInteger userId = [BTGetUserInfoDefalut sharedManager].userInfo.userId;
    NSString *userName = [BTGetUserInfoDefalut sharedManager].userInfo.username;
    BTUserStatisticReq *stasticApi = [[BTUserStatisticReq alloc] initWithUserId:userId userName:userName];
    [stasticApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data){
            self.userInfo = request.data;
            self.fabuCountL.text =  SAFESTRING(self.userInfo[@"articleNum"]);
            self.guanzhuCountL.text =  SAFESTRING(self.userInfo[@"followNum"]);
            self.fensiCountL.text =  SAFESTRING(self.userInfo[@"fansNum"]);
            self.huozanCountL.text =  SAFESTRING(self.userInfo[@"likeNum"]);
            NSDictionary *user = self.userInfo[@"user"];

            NSInteger authStatus = [SAFESTRING(user[@"authStatus"]) integerValue];
            NSInteger authType = [SAFESTRING(user[@"authType"]) integerValue];
            
            if([user isKindOfClass:[NSDictionary class]]){
                
                [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:SAFESTRING(user[@"avatar"]) andImageView:_userIV andAuthStatus:authStatus andAuthType:authType addSuperView:self.avatarBgView];
            }else{
                [self.userIV sd_setImageWithURL:[NSURL URLWithString:[SAFESTRING(getUserCenter.detailMyInfo.userAvatar) hasPrefix:@"http"]?getUserCenter.detailMyInfo.userAvatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,getUserCenter.detailMyInfo.userAvatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
            }
            
            if(authStatus == 2){
                self.verifyBtn.hidden = YES;
                self.moreL.hidden = NO;
            }else{
                self.verifyBtn.hidden = NO;
                self.moreL.hidden = YES;
            }
            
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

- (void)tapAction:(UIGestureRecognizer*)gesture{
    UIView *view = gesture.view;
    NSInteger index = view.tag;
    
    NSInteger userId = [BTGetUserInfoDefalut sharedManager].userInfo.userId;
    NSString *userName = [BTGetUserInfoDefalut sharedManager].userInfo.username;
    
    if (![getUserCenter isLogined]) {
        [AnalysisService alaysisMine_login];
        [getUserCenter loginoutPullView];
        return;
    }
    if(index == 100){//发布
        [BTCMInstance pushViewControllerWithName:@"BTFabuViewController" andParams:@{@"userName":userName,@"userId":@(userId)}];
        [MobClick event:@"mine_fabu"];
        
    }else if(index == 101){//关注
        [BTCMInstance pushViewControllerWithName:@"BTFocusViewController" andParams:@{@"userName":@"",@"userId":@(userId)}];
        [MobClick event:@"mine_guanzhlist"];
    }else if(index == 102){//粉丝
        [BTCMInstance pushViewControllerWithName:@"BTFansViewController" andParams:@{@"userName":@"",@"userId":@(userId)}];
        [MobClick event:@"mine_fensi"];
    }else if(index == 103){//获赞
        [BTCMInstance pushViewControllerWithName:@"BTUserPraiseVC" andParams:@{@"type":@"1",@"userId":@([BTGetUserInfoDefalut sharedManager].userInfo.userId)}];
        [MobClick event:@"mine_zan"];
    }
}

-(void)requestTPAmount{
    if ([getUserCenter isLogined]) {
       
        TPGetTPRequest *request = [[TPGetTPRequest alloc] init];
        [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            if (request.isSuccess) {
                BTMyTPModel *model = [BTMyTPModel modelWithJSON:request.data];
                self.getTanLiLabel.text = [NSString stringWithFormat:@"%@%ldTP",[APPLanguageService wyhSearchContentWith:@"huodetanli"],model.totalCoin];
            }
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    }else {
        self.getTanLiLabel.text = [NSString stringWithFormat:@"%@%dTP",[APPLanguageService wyhSearchContentWith:@"huodetanli"],0];
    }
}
-(void)checkIs0rNoLogin {
    DLog(@"token=====%@=====",getUserCenter.userInfo.token);
    DLog(@"%@",getUserCenter.detailMyInfo.mobile);
    DLog(@"%ld",getUserCenter.detailMyInfo.userId);
    if ([getUserCenter isLogined]&&ISNSStringValid(getUserCenter.detailMyInfo.mobile)) {
//        self.moreL.hidden = YES;
        self.moreL.text = [APPLanguageService sjhSearchContentWith:@"dianjijinrugerenzhuye"];
        
        if (ISNSStringValid(getUserCenter.detailMyInfo.username)) {
            
            self.noLoginAndNikeNameL.text = getUserCenter.detailMyInfo.username;
        } else {
            
            self.noLoginAndNikeNameL.text = [getUserCenter getPhone:getUserCenter.detailMyInfo.mobile];
        }
       
//        [self.userIV sd_setImageWithURL:[NSURL URLWithString:[getUserCenter.detailMyInfo.userAvatar hasPrefix:@"http"]?getUserCenter.detailMyInfo.userAvatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,getUserCenter.detailMyInfo.userAvatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];

    } else {
        
        self.noLoginAndNikeNameL.text = [APPLanguageService wyhSearchContentWith:@"noLogin"];
        self.moreL.text = [APPLanguageService wyhSearchContentWith:@"loginMore"];
//        self.userIV.image = [UIImage imageNamed:@"morentouxiang"];
//        self.verifyBtn.hidden = YES;
//        self.moreL.hidden = NO;
    }
}
-(void)checkUserAccount {

    if ([getUserCenter isLogined]) {
      
        UserAccountMainRequest *api = [[UserAccountMainRequest alloc] initWithSort:1];
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            _detailMyInfo = [MyInfoObJ objectWithDictionary:request.data];
            
            NSArray *exchangeCodeArray = @[@"binance",@"huobi.pro",@"okex"];
            NSArray *exchangeNameArray = @[@"币安",@"火币pro",@"OKEx"];
            for (int i = 0; i < exchangeNameArray.count; i++) {
                
                if ([[BTSearchService sharedService] readExchangeAuthorizedWithExchangeName:exchangeNameArray[i] userId:[NSString stringWithFormat:@"%ld",getUserCenter.userInfo.userId]]) {
                    OneEntityVoObj *model         = [OneEntityVoObj objectWithDictionary:[AppHelper getExchangeTotolInfo:exchangeCodeArray[i]]];
                    model.exchangeName            = exchangeNameArray[i];
                    model.jjsOrjjb                = 10;
                    _detailMyInfo.currencyCount  += model.btcCount;
                    
                    _detailMyInfo.positionCapitalizationCurrency += model.btcCount;
                    _detailMyInfo.positionCapitalCurrency +=model.btcCount;
                    //市值 本金
                    _detailMyInfo.positionCapital        += kIsCNY?model.priceCny:model.priceUsd;
                    _detailMyInfo.positionCapitalization += kIsCNY?model.priceCny:model.priceUsd;
                    
                    [self.JJSArray addObject:model];
                }
            }
            NSArray *entityVoList = request.data[@"detailVOList"];
            if ([entityVoList count]||[self.JJSArray count]) {
                _detailMyInfo.isHavaData = YES;
                self.eyeBtn.enabled = YES;
                if (ISNSStringValid([APPLanguageService readIsOrNoEyesType])) {
                    
                    if (ISStringEqualToString([APPLanguageService readIsOrNoEyesType], @"闭")) {
                        
                        self.shizhiL.text = @"******";
                        self.benjinL.text = @"******";
                        self.profitLosL.text = @"******";
                        self.totalLosL.text = @"******";
                        self.shizhiMoneyL.text = @"******";
                        
                        [self.eyeBtn setImage:[UIImage imageNamed:@"眼睛-闭"] forState:UIControlStateNormal];
                        
                    } else {
                        
                        NSString *unit = [BTHelperMethod signStr];
                        self.shizhiL.text = [NSString stringWithFormat:@"%@BTC",[DigitalHelperService isp8DataWithDouble:_detailMyInfo.positionCapitalizationCurrency]];
                        self.shizhiMoneyL.text =[NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService transformWith:_detailMyInfo.positionCapitalization]];
                        
                        self.benjinL.text = [NSString stringWithFormat:@"%@BTC",[DigitalHelperService isp8DataWithDouble:_detailMyInfo.positionCapitalCurrency]];
                        self.profitLosL.text =[NSString stringWithFormat:@"%@BTC",[DigitalHelperService isp8DataWithDouble:_detailMyInfo.positionGainAndLossCurrency]];
                        
//                        self.totalLosL.text =[NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService transformWith:_detailMyInfo.totalGainAndLoss]];
                        
                        [self.eyeBtn setImage:[UIImage imageNamed:@"眼睛-睁"] forState:UIControlStateNormal];
                    }
                }else {
                    NSString *unit = [BTHelperMethod signStr];
                    self.shizhiL.text = [NSString stringWithFormat:@"%@BTC",[DigitalHelperService isp8DataWithDouble:_detailMyInfo.positionCapitalizationCurrency]];
                    self.shizhiMoneyL.text =[NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService transformWith:_detailMyInfo.positionCapitalization]];
                    
                    self.benjinL.text = [NSString stringWithFormat:@"%@BTC",[DigitalHelperService isp8DataWithDouble:_detailMyInfo.positionCapitalCurrency]];
                    self.profitLosL.text =[NSString stringWithFormat:@"%@BTC",[DigitalHelperService isp8DataWithDouble:_detailMyInfo.positionGainAndLossCurrency]];
                    
//                    self.totalLosL.text =[NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService transformWith:_detailMyInfo.totalGainAndLoss]];
                    
                    [self.eyeBtn setImage:[UIImage imageNamed:@"眼睛-睁"] forState:UIControlStateNormal];
                }
            } else {
                NSString *unit =@"BTC";
                self.shizhiL.text = [NSString stringWithFormat:@"%@%@",@"0.00",unit];
                self.benjinL.text = [NSString stringWithFormat:@"%@%@",@"0.00",unit];
                self.profitLosL.text = [NSString stringWithFormat:@"%@%@",@"0.00",unit];
                self.totalLosL.text = [NSString stringWithFormat:@"%@%@",@"0.00",unit];
                self.shizhiMoneyL.text = [NSString stringWithFormat:@"%@%@",[BTHelperMethod signStr],@"0.00"];
                [self.eyeBtn setImage:[UIImage imageNamed:@"眼睛-睁"] forState:UIControlStateNormal];
                
            }
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    }else {
        NSString *unit =@"BTC";
        self.shizhiL.text = [NSString stringWithFormat:@"%@%@",@"0.00",unit];
        self.benjinL.text = [NSString stringWithFormat:@"%@%@",@"0.00",unit];
        self.profitLosL.text = [NSString stringWithFormat:@"%@%@",@"0.00",unit];
        self.totalLosL.text = [NSString stringWithFormat:@"%@%@",@"0.00",unit];
        self.shizhiMoneyL.text = [NSString stringWithFormat:@"%@%@",[BTHelperMethod signStr],@"0.00"];
        [self.eyeBtn setImage:[UIImage imageNamed:@"眼睛-睁"] forState:UIControlStateNormal];
        
    }
    
}

#pragma mark - 判断是否已经签到
-(void)checkIsSignIn{
    
    if ([getUserCenter isLogined]) {
        BTIsSignInRequest *request = [BTIsSignInRequest new];
        [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            //表示已经签到
            if ([request.data integerValue]) {
                //self.qbBtn.selected = YES;
                self.isOrNoQD = YES;
                [self isSignIn:YES];
                self.qbRoundL.hidden = YES;
                ViewBorderRadius(self.qbBtn, 14, 1, BtnBorderColor);
            }else{
                //未签到
                //self.qbBtn.selected = NO;
                self.isOrNoQD = NO;
                [self isSignIn:NO];
                self.qbRoundL.hidden = YES;
                ViewBorderRadius(self.qbBtn, 14, 1, MainBg_Color);
            }
        } failure:^(__kindof BTBaseRequest *request) {
        }];
    }else{
        //未签到
        //self.qbBtn.selected = NO;
        self.isOrNoQD = NO;
        [self isSignIn:NO];
        self.qbRoundL.hidden = YES;
        ViewBorderRadius(self.qbBtn, 14, 1, MainBg_Color);
    }
}


// 申请认证
- (IBAction)verifyClick:(id)sender {
    [MobClick event:@"mine_renzheng"];
    H5Node *node = [[H5Node alloc] init];
    node.title = [APPLanguageService sjhSearchContentWith:@"bitanrenzheng"];
    node.webUrl = [NSString stringWithFormat:@"%@%@",[BTConfig sharedInstance].Post_h5domain,Verify_URL];
    [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
}

//
//个人主页
- (IBAction)goPersonSetting:(UIButton *)sender {
    if (![getUserCenter isLogined]) {
        [AnalysisService alaysisMine_login];
        [getUserCenter loginoutPullView];
        return;
    }
    [MobClick event:@"mine_zhuye"];
   
    [BTCMInstance pushViewControllerWithName:@"BTPersonViewController" andParams:@{@"userId":@([BTGetUserInfoDefalut sharedManager].userInfo.userId),@"userName":SAFESTRING([BTGetUserInfoDefalut sharedManager].userInfo.username)}];
}

//明文暗文
- (IBAction)eyeBtn:(UIButton *)sender {
    
    if (![getUserCenter isLogined]) {
        [AnalysisService alaysisMine_login];
        [getUserCenter loginoutPullView];
        return;
    }
    if (ISNSStringValid([APPLanguageService readIsOrNoEyesType])) {
        
        if (ISStringEqualToString([APPLanguageService readIsOrNoEyesType], @"闭")) {
            
            NSString *unit = [BTHelperMethod signStr];
            self.shizhiL.text = [NSString stringWithFormat:@"%@BTC",[DigitalHelperService isp8DataWithDouble:_detailMyInfo.positionCapitalizationCurrency]];
            self.shizhiMoneyL.text =[NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService transformWith:_detailMyInfo.positionCapitalization]];
            
            self.benjinL.text = [NSString stringWithFormat:@"%@BTC",[DigitalHelperService isp8DataWithDouble:_detailMyInfo.positionCapitalCurrency]];
            self.profitLosL.text =[NSString stringWithFormat:@"%@BTC",[DigitalHelperService isp8DataWithDouble:_detailMyInfo.positionGainAndLossCurrency]];
            
            //            self.totalLosL.text =[NSString stringWithFormat:@"%@%@",unit,[DigitalHelperService transformWith:_detailMyInfo.totalGainAndLoss]];
            
            [self.eyeBtn setImage:[UIImage imageNamed:@"眼睛-睁"] forState:UIControlStateNormal];
            [APPLanguageService writeIsOrNoEyesType:@"睁"];
        } else {
            self.shizhiL.text = @"******";
            self.benjinL.text = @"******";
            self.profitLosL.text = @"******";
            self.totalLosL.text = @"******";
            self.shizhiMoneyL.text = @"******";
            [self.eyeBtn setImage:[UIImage imageNamed:@"眼睛-闭"] forState:UIControlStateNormal];
            [APPLanguageService writeIsOrNoEyesType:@"闭"];
        }
    }else {
        self.shizhiL.text = @"******";
        self.benjinL.text = @"******";
        self.profitLosL.text = @"******";
        self.totalLosL.text = @"******";
        self.shizhiMoneyL.text = @"******";
        
        [self.eyeBtn setImage:[UIImage imageNamed:@"眼睛-闭"] forState:UIControlStateNormal];
        [APPLanguageService writeIsOrNoEyesType:@"闭"];
    }
    [[NSNotificationCenter  defaultCenter] postNotificationName:NSNotification_HiddenAssets object:nil];
}
//查看收益
- (IBAction)goEarningsBtn:(UIButton *)sender {
    
    if (![getUserCenter isLogined]) {
        [AnalysisService alaysisMine_login];
        [getUserCenter loginoutPullView];
        return;
    }
    [AnalysisService alaysisMine_income_card];
    [BTCMInstance pushViewControllerWithName:@"LncomeStatisticsMain" andParams:nil];

}
//添加资产
- (IBAction)addSYBtnClick:(UIButton *)sender {
    if (![getUserCenter isLogined]) {
        [AnalysisService alaysisMine_login];
        [getUserCenter loginoutPullView];
        return;
    }
    [AnalysisService alaysisIncome_add_button];
    [BTCMInstance pushViewControllerWithName:@"BTNewAddRecord" andParams:@{@"kind":@""}];
}

//加用户群
- (IBAction)adduserFroup:(id)sender {
    [AnalysisService alaysis_usergroup_page];
    [BTCMInstance pushViewControllerWithName:@"BTContactUsViewController" andParams:nil];
//    H5Node *node = [[H5Node alloc] init];
//    node.webUrl = ADD_GROUP_URL;
//    node.title  = [APPLanguageService wyhSearchContentWith:@"tianjiaweixinquan"];
//    node.isNoLanguage = YES;
//    [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
    
}

//我的探力
- (IBAction)myTanliClick:(id)sender {
    if (![getUserCenter isLogined]) {
        [AnalysisService alaysisMine_login];
        [getUserCenter loginoutPullView];
        return;
    }
    [AnalysisService alaysismine_page_tanli];
    //[BTCMInstance pushViewControllerWithName:@"signIn" andParams:@{@"isTarget":@(1)}];
    [BTCMInstance pushViewControllerWithName:@"BTNewMyTanLiMain" andParams:@{@"isTarget":@(YES),@"isContinue":@(self.isOrNoQD)}];
}

////消息中心
//- (IBAction)messageCenterBtnClick:(UIButton *)sender {
//
//    if (![getUserCenter isLogined]) {
//        [AnalysisService alaysisMine_login];
//        [getUserCenter loginoutPullView];
//        return;
//    }
//    [AnalysisService alaysisHome_message];
//    [BTCMInstance pushViewControllerWithName:@"MessageCenter" andParams:nil completion:^(id obj) {
//
//        [self checkMessageCenter];
//    }];
//}

//我的收藏
- (IBAction)myCollectionBtnClick:(UIButton *)sender {
    if (![getUserCenter isLogined]) {
        [AnalysisService alaysisMine_login];
        [getUserCenter loginoutPullView];
        return;
    }
    [AnalysisService alaysisMine_collect];
    [BTCMInstance pushViewControllerWithName:@"MyNewCollectionVC" andParams:nil];
}

//系统设置
//- (IBAction)systemSettingBtnClick:(UIButton *)sender {
//    [AnalysisService alaysisMine_set];
//     [BTCMInstance pushViewControllerWithName:@"SystemSetting" andParams:nil];
//}


- (void)systemSettingBtnClick{
    [AnalysisService alaysisMine_set];
    [BTCMInstance pushViewControllerWithName:@"SystemSetting" andParams:nil];
}

//邀请好友
- (IBAction)shareBtnClick:(UIButton *)sender {
//    if (![getUserCenter isLogined]) {
//        [AnalysisService alaysisMine_login];
//        [getUserCenter loginoutPullView];
//        return;
//    }
    [AnalysisService alaysisMine_invite];
    H5Node *node =[[H5Node alloc] init];
    node.title = [APPLanguageService wyhSearchContentWith:@"yaoqinghaoyou"];
    [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
}
//意见反馈
- (IBAction)FeedBackClick:(UIButton *)sender {
    if (![getUserCenter isLogined]) {
        [AnalysisService alaysisMine_login];
        [getUserCenter loginoutPullView];
        return;
    }
    [AnalysisService alaysisMine_advice];
    [BTCMInstance pushViewControllerWithName:@"FeedBack" andParams:nil];
}

//帮助中心
- (IBAction)helpCenterClick:(id)sender {
    [MobClick event:@"help"];
    [BTCMInstance pushViewControllerWithName:@"BTHelpCenterViewController" andParams:nil];
}

//红涨绿跌
- (IBAction)changeUpAndFailColorBtnClick:(UIButton *)sender {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    UIButton *switchButton = (UIButton*)sender;
    if(!switchButton.selected){
        if(![userDefaults boolForKey:RedRiseAlert]){
            [BTRedRiseAlertView showWithTitle:[APPLanguageService sjhSearchContentWith:@"redRiseSwitch"] completion:^{
                
            }];
            [userDefaults setBool:YES forKey:RedRiseAlert];
        }
    }else{
        if(![userDefaults boolForKey:GreenRiseAlert]){
            [BTRedRiseAlertView showWithTitle:[APPLanguageService sjhSearchContentWith:@"greenRiseSwitch"] completion:^{
                
            }];
            [userDefaults setBool:YES forKey:GreenRiseAlert];
        }
    }
    switchButton.selected = !switchButton.selected;
    
    if (switchButton.selected) {
        [userDefaults setBool:YES forKey:RedRiseGreenFall];
    }else {
        [userDefaults setBool:NO forKey:RedRiseGreenFall];
    }
    [userDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_RedRiseGreenFall object:nil];
}

//法币显示
- (IBAction)FBXSBtnClick:(UIButton *)sender {
    
    NSLog(@"%@",[APPLanguageService readLanguage]);
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[APPLanguageService wyhSearchContentWith:@"fabixianshi"] delegate:self cancelButtonTitle:[APPLanguageService wyhSearchContentWith:@"quxiao"] destructiveButtonTitle:nil otherButtonTitles:[APPLanguageService wyhSearchContentWith:@"renmingbi"],[APPLanguageService wyhSearchContentWith:@"dollar"], nil];
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {//人民币
        
        [APPLanguageService writeLegalTendeType:@"1"];
        self.currencyContentL.text = [APPLanguageService wyhSearchContentWith:@"renmingbi"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_SwitchLanguage object:nil];
    }else if (buttonIndex == 1){//美元
        
        [APPLanguageService writeLegalTendeType:@"2"];
        self.currencyContentL.text = [APPLanguageService wyhSearchContentWith:@"dollar"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_SwitchLanguage object:nil];
    }else {
        
        return;
    }
    
    [MBProgressHUD showMessage:[APPLanguageService sjhSearchContentWith:@"shezhichenggong"] wait:YES];
}
- (IBAction)NightModeBtnClick:(UIButton *)sender {
    
    UIButton *switchButton = (UIButton*)sender;
    switchButton.selected = !switchButton.selected;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (switchButton.selected) {
        [userDefaults setBool:YES forKey:NightModeOrDayMode];
    }else {
        [userDefaults setBool:NO forKey:NightModeOrDayMode];
    }
    [userDefaults synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_SwitchLanguage object:nil];
}


//检查未读消息
-(void)checkMessageCenter {
    UITabBarItem * item=[self.tabBarController.tabBar.items objectAtIndex:4];
    if(@available(iOS 10.0, *)){
        item.badgeColor = kHEXCOLOR(0xE8003F);
    }
    if ([getUserCenter isLogined]) {
        
        CheckMessageUnreadRequest *api = [[CheckMessageUnreadRequest alloc] initWithCheckMessageUnread];
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            MessageModel *model = [MessageModel modelWithJSON:request.data];
            NSInteger total = model.comment + model.like + model.message + model.mention;
            if (total > 0) {
                
                self.messageLabel.hidden = NO;
                self.messageLabel.text = total > 99 ? @" 99+ " : [NSString stringWithFormat:@"%ld",(long)total];
                item.badgeValue = total > 99 ? @"99+" : [NSString stringWithFormat:@"%ld",(long)total];
                if (total > 99) {
                    [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(22);
                    }];
                    //self.unreadLabel.constant = 22;
                }else {
                    [self.messageLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.mas_equalTo(12);
                    }];
                    //self.unreadLabel.constant = 12;
                }
            }else {
                self.messageLabel.hidden = YES;
                item.badgeValue      = nil;
            }
            
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
        
    } else {
        
        self.messageLabel.hidden = YES;
        item.badgeValue      = nil;
    }
}
//签到按钮点击
- (IBAction)SignInBtnClick:(UIButton *)sender {
    
    [MobClick event:@"mine_page_checkin"];
    if (![getUserCenter isLogined]) {
        [AnalysisService alaysisMine_login];
        [getUserCenter loginoutPullView];
        return;
    }    
    if (!self.isOrNoQD) {
        [BTCMInstance pushViewControllerWithName:@"BTNewMyTanLiMain" andParams:@{@"isContinue":@(YES)}];
    }else{
        [BTCMInstance pushViewControllerWithName:@"BTNewMyTanLiMain" andParams:nil];
    }
    
}

//判断是否签到
-(void)isSignIn:(BOOL)signIn{
    if (signIn) {
        self.QbTitleLabel.text = [APPLanguageService wyhSearchContentWith:@"yiqiandao"];
        self.QbTitleLabel.textColor = ThirdColor;
        self.QbImgView.image = [UIImage imageNamed:@"ic_yiqiandao"];
    }else{
        self.QbTitleLabel.text = [APPLanguageService wyhSearchContentWith:@"qiandaodongci"];
        self.QbTitleLabel.textColor = MainBg_Color;
        self.QbImgView.image = [UIImage imageNamed:@"ic_weiqiandiao"];
    }
    
    CGFloat textW = [self.QbTitleLabel.text boundingRectWithSize:CGSizeMake(300, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.QbTitleLabel.font} context:nil].size.width;
    
    //距离左右是12 图片16 label距离图片2
    self.QbWidthConstraint.constant = 12*2 + 16 + 7 + textW;
}


-(NSMutableArray *)JJSArray {
    
    if (!_JJSArray) {
        
        _JJSArray = [NSMutableArray array];
    }
    return _JJSArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 2){//查看收益
        if (![getUserCenter isLogined]) {
            [AnalysisService alaysisMine_login];
            [getUserCenter loginoutPullView];
            return;
        }
        [AnalysisService alaysisMine_income_card];
        [BTCMInstance pushViewControllerWithName:@"LncomeStatisticsMain" andParams:nil];
    }
}

- (UIView*)messageView{
    if(!_messageView){
        _messageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30.0f)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"个人-消息"] forState:UIControlStateNormal];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.textColor = CWhiteColor;
        _messageLabel.font = FONTOFSIZE(9.0f);
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        ViewRadius(_messageLabel, 6);
        _messageLabel.backgroundColor = kHEXCOLOR(0xE8003F);
        [_messageView addSubview:btn];
        [_messageView addSubview:_messageLabel];
        _messageLabel.hidden = YES;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_messageView);
            make.width.height.mas_equalTo(30.0f);
            make.centerY.equalTo(_messageView.mas_centerY);
        }];
        
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn.mas_right).offset(-15);
            make.top.equalTo(btn.mas_top).offset(-4);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(12);
        }];
    }
    
    return _messageView;
    
}

- (UIButton*)messageBtn{
    if(!_messageBtn){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setImage:[UIImage imageNamed:@"个人-消息"] forState:UIControlStateNormal];
        _messageBtn = btn;
        [btn bk_addEventHandler:^(id  _Nonnull sender) {
            if (![getUserCenter isLogined]) {
                [AnalysisService alaysisMine_login];
                [getUserCenter loginoutPullView];
                return;
            }
            [AnalysisService alaysisHome_message];
            [BTCMInstance pushViewControllerWithName:@"MessageCenter" andParams:nil completion:^(id obj) {
                
                [self checkMessageCenter];
            }];
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.textColor = CWhiteColor;
        _messageLabel.font = FONTOFSIZE(9.0f);
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        ViewRadius(_messageLabel, 6);
        _messageLabel.backgroundColor = kHEXCOLOR(0xE8003F);
        [_messageBtn addSubview:_messageLabel];
        _messageLabel.hidden = YES;
        
        [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(btn.mas_right).offset(-15);
            make.top.equalTo(btn.mas_top).offset(-4);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(12);
        }];
    }
    return _messageBtn;
}

@end
