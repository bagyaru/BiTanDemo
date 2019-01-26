//
//  RegisterViewController.m
//  BT
//
//  Created by admin on 2018/7/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginRequest.h"
#import "GetCaptchaRequest.h"
#import "BTUserCenter.h"
#import "BTConfig.h"
#import "CountryCodeViewController.h"
#import "BTNavigationViewController.h"
#import "BTRegisterRequest.h"
#define MAXTIMER 60
//数字和字母
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface RegisterViewController ()<UITextFieldDelegate>{
    
    NSTimer      *_codeTimer;//定时器
    NSInteger    _nTimerCount;//倒计时
}
@property (weak, nonatomic) IBOutlet BTTextField *phoneTF;
@property (weak, nonatomic) IBOutlet BTButton *verificationCodeBtn;
@property (weak, nonatomic) IBOutlet BTTextField *verificationCodeTF;
@property (weak, nonatomic) IBOutlet BTTextField *passwordTF;
@property (weak, nonatomic) IBOutlet BTTextField *InviteCodeTF;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet UIView *selectCountryView;
@property (weak, nonatomic) IBOutlet BTButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *downBtn;
@property (weak, nonatomic) IBOutlet UIButton *hiddeBtn;


@end

@implementation RegisterViewController
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:nil];
    [_codeTimer invalidate];
    _codeTimer = nil;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.downBtn.image = IMAGE_NAMED(@"filterdown");
    [self.hiddeBtn setImage:IMAGE_NAMED(@"眼睛-闭") forState:UIControlStateNormal];
    [self.hiddeBtn setImage:IMAGE_NAMED(@"眼睛-睁") forState:UIControlStateSelected];
    self.view.backgroundColor = KWhiteColor;
    self.title = [APPLanguageService wyhSearchContentWith:@"zhuce"];
    ViewRadius(self.registerBtn, 4);
    self.phoneTF.delegate            = self;
    self.passwordTF.delegate         = self;
    self.InviteCodeTF.delegate       = self;
    self.verificationCodeTF.delegate = self;
    [self checkAll];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:nil];
    [self.selectCountryView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCountryCode:)]];
    // Do any additional setup after loading the view from its nib.
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
    
    //验证码最长可输入8个字节
    if (self.verificationCodeTF.text.length > 8) {
        
        self.verificationCodeTF.text = [self.verificationCodeTF.text substringToIndex:8];
        
    }
    [self checkAll];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField == self.InviteCodeTF) {
        
        if (range.length == 1 && string.length == 0) {
            
            return YES;
        }else if (self.InviteCodeTF.text.length >= 4) {
            
            self.InviteCodeTF.text = [textField.text substringToIndex:4];
            return NO;
        }else {
            
            NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
            NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
            
            return [string isEqualToString:filtered];
            
        }
    }
    if (textField == self.passwordTF) {
        
        if (range.length == 1 && string.length == 0) {
            
            return YES;
        }else if (self.passwordTF.text.length >= 12) {
            
            self.passwordTF.text = [textField.text substringToIndex:12];
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
        
        if (ISNSStringValid(self.passwordTF.text)) {
            
            if (self.passwordTF.text.length < 6) {
                
                self.registerBtn.backgroundColor = MainBg_Color;
                self.registerBtn.alpha   = 0.5;
                self.registerBtn.enabled = NO;
            }else {
                
                self.registerBtn.backgroundColor = MainBg_Color;
                self.registerBtn.alpha   = 1;
                self.registerBtn.enabled = YES;
            }
        }else {
            
            self.registerBtn.backgroundColor = MainBg_Color;
            self.registerBtn.alpha   = 1;
            self.registerBtn.enabled = YES;
        }
    } else {
        self.registerBtn.backgroundColor = MainBg_Color;
        self.registerBtn.alpha   = 0.5;
        self.registerBtn.enabled = NO;
    }
}

//获取验证码
- (IBAction)getYZMBtnClcik:(BTButton *)sender {
    
    [self.phoneTF resignFirstResponder];
    [self.verificationCodeTF resignFirstResponder];

    if (!ISNSStringValid(self.phoneTF.text)) {
            
            [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"shuRuPhone"] wait:YES];
            return;
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
//明暗文切换
- (IBAction)hIddeBtnClcik:(UIButton *)sender {
    
    // 前提:在xib中设置按钮的默认与选中状态的背景图
    // 切换按钮的状态
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.passwordTF.text;
        self.passwordTF.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.passwordTF.secureTextEntry = NO;
        self.passwordTF.text = tempPwdStr;
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.passwordTF.text;
        self.passwordTF.text = @"";
        self.passwordTF.secureTextEntry = YES;
        self.passwordTF.text = tempPwdStr;
    }
}

//注册
- (IBAction)registerBtnClick:(BTButton *)sender {
    self.registerBtn.enabled = NO;
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
    if (ISNSStringValid(self.passwordTF.text)) {//有密码注册
        BTRegisterRequest *api = [[BTRegisterRequest alloc] initWithDict:@{@"captcha":self.verificationCodeTF.text,@"countryCode":self.countryCodeLabel.text,@"inviterCode":self.InviteCodeTF.text,@"mobile":self.phoneTF.text,@"password":[getUserCenter md5:[NSString stringWithFormat:@"%@%@",MD5PassWordStr,self.passwordTF.text]],@"userRole":@(2)}];
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
            if (myInfo.userHavePassword) {
                NSLog(@"有密码");
            }else {
                NSLog(@"没有密码");
            }
            [BTCMInstance dismissViewController];
            [[NSNotificationCenter  defaultCenter] postNotificationName:NSNotification_loginSuccess object:nil];
            
        } failure:^(__kindof BTBaseRequest *request) {
            self.registerBtn.enabled = YES;
        }];
    }else {//无密码注册
        
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
            if (myInfo.userHavePassword) {
                NSLog(@"有密码");
            }else {
                NSLog(@"没有密码");
            }
            [BTCMInstance dismissViewController];
            [[NSNotificationCenter  defaultCenter] postNotificationName:NSNotification_loginSuccess object:nil];
            
        } failure:^(__kindof BTBaseRequest *request) {
            NSLog(@"failed");
            self.registerBtn.enabled = YES;
        }];
    }
}
//协议
- (IBAction)xieyiBtnClick:(BTButton *)sender {
    
    NSLog(@"%@",[BTConfig sharedInstance].h5domain);
    H5Node *node = [[H5Node alloc] init];
    node.title = [APPLanguageService wyhSearchContentWith:@"xieyi"];
    node.webUrl = XieYi_H5;
    
    [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
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
