//
//  PersonSettingViewController.m
//  BT
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PersonSettingViewController.h"
#import "HYPhoto.h"
#import "SettingNickNameViewController.h"
#import "changePhotoRequest.h"
#import "updatePhotoToServiceRequest.h"
#import "MyInfoObJ.h"
#import "GetCaptchaRequest.h"
#import "SettingIntroduceViewController.h"
#import "ChangeNikeNameRequest.h"
@interface PersonSettingViewController ()<BTLoadingViewDelegate>{
    
    MBProgressHUD *_hud;
    
}

@property (weak, nonatomic) IBOutlet UIImageView *photoIV;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;

@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *introduceL;

@property (weak, nonatomic) IBOutlet UILabel *phoneL;
@property (weak, nonatomic) IBOutlet BTLabel *settingOrchangePasswordL;
@property (weak, nonatomic) IBOutlet UIButton *settingOrchangePasswordBtn;
@property (weak, nonatomic) IBOutlet UIView *avatarView;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *introduceView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view3Top;


@property (nonatomic,strong)MyInfoObJ  *detailMyInfo;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) BTLoadingView *loadingView;

@end

@implementation PersonSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = [APPLanguageService wyhSearchContentWith:@"PersonSetting"];
    ViewRadius(self.photoIV, 20);
    ViewRadius(self.bgImageV, 4);
    self.nameL.text = SAFESTRING(self.userInfo[@"nickName"]);
    self.introduceL.text = SAFESTRING(self.userInfo[@"introductions"]);
    NSString *avatar = SAFESTRING(self.userInfo[@"avatar"]);
    NSString *bg = SAFESTRING(self.userInfo[@"homePageImg"]);
    [self.photoIV sd_setImageWithURL:[NSURL URLWithString:[avatar hasPrefix:@"http"]?avatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,avatar]] placeholderImage:[UIImage imageNamed:@"Mask_list"]];
    [self.bgImageV sd_setImageWithURL:[NSURL URLWithString:[bg hasPrefix:@"http"]?bg:[NSString stringWithFormat:@"%@%@",PhotoImageURL,bg]] placeholderImage:[UIImage imageNamed:@"person_bg"]];
    self.phoneL.text =  [getUserCenter getPhone:self.detailMyInfo.mobile];
    self.settingOrchangePasswordL.localText = getUserCenter.detailMyInfo.userHavePassword ? @"xiugaimima" : @"shezhimima";
    
    if ([self.parameters[@"whereVC"] isEqualToString:@"系统设置"]) {
        
        self.avatarView.hidden = YES;
        self.view2.hidden = YES;
        self.introduceView.hidden = YES;
        self.bgView.hidden = YES;
        self.view3Top.constant = 15;
        self.title = [APPLanguageService wyhSearchContentWith:@"zhanghuanquan"];
    }else {
        
        self.view3.hidden = YES;
        self.view4.hidden = YES;
    }
}
#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    
}
+ (id)createWithParams:(NSDictionary *)params{
    PersonSettingViewController *vc = [[PersonSettingViewController alloc] init];
    
    id obj = [params objectForKey:@"data"];
    if([obj isKindOfClass:[NSDictionary class]]){
        vc.userInfo = obj;
    }else{
        vc.detailMyInfo = obj;
    }
    NSLog(@"%@",vc.detailMyInfo.userAvatar);
   
    return vc;
    
}
- (void)updateWithParams:(NSDictionary *)params{
    
   
}
//选择头像
- (IBAction)photoBtnClick:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    
    
    [[HYPhoto getSharePhoto] getPhoto:self Back:YES Image:^(UIImage *image, id sender) {
        
        
        if ( image )
        {
            NSData *data;
            
            data = UIImageJPEGRepresentation(image, 0.5);
            [weakSelf uploadImageData:data type:@"1"];
            weakSelf.photoIV.image = [UIImage imageWithData:data];
        }
    }];
}
- (IBAction)bgBtnClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    
    
    [[HYPhoto getSharePhoto] getPhoto:self Back:YES Image:^(UIImage *image, id sender) {
        
        
        if ( image )
        {
            NSData *data;
            
            data = UIImageJPEGRepresentation(image, 0.5);
            [weakSelf uploadImageData:data type:@"6"];
            weakSelf.bgImageV.image = [UIImage imageWithData:data];
        }
    }];
    
}

