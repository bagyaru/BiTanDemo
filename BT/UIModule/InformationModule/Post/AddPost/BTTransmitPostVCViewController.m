//
//  BTTransmitPostVCViewController.m
//  BT
//
//  Created by apple on 2018/9/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTTransmitPostVCViewController.h"
#import "WBEmoticonInputView.h"
#import "WBStatusComposeTextParser.h"
#import "WBStatusHelper.h"
#import "WBStatusLayout.h"
#import "YYKit.h"
#import "BTAddPostRequest.h"
#import "BTTransmitPostView.h"
#import "BTCancelAlertView.h"
#import "BTSelectPersonVC.h"
#import "BTUserAlertView.h"
#import "BTUserPermissionReq.h"
#import "BTUserPermissonModel.h"
#import "BTPotTipView.h"
#import "BTConfig.h"
#define kToolbarHeight (80)

@interface BTTransmitPostVCViewController ()<YYTextViewDelegate, YYTextKeyboardObserver, WBStatusComposeEmoticonViewDelegate>

@property (nonatomic, strong) YYTextView *textView;

@property (nonatomic, strong) UIView *toolbar;
@property (nonatomic, strong) UIView *toolbarBackground;
@property (nonatomic, strong) UIButton *toolbarPOIButton;
@property (nonatomic, strong) UIButton *toolbarGroupButton;
@property (nonatomic, strong) UIButton *toolbarPictureButton;
@property (nonatomic, strong) UIButton *toolbarAtButton;
@property (nonatomic, strong) UIButton *toolbarTopicButton;
@property (nonatomic, strong) UIButton *toolbarEmoticonButton;
@property (nonatomic, strong) UIButton *toolbarExtraButton;
@property (nonatomic, assign) BOOL isInputEmoticon;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) NSString *originStr;

@property (nonatomic, strong) BTTransmitPostView *postView;


@end

@implementation BTTransmitPostVCViewController

- (instancetype)init {
    self = [super init];
    [[YYTextKeyboardManager defaultManager] addObserver:self];
    return self;
}

- (void)dealloc {
    [[YYTextKeyboardManager defaultManager] removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([BTGetUserInfoDefalut sharedManager].userInfo.token.length == 0){
      [BTCMInstance dismissViewController];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.listModel = self.parameters[@"model"];
    [self _initNavBar];
    [self _initTextView];
    [self _initToolbar];
    [_textView becomeFirstResponder];
    
    self.postView = [[BTTransmitPostView alloc] initWithFrame:CGRectMake(15, 231, ScreenWidth - 30.0f, 60.0f)];
    [self.textView addSubview:self.postView];
    self.postView.model = self.listModel;
    self.postView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.postView addGestureRecognizer:tap];
    [self judgeUserPermission:NO];
    
}

- (void)_initNavBar {
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName :FirstColor, NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    //CNavBgColor
    [navBar setBackgroundImage:[UIImage imageWithColor:CNavBgColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage imageWithColor:SeparateColor size:CGSizeMake(ScreenWidth, 0.5)]];
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fatie_shut"] style:UIBarButtonItemStylePlain target:self action:@selector(_cancel)];
    self.navigationItem.leftBarButtonItem = button;
    self.navigationItem.leftBarButtonItem = button;
    self.title = [APPLanguageService sjhSearchContentWith:@"zhuanfatiezi"];
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:[APPLanguageService sjhSearchContentWith:@"zhuanfa"] style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    [rightBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                           NSForegroundColorAttributeName : ThirdColor} forState:UIControlStateDisabled];
    [rightBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                           NSForegroundColorAttributeName : MainBg_Color} forState:UIControlStateNormal];
    [rightBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                           NSForegroundColorAttributeName : MainBg_Color} forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

