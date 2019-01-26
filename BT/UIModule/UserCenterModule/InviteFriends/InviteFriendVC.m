//
//  InviteFriendVC.m
//  BT
//
//  Created by apple on 2018/4/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "InviteFriendVC.h"
#import "UIButton+Factory.h"
#import "LabelIndicatorView.h"
#import "BTInviteFriendRequest.h"
#import "HInviteCodeShare.h"
@interface InviteFriendVC ()<BTLoadingViewDelegate>

@property (nonatomic, strong) LabelIndicatorView *activityView;
@property (weak, nonatomic) IBOutlet UIScrollView *mScrollview;

@property (weak, nonatomic) IBOutlet UIImageView *inviteLayer;
@property (weak, nonatomic) IBOutlet UIImageView *BTBIV;
@property (weak, nonatomic) IBOutlet BTLabel *indicatorL;
@property (weak, nonatomic) IBOutlet UILabel *inviteCodeL;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UILabel *inviteCountL;
@property (weak, nonatomic) IBOutlet UILabel *inviteTotalL;
@property (nonatomic, strong) BTLoadingView *loadingView;

@property (nonatomic, strong)HYShareActivityView *shareView;
@property (nonatomic, copy) NSString * code;

@end

@implementation InviteFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [APPLanguageService wyhSearchContentWith:@"yaoqinghaoyou"];
    [self addNavigationItemViewWithImageNames:@"invite_share" isLeft:NO target:self action:@selector(shareBtnClick) tag:1000];
    [self createUI];
    [self loadData];
    
}

- (void)createUI{
   
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:nil delegate:self];
    _mScrollview.showsVerticalScrollIndicator = NO;
    if(ScreenHeight<750.0f){
        _mScrollview.contentSize =CGSizeMake(ScreenWidth, 750.0f-(iPhoneX?88:64));
        _mScrollview.bounces = NO;
    }else{
        _mScrollview.contentSize =CGSizeMake(ScreenWidth, ScreenHeight -(iPhoneX?88:64));
        _mScrollview.bounces = NO;
    }
    [_inviteLayer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(_mScrollview);
        make.height.mas_equalTo(_mScrollview.contentSize.height);
    }];
   
    self.BTBIV.image = IMAGE_NAMED(ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans)?@"invite_coin":@"invite_coin_EN");
    UIFont *headerFont =nil;
    
    if(IOS_VERSION>=9.0){
        headerFont =[UIFont fontWithName:@"PingFangSC-Regular" size:12];
        
    }else{
        headerFont =[UIFont systemFontOfSize:12.0f];
    }
    _activityView =[[LabelIndicatorView alloc] initWithFrame:CGRectZero invite:YES title:[APPLanguageService wyhSearchContentWith:@"huodongxize"] font:headerFont textColor:kHEXCOLOR(0xFFCF00) alpha:1];
    
    UITapGestureRecognizer *tapActivity=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActivity:)];
    [_activityView addGestureRecognizer:tapActivity];
    [_inviteLayer addSubview:_activityView];
    [_activityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_inviteLayer).offset(20);
        make.right.equalTo(_inviteLayer.mas_right).offset(-20);
        make.width.mas_equalTo(60.0f);
        make.height.mas_equalTo(17.0f);
    }];
    
    _inviteBtn.layer.cornerRadius = 23.0f;
    _inviteBtn.layer.masksToBounds =YES;
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, 157.0f, 46.0f);
    gradientLayer.colors = @[(__bridge id)kHEXCOLOR(0x1304B7).CGColor,(__bridge id)kHEXCOLOR(0xB808AD).CGColor];
    
    gradientLayer.locations= @[@0.0,@1.0];
    gradientLayer.startPoint = CGPointMake(0.0,0);
    gradientLayer.endPoint = CGPointMake(1,0);
    [_inviteBtn.layer insertSublayer:gradientLayer atIndex:0];
}

- (void)loadData{
    NSString *str = [APPLanguageService wyhSearchContentWith:@"yaoqinghaoyousongjigetanli"];
    self.indicatorL.attributedText = [self attributeStr:str ofStr:@"7"];
    [self requestData];
}

