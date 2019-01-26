//
//  MainViewController.m
//  BT
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QuotesViewController.h"
#import "QuotesCell.h"
#import "BYListBar.h"
#import "MyOptionViewController.h"
#import "BTTitleView.h"
#import "MarketViewController.h"
#import "CurrencyViewController.h"
#import "HistorySearchViewController.h"
#import "BTSearchService.h"
#import "CurrencyListRequest.h"
#import "BTConfigureService.h"
#import "CheckMessageUnreadRequest.h"
#import "MessageModel.h"


////
#import "OptionExchangeView.h"
#import "GroupSideView.h"
#import "HintAlert.h"
#import "ComfirmAlertView.h"

#import "ConfirmSelectAlert.h"
#import "NewCreateGroupAlert.h"
#import "AddToGroupAlert.h"

#import "ExchangeListRequest.h"
#import "BTExchangeListModel.h"
#import "BTGroupListRequest.h"

#import "BTIsSignInRequest.h"
#import "TPAlertView.h"

#import "BTShareHeaderView.h"
#import "UIView+saveImageWithScale.h"

#import "QuotosNavView.h"
#import "ExchangeSelectCell.h"
#import "BTExchangeHeaderView.h"

#import "TabContentView.h"
#import "BTExchangeViewController.h"
#import "BTExchangeCategoryReq.h"
#import "HistorySearchViewController.h"
#import "BTExchangeListModel.h"

static NSString *cellIdentifier = @"ExchangeSelectCell";

@interface QuotesViewController ()<UISearchBarDelegate,UIScrollViewDelegate>{
    HYShareActivityView *_shareView;
}


@property (nonatomic,strong)  QuotosNavView *navView;

@property (nonatomic, strong) BYListBar *listBar;

@property (nonatomic, strong) BYListBar *exchangeListBar;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIScrollView *scrollViewContainer;

@property (nonatomic, strong) MyOptionViewController *optionVC;

@property (nonatomic, strong) MarketViewController *marketVc;

@property (nonatomic, strong) BTTitleView *ivTitle;

@property (nonatomic, strong) HistorySearchViewController  *historySearchVc;

@property (nonatomic, strong) NSMutableArray *listTop;

@property (nonatomic, strong) NSMutableArray *arrList;

@property (nonatomic, strong) CurrencyListRequest *listRequest;

@property (nonatomic, strong) BTButton *leftBtn;
@property (nonatomic, strong) UIImageView *leftIv;
@property (nonatomic, strong) BTExchangeListModel *exchangeModel;

@property (nonatomic, strong) BTGroupListModel *listModel;


@property (nonatomic, strong) ExchangeListRequest *exchangeListApi;
@property (nonatomic, strong) BTGroupListRequest *groupListApi;

@property (nonatomic, strong) BTLoadingView *loadingView;

@property (nonatomic, strong) UIImageView *photoImageVIew;

@property (nonatomic, strong) UIView *shareHeaderView;

@property (nonatomic,strong) UITableView *mTableView;

@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic, strong) TabContentView *tabContentView;
@property (nonatomic, strong) NSMutableArray *exchangeListTop;
@property (nonatomic, strong) NSMutableArray *exchangeContentViews;

@end

@implementation QuotesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
//    [self configNavBar];
    [self requestCurrencyList];
    [self addNavigationItemWithImageNames:@[@"main_search"] isLeft:NO target:self action:@selector(btnClick:) tags:@[@"1000"]];
