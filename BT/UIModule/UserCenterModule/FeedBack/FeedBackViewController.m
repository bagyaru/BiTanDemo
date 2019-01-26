//
//  FeedBackViewController.m
//  BT
//
//  Created by admin on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FeedBackViewController.h"
#import "FeedBackRequest.h"
#define titleTVMaxLenth 100
@interface FeedBackViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet BTTextView *textView;

@property (weak, nonatomic) IBOutlet BTLabel *alertL;

@property (weak, nonatomic) IBOutlet BTButton *savaBtn;

@property (weak, nonatomic) IBOutlet BTLabel *numberL;
@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.savaBtn.enabled = NO;
    self.textView.delegate = self;
    self.title = [APPLanguageService wyhSearchContentWith:@"FeedBack"];
    ViewRadius(self.savaBtn, 4);
    self.savaBtn.backgroundColor = MainBg_Color;
    self.savaBtn.alpha           = 0.5;
    // Do any additional setup after loading the view from its nib.
}
//将要开始编辑是
-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    if (textView == self.textView) {
        
        _numberL.text = [NSString stringWithFormat:@"%ld/100",self.textView.text.length];
    }
    
}
//正在编辑中
-(void)textViewDidChange:(UITextView *)textView {
    
    self.alertL.hidden = textView.text.length > 0;
    self.savaBtn.enabled = textView.text.length > 0;
    if (ISNSStringValid(textView.text)) {
        self.savaBtn.backgroundColor = MainBg_Color;
        self.savaBtn.alpha           = 1;
    }else {
        
        self.savaBtn.backgroundColor = MainBg_Color;
        self.savaBtn.alpha           = 0.5;
    }
    if (textView == self.textView) {
        
        _numberL.text = [NSString stringWithFormat:@"%ld/100",self.textView.text.length];
        
        if ([self.textView.text length] > titleTVMaxLenth) {
            self.textView.text = [self.textView.text substringWithRange:NSMakeRange(0, titleTVMaxLenth)];
           _numberL.text = @"100/100";
            [self.textView.undoManager removeAllActions];
            [self.textView becomeFirstResponder];
            return;
        }
    }
}
- (IBAction)savaBtnClick:(BTButton *)sender {
    
    if (!ISNSStringValid(_textView.text)) {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"FeedBackAlert"] wait:YES];
        
        return;
    }
    self.savaBtn.enabled = NO;
    FeedBackRequest *api = [[FeedBackRequest alloc] initWithContent:_textView.text];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [AnalysisService alaysisMine_advice_01];
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"success"] wait:YES];
        
        [BTCMInstance popViewController:nil];
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
    
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
