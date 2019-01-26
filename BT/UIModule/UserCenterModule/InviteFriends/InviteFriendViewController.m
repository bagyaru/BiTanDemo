//
//  InviteFriendViewController.m
//  BT
//
//  Created by apple on 2018/5/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "InviteFriendViewController.h"
#import "BTInviteFriendRequest.h"
#import "BTLoadingView.h"
#import "InviteFriendModel.h"
#import "ShareCodeView.h"
#import "HInviteCodeShare.h"
#import "TPTargetRequest.h"
#import "TargetModel.h"

@interface InviteFriendViewController ()<BTLoadingViewDelegate>

/**加载界面*/
@property (nonatomic,strong) BTLoadingView *loadingView;
@property (nonatomic,strong) InviteFriendModel *inviteModel;
/**用来获取邀请好友注册获取的探力 传送到下一个界面使用*/
@property (nonatomic,strong) TargetModel *targetModel;

@end

@implementation InviteFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [APPLanguageService wyhSearchContentWith:@"yaoqinghaoyou"];
//    [self addNavigationItemWithTitles:@[[APPLanguageService wyhSearchContentWith:@"huodongxize"]] isLeft:NO target:self action:@selector(activityRuleMethod) tags:@[@(1000)] whereVC:@"邀请好友"];
    
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:nil delegate:self];
    [self requestData];
    
    
}

#pragma mark - UI
-(void)createUI{
    
    
    UIScrollView *scrollView = [UIScrollView new];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = kHEXCOLOR(0xf5f5f5);
    scrollView.showsVerticalScrollIndicator = NO;
   
    UIView *topView = [UIView new];
    [scrollView addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(scrollView);
        make.height.mas_equalTo(RELATIVE_WIDTH(188));
    }];
    
    
    UIImageView *imgView = [UIImageView new];
    [topView addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"bg_01"];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(topView);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    UILabel *tipLabel = [UILabel new];
    [topView addSubview:tipLabel];
    tipLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(24)];
    tipLabel.textColor = kHEXCOLOR(0x111210);
    tipLabel.text = [APPLanguageService wyhSearchContentWith:@"tanli"];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView).offset(RELATIVE_WIDTH(52));
        make.centerX.equalTo(topView);
        make.height.mas_equalTo(RELATIVE_WIDTH(33));
    }];
    
    UILabel *detailDescLabel = [UILabel new];
    [topView addSubview:detailDescLabel];
    detailDescLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
    detailDescLabel.textColor = kHEXCOLOR(0x111210);
    
    
    
    detailDescLabel.numberOfLines = 0;
    NSString *detailDescText = [APPLanguageService wyhSearchContentWith:@"yaoqinghaoyouDesc"];
    [detailDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(RELATIVE_WIDTH(7));
        make.left.equalTo(topView).offset(RELATIVE_WIDTH(15));
        make.right.equalTo(topView).offset(RELATIVE_WIDTH(-15));
        make.centerX.equalTo(topView);
    }];
    
    
    //实例化NSMutableAttributedString模型
    NSMutableAttributedString *detailAttributedString = [[NSMutableAttributedString alloc] initWithString:detailDescText];
    //建立行间距模型
    NSMutableParagraphStyle *detailParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    //设置行间距
    [detailParagraphStyle setLineSpacing:5.0f];
    [detailParagraphStyle setAlignment:NSTextAlignmentCenter];
    //把行间距模型加入NSMutableAttributedString模型
    [detailAttributedString addAttribute:NSParagraphStyleAttributeName value:detailParagraphStyle range:NSMakeRange(0, [detailDescText length])];
    detailDescLabel.attributedText = detailAttributedString;
    [self requestTargetData:detailDescLabel attributes:detailAttributedString];
    
    
    UIView *bottomView = [UIView new];
    [scrollView addSubview:bottomView];
//    bottomView.backgroundColor = [UIColor whiteColor];
    ViewRadius(bottomView, RELATIVE_WIDTH(6));
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(RELATIVE_WIDTH(27));
        make.right.equalTo(scrollView).offset(RELATIVE_WIDTH(-27));
        make.top.equalTo(topView.mas_bottom).offset(RELATIVE_WIDTH(16));
        make.height.mas_equalTo(RELATIVE_WIDTH(376));
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
        make.top.equalTo(bottomTopBgView).offset(RELATIVE_WIDTH(49));
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
    
    inviteCodeLabel.text = self.inviteModel.code;
    
    UIButton *inviteFriendBtn = [UIButton new];
    [bottomTopBgView addSubview:inviteFriendBtn];
    [inviteFriendBtn setTitle:[APPLanguageService wyhSearchContentWith:@"lijiyaoqinghaoyou"] forState:UIControlStateNormal];
    [inviteFriendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ViewRadius(inviteFriendBtn, RELATIVE_WIDTH(3));
    inviteFriendBtn.backgroundColor = kHEXCOLOR(0x108ee9);
    inviteFriendBtn.titleLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
    [inviteFriendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bottomTopBgView);
        make.top.equalTo(inviteCodeLabel.mas_bottom).offset(RELATIVE_WIDTH(10));
        make.width.mas_equalTo(RELATIVE_WIDTH(121));
        make.height.mas_equalTo(RELATIVE_WIDTH(36));
    }];
    [inviteFriendBtn addTarget:self action:@selector(shareToFriend) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView *separateImgView = [UIImageView new];
    [bottomView addSubview:separateImgView];
    separateImgView.image = [UIImage imageNamed:@"ic_yaoqingye-fenge"];
    [separateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView);
        make.top.equalTo(bottomTopBgView.mas_bottom).offset(RELATIVE_WIDTH(-1));
        make.height.mas_equalTo(RELATIVE_WIDTH(34));
    }];
    
    
    UIView *bottomUnderView = [UIView new];
    [bottomView addSubview:bottomUnderView];
    bottomUnderView.backgroundColor = [UIColor whiteColor];
    [bottomUnderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bottomView);
        make.top.equalTo(separateImgView.mas_bottom).offset(RELATIVE_WIDTH(-1));
    }];
    
    UILabel *bottomTipLabel = [UILabel new];
    [bottomUnderView addSubview:bottomTipLabel];
    bottomTipLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(16) weight:UIFontWeightMedium];
    bottomTipLabel.textColor = kHEXCOLOR(0x111210);
    bottomTipLabel.numberOfLines = 0;
    bottomTipLabel.textAlignment = NSTextAlignmentCenter;
    bottomTipLabel.text = [NSString stringWithFormat:@"%@%ld%@",[APPLanguageService wyhSearchContentWith:@"yaoqinghaoyoubottomDesc1"],self.inviteModel.inviteNum,[APPLanguageService wyhSearchContentWith:@"haoyou"]];
    [bottomTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomUnderView).offset(RELATIVE_WIDTH(27));
        make.left.equalTo(bottomUnderView).offset(RELATIVE_WIDTH(15));
        make.right.equalTo(bottomUnderView).offset(RELATIVE_WIDTH(-15));
    }];
    
    
    UILabel *bottomDescLabel = [UILabel new];
    [bottomUnderView addSubview:bottomDescLabel];
    bottomDescLabel.textColor = bottomTipLabel.textColor;
    bottomDescLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
    bottomDescLabel.numberOfLines = 0;