- (void)requestData{
    [self.loadingView showLoading];
    BTInviteFriendRequest *api = [[BTInviteFriendRequest alloc] init];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if(request.data&&[request.data isKindOfClass: [NSDictionary class]]){
            NSDictionary *dict =request.data;
            self.inviteCodeL.text =SAFESTRING(dict[@"code"]);
            NSString *inviteCount =SAFESTRING(dict[@"inviteNum"]);
            NSString *inviteCountStr = [NSString stringWithFormat:@"%@%@%@",[APPLanguageService wyhSearchContentWith:@"yiyaoqingjigehaoyou"],inviteCount,[APPLanguageService wyhSearchContentWith:@"ren"]];
            self.inviteCountL.attributedText = [self attributeStr:inviteCountStr ofStr:inviteCount];
            
            NSString *totolCoinStr = SAFESTRING(dict[@"totalCount"]);
            NSString *userNum = SAFESTRING(dict[@"userNum"]);
            NSString *totalStr= @"";
            if (ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans)) {
                
                totalStr =[NSString stringWithFormat:@"%@ %@ %@ %@ %@",[APPLanguageService wyhSearchContentWith:@"yiyou"],userNum,[APPLanguageService wyhSearchContentWith:@"weiyonghufachuyaoqing"],totolCoinStr,[APPLanguageService wyhSearchContentWith:@"kongtanli"]];
                
            }else {
                
               totalStr =[NSString stringWithFormat:@"%@ %@ %@ %@ %@%@",[APPLanguageService wyhSearchContentWith:@"yiyou"],userNum,[APPLanguageService wyhSearchContentWith:@"yonghu"],totolCoinStr,[APPLanguageService wyhSearchContentWith:@"weiyonghufachuyaoqing"],[APPLanguageService wyhSearchContentWith:@"kongtanli"]];
            }
            self.inviteTotalL.attributedText =[self attributeStr:totalStr withStr:userNum secondStr:totolCoinStr];
            self.code =SAFESTRING(SAFESTRING(dict[@"code"]));
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
        
    }];
    
}
//活动细则
- (void)tapActivity:(UIGestureRecognizer*)gesture{
    H5Node *node = [[H5Node alloc] init];
    node.title = [APPLanguageService wyhSearchContentWith:@"huodongxize"];
    node.webUrl = myInviteRulesUrl;
    node.isNoLanguage = YES;
    
    [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
    
}
//邀请好友
- (IBAction)inviteBtnClick:(id)sender {
    if(self.code.length == 0) return;
    
    [[HInviteCodeShare sharedHInviteCodeShare] shareWithContent:self.code reward:20];
    [AnalysisService alaysismine_page_tanli_yaoqing];
}

//分享
- (void)shareBtnClick{
    if(self.code.length == 0) return;
    
    [[HInviteCodeShare sharedHInviteCodeShare] shareWithContent:self.code reward:20];
    
}

- (NSAttributedString*)attributeStr:(NSString*)str ofStr:(NSString*)litterStr{
    NSRange blueColorRange = [str rangeOfString:litterStr];
    
    NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
    [wordStyle setLineSpacing:10];
    wordStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *wordDic = @{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:wordStyle};
    NSMutableAttributedString *wordLabelAttStr = [[NSMutableAttributedString alloc] initWithString:str attributes:wordDic];
    [wordLabelAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FFCF00"] range:blueColorRange];
    return wordLabelAttStr;
}

- (NSAttributedString*)attributeStr:(NSString*)str withStr:(NSString*)firstStr secondStr:(NSString*)secondStr{
    NSRange firstRange = [str rangeOfString:firstStr];
    NSRange secondRange = [str rangeOfString:secondStr];
    
    NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
    wordStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *wordDic = @{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:wordStyle};
    NSMutableAttributedString *wordLabelAttStr = [[NSMutableAttributedString alloc] initWithString:str attributes:wordDic];
    [wordLabelAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FFCF00"] range:firstRange];
    [wordLabelAttStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#FFCF00"] range:secondRange];
    return wordLabelAttStr;
    
}

- (void)refreshingData{
    [self requestData];
}

@end
