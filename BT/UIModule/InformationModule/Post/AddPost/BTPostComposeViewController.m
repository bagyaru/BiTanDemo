//
//  BTPostComposeViewController.m
//  BT
//
//  Created by apple on 2018/9/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPostComposeViewController.h"
#import "WBEmoticonInputView.h"
#import "WBStatusComposeTextParser.h"
#import "WBStatusHelper.h"
#import "WBStatusLayout.h"
#import "YYKit.h"
#import "MQImageDragView.h"
#import "JKImagePickerController.h"
#import "BTAddPostRequest.h"
#import "changePhotoRequest.h"
#import "JKPhotoBrowser.h"
#import "BTCancelAlertView.h"
#import "BTPostMainListModel.h"
#import "BTSelectPersonVC.h"
#import "BTUserPermissionReq.h"
#import "BTUserPermissonModel.h"
#import "BTPotTipView.h"
#import "BTUserAlertView.h"
#import "H5ViewController.h"
#import "BTConfig.h"
#define kToolbarHeight (80)

@interface BTPostComposeViewController() <YYTextViewDelegate, YYTextKeyboardObserver, WBStatusComposeEmoticonViewDelegate,MQImageDragViewDelegate,JKImagePickerControllerDelegate>

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
@property (nonatomic,strong) MQImageDragView *dragView;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSMutableArray *resultImagesKeys;
@property (nonatomic, strong) UILabel *countLabel;


@end

@implementation BTPostComposeViewController

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
    if([BTGetUserInfoDefalut sharedManager].userInfo.token.length ==0){
        if (_dismiss) _dismiss();
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector( setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self _initNavBar];
    [self _initTextView];
    [self _initToolbar];
    
    [self loadData];
    
    [_textView becomeFirstResponder];
    self.dragView = [[MQImageDragView alloc] initWithFrame:CGRectMake(0, self.textView.bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
    self.dragView.backgroundColor = isNightMode ?ViewContentBgColor :CWhiteColor;
    self.dragView.kMarginLRTB = 15;
    self.dragView.kMarginB = 20;
    self.dragView.kMaxCount = 6;
    self.dragView.kCountInRow = 4;
    [self.textView addSubview:self.dragView];
    self.dragView.frame = CGRectMake(0, 60 , [UIScreen mainScreen].bounds.size.width, [self.dragView getHeightThatFit]);
    self.dragView.dragViewDelegete = self;
    self.dragView.hidden = YES;
    self.height = [self.dragView getHeightThatFit];
}

- (void)_initNavBar {
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName :FirstColor, NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    //CNavBgColor
    [navBar setBackgroundImage:[UIImage imageWithColor:CNavBgColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage imageWithColor:SeparateColor size:CGSizeMake(ScreenWidth, 0.5)]];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"fatie_shut"] style:UIBarButtonItemStylePlain target:self action:@selector(_cancel)];
    self.navigationItem.leftBarButtonItem = button;
    self.title = [APPLanguageService sjhSearchContentWith:@"faduantie"];
    
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:[APPLanguageService sjhSearchContentWith:@"fabu"] style:UIBarButtonItemStylePlain target:self action:@selector(send)];
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
    _textView.allowsCopyAttributedString = NO;
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.textColor = FirstColor;
    _textView.backgroundColor = isNightMode? ViewContentBgColor :CWhiteColor;
    WBStatusComposeTextParser *textParser = [WBStatusComposeTextParser new];
    textParser.textColor =  FirstColor;
    textParser.highlightTextColor = MainBg_Color;
    _textView.textParser = textParser;
    _textView.delegate = self;
    _textView.inputAccessoryView = [UIView new];
    
    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
    modifier.font = FONTOFSIZE(16.0f);
    modifier.paddingTop = 12;
    modifier.paddingBottom = 12;
    modifier.lineHeightMultiple = 1.5;
    _textView.linePositionModifier = modifier;
    
    NSString *placeholderPlainText = nil;
    placeholderPlainText = [APPLanguageService sjhSearchContentWith:@"fatieplaceholder"];
    if (placeholderPlainText) {
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithString:placeholderPlainText];
        atr.color = ThirdColor;
        atr.font = [UIFont systemFontOfSize:16];
        _textView.placeholderAttributedText = atr;
    }
    [self.view addSubview:_textView];
}

- (void)_initToolbar {
    if (_toolbar) return;
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
    _countLabel = [UILabel labelWithFrame:CGRectZero title:@"0/500" font:FONTOFSIZE(12) textColor:ThirdColor];
    [_toolbar addSubview:_countLabel];
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_toolbar).offset(-15);
        make.top.equalTo(_toolbar).offset(10);
    }];
    _countLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    _toolbarPictureButton = [self _toolbarButtonWithImage:@"addImage"
                                                highlight:@"addImage"];
    
    _toolbarAtButton = [self _toolbarButtonWithImage:@"post_At"
                                           highlight:@"post_At"];
    CGFloat one = _toolbar.width / 5;
    _toolbarPictureButton.centerX = one * 0.5;
    _toolbarAtButton.centerX = one * 1.2;
    _toolbar.bottom = self.view.height;
    [self.view addSubview:_toolbar];
}

