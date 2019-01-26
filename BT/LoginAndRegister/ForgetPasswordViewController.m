//
//  ForgetPasswordViewController.m
//  BT
//
//  Created by admin on 2018/7/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "BTValidCaptchaRequest.h"
#import "GetCaptchaRequest.h"
@interface ForgetPasswordViewController ()<UITextFieldDelegate> {
    
    NSInteger _messageType;
    NSTimer      *_codeTimer;//定时器
    NSInteger    _nTimerCount;//倒计时
}

@property (weak, nonatomic) IBOutlet UILabel *headL;
@property (weak, nonatomic) IBOutlet BTButton *verificationCodeBtn;
@property (weak, nonatomic) IBOutlet BTTextField *verificationCodeTF;
@property (weak, nonatomic) IBOutlet BTButton *savaBtn;

@end

@implementation ForgetPasswordViewController
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:nil];
    [_codeTimer invalidate];
    _codeTimer = nil;
}
-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self checkAll];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KWhiteColor;
    self.title = [APPLanguageService wyhSearchContentWith:@"anquanjiaoyan"];
    self.verificationCodeTF.delegate            = self;
    [self checkAll];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:nil];
    self.headL.text = [NSString stringWithFormat:@"%@（%@）%@",[APPLanguageService wyhSearchContentWith:@"wangjimimayanzheng1"],[getUserCenter getPhone:self.parameters[@"phone"]],[APPLanguageService wyhSearchContentWith:@"wangjimimayanzheng2"]];
    

    [getUserCenter setLabelSpace:self.headL withValue:self.headL.text withFont:SYSTEMFONT(14) withHJJ:10.0 withZJJ:0.0];
    self.headL.textAlignment = NSTextAlignmentCenter;
    self.savaBtn.localTitle = @"xiayibu";
    if (ISStringEqualToString(self.parameters[@"type"], @"忘记密码")) {
        _messageType = 5;
    }
    if (ISStringEqualToString(self.parameters[@"type"], @"修改登录密码")) {
        _messageType = 6;
    }
    
    //成功倒计时
    self.verificationCodeBtn.enabled = NO;
    _codeTimer = nil;
    _nTimerCount = [self.parameters[@"time"] integerValue];
    _codeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(setChangeCodeBtn) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_codeTimer forMode:NSDefaultRunLoopMode];
    // Do any additional setup after loading the view from its nib.
}

-(void)textFiledEditChanged:(NSNotification *)obj {
    
    //验证码最长可输入8个字节
    if (self.verificationCodeTF.text.length > 8) {
        
        self.verificationCodeTF.text = [self.verificationCodeTF.text substringToIndex:8];
        
    }
    [self checkAll];
}
-(void)checkAll {
    
    if (ISNSStringValid(self.verificationCodeTF.text)) {
        
        self.savaBtn.backgroundColor = MainBg_Color;
        self.savaBtn.alpha   = 1;
        self.savaBtn.enabled = YES;
    } else {
        self.savaBtn.backgroundColor = MainBg_Color;
        self.savaBtn.alpha   = 0.5;
        self.savaBtn.enabled = NO;
    }
}
//获取验证码
- (IBAction)getYZMBtnClcik:(BTButton *)sender {
    
    
    self.verificationCodeBtn.enabled = NO;
    GetCaptchaRequest *api = [[GetCaptchaRequest alloc] initWithCountryCode:self.parameters[@"code"] account:self.parameters[@"phone"] sendType:@"1" messageType:self.parameters[@"messageType"]];
    api.isShowMessage = YES;
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest * _Nonnull request) {
        [getUserCenter removeTimeDifferenceWithType:[NSString stringWithFormat:@"%@%@",self.parameters[@"type"],self.parameters[@"phone"]]];
        //成功倒计时
        _codeTimer = nil;
        _nTimerCount = 60;
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
        _nTimerCount = 60;
    }
    else
    {
        _verificationCodeBtn.enabled = NO;
        [_verificationCodeBtn setTitle:[NSString stringWithFormat:@"%@ %lds",[APPLanguageService wyhSearchContentWith:@"yifasong"],(long)_nTimerCount] forState:UIControlStateNormal];
    }
}
- (IBAction)savaBtn:(BTButton *)sender {
    self.savaBtn.enabled = NO;
    if (ISNSStringValid(self.verificationCodeTF.text)) {
        
        BTValidCaptchaRequest *api = [[BTValidCaptchaRequest alloc] initWithDict:@{@"account":self.parameters[@"phone"],@"captcha":self.verificationCodeTF.text,@"messageType":@(_messageType)}];
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
         
           if (ISStringEqualToString(self.parameters[@"type"], @"忘记密码")) {
               
               [BTCMInstance pushViewControllerWithName:@"SettingOrChange" andParams:@{@"type":@"设置密码",@"phone":self.parameters[@"phone"],@"code":self.verificationCodeTF.text}];
           }
            if (ISStringEqualToString(self.parameters[@"type"], @"修改登录密码")) {

                [BTCMInstance pushViewControllerWithName:@"SettingOrChange" andParams:@{@"type":@"修改登录密码",@"phone":self.parameters[@"phone"],@"code":self.verificationCodeTF.text}];
            }
            
        } failure:^(__kindof BTBaseRequest *request) {
            
            self.savaBtn.enabled = YES;
        }];
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
