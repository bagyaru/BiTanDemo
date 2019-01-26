//
//  BTNewSheQuMainViewController.m
//  BT
//
//  Created by admin on 2018/8/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTNewSheQuMainViewController.h"
#import "BYListBar.h"
#import "QiHuoListContentVC.h"
#import "BTFutureListApi.h"

#import "FastInfomationViewController.h"
#import "NewsViewController.h"
#import "StrategyViewController.h"
#import "TopicListViewController.h"
#import "BTTitleView.h"
#import "BTSheQuHeadListRequest.h"

#import "BTPostMainListViewController.h"
#import "BTPostComposeViewController.h"
#import "BTFocusListViewController.h"
@interface BTNewSheQuMainViewController ()<UIScrollViewDelegate,BTLoadingViewDelegate>

@property (nonatomic, strong) BYListBar *listBar;
@property (nonatomic, strong) UIScrollView *scrollViewContainer;
@property (nonatomic, strong) NSMutableArray *listTop;
@property (nonatomic, strong) BTFutureListApi *api;

@property (nonatomic, strong) UIView *customTabbarView;
@property (nonatomic, strong) UIImageView *customTabbarView_ImageView;
@property (nonatomic, strong) UIImageView *firstAlertIV;
@property (nonatomic, assign) BOOL isPostMainVC;
@property (nonatomic, assign) BOOL isFirstEnter;
@property (nonatomic, strong) BTSheQuHeadListRequest *headListApi;
@property (nonatomic, strong) BTLoadingView *loadingView;
@end

@implementation BTNewSheQuMainViewController

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self load_TopData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [APPLanguageService wyhSearchContentWith:@"zixun"];
    [self createUI];
    [[AFNetworkReachabilityManager sharedManager]   setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                [self.loadingView showErrorWith:[APPLanguageService wyhSearchContentWith:@"nonetwork"]];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [self.loadingView showErrorWith:[APPLanguageService wyhSearchContentWith:@"nonetwork"]];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                [self loadData];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [self loadData];
                break;
        }
        
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    self.isFirstEnter = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide_CustomTabBarView) name:@"hide_CustomTabBarView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show_CustomTabBarView) name:@"show_CustomTabBarView" object:nil];
}
- (void)createUI{
    self.scrollViewContainer.delegate = self;
    [self.view addSubview:self.scrollViewContainer];
    [self configSubVCs];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:self.scrollViewContainer delegate:self];
    [self.loadingView showLoading];
}
-(void)refreshingData {
    
     [self loadData];
}
- (void)loadData{
    [self.loadingView showLoading];
    _listTop = @[].mutableCopy;
    [self requestFutureList];
}

- (UIScrollView *)scrollViewContainer{
    if (!_scrollViewContainer) {
        //CGFloat bottom = 0.0;
        _scrollViewContainer = [[UIScrollView alloc] init];
        _scrollViewContainer.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - kTopHeight - kTabBarHeight);
        _scrollViewContainer.pagingEnabled = YES;
        _scrollViewContainer.bounces = NO;
        _scrollViewContainer.showsHorizontalScrollIndicator = NO;
    }
    return _scrollViewContainer;
}

- (void)configSubVCs{
    self.view.backgroundColor = ViewBGColor;
}