//    [[AFNetworkReachabilityManager sharedManager]   setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusUnknown:
//                break;
//            case AFNetworkReachabilityStatusNotReachable:
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//                [self refreshRequest];
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//                [self refreshRequest];
//                break;
//        }
//
//    }];
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    
    BTExchangeListModel *model = [[BTExchangeListModel alloc] init];
    model.exchangeName = [AppHelper getExchangeName];
    model.exchangeCode =[AppHelper getExchangeCode];
    self.exchangeModel = model;
    
    BTGroupListModel *modelAll = [[BTGroupListModel alloc] init];
    modelAll.groupName = [APPLanguageService sjhSearchContentWith:@"quanbu"]; //@"全部";
    modelAll.userGroupId = ALL_GROUP_ID;
    modelAll.isSelected =YES;
    self.listModel = modelAll;
    
    if(appDelegate.listModel){
        self.listModel =  appDelegate.listModel;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshListBar) name:NSNotification_Refresh_List_Bar object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMainGroup:) name:k_Notification_Refresh_Main_Group object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:NSNotification_RedRiseGreenFall object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchListBar) name: NSNotification_Switch_List_Bar object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeListBarStatus) name: k_Notification_Change_List_Style object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSelectGroup:) name:k_Notification_Refresh_Select_Group object:nil];
    
    BTExchangeListModel *paramsModel = self.parameters[@"model"];
    if(paramsModel){
        self.title = paramsModel.exchangeName;
    }else{
        [MobClick event:@"market_info"];//默认打点
        [self addNavigationItemWithImageNames:@[@"ic_zixuancelan"] isLeft:YES target:self action:@selector(btnClick:) tags:@[@"1001"]];
        self.navigationItem.titleView = self.navView;
        [self.view addSubview:self.tabContentView];
//        [self.tabContentView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(44, 0, iPhoneX?83:49, 0));
//        }];
        self.tabContentView.frame = CGRectMake(0, 44, ScreenWidth, ScreenHeight - 44 -kTabBarHeight - kTopHeight);
        self.tabContentView.hidden = YES;
        self.exchangeListBar = [[BYListBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44.0f)];
        [self.view addSubview:self.exchangeListBar];
        self.exchangeListBar.hidden = YES;
        self.exchangeListBar.isFuture = YES;
        
        [self requestExchange];
    }
    self.dataArray = @[].mutableCopy;
}

//
- (void)requestExchange{
    _exchangeListTop = @[].mutableCopy;
    _exchangeContentViews = @[].mutableCopy;
    
    [self.exchangeListTop addObject:[APPLanguageService sjhSearchContentWith:@"quanbu"]];
    BTExchangeViewController *currencyVc = [[BTExchangeViewController alloc] init];
    currencyVc.type = -1;
    [self.exchangeContentViews addObject:currencyVc];
    
    BTExchangeCategoryReq *listRequest = [[BTExchangeCategoryReq alloc] init];
    [listRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data &&[request.data isKindOfClass:[NSArray class]]){
            for (NSInteger i = 0 ; i < [request.data count];i++) {
                NSDictionary *dic = request.data[i];
                if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
                    NSString *nameCn = SAFESTRING(dic[@"nameCn"]);
                    [self.exchangeListTop addObject:nameCn];
                }else{
                    NSString *nameEn = SAFESTRING(dic[@"nameEn"]);
                    [self.exchangeListTop addObject:nameEn];
                }
                NSString *type = SAFESTRING(dic[@"type"]);
                BTExchangeViewController *currencyVc = [[BTExchangeViewController alloc] init];
                currencyVc.type = [type integerValue];
                [_exchangeContentViews addObject:currencyVc];
            }
            if(self.exchangeListTop.count >0){
                [self configExchangeBar];
            }
        }
        
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if(self.exchangeListTop.count >0){
            [self configExchangeBar];
        }
    }];
}

- (void)configExchangeBar{
    [MobClick event:@"exchange_all"];
    self.exchangeListBar.visibleItemList = self.exchangeListTop;
    WS(ws)
    NSDictionary *infoPoints = @{@"0":@"exchange_all",@"1":@"exchange_mining",@"2":@"exchange_otc",@"3":@"exchange_currency",@"4":@"exchange_decentralization",@"5":@"exchange_futures"};
    self.exchangeListBar.listBarItemClickBlock = ^(NSString *itemName, NSInteger itemIndex) {
        [ws.tabContentView updateTab:itemIndex];
        [MobClick event:SAFESTRING(infoPoints[SAFESTRING(@(itemIndex))])];
    };
    
    [self.tabContentView configParam:self.exchangeContentViews Index:0 block:^(NSInteger index) {
        [ws.exchangeListBar itemClickByScrollerWithIndex:index];
    }];
}

