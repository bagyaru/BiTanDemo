//
//  LoginAndRegisterViewController.m
//  BT
//
//  Created by admin on 2018/1/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LoginAndRegisterViewController.h"
#import "LoginRequest.h"
#import "BTHavaPasswordLoginRequest.h"
#import "GetCaptchaRequest.h"
#import "BTUserCenter.h"
#import "BTConfig.h"
#import "CountryCodeViewController.h"
#import "BTNavigationViewController.h"
#define MAXTIMER 60
//数字和字母
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface LoginAndRegisterViewController ()<UITextFieldDelegate>{
    
    NSTimer      *_codeTimer;//定时器
    NSInteger    _nTimerCount;//倒计时
    BOOL         _changeLoginType;//切换登录方式
}

@property (weak, nonatomic) IBOutlet BTButton *loginBtn;
@property (weak, nonatomic) IBOutlet BTButton *changeLoginTypeBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginTopH;
@property (weak, nonatomic) IBOutlet BTButton *verificationCodeBtn;
@property (weak, nonatomic) IBOutlet BTTextField *phoneTF;
@property (weak, nonatomic) IBOutlet BTTextField *verificationCodeTF;
@property (weak, nonatomic) IBOutlet BTTextField *InviteCodeTF;

@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet UIView *selectCountryView;
@property (weak, nonatomic) IBOutlet UIButton *hiddeBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cacellBtnTop;
@property (weak, nonatomic) IBOutlet UIButton *logoBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIImageView *downBtn;

@end

@implementation LoginAndRegisterViewController
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:nil];
    [_codeTimer invalidate];
    _codeTimer = nil;
    
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ViewRadius(self.loginBtn, 4);
    
    
    [self.hiddeBtn setImage:IMAGE_NAMED(@"眼睛-闭") forState:UIControlStateNormal];
    [self.hiddeBtn setImage:IMAGE_NAMED(@"眼睛-睁") forState:UIControlStateSelected];
    
    self.phoneTF.delegate = self;
    self.verificationCodeTF.delegate = self;
    self.InviteCodeTF.delegate = self;
    _changeLoginType           = NO;
    self.cacellBtnTop.constant = 24+(kTopHeight-64);
    [self checkAll];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:nil];
    //self.loginBtn.localTitle = @"login";
    [self.backBtn setImage:IMAGE_NAMED(@"评论关闭") forState:UIControlStateNormal];
    self.downBtn.image = IMAGE_NAMED(@"filterdown");
    if ([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]) {
        
        [self.logoBtn setImage:IMAGE_NAMED(@"ic_denglulogo") forState:UIControlStateNormal];
        
    }else{
        
        [self.logoBtn setImage:IMAGE_NAMED(@"ic_denglulogo_en") forState:UIControlStateNormal];
    }
    [self.selectCountryView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCountryCode:)]];
}
-(void)textFiledEditChanged:(NSNotification *)obj {
    
    if ([self.countryCodeLabel.text isEqualToString:@"+86"]) {
        
        //手机号最长可输入11个字(国内)
        if (self.phoneTF.text.length > 11) {
            
            self.phoneTF.text = [self.phoneTF.text substringToIndex:11];
        }
        
    }else {
        //手机号最长可输入6-15个字(国内外)
        if (self.phoneTF.text.length > 15) {
            
            self.phoneTF.text = [self.phoneTF.text substringToIndex:15];
        }
    }
    if (_changeLoginType) {//账号密码登录
        
        //密码最长可输入12个字节
        if (self.verificationCodeTF.text.length > 12) {
            
            self.verificationCodeTF.text = [self.verificationCodeTF.text substringToIndex:12];
            
        }
        
    }else {//验证码登录
        
        //验证码最长可输入8个字节
        if (self.verificationCodeTF.text.length > 8) {
            
            self.verificationCodeTF.text = [self.verificationCodeTF.text substringToIndex:8];
            
        }
    }
     [self checkAll];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.verificationCodeTF && _changeLoginType) {
        
        if (range.length == 1 && string.length == 0) {
            
            return YES;
        }else if (self.verificationCodeTF.text.length >= 12) {
            
            self.verificationCodeTF.text = [textField.text substringToIndex:12];
            return NO;
        }else {
            
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            
            return [string isEqualToString:filtered];
            
        }
    }
    
    return YES;
}
-(void)checkAll {
    
    if ([self.countryCodeLabel.text isEqualToString:@"+86"]){
        if (self.phoneTF.text.length == 11) {
            [self.verificationCodeBtn setTitleColor:MainBg_Color forState:UIControlStateNormal];
        } else {
        
            [self.verificationCodeBtn setTitleColor:ThirdColor forState:UIControlStateNormal];
        }
    }else{
        if (self.phoneTF.text.length >= 6) {
            self.verificationCodeBtn.enabled = YES;
            [self.verificationCodeBtn setTitleColor:MainBg_Color forState:UIControlStateNormal];
        }else {
            self.verificationCodeBtn.enabled = NO;
            [self.verificationCodeBtn setTitleColor:ThirdColor forState:UIControlStateNormal];
        }
    }
    if (ISNSStringValid(self.phoneTF.text)&&ISNSStringValid(self.verificationCodeTF.text)) {
        
        self.loginBtn.backgroundColor = MainBg_Color;
        self.loginBtn.alpha           = 1;
        self.loginBtn.enabled = YES;
    } else {
        self.loginBtn.backgroundColor = MainBg_Color;
        self.loginBtn.alpha           = 0.5;
        self.loginBtn.enabled = NO;
    }
}
//获取验证码
- (IBAction)getVerificationCodeBtn:(UIButton *)sender {
    
    [self.phoneTF resignFirstResponder];
    [self.verificationCodeTF resignFirstResponder];
    
    if ([self.countryCodeLabel.text isEqualToString:@"+86"]){
        if (!ISNSStringValid(self.phoneTF.text))
        {
            
            [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"shuRuPhone"] wait:YES];
            
            return;
        }
    }
    
    
      self.verificationCodeBtn.enabled = NO;
        GetCaptchaRequest *api = [[GetCaptchaRequest alloc] initWithCountryCode:self.countryCodeLabel.text account:self.phoneTF.text sendType:@"1" messageType:@"2"];
         api.isShowMessage = YES;
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest * _Nonnull request) {
           
                //成功倒计时
                _codeTimer = nil;
                _nTimerCount = MAXTIMER;
                _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setChangeCodeBtn) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:_codeTimer forMode:NSDefaultRunLoopMode];
       
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            self.verificationCodeBtn.enabled = YES;
        }];
    
}
//倒计时
-(void)setChangeCodeBtn
{
    _nTimerCount--;
    if (_nTimerCount <= 0)
    {
        [_verificationCodeBtn setTitle:[APPLanguageService wyhSearchContentWith:@"chongixnhuoqu"] forState:UIControlStateNormal];
        _verificationCodeBtn.enabled = YES;
        [_codeTimer invalidate];
        _codeTimer = nil;
        _nTimerCount = MAXTIMER;
    }
    else
    {
        _verificationCodeBtn.enabled = NO;
        [_verificationCodeBtn setTitle:[NSString stringWithFormat:@"%@ %lds",[APPLanguageService wyhSearchContentWith:@"yifasong"],(long)_nTimerCount] forState:UIControlStateNormal];
    }
}
//注册
- (IBAction)zhuceBtnClick:(BTButton *)sender {
    
    [BTCMInstance pushViewControllerWithName:@"Register" andParams:nil];
}

