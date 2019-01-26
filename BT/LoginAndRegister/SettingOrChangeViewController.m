//
//  SettingOrChangeViewController.m
//  BT
//
//  Created by admin on 2018/7/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SettingOrChangeViewController.h"
#import "GetCaptchaRequest.h"
#import "BTUserCenter.h"
#import "BTConfig.h"
#import "CountryCodeViewController.h"
#import "BTNavigationViewController.h"

#import "BTForgetPasswordRequest.h"
#import "LoginAndRegisterViewController.h"
#import "BTChangePasswordRequest.h"
#import "BTSettingPasswordRequest.h"

#import "MyInfoObJ.h"
//数字和字母
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface SettingOrChangeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet BTTextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *countryCodeLabel;
@property (weak, nonatomic) IBOutlet UIView *selectCountryView;
@property (weak, nonatomic) IBOutlet UIButton *hiddeBtn;
@property (weak, nonatomic) IBOutlet BTButton *nextBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLayout;
@property (weak, nonatomic) IBOutlet UIImageView *downBtn;

@end

@implementation SettingOrChangeViewController
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:nil];
}
-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    [self checkAll];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.downBtn.image = IMAGE_NAMED(@"filterdown");
    [self.hiddeBtn setImage:IMAGE_NAMED(@"眼睛-闭") forState:UIControlStateNormal];
    [self.hiddeBtn setImage:IMAGE_NAMED(@"眼睛-睁") forState:UIControlStateSelected];
    ViewRadius(self.nextBtn, 4);
    self.textField.delegate            = self;
    [self checkAll];
    self.view.backgroundColor = KWhiteColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:@"UITextFieldTextDidChangeNotification" object:nil];
    self.hiddeBtn.hidden            = NO;
    self.selectCountryView.hidden   = YES;
    self.nextBtn.localTitle         = @"wangcheng_password";
    self.textField.localPlaceholder = @"qingshurumima_password";
    self.textField.keyboardType     = UIKeyboardTypeDefault;
    self.textField.secureTextEntry  = YES;
    self.leftLayout.constant        = -43;
    if (ISStringEqualToString(self.parameters[@"type"], @"忘记密码")) {
      
        self.leftLayout.constant      = 15;
        self.hiddeBtn.hidden          = YES;
        self.selectCountryView.hidden = NO;
        self.nextBtn.localTitle       = @"xiayibu";
        self.textField.keyboardType   = UIKeyboardTypeNumberPad;
        self.textField.secureTextEntry= NO;
        self.title = [APPLanguageService wyhSearchContentWith:@"zhaohuimima"];
        [self.selectCountryView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCountryCode:)]];
        self.textField.localPlaceholder = @"shuRuPhone";
    }
    if (ISStringEqualToString(self.parameters[@"type"], @"设置密码")||ISStringEqualToString(self.parameters[@"type"], @"设置登录密码")) {
        
        self.title = [APPLanguageService wyhSearchContentWith:@"shezhimima"];
    }
    if (ISStringEqualToString(self.parameters[@"type"], @"修改登录密码")) {
        
        self.title = [APPLanguageService wyhSearchContentWith:@"xiugaimima"];
    }
    // Do any additional setup after loading the view from its nib.
}
-(void)textFiledEditChanged:(NSNotification *)obj {
    
    if (ISStringEqualToString(self.parameters[@"type"], @"忘记密码")) {
      
        if ([self.countryCodeLabel.text isEqualToString:@"+86"]) {
            
            //手机号最长可输入11个字(国内)
            if (self.textField.text.length > 11) {
                
                self.textField.text = [self.textField.text substringToIndex:11];
            }
            
        }else {
            //手机号最长可输入6-15个字(国内外)
            if (self.textField.text.length > 15) {
                
                self.textField.text = [self.textField.text substringToIndex:15];
            }
        }
    }
    
    [self checkAll];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (ISStringEqualToString(self.parameters[@"type"], @"设置密码")||ISStringEqualToString(self.parameters[@"type"], @"修改登录密码")||ISStringEqualToString(self.parameters[@"type"], @"设置登录密码")) {
       
        
            if (textField == self.textField) {
        
                if (range.length == 1 && string.length == 0) {
        
                    return YES;
                }else if (self.textField.text.length >= 12) {
        
                    self.textField.text = [textField.text substringToIndex:12];
                    return NO;
                }else {
        
                    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
                    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        
                    return [string isEqualToString:filtered];
        
                }
            }
    }
    return YES;
}
-(void)checkAll {
    
    if (ISStringEqualToString(self.parameters[@"type"], @"忘记密码")) {
        
        
        if ([self.countryCodeLabel.text isEqualToString:@"+86"]){
            if (self.textField.text.length == 11) {
                
                self.nextBtn.backgroundColor = MainBg_Color;
                self.nextBtn.alpha   = 1;
                self.nextBtn.enabled = YES;
                
            } else {
                
                self.nextBtn.backgroundColor = MainBg_Color;
                self.nextBtn.alpha   = 0.5;
                self.nextBtn.enabled = NO;
            }
        }else{
            if (self.textField.text.length >= 6) {
                
                self.nextBtn.backgroundColor = MainBg_Color;
                self.nextBtn.alpha   = 1;
                self.nextBtn.enabled = YES;
            } else {
                self.nextBtn.backgroundColor = MainBg_Color;
                self.nextBtn.alpha   = 0.5;
                self.nextBtn.enabled = NO;
            }
        }
        
    }else {
        
        if (self.textField.text.length < 6) {
            
            self.nextBtn.backgroundColor = MainBg_Color;
            self.nextBtn.alpha   = 0.5;
            self.nextBtn.enabled = NO;
        }else {
            
            self.nextBtn.backgroundColor = MainBg_Color;
            self.nextBtn.alpha   = 1;
            self.nextBtn.enabled = YES;
        }
    }

}
//隐藏
- (IBAction)hIddeBtnClcik:(UIButton *)sender {
    
    // 前提:在xib中设置按钮的默认与选中状态的背景图
    // 切换按钮的状态
    sender.selected = !sender.selected;
    
    if (sender.selected) { // 按下去了就是明文
        
        NSString *tempPwdStr = self.textField.text;
        self.textField.text = @""; // 这句代码可以防止切换的时候光标偏移
        self.textField.secureTextEntry = NO;
        self.textField.text = tempPwdStr;
        
    } else { // 暗文
        
        NSString *tempPwdStr = self.textField.text;
        self.textField.text = @"";
        self.textField.secureTextEntry = YES;
        self.textField.text = tempPwdStr;
    }
    
}