//
- (void)_initTextView {
    if (_textView) return;
    _textView = [YYTextView new];
    _textView.size = CGSizeMake(self.view.width, self.view.height);
    _textView.textContainerInset = UIEdgeInsetsMake(12, 16, 12, 16);
    _textView.contentInset = UIEdgeInsetsMake(12, 0, kToolbarHeight, 0);
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _textView.extraAccessoryViewHeight = kToolbarHeight;
    _textView.showsVerticalScrollIndicator = NO;
    _textView.alwaysBounceVertical = YES;
    _textView.textColor = FirstColor;
    _textView.backgroundColor = isNightMode? ViewContentBgColor :CWhiteColor;
    _textView.allowsCopyAttributedString = NO;
    _textView.font = [UIFont systemFontOfSize:16];
    WBStatusComposeTextParser *textParser = [[WBStatusComposeTextParser alloc] init];
    textParser.textColor =  FirstColor;
    textParser.highlightTextColor = MainBg_Color;
    _textView.textParser = textParser;
    _textView.delegate = self;
    _textView.inputAccessoryView = [UIView new];
    
    if(self.listModel.type == 3){
        NSString *name = [NSString stringWithFormat:@"@%@:",[self.listModel.nickName stringByReplacingOccurrencesOfString:@" "  withString:@""]];
        NSString *str = [NSString stringWithFormat:@"%@%@",name,self.listModel.content ];
        _textView.text = [NSString stringWithFormat:@"//%@",str];
        _textView.selectedRange = NSMakeRange(0, 0);
    }else{
        _textView.text = [APPLanguageService sjhSearchContentWith:@"zhuanfaplaceholder"];
    }
    self.originStr = _textView.text;
   
    
    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
    modifier.font = FONTOFSIZE(16.0f);
    modifier.paddingTop = 12;
    modifier.paddingBottom = 12;
    modifier.lineHeightMultiple = 1.5;
    _textView.linePositionModifier = modifier;
    
    NSString *placeholderPlainText = nil;
    placeholderPlainText = [APPLanguageService sjhSearchContentWith:@"zhuanfaplaceholder"];
    if (placeholderPlainText) {
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderPlainText];
        atr.color = ThirdColor;
        atr.font = [UIFont systemFontOfSize:16];
        _textView.placeholderAttributedText = atr;
    }
    [self.view addSubview:_textView];
    
}
//
- (void)_initToolbar {
    if (_toolbar) return;
    _toolbar = [UIView new];
    _toolbar = [UIView new];
    _toolbar.backgroundColor = isNightMode ?ViewContentBgColor :CWhiteColor;
    _toolbar.size = CGSizeMake(self.view.width, kToolbarHeight);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    _toolbarBackground = [UIView new];
    _toolbarBackground.backgroundColor = isNightMode ?ViewBGColor :CWhiteColor;
    _toolbarBackground.size = CGSizeMake(_toolbar.width, 50);
    _toolbarBackground.bottom = _toolbar.height;
    _toolbarBackground.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    [_toolbar addSubview:_toolbarBackground];
    _toolbarBackground.height = 300; // extend
    _countLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _toolbarAtButton = [self _toolbarButtonWithImage:@"post_At"
                                           highlight:@"post_At"];
    CGFloat one = _toolbar.width / 5;
    _toolbarAtButton.centerX = one * 0.5;
    _toolbar.bottom = self.view.height;
    [self.view addSubview:_toolbar];
    
    
    _countLabel = [UILabel labelWithFrame:CGRectZero title:@"0/150" font:FONTOFSIZE(12) textColor:ThirdColor];
    [_toolbar addSubview:_countLabel];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_toolbar).offset(-15);
        make.top.equalTo(_toolbar).offset(5);
    }];
    _countLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    self.countLabel.text = [NSString stringWithFormat:@"%lu/150", (unsigned long)_textView.text.length];
    [self.view addSubview:_toolbar];
}

- (UIButton *)_toolbarButtonWithImage:(NSString *)imageName highlight:(NSString *)highlightImageName {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.exclusiveTouch = YES;
    button.size = CGSizeMake(46, 46);
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlightImageName] forState:UIControlStateHighlighted];
    button.centerY = 46 / 2;
    button.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [button addTarget:self action:@selector(_buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbarBackground addSubview:button];
    return button;
}

- (void)_buttonClicked:(UIButton *)button {
    if (button == _toolbarAtButton) {
        [self.view endEditing:YES];
        BTSelectPersonVC *selectVC = [[BTSelectPersonVC alloc] init];
        [self.navigationController pushViewController:selectVC animated:YES];
        NSInteger index = self.textView.selectedRange.location;
        selectVC.selectBlock = ^(NSString *name){
            NSString *insertString = [NSString stringWithFormat:@"@%@",name];
            [self.textView replaceRange:self.textView.selectedTextRange withText:insertString];
            self.textView.selectedRange = NSMakeRange(index + insertString.length, 0);
        };
    }
}
//
- (void)_cancel {
    [self.view endEditing:YES];
    if([self.textView.text isEqualToString:self.originStr]){
        [BTCMInstance dismissViewController];
    }else{
        [BTCancelAlertView showWithTitle:@"" completion:^(NSString *str) {
            if(str.length == 0){
                [self.textView becomeFirstResponder];
            }else{
                [BTCMInstance dismissViewController];
            }
        }];
    }
}
//
#pragma mark @protocol YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
    self.countLabel.text = [NSString stringWithFormat:@"%lu/150", (unsigned long)textView.text.length];
    if (textView.text.length >= 150) {
        textView.text = [textView.text substringToIndex:150];
        self.countLabel.text = @"150/150";
    }
    
    //处理遮挡的问题
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if(size.height +30 > 231){
        self.postView.frame = CGRectMake(15, size.height +30, ScreenWidth - 30.0f, 60.0f);
    }else{
        self.postView.frame = CGRectMake(15, 231, ScreenWidth - 30.0f, 60.0f);
    }
}

// 计算剩余可输入字数 超出最大可输入字数，就禁止输入
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    // 设置占位文字是否隐藏
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        if (offsetRange.location < 150) {
            return YES;
        }else{
            return NO;
        }
    }
    if([text isEqualToString:textView.text]){
        return YES;
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = 150 - comcatstr.length;
    if (caninputlen >= 0){
        return YES;
    }else{
        return NO;
    }
}