- (void)configMoveBar:(NSInteger)type{
    self.listBar = [[BYListBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    //self.listBar.backgroundColor = kHEXCOLOR(0x999999);
    //[self.view addSubview:self.listBar];
    self.listBar.intrinsicContentSize = CGSizeMake(ScreenWidth, 44);
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    BTTitleView *ivTitle = [[BTTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    
    [ivTitle addSubview:self.listBar];
    self.navigationItem.titleView = ivTitle;
    
    self.listBar.isFuture = YES;
    self.listBar.isSheQu  = YES;
    self.listBar.visibleItemList = [NSMutableArray arrayWithArray:self.listTop];
    WS(ws);
    self.listBar.listBarItemClickBlock = ^(NSString *itemName , NSInteger itemIndex){
        [UserDefaults setInteger:itemIndex+1 forKey:@"BTNewSheQuMainViewController_ItemIndex"];
        [UserDefaults synchronize];
        [ws startTimeWithVcIndex:itemIndex];
        [BTConfigureService shareInstanceService].sheQuIndex = itemIndex;
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_SheQu_needRequest object:nil];
        [UIView animateWithDuration:0.25 animations:^{
            ws.scrollViewContainer.contentOffset = CGPointMake(ScreenWidth * itemIndex, 0);
        }];
    };
    NSInteger historyIndex = [UserDefaults integerForKey:@"BTNewSheQuMainViewController_ItemIndex"];
    NSLog(@"%ld",historyIndex);
    //[self.listBar itemClickByScrollerWithIndex:historyIndex == 0 ? 1 : historyIndex-1];
    [self.listBar itemClickByScrollerWithIndex:1];
}

- (void)requestFutureList{
    [self configSubVCs];
    NSArray *array = [UserDefaults objectForKey:[NSString stringWithFormat:@"array_%@",[APPLanguageService readLanguage]]];
    if (array != nil && array.count > 0 && self.scrollViewContainer.subviews.count <= 1) {
        [self.loadingView hiddenLoading];
        [self creatSubViewControllerWithArray:array];
    }else {
        
        [self load_TopData];
    }
}
-(void)creatSubViewControllerWithArray:(NSArray *)array {
    for (NSInteger i = 0 ; i < array.count;i++) {
        UIViewController *contentVC;
        NSDictionary *dict = array[i];
        [self.listTop addObject:SAFESTRING(dict[@"name"])];
        
        if ([dict[@"value"] integerValue] == 2) {//要闻
            NewsViewController *newVC = [[NewsViewController alloc] init];
            newVC.bigType = [dict[@"value"] integerValue];
            contentVC = newVC;
        }
        if ([dict[@"value"] integerValue] == 1) {//快讯
            contentVC = [[FastInfomationViewController alloc] init];
        }
        if ([dict[@"value"] integerValue] == 4) {//话题
            contentVC = [[TopicListViewController alloc] init];
        }
        if ([dict[@"value"] integerValue] == 3) {//新手攻略
            contentVC = [[StrategyViewController alloc] init];
        }
        if ([dict[@"value"] integerValue] == 6) {//币圈儿（探报）
            NewsViewController *newVC = [[NewsViewController alloc] init];
            newVC.bigType = [dict[@"value"] integerValue];
            contentVC = newVC;
        }
        if ([dict[@"value"] integerValue] == 8) {//贴子
            BTPostMainListViewController *newVC = [[BTPostMainListViewController alloc] init];
            contentVC = newVC;
        }
        if ([dict[@"value"] integerValue] == 9) {//关注
            BTFocusListViewController *newVC = [[BTFocusListViewController alloc] init];
            contentVC = newVC;
        }
        
        contentVC.view.frame =  CGRectMake(ScreenWidth *i, 0,ScreenWidth,self.scrollViewContainer.frame.size.height);
        [self addChildViewController:contentVC];
        [self.scrollViewContainer addSubview:contentVC.view];
    }
    
    self.scrollViewContainer.contentSize = CGSizeMake(ScreenWidth * self.listTop.count, self.scrollViewContainer.frame.size.height);
    [self configMoveBar:0];
}
-(void)load_TopData {
  
    _headListApi = [BTSheQuHeadListRequest new];
    [_headListApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        NSLog(@"%@",request.data);
        [self.loadingView hiddenLoading];
        if ([request.data isKindOfClass:[NSArray class]]) {
            NSArray *array = request.data;
            [UserDefaults setObject:array forKey:[NSString stringWithFormat:@"array_%@",[APPLanguageService readLanguage]]];
            [UserDefaults synchronize];
            if (self.isFirstEnter) {
               [self creatSubViewControllerWithArray:array];
            }
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index= round(scrollView.contentOffset.x / ScreenWidth);
    [self.listBar itemClickByScrollerWithIndex:index];
}
-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self hide_CustomTabBarView];
    self.isFirstEnter = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isNightMode) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }else {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
    });
    
    if (self.isPostMainVC) {//帖子页面改变TabBar
        if (!self.isFirstEnter) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide_CustomTabBarView) name:@"hide_CustomTabBarView" object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show_CustomTabBarView) name:@"show_CustomTabBarView" object:nil];
