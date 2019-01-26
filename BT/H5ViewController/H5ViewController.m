//
//  H5ViewController.m
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "H5ViewController.h"
#import <WebKit/WebKit.h>
#import "BTConfig.h"
#import "WKWebViewJavascriptBridge.h"
#define YZHY_URL @"http://statics.bitane.io/invitation2.html"
@interface H5ViewController ()<WKNavigationDelegate, WKUIDelegate>{
    
    HYShareActivityView *_shareView;
}

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) BTLoadingView *loadingView;

@property WKWebViewJavascriptBridge *webViewBridge;

@property (nonatomic, strong) UIImageView *photoImageVIew;
@property (nonatomic, strong) UIImage     *resultImage;
@end

@implementation H5ViewController
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSNotification_loginSuccess
                                                  object:nil];
}
- (void)backBtnClicked{
    if(self.parameters){
        [BTCMInstance popViewController:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (!ISNSStringValid([BTConfig sharedInstance].h5domain)) {
        [[BTConfigureService shareInstanceService] getGlobal_HTML_configuration];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
}
+ (id)createWithParams:(NSDictionary *)params{
    H5ViewController *vc = [[H5ViewController alloc] init];
    vc.node = [params objectForKey:@"node"];
    vc.hidesBottomBarWhenPushed = YES;
    NSString *stringLanguage;
    if ([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]) {
        stringLanguage = @"cn";
    }else{
        stringLanguage = @"en";
    }
    if(vc.node.isNoLanguage){
        stringLanguage = @"";
    }
    NSString *userID = [NSString stringWithFormat:@"%ld",(long)getUserCenter.userInfo.userId];
    if (![vc.node.webUrl hasPrefix:@"http"]) {//除官网地址外 都有拼接
        
        if (ISStringEqualToString(vc.node.webUrl, BTXZS_H5)) {
            
            vc.node.webUrl = [NSString stringWithFormat:@"%@%@?%@",[BTConfig sharedInstance].h5domain,vc.node.webUrl,SAFESTRING(userID)];
        }else {
            
            vc.node.webUrl = [NSString stringWithFormat:@"%@%@/%@?%@",[BTConfig sharedInstance].h5domain,vc.node.webUrl,stringLanguage,SAFESTRING(userID)];
        }
        
    }else {
        if(stringLanguage.length >0){
            vc.node.webUrl = [NSString stringWithFormat:@"%@?userId=%@&lang=%@",vc.node.webUrl,SAFESTRING(userID),stringLanguage];
        }else{
            vc.node.webUrl = [NSString stringWithFormat:@"%@?userId=%@",vc.node.webUrl,SAFESTRING(userID)];
        }
    }
    
    NSLog(@"%@",vc.node.webUrl);
    return vc;
    
}
- (void)configView{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(request) name:NSNotification_loginSuccess object:nil];
    
    if (self.node.title.length > 0) {
        self.title = self.node.title;
    }
    _webView = [[WKWebView alloc] init];
    [self.view addSubview:_webView];
    _webView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-kTopHeight);
    //_webView.navigationDelegate = self;
    _webView.UIDelegate = self;
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:nil delegate:nil];
    [self request];
    
    _webViewBridge = [WKWebViewJavascriptBridge bridgeForWebView:self.webView];
    [_webViewBridge setWebViewDelegate:self];
    
    [self registerNativeFunctions];
}

#pragma mark - BTLoadingViewDelegate
-  (void)refreshingData{
    [self request];
}

- (void)deleteWebCache {
        //// All kinds of data
        if (@available(iOS 9.0, *)) {
            NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
            //// Date from
            NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
            //// Execute
            [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
                // Done
            }];
        } else {
            // Fallback on earlier versions
            NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
            NSError *errors;
            [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        }
}