//图片上传(七牛生成key)
- (void)uploadImageData:(NSData *)data type:(NSString*)type{
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:self.view delegate:self];
    [self.loadingView showLoading];
    changePhotoRequest *api = [[changePhotoRequest alloc] initWithUsername:data uploadType:type];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if([type isEqualToString:@"1"]){
             [self getImageKeyUpdataPhoto:[request.responseObject objectForKey:@"data"]];
        }else{
            [self uploadBg:[request.responseObject objectForKey:@"data"]];
        }
       
    } failure:^(__kindof BTBaseRequest *request) {
         [self.loadingView hiddenLoading];
    }];
}
//图片上传到自己服务器
-(void)getImageKeyUpdataPhoto:(NSString *)key{
    
    updatePhotoToServiceRequest *api = [[updatePhotoToServiceRequest alloc] initWithUsername:key];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
         [self.loadingView hiddenLoading];
        //更新本地信息frv4fr4
        MyInfoObJ *myInfo = [[MyInfoObJ alloc] init];
        myInfo.userAvatar       = key;
        myInfo.username         = getUserCenter.detailMyInfo.username;
        myInfo.mobile           = getUserCenter.detailMyInfo.mobile;
        myInfo.userHavePassword = getUserCenter.detailMyInfo.userHavePassword;
        [myInfo saveToClassFile];
        getUserCenter.detailMyInfo = myInfo;
        
        NSLog(@"上传成功");
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
    }];
}

- (void)uploadBg:(NSString*)key{
    ChangeNikeNameRequest *api = [[ChangeNikeNameRequest alloc]initWithNikeName:@"" introduces:@"" homePage:key];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
    }];
    
    
}
//选择昵称
- (IBAction)nameBtnClick:(UIButton *)sender {
    
    SettingNickNameViewController *vc = [[SettingNickNameViewController alloc] init];
    
    vc.oldNickName = self.nameL.text;
    
    vc.SuccessBlock = ^(NSString *str) {

        self.nameL.text = str;
    };
//    [BTCMInstance pushViewController:vc];
    [self.navigationController pushViewController:vc animated:YES];
}

////选择简介
- (IBAction)introduceClick:(id)sender {
    SettingIntroduceViewController *vc = [[SettingIntroduceViewController alloc] init];
    vc.oldNickName = self.introduceL.text;
    vc.SuccessBlock = ^(NSString *str) {
        self.introduceL.text = str;
    };
    //    [BTCMInstance pushViewController:vc];
    [self.navigationController pushViewController:vc animated:YES];
}


//手机号
- (IBAction)phoneBtnClick:(UIButton *)sender {
    
    [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"noChange"] wait:YES];
}

- (IBAction)settingOrchangePasswordBtnClick:(UIButton *)sender {
    self.settingOrchangePasswordBtn.enabled = NO;
    if (getUserCenter.detailMyInfo.userHavePassword) {//修改登录密码
        
        if ([getUserCenter timeDifferenceWithType:[NSString stringWithFormat:@"修改登录密码%@",getUserCenter.detailMyInfo.mobile]] == 60) {
            
            //获取修改密码的验证码
            GetCaptchaRequest *api = [[GetCaptchaRequest alloc] initWithCountryCode:@"" account:getUserCenter.detailMyInfo.mobile sendType:@"1" messageType:@"6"];
            api.isShowMessage = YES;
            [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest * _Nonnull request) {
                
                [BTCMInstance pushViewControllerWithName:@"ForgetPassword" andParams:@{@"type":@"修改登录密码",@"phone":getUserCenter.detailMyInfo.mobile,@"code":@"",@"messageType":@"6",@"time":@([getUserCenter timeDifferenceWithType:[NSString stringWithFormat:@"修改登录密码%@",getUserCenter.detailMyInfo.mobile]])}];
                
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                
                self.settingOrchangePasswordBtn.enabled = YES;
            }];
            
        }else {
            
           [BTCMInstance pushViewControllerWithName:@"ForgetPassword" andParams:@{@"type":@"修改登录密码",@"phone":getUserCenter.detailMyInfo.mobile,@"code":@"",@"messageType":@"6",@"time":@([getUserCenter timeDifferenceWithType:[NSString stringWithFormat:@"修改登录密码%@",getUserCenter.detailMyInfo.mobile]])}];
        }
    }else {//设置登录密码
        
       [BTCMInstance pushViewControllerWithName:@"SettingOrChange" andParams:@{@"type":@"设置登录密码"}];
    }
}
-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    self.settingOrchangePasswordBtn.enabled = YES;
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