- (void)getScreenShot:(NSNotification*)notify{
    UIViewController *vc =  [BTCMInstance topViewController];
    if([vc isKindOfClass:[self class]]){
        //截屏分享
        if(_shareView.superview){//注意防止重复
            return;
        }
        [self shareScreenShot];
    }
    
}

- (UIView*)shareHeaderView{
    if(!_shareHeaderView){
        _shareHeaderView = [BTShareHeaderView loadFromXib];
        self.shareHeaderView.frame = CGRectMake(0, 0, ScreenWidth, 87.0f);
        [self.shareHeaderView layoutIfNeeded];
    }
    return _shareHeaderView;
}

- (NSData *)imageDataScreenShot{
    CGSize imageSize = CGSizeZero;
    imageSize = [UIScreen mainScreen].bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows]){
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}

- (UIImage*)concatImage:(UIImage*)image1 iamge2:(UIImage*)image2{
    CGSize size = CGSizeMake(image2.size.width, image1.size.height+image2.size.height);
    UIGraphicsBeginImageContextWithOptions(size,NO,[UIScreen mainScreen].scale);
    [image1 drawInRect:CGRectMake(0, 0, image1.size.width, image1.size.height)];
    [image2 drawInRect:CGRectMake(0, image1.size.height, image2.size.width, image2.size.height)];
    UIImage *togetherImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return togetherImage;
}

- (UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width,h=rect.size.height;
    CGRect dianRect = CGRectMake(x, y, w, h);
    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}

//
- (void)shareScreenShot{
    CGFloat scale =  [UIScreen mainScreen].scale;
    CGFloat top = iPhoneX?84:64;
    CGFloat bottom;
    if(self.parameters[@"model"]){
        bottom = 49;
    }else{
        bottom = kTabBarHeight;
    }
    UIImage *bottomImage = [UIImage imageWithData:[self imageDataScreenShot]];
    bottomImage = [self ct_imageFromImage:bottomImage inRect:CGRectMake(0, top+66, bottomImage.size.width, bottomImage.size.height - (top+66)*scale - bottom*scale)];
    
    
    UIImage *headImage = [self.shareHeaderView saveImageWithScale:[UIScreen mainScreen].scale];
    UIImage *image = [self concatImage:headImage iamge2:bottomImage];
    
    self.photoImageVIew.image = image;
    self.photoImageVIew.frame = CGRectMake(self.photoImageVIew.frame.origin.x, self.photoImageVIew.frame.origin.y, self.photoImageVIew.frame.size.width, ScreenHeight - NaviBarHeight - 66 - bottom + 87.0f);
    
    //分享
    _shareView =  [[HYShareActivityView alloc] initWithButtons:@[@(HYSharePlatformTypeWechatSession),@(HYSharePlatformTypeWechatTimeline),@(HYSharePlatformTypeSinaWeibo)] image:self.photoImageVIew shareTypeBlock:^(HYSharePlatformType type) {
        
        [self shareActiveType:type image:image];
    }];
    
    _shareView.delegate = self;
    [_shareView show];
}