//明暗文切换
- (IBAction)hIddeBtnClcik:(UIButton *)sender {
    
    // 前提:在xib中设置按钮的默认与选中状态的背景图
    // 切换按钮的状态
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.verificationCodeTF.text;
        self.verificationCodeTF.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.verificationCodeTF.secureTextEntry = NO;
        self.verificationCodeTF.text = tempPwdStr;
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.verificationCodeTF.text;
        self.verificationCodeTF.text = @"";
        self.verificationCodeTF.secureTextEntry = YES;
        self.verificationCodeTF.text = tempPwdStr;
    }
}

//登录
- (IBAction)loginBtnClick:(UIButton *)sender {
    
    if (!ISNSStringValid(self.phoneTF.text))
    {
  
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"shuRuPhone"] wait:YES];
        
        return;
    }
    if (!ISNSStringValid(self.verificationCodeTF.text))
    {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"shuRuYZM"] wait:YES];
        
        return;
    }
   
    
    if (_changeLoginType) {//有密码登录
        
        BTHavaPasswordLoginRequest *api = [[BTHavaPasswordLoginRequest alloc] initWithDict:@{@"password":[getUserCenter md5:[NSString stringWithFormat:@"%@%@",MD5PassWordStr,self.verificationCodeTF.text]],@"account":self.phoneTF.text,@"loginMethod":@(1)}];
        api.isShowMessage = YES;
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            NSLog(@"%@",request.data);
            
            BTUserInfo *info = [BTUserInfo objectWithDictionary:request.data];
            info.userHavePassword =[[request.data objectForKey:@"userHavePassword"] boolValue];
            [info saveToClassFile];
            getUserCenter.userInfo = info;
            MyInfoObJ *myInfo = [MyInfoObJ objectWithDictionary:request.data];
            myInfo.userHavePassword =[[request.data objectForKey:@"userHavePassword"] boolValue];
            [myInfo saveToClassFile];
            getUserCenter.detailMyInfo = myInfo;
            [BTCMInstance dismissViewController];
            [[NSNotificationCenter  defaultCenter] postNotificationName:NSNotification_loginSuccess object:nil];
        } failure:^(__kindof BTBaseRequest *request) {
            NSLog(@"failed");
        }];
        
    }else {//无密码登录
        
        LoginRequest *api = [[LoginRequest alloc] initWithUsername:self.phoneTF.text password:self.verificationCodeTF.text inviteCode:self.InviteCodeTF.text CountryCode:self.countryCodeLabel.text];
        api.isShowMessage = YES;
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            NSLog(@"%@",request.data);
            
            BTUserInfo *info = [BTUserInfo objectWithDictionary:request.data];
            info.userHavePassword =[[request.data objectForKey:@"userHavePassword"] boolValue];
            [info saveToClassFile];
            getUserCenter.userInfo = info;
            MyInfoObJ *myInfo = [MyInfoObJ objectWithDictionary:request.data];
            myInfo.userHavePassword =[[request.data objectForKey:@"userHavePassword"] boolValue];
            [myInfo saveToClassFile];
            getUserCenter.detailMyInfo = myInfo;
            [BTCMInstance dismissViewController];
            [[NSNotificationCenter  defaultCenter] postNotificationName:NSNotification_loginSuccess object:nil];
        } failure:^(__kindof BTBaseRequest *request) {
            NSLog(@"failed");
        }];
    }
}
//切换登录方式
- (IBAction)changeLoginTypeBtn:(BTButton *)sender {
    _changeLoginType = !_changeLoginType;
    if (_changeLoginType) {//账号登录
        [MobClick event:@"account_password_login"];
        self.hiddeBtn.hidden            = NO;
        self.verificationCodeBtn.hidden = YES;
        self.forgetPasswordBtn.hidden   = NO;
        self.loginTopH.constant         = 60;
        self.verificationCodeTF.localPlaceholder = @"qingshurumima_password";
        self.changeLoginTypeBtn.localTitle = @"duanxinyanzhengmadenglu";
        self.verificationCodeTF.keyboardType = UIKeyboardTypeDefault;
    }else {
        [MobClick event:@"message_verification_code_login"];
        self.hiddeBtn.hidden            = YES;
        self.verificationCodeBtn.hidden = NO;
        self.forgetPasswordBtn.hidden   = YES;
        self.loginTopH.constant         = 30;
        self.verificationCodeTF.localPlaceholder = @"shuRuYZM";
        self.changeLoginTypeBtn.localTitle = @"zhanghaomimadenglu";
        self.verificationCodeTF.keyboardType = UIKeyboardTypeNumberPad;
    }
}
//忘记密码
- (IBAction)forgetPasswordBtnClick:(BTButton *)sender {
    
    [BTCMInstance pushViewControllerWithName:@"SettingOrChange" andParams:@{@"type":@"忘记密码"}];
}

//协议
- (IBAction)xieYiBtnClicl:(BTButton *)sender {
    NSLog(@"%@",[BTConfig sharedInstance].h5domain);
    H5Node *node = [[H5Node alloc] init];
    node.title = [APPLanguageService wyhSearchContentWith:@"xieyi"];
    node.webUrl = XieYi_H5;
   
    [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
}
//返回
- (IBAction)backClick:(UIButton *)sender {
    
    [BTCMInstance dismissViewController];
}

#pragma mark - 选择国家区号
- (void)selectCountryCode:(UITapGestureRecognizer *)sender {

    CountryCodeViewController *countryCodeVC = [CountryCodeViewController new];
    BTNavigationViewController *nav = [[BTNavigationViewController alloc] initWithRootViewController:countryCodeVC];
    [self presentViewController:nav animated:YES completion:nil];
    
    WS(ws)
    countryCodeVC.codeBlock = ^(NSString *code){
        NSString *codeStr = [code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        codeStr = [codeStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        ws.countryCodeLabel.text = codeStr;
        [self textFiledEditChanged:[NSNotification notificationWithName:@"UITextFieldTextDidChangeNotification" object:nil]];
    };
    
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
