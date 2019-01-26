//
//  SystemSettingViewController.m
//  BT
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SystemSettingViewController.h"
#import "LoginOutRequest.h"
#import "BTSearchService.h"
#import "ADView.h"
#import "BTDeteleRecordAlert.h"
@interface SystemSettingViewController ()<UIActionSheetDelegate>{
    
    NSString *_isChooseLanguageOrCurrency;
}
@property (weak, nonatomic) IBOutlet BTLabel *settingOrchangePasswordL;
@property (weak, nonatomic) IBOutlet BTLabel *languageContentL;
@property (weak, nonatomic) IBOutlet BTLabel *cacheContentL;
@property (weak, nonatomic) IBOutlet BTLabel *versionNumberL;

@property (weak, nonatomic) IBOutlet BTButton *btnLoginOut;


@end

@implementation SystemSettingViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.btnLoginOut.hidden =  getUserCenter.userInfo.token.length > 0 ? NO:YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [APPLanguageService wyhSearchContentWith:@"SystemSetting"];
    //ViewRadius(self.btnLoginOut, 4);
    self.btnLoginOut.backgroundColor = isNightMode?TableViewCellNightColor:KWhiteColor;
    if ([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]) {
        
        self.languageContentL.text = [APPLanguageService wyhSearchContentWith:@"languageZH"];
    }else {
        
       self.languageContentL.text = [APPLanguageService wyhSearchContentWith:@"languageUS"];
    }
   
    self.cacheContentL.text = [NSString stringWithFormat:@"%.1fMB",[[SDImageCache sharedImageCache] getSize]/1000.0/1000.0];
    self.versionNumberL.text = [NSString stringWithFormat:@"V%@",IosAppVersion];
    
    self.settingOrchangePasswordL.localText = getUserCenter.detailMyInfo.userHavePassword ? @"xiugaimima" : @"shezhimima";
}

- (IBAction)loginOut:(BTButton *)sender {
    
    [UIAlertView showWithTitle:[APPLanguageService sjhSearchContentWith:@"tishi"]
                       message:[APPLanguageService wyhSearchContentWith:@"ninquedingtuichuma"] cancelButtonTitle:[APPLanguageService wyhSearchContentWith:@"quxiao"] otherButtonTitles:@[[APPLanguageService wyhSearchContentWith:@"queding"]]
                      tapBlock:^(UIAlertView * __nonnull alertView, NSInteger buttonIndex)
     {
         
         NSLog(@"%ld",(long)buttonIndex);
         
         if (buttonIndex == 1) {
             
             LoginOutRequest *api = [[LoginOutRequest alloc] initWithLoginOut];
             [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
                 
                 NSLog(@"%@",request.data);
                 
                 [getUserCenter loginout];
                 
                 [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"success"] wait:YES];
                 
                 [BTCMInstance popViewController:nil];
             } failure:^(__kindof BTBaseRequest *request) {
                 NSLog(@"failed");
             }];
         }
        
     }];
    
}
//系统语言选择
- (IBAction)clickedSwitchLanguage:(id)sender {
    _isChooseLanguageOrCurrency = @"系统语言选择";
    NSLog(@"%@",[APPLanguageService readLanguage]);
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[APPLanguageService wyhSearchContentWith:@"yuyanxuanze"] delegate:self cancelButtonTitle:[APPLanguageService wyhSearchContentWith:@"quxiao"] destructiveButtonTitle:nil otherButtonTitles:[APPLanguageService wyhSearchContentWith:@"languageZH"],[APPLanguageService wyhSearchContentWith:@"languageUS"], nil];
    [sheet showInView:self.view];
}
//关于我们
- (IBAction)FBXSBtnClick:(UIButton *)sender {
    
    [AnalysisService alaysisMine_about];
    H5Node *node = [[H5Node alloc] init];
    node.title = [APPLanguageService wyhSearchContentWith:@"aboutUs"];
    node.webUrl = AboutUs_H5;
    
    [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"%ld",buttonIndex);
    ADView *ad = [[ADView alloc] init];
    if (buttonIndex == 0) {//系统语言设置为简体中文
        [APPLanguageService writeLanguage:lang_Language_Zh_Hans];
        self.languageContentL.text = [APPLanguageService wyhSearchContentWith:@"languageZH"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_SwitchLanguage object:nil];
        [[BTSearchService sharedService] clearBTSplashScreenModel];
        [ad splashScreenAPI];
    }else if (buttonIndex == 1){//系统语言设置为英文
        [APPLanguageService writeLanguage:lang_Language_En];
        self.languageContentL.text = [APPLanguageService wyhSearchContentWith:@"languageUS"];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_SwitchLanguage object:nil];
        [[BTSearchService sharedService] clearBTSplashScreenModel];
        [ad splashScreenAPI];
    }else {
        
        return;
    }
    [MBProgressHUD showMessage:[APPLanguageService sjhSearchContentWith:@"shezhichenggong"] wait:YES];
}
//清理缓存
- (IBAction)QLHCBtnClick:(UIButton *)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[APPLanguageService wyhSearchContentWith:@"quedingqingchuhuancun"] message:[NSString stringWithFormat:@"%@%.1fMB",[APPLanguageService wyhSearchContentWith:@"dangqianhuancun"],[[SDImageCache sharedImageCache] getSize]/1000.0/1000.0] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];//图片缓存
    
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",buttonIndex);
    
    if (buttonIndex == 1) {
        
        //[[SDImageCache sharedImageCache] clearDisk];//清除本地磁盘的缓存数据
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            
            
            [MBProgressHUD showMessageIsWait:@"清除缓存成功" wait:YES];
            self.cacheContentL.text = @"0MB";
            // 清除完毕的处理。
        }];
    }
    
    
}
//设置账户信息
- (IBAction)settingAccountInformationBtnClick:(UIButton *)sender {
    if (![getUserCenter isLogined]) {
        [AnalysisService alaysisMine_login];
        [getUserCenter loginoutPullView];
        return;
    }
    [BTCMInstance pushViewControllerWithName:@"personSetting" andParams:@{@"data":getUserCenter.detailMyInfo?getUserCenter.detailMyInfo:[[MyInfoObJ alloc] init],@"whereVC":@"系统设置"}];
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