-(void)shareActiveType:(NSUInteger)type image:(UIImage*)image {
    
    if (type == 2) {//微博
        if ([WeiboSDK isWeiboAppInstalled] )
        {
          
        }
    }else {//微信
        
        if ([WXApi isWXAppInstalled] )
        {
          
        }
    }
    [getUserCenter shareBuriedPointWithType:type withWhereVc:20];
    HYShareInfo *info = [[HYShareInfo alloc] init];
    info.content = [APPLanguageService wyhSearchContentWith:@"fenxiangfubiaoti"];
    info.images = image;
    info.type = (HYPlatformType)type;
    info.shareType    = HYShareDKContentTypeImage;
    [HYShareKit shareImageWeChat:info  completion:^(NSString *errorMsg)
     {
         if ( ISNSStringValid(errorMsg) )
         {
             
             [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
             [self.photoImageVIew removeFromSuperview];
             self.photoImageVIew = nil;
             [_shareView hide];
           
         }
     }];
    
}
#pragma mark - lazy
- (UIImageView *)photoImageVIew{
    if (!_photoImageVIew) {
        _photoImageVIew = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
        _photoImageVIew.userInteractionEnabled = YES;
    }
    return _photoImageVIew;

}

- (void)refreshRequest{
    if (self.listTop && [self.listTop count] == 2) {
        if (self.listRequest) {
            [self.listRequest stop];
            [self.listRequest start];
            [self requestCurrencyList];
        }else{
            [self requestCurrencyList];
        }
    }
}

- (void)configView{
    self.scrollViewContainer.delegate = self;
    [self.view addSubview:self.scrollViewContainer];
    
    //////优化页面显示
    if(!self.parameters[@"model"]){
        [self.listTop addObject:@"zixuan"];
        [self.listTop addObject:@"shizhi"];
    }
    [self configSubVCs];
//    [self configMoveBar:0];
}

- (void)configSubVCs{
    self.view.backgroundColor = CViewBgColor;
    self.optionVC = [[MyOptionViewController alloc] init];
    WS(ws);
    self.optionVC.optionBlock = ^{
        [ws.searchBar becomeFirstResponder];
    };
    //
    if(!self.parameters[@"model"]){
        self.optionVC.view.frame = CGRectMake(0, 0, ScreenWidth, self.scrollViewContainer.frame.size.height);
        [self addChildViewController:self.optionVC];
        [self.scrollViewContainer addSubview:self.optionVC.view];
        self.marketVc = [[MarketViewController alloc] init];
        self.marketVc.view.frame =  CGRectMake(ScreenWidth, 0, ScreenWidth, self.scrollViewContainer.frame.size.height);
        [self addChildViewController:self.marketVc];
        [self.scrollViewContainer addSubview:self.marketVc.view];
        self.scrollViewContainer.contentSize = CGSizeMake(ScreenWidth * 2, self.scrollViewContainer.frame.size.height);
    }else{
        self.scrollViewContainer.contentSize = CGSizeMake(ScreenWidth * 0, self.scrollViewContainer.frame.size.height);
    }
}

- (void)configMoveBar:(NSInteger)type{
    self.listBar = [[BYListBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 36)];
    self.listBar.backgroundColor = kHEXCOLOR(0xF5F5F5);
    NSString *exchangeCode;
    BTExchangeModel *model = self.parameters[@"model"];
    if(model){
        exchangeCode = model.exchangeCode;
    }else{
        exchangeCode = k_Net_Code;
    }
    self.listBar.exchangeCode = exchangeCode;
    
    [self.view addSubview:self.listBar];
    self.listBar.visibleItemList = [NSMutableArray arrayWithArray:self.listTop];
    WS(ws);
    self.listBar.listBarItemClickBlock = ^(NSString *itemName , NSInteger itemIndex){
        [ws startTimeWithVcIndex:itemIndex];
        [BTConfigureService shareInstanceService].index = itemIndex;
        [ws addNoti];
        [UIView animateWithDuration:0.25 animations:^{
            ws.scrollViewContainer.contentOffset = CGPointMake(ScreenWidth * itemIndex, 0);
        }];
    };
    
    if(type == 0){
        
    }else{
        if(!self.parameters){
            if (getUserCenter.userInfo.token.length == 0) {
                [self.listBar itemClickByScrollerWithIndex:1];
            }else{
                [self.listBar itemClickByScrollerWithIndex:0];
            }
        }else{
             [self.listBar itemClickByScrollerWithIndex:0];
        }
    }
}

- (void)resetController{
    for(UIViewController *controller in self.childViewControllers){
        [controller removeFromParentViewController];
    }
}

- (void)addNoti{
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_needRequest object:nil];
}