//            if (self.listTop <= 0) {
//                [self loadData];
//            }
        }
         [self show_CustomTabBarView];
    }
}
- (void)startTimeWithVcIndex:(NSInteger)index{
    UIViewController *vc = self.childViewControllers[index];
    
    if ([vc isKindOfClass:[BTPostMainListViewController class]]) {//帖子页面改变TabBar
        [MobClick event:@"post"];
        self.isPostMainVC = YES;
        //[self show_CustomTabBarView];
        if (getMainTabBar.selectedIndex == 2 && !ISStringEqualToString([UserDefaults objectForKey:BTClassName], @"BTPostDetailViewController")) {

            [self show_CustomTabBarView];
        }
    }else {
        self.isPostMainVC = NO;
        [self hide_CustomTabBarView];
    }
    if ([vc isKindOfClass:[BTFocusListViewController class]]) {
        [MobClick event:@"guanzhulist"];
    }
    if ([vc isKindOfClass:[NewsViewController class]]) {
        if (index > 0) {
           [MobClick event:@"tanbao"];
        }else {
           [AnalysisService alaysisNews_headlines];
        }
    }
    if ([vc isKindOfClass:[FastInfomationViewController class]]) {
        [AnalysisService alaysisNews_newsflash];
    }
    if ([vc isKindOfClass:[TopicListViewController class]]) {
        [AnalysisService alaysis_news_topic_list];
    }
    if ([vc isKindOfClass:[StrategyViewController class]]) {
        [AnalysisService alaysisNews_tactic];
    }
   
}
-(void)show_CustomTabBarView {
    
    self.title = [APPLanguageService sjhSearchContentWith:@"fatie"];
    [kAppWindow addSubview:self.customTabbarView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
        if (![UserDefaults boolForKey:@"isShow_firstAlertIV"]) {//只展示一次
            [kAppWindow addSubview:self.firstAlertIV];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                
                [UserDefaults setBool:YES forKey:@"isShow_firstAlertIV"];
                [UserDefaults synchronize];
                
                [self shakeToShow:_firstAlertIV isHidden:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                    
                    [_firstAlertIV removeFromSuperview];
                    _firstAlertIV     = nil;
                });
            });
        }
    });
}
-(void)hide_CustomTabBarView {
    if (_customTabbarView) {
        [self shakeToShow:_customTabbarView_ImageView isHidden:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
            
            self.title = [APPLanguageService wyhSearchContentWith:@"zixun"];
            [_customTabbarView removeFromSuperview];
            [_firstAlertIV removeFromSuperview];
            _customTabbarView = nil;
            _firstAlertIV     = nil;
        });
    }
}
#pragma mark lazy
-(UIView *)customTabbarView {
    
    if (!_customTabbarView) {
        CGFloat customTabbarViewW = ScreenWidth/5;
        CGFloat customTabbarViewH = kTabBarHeight+17;
        CGFloat customTabbarViewX = (ScreenWidth-customTabbarViewW)/2;
        CGFloat customTabbarViewY = ScreenHeight-customTabbarViewH;
        _customTabbarView = [[UIView alloc] initWithFrame:CGRectMake(customTabbarViewX, customTabbarViewY, customTabbarViewW, customTabbarViewH)];
        _customTabbarView_ImageView = [[UIImageView alloc] init];
        _customTabbarView_ImageView.frame = CGRectMake((customTabbarViewW-55)/2, 0, 55, 55);
        _customTabbarView_ImageView.image = IMAGE_NAMED(@"我的帖子-发帖");
        [_customTabbarView addSubview:_customTabbarView_ImageView];
        [self shakeToShow:_customTabbarView_ImageView isHidden:NO];
        
        UIButton *customTabbarView_Btn = [[UIButton alloc] init];
        customTabbarView_Btn.frame = CGRectMake(0, 0, customTabbarViewW, customTabbarViewH);
        [customTabbarView_Btn addTarget:self action:@selector(customTabbarView_BtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_customTabbarView addSubview:customTabbarView_Btn];
        
        _customTabbarView.backgroundColor = KClearColor;
    }
    return _customTabbarView;
}
-(void)customTabbarView_BtnClick {
    [MobClick event:@"post_fatie"];
    if ([getUserCenter isLogined]) {
        BTPostComposeViewController *vc = [BTPostComposeViewController new];
        vc.type = WBStatusComposeViewTypeComment;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        @weakify(nav);
        vc.dismiss = ^{
            @strongify(nav);
            [nav dismissViewControllerAnimated:YES completion:NULL];
        };
        [self presentViewController:nav animated:YES completion:NULL];
    }else {
        
        [getUserCenter loginoutPullView];
    }
}
-(UIImageView *)firstAlertIV {
    
    if (!_firstAlertIV) {
        _firstAlertIV = [[UIImageView alloc] init];
        _firstAlertIV.image = IMAGE_NAMED(@"我的帖子-首次进入");
        _firstAlertIV.frame = CGRectMake((ScreenWidth-240)/2, ScreenHeight-(kTabBarHeight+20)-60, 240, 54);
        [self shakeToShow:_firstAlertIV isHidden:NO];
    }
    return _firstAlertIV;
}
- (void)shakeToShow:(UIView*)aView isHidden:(BOOL)isHidden

{
    
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = 0.3;// 动画时间
    
    NSMutableArray *values = [NSMutableArray array];
    
    if (!isHidden) {//显示
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
        
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    }else {
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.0, 0.0, 1.0)]];
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
    }
   
    animation.values = values;
    
    [aView.layer addAnimation:animation forKey:nil];
    
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