- (void)loadData{
    self.resultImagesKeys = @[].mutableCopy;
    [self judgeUserPermission:NO];
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

- (void)_cancel {
    [self.view endEditing:YES];
    if(self.textView.text.length >0 ||[self.dragView getAllImages].count >0){
        [BTCancelAlertView showWithTitle:@"" completion:^(NSString *str) {
            if(str.length == 0){
                [self.textView becomeFirstResponder];
            }else{
                if (_dismiss) _dismiss();
            }
        }];
       
    }else{
        if (_dismiss) _dismiss();
    }
}

- (void)_buttonClicked:(UIButton *)button {
    if (button == _toolbarPictureButton) {
        JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.showsCancelButton = YES;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.minimumNumberOfSelection = 1;
        imagePickerController.maximumNumberOfSelection = 6;
        imagePickerController.selectedAssetArray = [self.dragView getAssests].mutableCopy;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }else if (button == _toolbarAtButton) {
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
#pragma mark @protocol YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView {
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    if(!self.dragView.hidden){
        self.dragView.frame = CGRectMake(0, size.height +30 , [UIScreen mainScreen].bounds.size.width, [self.dragView getHeightThatFit]);
        
        CGFloat width = (self.view.frame.size.width - 4 *self.dragView.kMarginLRTB)/self.dragView.kCountInRow;
        if([self.dragView getAllImages].count >2){
            self.textView.contentSize = CGSizeMake(self.textView.contentSize.width, size.height + 2*width +45);
        }else if([self.dragView getAllImages].count >0){
            self.textView.contentSize = CGSizeMake(self.textView.contentSize.width, size.height + width +45);
        }
    }
    self.countLabel.text = [NSString stringWithFormat:@"%lu/500", (unsigned long)textView.text.length];
    if (textView.text.length >= 500) {
        textView.text = [textView.text substringToIndex:500];
        self.countLabel.text = @"500/500";
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //输入@时候弹出选人页面
    if([text isEqualToString:@"@"]){
        [self.view endEditing:YES];
        BTSelectPersonVC *selectVC = [[BTSelectPersonVC alloc] init];
        [self.navigationController pushViewController:selectVC animated:YES];
        NSInteger index = self.textView.selectedRange.location;
        selectVC.selectBlock = ^(NSString *name){
            NSString *insertString = [NSString stringWithFormat:@"%@",name];
            [self.textView replaceRange:self.textView.selectedTextRange withText:insertString];
            self.textView.selectedRange = NSMakeRange(index + insertString.length, 0);
            
        };
    }
    return YES;
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

#pragma mark @protocol WBStatusComposeEmoticonView
- (void)emoticonInputDidTapText:(NSString *)text {
    if (text.length) {
        [_textView replaceRange:_textView.selectedTextRange withText:text];
    }
}

- (void)emoticonInputDidTapBackspace {
    [_textView deleteBackward];
}

- (void)imageDragViewAddButtonClicked{
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 6;
    imagePickerController.selectedAssetArray = [self.dragView getAssests].mutableCopy;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)imageDragViewDeleteButtonClickedAtIndex:(NSInteger)index{
    if([self.dragView getAllImages].count ==0){
        self.dragView.hidden = YES;
        CGRect frame = self.textView.frame;
        CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
        CGSize size = [self.textView sizeThatFits:constraintSize];
        if(size.height >self.height - 100){
            self.textView.contentSize = CGSizeMake(self.textView.contentSize.width, size.height);
        }else{
            self.textView.contentSize = CGSizeMake(self.textView.contentSize.width, self.height);
        }
    }
}

- (void)imageDragViewButtonClickedAtIndex:(NSInteger)index{
    [self.textView endEditing:YES];
    JKPhotoBrowser  *photoBorwser = [[JKPhotoBrowser alloc] initWithFrame:[UIScreen mainScreen].bounds];
    photoBorwser.currentPage = index;
    photoBorwser.assetsArray = [NSMutableArray arrayWithArray:[self.dragView getAllImages]];
    [photoBorwser show:YES];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source{
    if([self.dragView getAllImages].count >0){
        [self.dragView deleteAllImageBtn];
    }
    for(JKAssets *asset in assets){
        [self.dragView addImage:asset.photo asset:asset];
    }
    
    
    self.dragView.hidden = NO;
    CGRect frame = self.textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [self.textView sizeThatFits:constraintSize];
    self.dragView.frame = CGRectMake(0, size.height +30 , [UIScreen mainScreen].bounds.size.width, [self.dragView getHeightThatFit]);
    self.dragView.height = [self.dragView getHeightThatFit];
    CGFloat width = (self.view.frame.size.width - 4 *self.dragView.kMarginLRTB)/self.dragView.kCountInRow;
    if([self.dragView getAllImages].count >2){
         self.textView.contentSize = CGSizeMake(self.textView.contentSize.width, size.height + 2*width +45);
    }else if([self.dragView getAllImages].count >0){
        self.textView.contentSize = CGSizeMake(self.textView.contentSize.width, size.height + width +45);
    }
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        [self.textView scrollToBottom];
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        [self.textView becomeFirstResponder];
    }];
}

//发帖子
- (void)send{
    [self judgeUserPermission:YES];
}
- (void)nextAction{
    [self.textView endEditing:YES];
    NSArray *images = [self.dragView getAllImages];
    if(images.count == 0){//无图片，直接发帖子
        [BTShowLoading show];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self postRequest];
        
    }else{//先上传图片
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self uploadImages:images];
    }
}
- (void)uploadImages:(NSArray*)images{
    [BTShowLoading show];
    for(UIImage *image in images){
        NSData *data = UIImageJPEGRepresentation(image, 0.5);
        changePhotoRequest *photoApi = [[changePhotoRequest alloc] initWithUsername:data uploadType:@"2"];
        [photoApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            if(request.data&&[request.data isKindOfClass:[NSString class]]){
                [self.resultImagesKeys addObject:request.data];
            }
            if(self.resultImagesKeys.count == images.count){//表示所有图片已经上传完
                //调用发帖接口
                [self postRequest];
            }
            
        } failure:^(__kindof BTBaseRequest *request) {
            [BTShowLoading hide];
            [MBProgressHUD showMessage:request.resultMsg wait:YES];
            self.resultImagesKeys = @[].mutableCopy;
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }];
    }
}