//下一步或完成
- (IBAction)nextBtnClick:(BTButton *)sender {
    self.nextBtn.enabled = NO;
    if (ISStringEqualToString(self.parameters[@"type"], @"忘记密码")) {
        
        if (!ISNSStringValid(self.textField.text)) {
            
            [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"shuRuPhone"] wait:YES];
            return;
        }
        
        if ([getUserCenter timeDifferenceWithType:[NSString stringWithFormat:@"%@%@",self.parameters[@"type"],self.textField.text]] == 60) {
          
            GetCaptchaRequest *api = [[GetCaptchaRequest alloc] initWithCountryCode:self.countryCodeLabel.text account:self.textField.text sendType:@"1" messageType:@"5"];
            api.isShowMessage = YES;
            [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest * _Nonnull request) {
                
                [BTCMInstance pushViewControllerWithName:@"ForgetPassword" andParams:@{@"type":@"忘记密码",@"phone":self.textField.text,@"time":@([getUserCenter timeDifferenceWithType:[NSString stringWithFormat:@"%@%@",self.parameters[@"type"],self.textField.text]]),@"code":self.countryCodeLabel.text,@"messageType":@"5"}];
                
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                
                self.nextBtn.enabled = YES;
                NSUserDefaults *userdefault = [NSUserDefaults standardUserDefaults];
                [userdefault removeObjectForKey:[NSString stringWithFormat:@"%@%@",self.parameters[@"type"],self.textField.text]];
                [userdefault synchronize];
            }];
        }else {
            
            [BTCMInstance pushViewControllerWithName:@"ForgetPassword" andParams:@{@"type":@"忘记密码",@"phone":self.textField.text,@"time":@([getUserCenter timeDifferenceWithType:[NSString stringWithFormat:@"%@%@",self.parameters[@"type"],self.textField.text]]),@"code":self.countryCodeLabel.text,@"messageType":@"5"}];
        }
    
    }
    
    if (ISStringEqualToString(self.parameters[@"type"], @"设置密码")) {//忘记密码-设置新密码
        BTForgetPasswordRequest *api = [[BTForgetPasswordRequest alloc] initWithAccount:self.parameters[@"phone"] password:[getUserCenter md5:[NSString stringWithFormat:@"%@%@",MD5PassWordStr,self.textField.text]] captcha:self.parameters[@"code"]];
        
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
           
            [MBProgressHUD showMessageIsWait:[NSString stringWithFormat:@"%@%@",[APPLanguageService wyhSearchContentWith:@"shezhimima"],[APPLanguageService wyhSearchContentWith:@"success"]] wait:YES];
            [BTCMInstance popRootViewController:nil];
        } failure:^(__kindof BTBaseRequest *request) {
           self.nextBtn.enabled = YES;
        }];
    }
    
    if (ISStringEqualToString(self.parameters[@"type"], @"修改登录密码")) {
        BTChangePasswordRequest *api = [[BTChangePasswordRequest alloc] initWithDict:@{@"account":self.parameters[@"phone"],@"newPassword":[getUserCenter md5:[NSString stringWithFormat:@"%@%@",MD5PassWordStr,self.textField.text]],@"captcha":self.parameters[@"code"]}];
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            [MBProgressHUD showMessageIsWait:[NSString stringWithFormat:@"%@%@",[APPLanguageService wyhSearchContentWith:@"xiugaimima"],[APPLanguageService wyhSearchContentWith:@"success"]] wait:YES];
            [BTCMInstance popRootViewController:nil];
        } failure:^(__kindof BTBaseRequest *request) {
            self.nextBtn.enabled = YES;
        }];
        
    }
    if (ISStringEqualToString(self.parameters[@"type"], @"设置登录密码")) {
        
        BTSettingPasswordRequest *api = [[BTSettingPasswordRequest alloc] initWithDict:@{@"password":[getUserCenter md5:[NSString stringWithFormat:@"%@%@",MD5PassWordStr,self.textField.text]]}];
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            //更新本地信息
            MyInfoObJ *myInfo = [[MyInfoObJ alloc] init];
            myInfo.userAvatar       = getUserCenter.detailMyInfo.userAvatar;
            myInfo.username         = getUserCenter.detailMyInfo.username;
            myInfo.mobile           = getUserCenter.detailMyInfo.mobile;
            myInfo.userHavePassword = YES;
            [myInfo saveToClassFile];
            getUserCenter.detailMyInfo = myInfo;
            [MBProgressHUD showMessageIsWait:[NSString stringWithFormat:@"%@%@",[APPLanguageService wyhSearchContentWith:@"shezhimima"],[APPLanguageService wyhSearchContentWith:@"success"]] wait:YES];
            [BTCMInstance popRootViewController:nil];
        } failure:^(__kindof BTBaseRequest *request) {
           self.nextBtn.enabled = YES;
        }];
    }
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