//其他页面选择分组 切换回来行情这个页面
- (void)switchListBar{
    // 重置 上方选择按钮
    [self.navView.globalBtn setBackgroundColor:kHEXCOLOR(0x108ee9)];
    [self.navView.globalBtn setTitleColor:kHEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [self.navView.exchangeBtn setBackgroundColor:isNightMode?ViewContentBgColor:kHEXCOLOR(0xffffff)];
    [self.navView.exchangeBtn setTitleColor:kHEXCOLOR(0x108ee9) forState:UIControlStateNormal];
    self.tabContentView.hidden = YES;
    self.exchangeListBar.hidden = YES;
    [self.listBar itemClickByScrollerWithIndex:0];
}

//无数据 跳转到
- (void)changeListBarStatus{
    [self.listBar itemClickByScrollerWithIndex:1];
}

- (void)requestCurrencyList{
    
//    [self resetController];
//    for(UIView *view in self.scrollViewContainer.subviews){
//        [view removeFromSuperview];
//    }
//
//    [self configSubVCs];
    
//    [self.listTop removeAllObjects];
//    if(!self.parameters[@"model"]){
//        [self.listTop addObject:@"zixuan"];
//        [self.listTop addObject:@"shizhi"];
//    }
//    [self.arrList removeAllObjects];
    
    NSString *exchangeCode;
    NSString *exchangeName;
    BTExchangeListModel *model = self.parameters[@"model"];
    if(model){
        exchangeCode = model.exchangeCode;
        exchangeName = model.exchangeName;
    }else{
        exchangeCode = k_Net_Code;
        exchangeName = @"";
    }
    
    if(model){
        NSArray * list =  @[
                            @{
                                @"currencyCode":[APPLanguageService sjhSearchContentWith:@"quanbu"],
                                @"currencySimpleName":[APPLanguageService sjhSearchContentWith:@"quanbu"]
                                }
                            ];
        NSMutableArray *arr = @[].mutableCopy;
        [arr addObjectsFromArray:list];
        if(model.baseSymbolList.count >0){
            [arr addObjectsFromArray:model.baseSymbolList];
        }
        for (NSInteger i = 0 ; i <arr.count;i++) {
            NSDictionary *dic = arr[i];
            NSString *currencyCode = dic[@"currencySimpleName"];
            [self.listTop addObject:currencyCode];
            [self.arrList addObject:currencyCode];
            
            CurrencyViewController *currencyVc = [[CurrencyViewController alloc] init];
            
            currencyVc.exchangeCode = exchangeCode;
            currencyVc.exchangeName = exchangeName;
            
            if([currencyCode isEqualToString:[APPLanguageService sjhSearchContentWith:@"quanbu"]]){
                 currencyVc.currencyCode = @"";
            }else{
                currencyVc.currencyCode = currencyCode;
            }
            currencyVc.view.frame =  CGRectMake(ScreenWidth *(0+i), 0,ScreenWidth,self.scrollViewContainer.frame.size.height);
            [self addChildViewController:currencyVc];
            [self.scrollViewContainer addSubview:currencyVc.view];
        }
        NSInteger count = 0;
        if(!self.parameters[@"model"]){
            count = 2;
        }
        self.scrollViewContainer.contentSize = CGSizeMake(ScreenWidth * ([arr count] + count), self.scrollViewContainer.frame.size.height);
        [self configMoveBar:1];
        
        
        
    }else{
        if(self.listTop.count == 5) return;
//        self.listRequest = [[CurrencyListRequest alloc] initWithExchangeCode:exchangeCode];
//        [self.listRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            // todo
        //            [self.loadingView hiddenLoading];
        
        NSArray *arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"currency_types"];
        if(arr.count == 0){
            arr = @[@"BTC",@"ETH",@"USDT"];
        }
        
        for (NSInteger i = 0 ; i < arr.count;i++) {
//            NSDictionary *dic = arr[i];
            NSString *title = arr[i];
            NSString *currencyCode =title; //dic[@"currencySimpleName"];
            [self.listTop addObject:currencyCode];
            [self.arrList addObject:currencyCode];
            CurrencyViewController *currencyVc = [[CurrencyViewController alloc] init];
            currencyVc.currencyCode = currencyCode;
            currencyVc.exchangeCode = exchangeCode;
            currencyVc.exchangeName = exchangeName;
            
            if(!self.parameters[@"model"]){
                currencyVc.view.frame =  CGRectMake(ScreenWidth *(2+i), 0,ScreenWidth,self.scrollViewContainer.frame.size.height);
            }else{
                currencyVc.view.frame =  CGRectMake(ScreenWidth *(1+i), 0,ScreenWidth,self.scrollViewContainer.frame.size.height);
            }
            
            [self addChildViewController:currencyVc];
            [self.scrollViewContainer addSubview:currencyVc.view];
        }
        NSInteger count = 1;
        if(!self.parameters[@"model"]){
            count = 2;
        }
        self.scrollViewContainer.contentSize = CGSizeMake(ScreenWidth * ([arr count] + count), self.scrollViewContainer.frame.size.height);
        [self configMoveBar:1];
            
//        } failure:^(__kindof BTBaseRequest *request) {
//            [self.loadingView hiddenLoading];
//        }];
    }
    
}
    
    

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //    [self checkIsSignIn];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getScreenShot:)
                                                 name:UIApplicationUserDidTakeScreenshotNotification object:nil];
}
//
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    BTExchangeModel *model = self.parameters[@"model"];
    if(model){
        [MobClick event:@"exchanges_market_info"];
    }else{
        [MobClick event:home_page];
    }
    if(!appDelegate.listModel){
        self.listModel.userGroupId = ALL_GROUP_ID;
        if (getUserCenter.userInfo.token.length == 0) {
            [self.listBar itemClickByScrollerWithIndex:1];
        }else{
            [self.listBar itemClickByScrollerWithIndex:0];
        }
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [AnalysisService alaysisHome_search];
    [BTCMInstance presentViewControllerWithName:@"historySearch" andParams:nil animated:NO];
    return NO;
}