//发帖子
- (void)postRequest{
    NSString *imagesKey = @"";
    NSArray *images = self.resultImagesKeys;
    if(images.count >0){
        imagesKey = [images componentsJoinedByString:@","];
    }
    NSDictionary *params = @{
                             @"content": SAFESTRING(self.textView.text),
                             @"images": SAFESTRING(imagesKey),
                             @"shareId": @(0),
                             @"sourceId": @(0),
                             @"type": @(1),//短帖
                             @"userId": @([BTGetUserInfoDefalut sharedManager].userInfo.userId),
                             };
    BTAddPostRequest *addPostApi = [[BTAddPostRequest alloc] initWithDict:params];
    [addPostApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
        //通知帖子列表刷新
        if(request.data){
            [getUserCenter shareSuccseGetTanLiWithType:10 withTime:1];
            [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"fatiechenggong"] wait:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Refresh_Post_List object:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
//        [MBProgressHUD showMessage:request.resultMsg wait:YES];
        
        //发帖子失败后 保存数据
        [self generateModel];
        [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Refresh_Post_List object:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
        
       
        self.resultImagesKeys = @[].mutableCopy;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }];
}

- (void)generateModel{
    BTPostMainListModel *listModel = [[BTPostMainListModel alloc] init];
    listModel.uuid = [BTHelperMethod uuidString];
    listModel.avatar = getUserCenter.userInfo.userAvatar;
    listModel.nickName = getUserCenter.userInfo.username;
    listModel.userId = getUserCenter.userInfo.userId;
    listModel.issueDate = SAFESTRING(@([[NSDate date] timeIntervalSince1970] *1000));
    listModel.errorType = 1;
    listModel.type = 1;
    listModel.content = SAFESTRING(self.textView.text);
    listModel.images = self.resultImagesKeys;
    [[BTGetUserInfoDefalut sharedManager].posts addObject:listModel];
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
                            if (_dismiss) _dismiss();
                        }else{// find assist
                            H5Node *node = [[H5Node alloc] init];
                            node.title = [APPLanguageService wyhSearchContentWith:@"tianjiaweixinquan"];
                            node.webUrl = [NSString stringWithFormat:@"%@%@",[BTConfig sharedInstance].h5domain,BTXZS_H5];
                            H5ViewController *h5VC = [[H5ViewController alloc] init];
                            h5VC.node = node;
                            [self.navigationController pushViewController:h5VC animated:YES];
//                            [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
                        }
                    }];
                    
                }else if(model.postLimit){//
                    [_textView resignFirstResponder];
                    NSString *content = [NSString stringWithFormat:@"%@%@%@",[APPLanguageService sjhSearchContentWith:@"fatieshangxian"],@(model.postLimitNum),[APPLanguageService sjhSearchContentWith:@"ci"]];
                    [BTPotTipView showBTPotTipView:content completion:^(NSInteger status) {
                        if (_dismiss) _dismiss();
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
