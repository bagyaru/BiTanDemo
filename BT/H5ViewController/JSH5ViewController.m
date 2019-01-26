//
//  JSH5ViewController.m
//  BT
//
//  Created by admin on 2018/8/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "JSH5ViewController.h"
#import "WebViewJavascriptBridge.h"
#import "BTConfig.h"
#define YZHY_URL @"invitation2"
@interface JSH5ViewController ()<UIWebViewDelegate,BTLoadingViewDelegate> {
    
    HYShareActivityView *_shareView;
}
@property (nonatomic,strong)  WebViewJavascriptBridge* bridge;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic,strong)  NSURL *URL;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) UIImageView *photoImageVIew;
@property (nonatomic, strong) UIImage     *resultImage;
@end

@implementation JSH5ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatUI) name:NSNotification_loginSuccess object:nil];
    [self creatUI];
    // Do any additional setup after loading the view.
}
#pragma mark - 配置URL
- (void)requestUserBtcList{
    NSString *stringLanguage;
    if ([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]) {
        stringLanguage = @"cn";
    }else{
        stringLanguage = @"en";
    }
    NSString *userID = [NSString stringWithFormat:@"%ld",(long)getUserCenter.userInfo.userId];
    if (ISStringEqualToString(self.parameters[@"type"], @"邀请好友")) {
        
        NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?isApp=%@&userId=%@&lang=%@",[BTConfig sharedInstance].h5domain,YZHY_URL,@"ios",SAFESTRING(userID),stringLanguage]];
        self.URL = url;
        self.title = [APPLanguageService wyhSearchContentWith:@"yaoqinghaoyou"];
        NSLog(@"%@",url);
    }
}
-(void)creatUI{
    [self requestUserBtcList];
    if (!_webView) {
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    }
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.webView aboveSubView:nil delegate:self];
    //2、设置属性：
    _webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    // webView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打
    // 3、显示网页视图UIWebView：
    //4、加载内容
    NSURL* url = self.URL;//创建URL
    //NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    
    //加载请求的时候忽略缓存
    NSURLRequest* request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5.0];
    [_webView loadRequest:request];//加载
    
    [self.view addSubview:_webView];
    
    //初始化  WebViewJavascriptBridge
    if (_bridge) { return; }
    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
    //申明js调用oc方法的处理事件，这里写了后，h5那边只要请求了，oc内部就会响应
    [self JS2OC];
    //模拟操作：2秒后，oc会调用js的方法
    //[self OC2JS];
}
/**
 JS  调用  OC
 */
-(void)JS2OC{
    /*
     含义：JS调用OC
     @param registerHandler 要注册的事件名称(比如这里我们为loginAction)
     @param handel 回调block函数 当后台触发这个事件的时候会执行block里面的代码
     */
   
    //登录
    [_bridge registerHandler:@"login" handler:^(id data, WVJBResponseCallback responseCallback) {
        
        //NSString *ID = (NSString *)data;
        [getUserCenter loginoutPullView];
        responseCallback(@"报告，oc已收到js的请求");
    }];
    //分享
    [_bridge registerHandler:@"shareImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        
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

    CGFloat showH = ScreenHeight-kTopHeight-30-160;
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
#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    [self creatUI];
}
#pragma mark - lazy
- (UIImageView *)photoImageVIew{
    if (!_photoImageVIew) {
        _photoImageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _photoImageVIew.userInteractionEnabled = YES;
    }
    return _photoImageVIew;
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [self.loadingView showLoading];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self.loadingView hiddenLoading];
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView stringByEvaluatingJavaScriptFromString:injectionJSString];

    //self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    [self.loadingView showErrorWith:[error description]];
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