#pragma mark - Lazy
- (UIScrollView *)scrollViewContainer{
    if (!_scrollViewContainer) {
        CGFloat bottom;
        if(self.parameters[@"model"]){
            bottom = 0.0;
        }else{
            bottom = kTabBarHeight;
        }
        _scrollViewContainer = [[UIScrollView alloc] init];
        _scrollViewContainer.frame = CGRectMake(0, 36, ScreenWidth, ScreenHeight - kTopHeight - bottom - 36);
        _scrollViewContainer.pagingEnabled = YES;
        _scrollViewContainer.bounces = NO;
        _scrollViewContainer.showsHorizontalScrollIndicator = NO;
    }
    return _scrollViewContainer;
}

#pragma mark - UIScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index= round(scrollView.contentOffset.x / ScreenWidth);
    [self.listBar itemClickByScrollerWithIndex:index];

}

- (void)startTimeWithVcIndex:(NSInteger)index{
    UIViewController *vc = self.childViewControllers[index];
    for (UIView *vcItem in self.childViewControllers) {
        if (![vcItem isEqual:vc]) {
            if ([vcItem isKindOfClass:[MarketViewController class]]) {
                [(MarketViewController *)vcItem stopTimer];
            }
            if ([vcItem isKindOfClass:[CurrencyViewController class]]) {
                [(CurrencyViewController *)vcItem stopTimer];
            }
            if ([vcItem isKindOfClass:[MyOptionViewController class]]) {
                [(MyOptionViewController *)vcItem stopTimer];
            }
        }
    }
    if ([vc isKindOfClass:[MarketViewController class]]) {
        [(MarketViewController *)vc startTimer];
    }
    if ([vc isKindOfClass:[CurrencyViewController class]]) {
        [(CurrencyViewController *)vc startTimer];
    }
    if ([vc isKindOfClass:[MyOptionViewController class]]) {
        [(MyOptionViewController *)vc startTimer];
    }
}