- (void)request {
    NSLog(@"%@",self.node.title);
    if (ISStringEqualToString(self.node.title, [APPLanguageService wyhSearchContentWith:@"yaoqinghaoyou"])) {
        
        NSString *stringLanguage;
        if ([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]) {
            stringLanguage = @"cn";
        }else{
            stringLanguage = @"en";
        }
        if(self.node.isNoLanguage){
            stringLanguage = @"";
        }
        NSString *userID = [NSString stringWithFormat:@"%ld",(long)getUserCenter.userInfo.userId];
        self.node.webUrl = [NSString stringWithFormat:@"%@?isApp=%@&userId=%@&lang=%@",YZHY_URL,@"ios",SAFESTRING(userID),stringLanguage];
    }
    if (self.node.webUrl.length > 0) {
        DLog(@"request url:%@", _node.webUrl);
        [self.loadingView showLoading];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.node.webUrl]];
        [self.webView loadRequest:request];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    DLog(@"");
    [self.loadingView hiddenLoading];
    // 1、只对本地html资源的图片有效果
    NSString *js = @"function imgAutoFit() { \
    var imgs = document.getElementsByTagName('img'); \
    for (var i = 0; i < imgs.length; ++i) {\
    var img = imgs[i];   \
    var maxWidth = %f;   \
    img.style.maxHeight = img.height * maxWidth / img.width; \
    img.style.maxWidth = maxWidth;   \
    } \
    }";
    
    js = [NSString stringWithFormat:js, [UIScreen mainScreen].bounds.size.width - 20];
    [webView evaluateJavaScript:js completionHandler:^(id _Nullable _id, NSError * _Nullable error) {
        DLog(@"error:%@", error);
    }];
    [webView evaluateJavaScript:@"imgAutoFit()" completionHandler:^(id _Nullable _id, NSError * _Nullable error) {
        DLog(@"error:%@", error);
    }];
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:^(id object, NSError * error) {
         DLog(@"error:%@", error);
    }];
    if(self.node.title.length ==0){
        self.title = webView.title;
    }
    if ([self.node.webUrl containsString:XieYi_H5] || [self.node.webUrl containsString:AboutUs_H5]) {
        
        //修改背景色
        [webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.background='#%@'",isNightMode ? @"222229" : @"ffffff"] completionHandler:nil];
        // 改变网页内容文字颜色
        
        [webView evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextFillColor= '#%@'",isNightMode ? @"BACDE6" : @"333333"] completionHandler:nil];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    if(error.code ==NSURLErrorCancelled){
        return;
    }
    [self.loadingView showErrorWith:[error description]];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    
}

#pragma mark- WKUIDelegate
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable result))completionHandler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:defaultText preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.text = defaultText;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *input = ((UITextField *)alertController.textFields.firstObject).text;
        completionHandler(input);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(nil);
    }]];
    [self presentViewController:alertController animated:YES completion:^{}];
}

#pragma mark - private method
- (void)registerNativeFunctions
{
    [self registLoginFunction];
    
    [self registShareFunction];
    
    [self registerLinkBtFunction];
}

// 联系BT 小助手
- (void)registerLinkBtFunction{
    
    [_webViewBridge registerHandler:@"contactBT" handler:^(id data, WVJBResponseCallback responseCallback) {
        [MobClick event:@"renzheng_contact_asst"];
        H5Node *node = [[H5Node alloc] init];
        node.title = [APPLanguageService wyhSearchContentWith:@"tianjiaweixinquan"];
        node.webUrl = [NSString stringWithFormat:@"%@%@",[BTConfig sharedInstance].h5domain,BTXZS_H5];
        [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
//        [BTCMInstance pushViewControllerWithName:@"BTContactUsViewController" andParams:nil];
        responseCallback(@"报告，oc已收到js的请求");
    }];
}

//登录
-(void)registLoginFunction {
    
    //登录
    [_webViewBridge registerHandler:@"login" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //NSString *ID = (NSString *)data;
        [getUserCenter loginoutPullView];
        responseCallback(@"报告，oc已收到js的请求");
    }];
}
//分享
-(void)registShareFunction {
    
    [_webViewBridge registerHandler:@"shareImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //NSString *ID = (NSString *)data;
        
        // 将base64字符串转为NSData
        NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:data options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
        self.resultImage   = [UIImage imageWithData:decodeData];
        
        [self alertShareView];
        responseCallback(@"报告，oc已收到js的请求");
    }];
}
-(void)alertShareView {
    self.photoImageVIew.image = self.resultImage;
    CGFloat H = CGImageGetHeight(self.resultImage.CGImage);
    CGFloat W = CGImageGetWidth(self.resultImage.CGImage);
    NSLog(@"宽====%.0f 高=====%.0f",W,H);
    
    CGFloat showH = ScreenHeight-kTopHeight-30-149;
    CGFloat showW = W/H*showH;
    
    self.photoImageVIew.frame = CGRectMake((ScreenWidth-showW)/2, kTopHeight+15, showW, showH);
    //分享
    if (!_shareView) {
        
        _shareView = [[HYShareActivityView alloc] initWithButtons:@[@(HYSharePlatformTypeWechatSession),@(HYSharePlatformTypeWechatTimeline),@(HYSharePlatformTypeSinaWeibo)] title:@"邀请好友" image:self.photoImageVIew shareTypeBlock:^(HYSharePlatformType type) {
            
            [self shareActiveType:type];
        }];
        
        _shareView.delegate = self;
    }
    NSLog(@"宽====%.0f 高=====%.0f",_shareView.frame.size.height,H);
    [_shareView show];
}
-(void)shareActiveType:(NSUInteger)type {
    
    if (self.resultImage)
    {
        
        //[getUserCenter shareBuriedPointWithType:type withWhereVc:10];
        HYShareInfo *info = [[HYShareInfo alloc] init];
        info.content = [APPLanguageService wyhSearchContentWith:@"fenxiangfubiaoti"];
        info.images = self.resultImage;
        info.type = (HYPlatformType)type;
        info.shareType    = HYShareDKContentTypeImage;
        [HYShareKit shareImageWeChat:info  completion:^(NSString *errorMsg)
         {
             if ( ISNSStringValid(errorMsg) )
             {
                 
                 [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
                 [_shareView hide];
             }
         }];
    }else
    {
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"fenxiangshibai"] wait:YES];
    }
}
#pragma mark - lazy
- (UIImageView *)photoImageVIew{
    if (!_photoImageVIew) {
        _photoImageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _photoImageVIew.userInteractionEnabled = YES;
    }
    return _photoImageVIew;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