//    bottomDescLabel.text = [NSString stringWithFormat:@"已有%ld位用户发出邀请\n今日共释放了%ldTP",self.inviteModel.userNum,self.inviteModel.totalCount];
    [bottomDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomTipLabel.mas_bottom).offset(RELATIVE_WIDTH(5));
        make.centerX.equalTo(bottomUnderView);
    }];
    
    NSString *bottomDescText = [APPLanguageService wyhSearchContentWith:@"yaoqinghaoyoubottomDesc2"];
    bottomDescText = [bottomDescText stringByReplacingOccurrencesOfString:@"-1" withString:[NSString stringWithFormat:@"%ld",self.inviteModel.userNum]];
    bottomDescText = [bottomDescText stringByReplacingOccurrencesOfString:@"-2" withString:[NSString stringWithFormat:@"%ld",self.inviteModel.totalCount]];
    //实例化NSMutableAttributedString模型
    NSMutableAttributedString *bottomDescAttributed = [[NSMutableAttributedString alloc] initWithString:bottomDescText];
    //建立行间距模型
    NSMutableParagraphStyle *bottomDescParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    //设置行间距
    [bottomDescParagraphStyle setLineSpacing:5.0f];
    [bottomDescParagraphStyle setAlignment:NSTextAlignmentCenter];
    //把行间距模型加入NSMutableAttributedString模型
    [bottomDescAttributed addAttribute:NSParagraphStyleAttributeName value:bottomDescParagraphStyle range:NSMakeRange(0, [bottomDescText length])];
    bottomDescLabel.attributedText = bottomDescAttributed;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
        make.bottom.equalTo(bottomView.mas_bottom).offset(RELATIVE_WIDTH(25));
    }];
    
    
}

#pragma mark - netData
- (void)requestData{
    [self.loadingView showLoading];
    //获取邀请码 邀请的描叙信息
    BTInviteFriendRequest *api = [[BTInviteFriendRequest alloc] init];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if (request.isSuccess) {
            self.inviteModel = [InviteFriendModel modelWithJSON:request.data];
            [self createUI];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

//获得邀请好友的探力值
-(void)requestTargetData:(UILabel*)label attributes:(NSMutableAttributedString*)attributed{
    TPTargetRequest *request = [TPTargetRequest new];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if (request.isSuccess) {
            for (NSDictionary *dic in request.data) {
                TargetModel *targetModel = [TargetModel modelWithJSON:dic];
                if (targetModel.type == 4) {
                    [attributed replaceCharactersInRange:[attributed.string rangeOfString:@"20"] withString:[NSString stringWithFormat:@"%ld",targetModel.reward]];
                    label.attributedText = attributed;
                    return;
                }
            }
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

#pragma mark - lazy load


#pragma mark - method
//分享
- (void)activityRuleMethod{
//    if(self.code.length == 0) return;
    
    H5Node *node = [[H5Node alloc] init];
    node.title = [APPLanguageService wyhSearchContentWith:@"huodongxize"];
    node.webUrl = myInviteRulesUrl;
    node.isNoLanguage = YES;
    
    [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
}

#pragma mark - delegate
- (void)refreshingData{
    [self requestData];
}


-(void)shareToFriend{
    if(self.targetModel.reward == 0){
        TPTargetRequest *request = [TPTargetRequest new];
        [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            if (request.isSuccess) {
                for (NSDictionary *dic in request.data) {
                    TargetModel *targetModel = [TargetModel modelWithJSON:dic];
                    //注册的type为8
                    if (targetModel.type == 8) {
                        self.targetModel = [TargetModel modelWithJSON:dic];
                        [[HInviteCodeShare alloc] shareWithContent:self.inviteModel.code reward:self.targetModel.reward];
                        [AnalysisService alaysismine_page_tanli_yaoqing];
                        return;
                    }
                }
            }
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    }else{
        [[HInviteCodeShare alloc] shareWithContent:self.inviteModel.code reward:self.targetModel.reward];
        [AnalysisService alaysismine_page_tanli_yaoqing];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