- (void)btnClick:(UIButton*)btn{
    if(btn.tag == 1000){//搜索
        [AnalysisService alaysisHome_search];
        [BTCMInstance presentViewControllerWithName:@"historySearch" andParams:nil animated:NO];
    }else{
        btn.ts_acceptEventInterval = 2.0f;
        [self requestList];
    }
}

- (void)tap{
    _leftIv.image = [UIImage imageNamed:@"main_up"];
    
    [MobClick event:@"exchange"];
    
}
- (void)leftBtnClick:(UIButton*)btn{
    [MobClick event:@"exchange"];
    _leftIv.image = [UIImage imageNamed:@"main_up"];
}

//检查未读消息
-(void)checkMessageCenter {
    if ([getUserCenter isLogined]) {
        
        CheckMessageUnreadRequest *api = [[CheckMessageUnreadRequest alloc] initWithCheckMessageUnread];
        
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            MessageModel *model = [MessageModel modelWithJSON:request.data];
            if ((model.comment + model.like + model.message + model.mention) > 0) {
                
                self.messageV.numBerL.hidden = NO;
                self.messageV.numBerL.text = [NSString stringWithFormat:@"%ld",model.comment + model.like + model.message + model.mention];
            }else {
                
                self.messageV.numBerL.hidden = YES;
            }
            
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
        
    } else {
        
        self.messageV.numBerL.hidden = YES;
    }
}

- (NSMutableArray *)arrList{
    if (!_arrList) {
        _arrList = [NSMutableArray array];
    }
    return _arrList;
}

- (NSMutableArray *)listTop{
    if (!_listTop) {
        _listTop = [NSMutableArray array];
    }
    return _listTop;
}

- (void)requestList{
    if (getUserCenter.userInfo.token.length == 0) {
        [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil animated:YES];
        return;
    }
    if(_groupListApi.isExecuting){
        [_groupListApi stop];
    }
    if(_exchangeListApi.isExecuting){
        [_exchangeListApi stop];
    }
    _groupListApi = [[BTGroupListRequest alloc]init];
    [_groupListApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
        if(request.data&&[request.data isKindOfClass:[NSArray class]]){
            NSMutableArray *data =@[].mutableCopy;
            
            BTGroupListModel *modelAll = [[BTGroupListModel alloc] init];
            modelAll.groupName = [APPLanguageService sjhSearchContentWith:@"quanbu"]; //@"全部";
            modelAll.userGroupId = ALL_GROUP_ID;
            [data addObject:modelAll];
            
            NSMutableArray *infoArr =@[].mutableCopy;
            for (NSDictionary *dict in request.data){
                BTGroupListModel *info =[BTGroupListModel objectWithDictionary:dict];
                [infoArr addObject:info];
            }
            NSArray *reverseArr =[[infoArr reverseObjectEnumerator] allObjects];
            [data addObjectsFromArray:reverseArr];
            for (BTGroupListModel *info in data){
                if(info.userGroupId == self.listModel.userGroupId){
                    info.isSelected = YES;
                }
            }
            [GroupSideView showWithArr:data completion:^(BTGroupListModel *model) {
                self.listModel = model;
                //选择完 给自选页面发个通知，通知刷新数据
                appDelegate.listModel = model;
                [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Refresh_Select_Group object:model];
                [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_Switch_List_Bar object:model];
            }];
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
    }];
}

