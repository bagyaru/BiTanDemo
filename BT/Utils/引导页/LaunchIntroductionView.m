//
//  LaunchIntroductionView.m
//  ZYGLaunchIntroductionDemo
//
//  Created by ZhangYunguang on 16/4/7.
//  Copyright © 2016年 ZhangYunguang. All rights reserved.
//

#import "LaunchIntroductionView.h"
#import "ADView.h"
#import "BTValidateSplashVersionRequest.h"
#import "BTSplashShowRequest.h"
#import "BTSplashScreenModel.h"
#import "BTSearchService.h"
#import "FFSnowflakesFallingView.h"
#import "BTLoginAndRrgisterView.h"
static NSString *const kAppVersion = @"appVersion";

@interface LaunchIntroductionView ()<UIScrollViewDelegate>
{
    UIScrollView  *launchScrollView;
    UIPageControl *page;
}

@end

@implementation LaunchIntroductionView
NSArray *images;
BOOL isScrollOut;//在最后一页再次滑动是否隐藏引导页
CGRect enterBtnFrame;
NSString *enterBtnImage;
static LaunchIntroductionView *launch = nil;
NSString *storyboard;

#pragma mark - 创建对象-->>不带button
+(instancetype)sharedWithImages:(NSArray *)imageNames{
    images = imageNames;
    isScrollOut = YES;
    launch = [[LaunchIntroductionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}

#pragma mark - 创建对象-->>带button
+(instancetype)sharedWithImages:(NSArray *)imageNames buttonImage:(NSString *)buttonImageName buttonFrame:(CGRect)frame{
    images = imageNames;
    isScrollOut = YES;
    enterBtnFrame = frame;
    enterBtnImage = buttonImageName;
    launch = [[LaunchIntroductionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}
#pragma mark - 用storyboard创建的项目时调用，不带button
+ (instancetype)sharedWithStoryboardName:(NSString *)storyboardName images:(NSArray *)imageNames {
    images = imageNames;
    storyboard = storyboardName;
    isScrollOut = YES;
    launch = [[LaunchIntroductionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}
#pragma mark - 用storyboard创建的项目时调用，带button
+ (instancetype)sharedWithStoryboard:(NSString *)storyboardName images:(NSArray *)imageNames buttonImage:(NSString *)buttonImageName buttonFrame:(CGRect)frame{
    images = imageNames;
    isScrollOut = NO;
    enterBtnFrame = frame;
    storyboard = storyboardName;
    enterBtnImage = buttonImageName;
    launch = [[LaunchIntroductionView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launch.backgroundColor = [UIColor whiteColor];
    return launch;
}
#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"currentColor" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"nomalColor" options:NSKeyValueObservingOptionNew context:nil];
        if ([self isFirstLauch]) {
            UIStoryboard *story;
            if (storyboard) {
                story = [UIStoryboard storyboardWithName:storyboard bundle:nil];
            }
            UIWindow *window = [UIApplication sharedApplication].windows.lastObject;
            if (story) {
                UIViewController * vc = story.instantiateInitialViewController;
                window.rootViewController = vc;
                [vc.view addSubview:self];
            }else {
                [window addSubview:self];
            }
            [self addImages];
        }else{
            
            [self removeFromSuperview];
            [self splashScreenAvailableUI];
        }
    }
    return self;
}
#pragma marl - 调用闪屏接口
-(void)splashScreenAPI {
    
    BTSplashScreenModel *localModel = [[BTSearchService sharedService] readBTSplashScreenModel];
    if (localModel) {
        BTValidateSplashVersionRequest *API = [[BTValidateSplashVersionRequest alloc] initWithSplashVersion:localModel.splashVersion splashId:localModel.splashId];
        [API requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            if (request.code == 0) {//本地闪屏信息可用

                [self splashScreenAvailableUI];
            }else {//本地闪屏信息不可用（过期）

                [self splashScreenOverdueUIWithType:1];
            }
        } failure:^(__kindof BTBaseRequest *request) {

        }];
    }else {//本地闪屏信息（没有）
        
        [self splashScreenOverdueUIWithType:2];
    }
    
}
#pragma marl - 调用闪屏UI 本地闪屏信息(没有或者过期) 更新闪屏信息
-(void)splashScreenOverdueUIWithType:(NSInteger)type {//本地闪屏信息(没有或者过期) 更新闪屏信息
    
    BTSplashShowRequest *api = [BTSplashShowRequest new];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        NSLog(@"%@",request.data);
        if ([request.data isKindOfClass:[NSDictionary class]]) {
            BTSplashScreenModel *model = [BTSplashScreenModel objectWithDictionary:request.data];
            
            if (iPhone6) {
                model.localPic = model.pic1;
            }else if (iPhone6P) {
                model.localPic = model.pic2;
            }else if (iPhoneX) {
                model.localPic = model.pic3;
            }else {
                model.localPic = model.pic1;
            }
            if (type == 1) {//过期 过来的
                BTSplashScreenModel *localModel = [[BTSearchService sharedService] readBTSplashScreenModel];
                [[BTSearchService sharedService] writeBTSplashScreenModel:model];
                if (localModel.splashId != model.splashId) {//有可能在过期之后没有更新信息 过期信息没删除或者重新发布 防止一直显示过期信息
                   [self splashScreenAvailableUIWithModel:localModel];
                }
            } else {//第一次
                [[BTSearchService sharedService] writeBTSplashScreenModel:model];
                [self splashScreenAvailableUI];
            }
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
        
    }];
}
#pragma marl - 调用闪屏UI 本地有闪屏信息且（可用）
-(void)splashScreenAvailableUI {
    BTSplashScreenModel *localModel = [[BTSearchService sharedService] readBTSplashScreenModel];
    //1、创建广告
    ADView *adView = [[ADView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds imgUrl:localModel.localPic splashId:localModel.splashId adUrl:localModel.redirectInfo clickImg:^(NSString *clikImgUrl) {
        
        NSLog(@"进入广告:%@",clikImgUrl);
        if (localModel.redirectType == 1) {//跳活动页面（H5）
            H5Node *node = [[H5Node alloc] init];
            //node.title = [APPLanguageService wyhSearchContentWith:@"aboutUs"];
            node.webUrl = clikImgUrl;
            
            [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
        }
        if (localModel.redirectType == 2) {//跳指定页面（原生）
            
            NSArray *a = [clikImgUrl componentsSeparatedByString:@":"];
            if (ISStringEqualToString(a[0], @"MY_PROPERTY")) {//我的资产
                
                if (![getUserCenter isLogined]) {
                    [AnalysisService alaysisMine_login];
                    [getUserCenter loginoutPullView];
                    return;
                }
                [AnalysisService alaysisMine_income_card];
                [BTCMInstance pushViewControllerWithName:@"LncomeStatisticsMain" andParams:nil];
            }
            if (ISStringEqualToString(a[0], @"MY_TP")) {//我的探力
                
                if (![getUserCenter isLogined]) {
                    [AnalysisService alaysisMine_login];
                    [getUserCenter loginoutPullView];
                    return;
                }
                [AnalysisService alaysismine_page_tanli];
                [BTCMInstance pushViewControllerWithName:@"BTNewMyTanLiMain" andParams:@{@"isTarget":@(1)}];
            }
            if (ISStringEqualToString(a[0], @"INFORMATION")) {//资讯
                
                [AnalysisService alaysisNews_headlines_list];
                
                [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":a[1]}];
            }
        }
    }];
    
    //设置倒计时（默认3秒）
    if (localModel.showDuration == 1) adView.showTime = 3;
    if (localModel.showDuration == 2) adView.showTime = 4;
    if (localModel.showDuration == 4) adView.showTime = 5;
    //2、显示广告
    [adView showWithShowInterval:localModel.showInterval];
}
#pragma marl - 调用闪屏UI 本地有闪屏信息且（不可用）先调之前存的信息
-(void)splashScreenAvailableUIWithModel:(BTSplashScreenModel *)model {
    
    BTSplashScreenModel *localModel = [[BTSearchService sharedService] readBTSplashScreenModel];
    //1、创建广告
    ADView *adView = [[ADView alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds imgUrl:localModel.localPic splashId:localModel.splashId adUrl:localModel.redirectInfo clickImg:^(NSString *clikImgUrl) {
        
        NSLog(@"进入广告:%@",clikImgUrl);
        
        if (model.redirectType == 1) {//跳活动页面（H5）
            
        }
        if (model.redirectType == 2) {//跳指定页面（原生）
            
        }
    }];
    
    //设置倒计时（默认3秒）
    if (model.showDuration == 1) adView.showTime = 3;
    if (model.showDuration == 2) adView.showTime = 4;
    if (model.showDuration == 3) adView.showTime = 5;
    
    //2、显示广告
    [adView showWithShowInterval:model.showInterval];
}
#pragma mark - 判断是不是首次登录或者版本更新
-(BOOL )isFirstLauch{
    //获取当前版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentAppVersion = infoDic[@"CFBundleShortVersionString"];
    //获取上次启动应用保存的appVersion
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:kAppVersion];
    //版本升级或首次登录  || ![version isEqualToString:currentAppVersion]
    if (version == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:currentAppVersion forKey:kAppVersion];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isOrNoGoodGuideTishi];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - 添加引导页图片
-(void)addImages{
    [self createScrollView];
}
#pragma mark - 创建滚动视图
-(void)createScrollView{
    launchScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
    launchScrollView.showsHorizontalScrollIndicator = NO;
    launchScrollView.bounces = NO;
    launchScrollView.pagingEnabled = YES;
    launchScrollView.delegate = self;
    launchScrollView.contentSize = CGSizeMake(kScreen_width * images.count, kScreen_height);
    [self addSubview:launchScrollView];
    for (int i = 0; i < images.count; i ++) {
        
         UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreen_width, 0, kScreen_width, kScreen_height)];
        if (i == 0) {
            //创建雪花飘落效果的view
            FFSnowflakesFallingView *snowflakesFallingView = [FFSnowflakesFallingView snowflakesFallingViewWithBackgroundImageName:iPhoneX ? [NSString stringWithFormat:@"%@_x",images[i]] : images[i] snowImageName:@"snow" frame:CGRectMake(i * kScreen_width, 0, kScreen_width, kScreen_height) clickImg:^(NSString *clikImgUrl) {
                
                if (clikImgUrl.integerValue == 1) {//跳过
                  
                    [self hideGuidView];
                }else if (clikImgUrl.integerValue == 3) {//登录
                    
                    [self hideGuidView];
                    [MobClick event:@"login"];
                    [getUserCenter loginoutPullView];
                }else {//点击注册或者背景 跳注册页
                    
                    [self hideGuidView];
                    [MobClick event:@"registered"];
                    [BTCMInstance pushViewControllerWithName:@"Register" andParams:nil];
                }
            }];
            [snowflakesFallingView beginSnow];
            [launchScrollView addSubview:snowflakesFallingView];
        }else {
            
            if (iPhoneX) {
                
                imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_x",images[i]]];
            }else {
                
                imageView.image = [UIImage imageNamed:images[i]];
            }
            
            imageView.userInteractionEnabled = YES;
            if (i == 1) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToHQ)];
                [imageView addGestureRecognizer:tap];
            }
            if (i == 2) {
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToSQ)];
                [imageView addGestureRecognizer:tap];
            }
            [launchScrollView addSubview:imageView];
        }
        
        if (i != 0) {
            //跳过按钮
            CGFloat btnW = 60;
            CGFloat btnH = 28;
            UIButton *TG_Button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - btnW - 15, kStatusBarHeight+10, btnW, btnH)];
            [TG_Button addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [TG_Button setTitle:[APPLanguageService wyhSearchContentWith:@"tiaoguo"] forState:UIControlStateNormal];
            TG_Button.titleLabel.font = [UIFont systemFontOfSize:12];
            [TG_Button setTitleColor:kHEXCOLOR(0x111210) forState:UIControlStateNormal];
            ViewBorderRadius(TG_Button, 2, 0.5, kHEXCOLOR(0x111210));
            
            BTLoginAndRrgisterView *loginV = [BTLoginAndRrgisterView loadFromXib];
            loginV.frame = CGRectMake(0, ScreenHeight-40-(kTabBarHeight-10), ScreenWidth, 40);
            ViewBorderRadius(loginV.dengLuBtn, 4, 1, kHEXCOLOR(0x111210));
            ViewBorderRadius(loginV.zhuCeBtn, 4, 1, kHEXCOLOR(0x111210));
            [loginV.zhuCeBtn addTarget:self action:@selector(TGButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [loginV.dengLuBtn addTarget:self action:@selector(TGButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [imageView addSubview:TG_Button];
            [imageView addSubview:loginV];
            imageView.userInteractionEnabled = YES;
        }
        if (i == images.count - 1) {
            //判断要不要添加button
            if (!isScrollOut) {
                UIButton *enterButton = [[UIButton alloc] initWithFrame:CGRectMake(enterBtnFrame.origin.x, enterBtnFrame.origin.y, enterBtnFrame.size.width, enterBtnFrame.size.height)];
                [enterButton setImage:[UIImage imageNamed:enterBtnImage] forState:UIControlStateNormal];
                [enterButton addTarget:self action:@selector(enterBtnClick) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:enterButton];
                imageView.userInteractionEnabled = YES;
            }
        }
    }
    page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, kScreen_height - 50, kScreen_width, 30)];
    page.numberOfPages = images.count;
    page.backgroundColor = [UIColor clearColor];
    page.currentPage = 0;
    page.defersCurrentPageDisplay = YES;
    //[self addSubview:page];
}
#pragma mark - 进入行情
-(void)pushToHQ {
    [self hideGuidView];
    [getMainTabBar guideToQuotes];
}
#pragma mark - 进入社区
-(void)pushToSQ {
   
    [self hideGuidView];
    [getMainTabBar guideToInfomation];
}
#pragma mark - 注册登录
-(void)TGButtonClick:(UIButton *)btn {
    
    if (btn.tag == 2) {//注册
        
        [self hideGuidView];
        [MobClick event:@"registered"];
        [BTCMInstance pushViewControllerWithName:@"Register" andParams:nil];
        
    }else {
        
        [self hideGuidView];
        [MobClick event:@"login"];
        [getUserCenter loginoutPullView];
    }
}
#pragma mark - 进入按钮
-(void)enterBtnClick{
    [self hideGuidView];
}
#pragma mark - 隐藏引导页
-(void)hideGuidView{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self splashScreenAvailableUI];
            [[NSUserDefaults standardUserDefaults] setObject:@"nofirst" forKey:@"startLocation"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self removeFromSuperview];
            //引导页消失之后 发送一个通知 开始定位
            [[NSNotificationCenter defaultCenter] postNotificationName:@"startLocation" object:nil];
        });
        
    }];
}
#pragma mark - scrollView Delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    int cuttentIndex = (int)(scrollView.contentOffset.x + kScreen_width/2)/kScreen_width;
    if (cuttentIndex == images.count - 1) {
        if ([self isScrolltoLeft:scrollView]) {
            if (!isScrollOut) {
                return ;
            }
            [self hideGuidView];
        }
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == launchScrollView) {
        int cuttentIndex = (int)(scrollView.contentOffset.x + kScreen_width/2)/kScreen_width;
        page.currentPage = cuttentIndex;
    }
}
#pragma mark - 判断滚动方向
-(BOOL )isScrolltoLeft:(UIScrollView *) scrollView{
    //返回YES为向左反动，NO为右滚动
    if ([scrollView.panGestureRecognizer translationInView:scrollView.superview].x < 0) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - KVO监测值的变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"currentColor"]) {
        page.currentPageIndicatorTintColor = self.currentColor;
    }
    if ([keyPath isEqualToString:@"nomalColor"]) {
        page.pageIndicatorTintColor = self.nomalColor;
    }
}

@end