//
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark @protocol YYTextKeyboardObserver
- (void)keyboardChangedWithTransition:(YYTextKeyboardTransition)transition {
    CGRect toFrame = [[YYTextKeyboardManager defaultManager] convertRect:transition.toFrame toView:self.view];
    if (transition.animationDuration == 0) {
        _toolbar.bottom = CGRectGetMinY(toFrame);
    } else {
        [UIView animateWithDuration:transition.animationDuration delay:0 options:transition.animationOption | UIViewAnimationOptionBeginFromCurrentState animations:^{
            _toolbar.bottom = CGRectGetMinY(toFrame);
        } completion:NULL];
    }
}

//发帖子
- (void)send{
    //    [self.textView endEditing:YES];
    [self judgeUserPermission:YES];
}
- (void)nextAction{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self postRequest];
}
//发帖子
- (void)postRequest{
    [BTShowLoading show];
    NSString *imagesKey = @"";
    NSInteger sourcePostId;
    NSInteger sharePostId;
    if(self.listModel.type == 3){//转发
        sourcePostId = self.listModel.sourcePostModel.postId;
        sharePostId  = self.listModel.postId;
    }else{
        sourcePostId = self.listModel.postId;
        sharePostId  = 0;
    }
    NSDictionary *params = @{
                             @"content": SAFESTRING(self.textView.text),
                             @"images": SAFESTRING(imagesKey),
                             @"shareId": @(sharePostId),
                             @"sourceId": @(sourcePostId),
                             @"type": @(3),//转发
                             @"userId": @([BTGetUserInfoDefalut sharedManager].userInfo.userId),
                             };
    
    
    BTAddPostRequest *addPostApi = [[BTAddPostRequest alloc] initWithDict:params];
    [addPostApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
        //通知帖子列表刷新
        if(request.data){
            [getUserCenter shareSuccseGetTanLiWithType:10 withTime:1];
            [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Refresh_Post_List object:nil];
            [BTCMInstance dismissViewController];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
//        [MBProgressHUD showMessage:request.resultMsg wait:YES];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Refresh_Post_List object:nil];
        [BTCMInstance dismissViewController];
        //失败后 保存到内存中
        self.listModel.content = self.textView.text;
        if(self.listModel.type != 3){//转发
            self.listModel.sourcePostModel = self.listModel;
        }
        if(self.listModel.type == 3){//转发
            
            self.listModel.errorType = 3;
        }else {
            
            self.listModel.errorType = 2;
            self.listModel.type = 3;
        }
        self.listModel.uuid = [BTHelperMethod uuidString];
        
        [[BTGetUserInfoDefalut sharedManager].posts addObject:self.listModel];
    }];
}
//跳转到原贴子
- (void)tap{
    NSInteger sourcePostId;
    if(self.listModel.type == 3){//转发
        sourcePostId = self.listModel.sourcePostModel.postId;
    }else{
        sourcePostId = self.listModel.postId;
    }
    [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":[NSString stringWithFormat:@"%ld",sourcePostId]}];
}

- (void)judgeUserPermission:(BOOL)isNext{
    if(isNext){
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    BTUserPermissionReq *api = [[BTUserPermissionReq alloc] init];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data &&[request.data isKindOfClass:[NSDictionary class]]){
            BTUserPermissonModel *model = [BTUserPermissonModel objectWithDictionary:request.data];
            if(model.fenHao){
                [_textView resignFirstResponder];
                return;
            }else{
                if(model.banned){//禁言
                     [_textView resignFirstResponder];
                    [BTUserAlertView showWithTitle:[APPLanguageService sjhSearchContentWith:@"jinyan"] content:[APPLanguageService sjhSearchContentWith:@"jinyandesc"] completion:^(NSInteger status) {
                        if(status ==0){
                             [BTCMInstance dismissViewController];
                        }else{// find assist
                            H5Node *node = [[H5Node alloc] init];
                            node.title = [APPLanguageService wyhSearchContentWith:@"tianjiaweixinquan"];
                             node.webUrl = [NSString stringWithFormat:@"%@%@",[BTConfig sharedInstance].h5domain,BTXZS_H5];
                            
                            [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
                        }
                    }];
                    
                } else if(model.postLimit){//
                    [_textView resignFirstResponder];
                    NSString *content = [NSString stringWithFormat:@"%@%@%@",[APPLanguageService sjhSearchContentWith:@"fatieshangxian"],@(model.postLimitNum),[APPLanguageService sjhSearchContentWith:@"ci"]];
                    [BTPotTipView showBTPotTipView:content completion:^(NSInteger status) {
                        [BTCMInstance dismissViewController];
                    }];
                    
                    
                }else{
                    if(isNext){// request
                        [self nextAction];
                    }
                }
            }
            
        }
    } failure:^(__kindof BTBaseRequest *request) {
        if(isNext){// request
            [self.view endEditing:YES];
            [MBProgressHUD showMessage:request.resultMsg wait:YES];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        
    }];
}

@end