- (void)refreshListBar{
    [self requestCurrencyList];
}

- (void)refreshMainGroup:(NSNotification*)notify{
    BTGroupListModel *listModel = (BTGroupListModel*)notify.object;
    self.listModel = listModel;
}

- (void)refreshSelectGroup:(NSNotification*)notify{
    BTGroupListModel *listModel = (BTGroupListModel*)notify.object;
    self.listModel = listModel;
}

- (void)refreshData{
    [self startTimeWithVcIndex:[BTConfigureService shareInstanceService].index];
}

-(QuotosNavView *)navView {
    if (!_navView) {
        _navView = [QuotosNavView loadFromXib];
        _navView.frame = CGRectMake(0, 0, 160, 30);
        _navView.intrinsicContentSize = CGSizeMake(160, 30);
        ViewBorderRadius(_navView.globalBtn, 4, 1, kHEXCOLOR(0x108ee9));
        ViewBorderRadius(_navView.exchangeBtn, 4, 1, kHEXCOLOR(0x108ee9));
        _navView.middeL.backgroundColor = kHEXCOLOR(0x108ee9);
        [_navView.globalBtn setBackgroundColor:kHEXCOLOR(0x108ee9)];
        [_navView.globalBtn setTitleColor:kHEXCOLOR(0xffffff) forState:UIControlStateNormal];
        [_navView.exchangeBtn setBackgroundColor:isNightMode? ViewContentBgColor :kHEXCOLOR(0xffffff)];
        [_navView.exchangeBtn setTitleColor:kHEXCOLOR(0x108ee9) forState:UIControlStateNormal];
        _navView.globalBtn.fixTitle =@"bihangqing";
        _navView.exchangeBtn.fixTitle =@"jiaoyisuo";
        [_navView.globalBtn addTarget:self action:@selector(navgationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navView.exchangeBtn addTarget:self action:@selector(navgationBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _navView;
}

-(void)navgationBtnClick:(UIButton *)btn {
    if (btn.tag == 111) {
        [self.navView.globalBtn setBackgroundColor:kHEXCOLOR(0x108ee9)];
        [self.navView.globalBtn setTitleColor:kHEXCOLOR(0xffffff) forState:UIControlStateNormal];
        [self.navView.exchangeBtn setBackgroundColor:isNightMode? ViewContentBgColor :kHEXCOLOR(0xffffff)];
        [self.navView.exchangeBtn setTitleColor:kHEXCOLOR(0x108ee9) forState:UIControlStateNormal];
        self.tabContentView.hidden = YES;
        self.exchangeListBar.hidden = YES;
        [MobClick event:@"market_info"];
        
    }else {
        [self.navView.exchangeBtn setBackgroundColor:kHEXCOLOR(0x108ee9)];
        [self.navView.exchangeBtn setTitleColor:kHEXCOLOR(0xffffff) forState:UIControlStateNormal];
        [self.navView.globalBtn setBackgroundColor:isNightMode? ViewContentBgColor :kHEXCOLOR(0xffffff)];
        [self.navView.globalBtn setTitleColor:kHEXCOLOR(0x108ee9) forState:UIControlStateNormal];
        self.tabContentView.hidden = NO;
        self.exchangeListBar.hidden = NO;
        [self.view bringSubviewToFront:self.exchangeListBar];
        [self.view bringSubviewToFront:self.tabContentView];
        [MobClick event:@"exchanges"];
    }
}

- (TabContentView*)tabContentView{
    if(!_tabContentView){
        _tabContentView = [[TabContentView alloc] initWithFrame:CGRectZero];
        _tabContentView.backgroundColor = ViewBGColor;
    }
    return _tabContentView;
}

@end
