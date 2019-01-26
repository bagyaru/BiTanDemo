//
//  SettingNickNameViewController.m
//  BT
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SettingNickNameViewController.h"
#import "ChangeNikeNameRequest.h"
#define MaxLenght 12
#define MinLenght 2
@interface SettingNickNameViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet BTTextField *nickNameTF;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet BTLabel *jianjieLabel;

@end

@implementation SettingNickNameViewController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UITextFieldTextDidChangeNotification"
                                                  object:self.nickNameTF];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:[APPLanguageService wyhSearchContentWith:@"sava"] style:UIBarButtonItemStylePlain target:self action:@selector(naviBtnClick)];
    [rightBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                           NSForegroundColorAttributeName : ThirdColor} forState:UIControlStateDisabled];
    [rightBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                           NSForegroundColorAttributeName : MainBg_Color} forState:UIControlStateNormal];
    [rightBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                           NSForegroundColorAttributeName : MainBg_Color} forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.title = [APPLanguageService wyhSearchContentWith:@"nickName"];
    self.nickNameTF.text = self.oldNickName;
    self.nickNameTF.delegate = self;
    
    self.nickNameTF.backgroundColor = isNightMode ? TableViewCellNightColor : KWhiteColor;
    self.lineLabel.backgroundColor  = SeparateColor;
    [self.nickNameTF setValue:ThirdColor forKeyPath:@"_placeholderLabel.textColor"];
    self.nickNameTF.textColor = FirstColor;
    self.jianjieLabel.textColor = ThirdColor;
    //对实时键盘监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.nickNameTF];
    // Do any additional setup after loading the view from its nib.
}
//保存
- (void)naviBtnClick{
    
    [self.nickNameTF resignFirstResponder];
    if (self.nickNameTF.text.length == 0) {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"shuRuNikeName"] wait:YES];
        return;
        
    }
    if (self.nickNameTF.text.length < MinLenght||self.nickNameTF.text.length > MaxLenght) {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"qingshuruzhengquedenicheng"] wait:YES];
        return;
    }
    
    ChangeNikeNameRequest *api = [[ChangeNikeNameRequest alloc] initWithNikeName:self.nickNameTF.text introduces:@"" homePage:@""];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (_SuccessBlock) {
            
            //更新本地信息
            MyInfoObJ *myInfo       = [[MyInfoObJ alloc] init];
            myInfo.userAvatar       = getUserCenter.detailMyInfo.userAvatar;
            myInfo.username         = self.nickNameTF.text;
            myInfo.mobile           = getUserCenter.detailMyInfo.mobile;
            myInfo.userHavePassword = getUserCenter.detailMyInfo.userHavePassword;
            [myInfo saveToClassFile];
            getUserCenter.detailMyInfo = myInfo;
            _SuccessBlock(self.nickNameTF.text);
            
            [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"success"] wait:YES];
            
            [BTCMInstance popViewController:nil];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
    
}

//对键盘进行监听，使输入的字符长度不能超过最大输入长度
-(void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    
    self.navigationItem.rightBarButtonItem.enabled = toBeString.length >0;
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > MaxLenght) {
                
                [self.nickNameTF resignFirstResponder];
                
                textField.text = [toBeString substringToIndex:MaxLenght];
                [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"chaochuzuidachangdu"] wait:YES];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > MaxLenght) {
            
            [self.nickNameTF resignFirstResponder];
            
            textField.text = [toBeString substringToIndex:MaxLenght];
            [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"chaochuzuidachangdu"] wait:YES];
        }
    }
}
#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *tem = [[string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]componentsJoinedByString:@""];
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／：；（）¥「」＂、[]{}#%*+=//|~＜＞$€^£•'@#$%^&*():;.,?!<>\\+'/\""];
    NSString *str = [tem stringByTrimmingCharactersInSet:set];
    if (![string isEqualToString:str]) {
        return NO;
        
    }
    return YES;
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
