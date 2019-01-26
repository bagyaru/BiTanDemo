//
//  HomeViewController.m
//  BT
//
//  Created by admin on 2018/6/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HomeViewController.h"
#import "InformationModuleRequest.h"
#import "FastInfomationObj.h"
#import "BannersRequest.h"
#import "HomeHeadView.h"
#import "HomeSelectView.h"
#import "BTDiscoveryMainCell.h"
#import "BTConceptUpDownRequest.h"
#import "BTZFFBRequest.h"
#import "BTBitaneIndexListRequest.h"
#import "BTBitaneIndexModel.h"
#import "BTBitaneIndexDetailModel.h"

#import "BTGroupListModel.h"
#import "ExchangeListRequest.h"
#import "BTGroupListRequest.h"
#import "GroupSideView.h"

#import "FFSnowflakesFallingView.h"
#import "MKRollImagesView.h"
#import "BTDiscoveryBannerReq.h"
#import "CCPScrollView.h"
#import "BTListExchangeNewsRequest.h"
#import "HomeHotSearchCell.h"

#import "BTHomeNewHotSearchRequest.h"
#import "BYListBar.h"
#import "HomeNavgationView.h"

#import "SGPagingView.h"
#import "UIView+SGPagingView.h"
#import "SGCenterTableView.h"
#import "BTHotSearchVC.h"
#import "BTRankingListVC.h"
#import "BTIsSignInRequest.h"

static NSString *const identifier  = @"BTDiscoveryMainCell";
static NSString *const identifier1 = @"HomeHotSearchCell";
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate,MKRollImagesViewDelegate,CAAnimationDelegate,SGPageContentCollectionViewDelegate,SGCenterChildBaseVCDelegate,UIScrollViewDelegate>{
    BTBaseRequest *api;
}
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *bitaneIndexArray;
@property (nonatomic, strong) NSMutableArray *bannersArray;
@property (nonatomic, strong) NSMutableArray *rssArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) HomeHeadView  *headView;
@property (nonatomic, strong) HomeSelectView*selectView;
@property (nonatomic, assign) NSInteger selectIndex; //1 涨幅榜 2 跌幅榜 成交额
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) BTGroupListModel *listModel;
@property (nonatomic, strong) ExchangeListRequest *exchangeListApi;
@property (nonatomic, strong) BTGroupListRequest *groupListApi;

@property (nonatomic, strong) MKRollImagesView *rollImageViews;
@property (strong, nonatomic) CCPScrollView *noticeView;

@property (nonatomic, strong) BYListBar *listBar;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (nonatomic, strong) HomeNavgationView *navagationView;
@property (nonatomic, strong) BTView *navagationBackView;

@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;
@property (nonatomic, strong) UIScrollView *childVCScrollView;
@property (nonatomic, strong) SGCenterTableView *mTableView;
@property (nonatomic, strong) HomeSelectView *rankHeaderView;
@end


@implementation HomeViewController

static CGFloat const PersonalCenterVCPageTitleViewHeight = 70;

- (CGFloat)topViewHeight{
    return 516.0f;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self addNavigationItemWithImageNames:@[@"main_search"] isLeft:NO target:self action:@selector(btnClick:) tags:@[@"10000"]];
    [self addNavigationItemWithImageNames:@[@"ic_zixuancelan"] isLeft:YES target:self action:@selector(btnClick:) tags:@[@"10001"]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redRiseGreenFall) name:NSNotification_RedRiseGreenFall object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSelectGroup:) name:k_Notification_Refresh_Select_Group object:nil];
    self.listModel = [[BTGroupListModel alloc] init];
    [self.navagationBackView addSubview:self.navagationView];
    [self.view addSubview:self.navagationBackView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat y = scrollView.contentOffset.y;
//    CGFloat alpha = (y+kStatusBarHeight)/(180-kStatusBarHeight);
    CGFloat alpha = (y)/(180);
    self.navagationView.backgroundColor = KClearColor;
    self.navagationView.clearView.backgroundColor = isNightMode ? TableViewCellNightColor : KWhiteColor;
    self.navagationView.clearView.alpha = alpha;

    NSLog(@"%.0f  %.1f",y,alpha);
    if (alpha > 0.5) {
        self.navagationView.titleL.hidden = NO;
        self.navagationView.backImageV.hidden = YES;
        [self.navagationView.searchBtn setImage:IMAGE_NAMED(@"main_search") forState:UIControlStateNormal];
        [self.navagationView.groupBtn setImage:IMAGE_NAMED(@"ic_zixuancelan") forState:UIControlStateNormal];
        if (isNightMode) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }else {

            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
    }else {
        self.navagationView.titleL.hidden = YES;
        self.navagationView.backImageV.hidden = NO;
        [self.navagationView.searchBtn setImage:IMAGE_NAMED(@"main_search_white") forState:UIControlStateNormal];
        [self.navagationView.groupBtn setImage:IMAGE_NAMED(@"ic_zixuancelan_white") forState:UIControlStateNormal];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    
    if (self.childVCScrollView && _childVCScrollView.contentOffset.y > 0) {
        self.mTableView.contentOffset = CGPointMake(0, [self topViewHeight]);
    }
    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY < [self topViewHeight]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pageTitleViewToTop" object:nil];
    }
    
    //改变吸顶的位置
    CGFloat sectionHeaderHeight = kTopHeight;
    CGFloat ceilPositon = 516 - sectionHeaderHeight;
    if (scrollView.contentOffset.y < sectionHeaderHeight){
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if (scrollView.contentOffset.y >= ceilPositon && scrollView.contentOffset.y >= sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(sectionHeaderHeight , 0, 0, 0);
    }
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [BTThreeManager sharedInstance].typeStr = @"首页";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.02 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self scrollViewDidScroll:self.mTableView];
    });
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    if(!isNightMode){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
   
    [self stopTimer];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startTimer];
    [MobClick event:@"home"];
    if (self.selectIndex == 0) {
        //[AnalysisService alaysisfind_page_zfb];
    }
    if (self.selectIndex == 1) {
        [AnalysisService alaysisfind_page_zfb];
    }
    if (self.selectIndex == 2) {
        [AnalysisService alaysisfind_page_dfb];
    }
    if (self.selectIndex == 3) {
        [AnalysisService alaysishome_amount];
    }
}
//收到红涨绿跌的通知
-(void)redRiseGreenFall {
    
    [self requestData];
    [self get_BTZS_Data];
    [self get_ZFFB_Data];
    [self loadBannerData:RefreshStatePull];
    [self loadGongGaoData];
}
- (void)btnClick:(UIButton*)btn{
    if (btn.tag == 10000) {
        [AnalysisService alaysisHome_search];
        [BTCMInstance presentViewControllerWithName:@"historySearch" andParams:nil animated:NO];
    }else {
        btn.ts_acceptEventInterval = 2.0f;
        [self requestList];
    }
}
- (void)startTimer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:[BTConfigureService shareInstanceService].timeSepa target:self selector:@selector(requestData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
}

- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}
-(void)creatUI {
    self.selectIndex = 0;
    self.title = [APPLanguageService wyhSearchContentWith:@"home"];
    [self foundTableView];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_mTableView delegate:self];
    [self get_BTZS_Data];
    [self get_ZFFB_Data];
    [self loadBannerData:RefreshStateNormal];
    [self loadGongGaoData];

    if (@available(iOS 11.0, *)) {
        self.mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _mTableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        [self get_BTZS_Data];
        [self get_ZFFB_Data];
        [self loadBannerData:RefreshStatePull];
        [self loadGongGaoData];
    }];
}
- (void)requestData{
    [self get_BTZS_Data];
    

}
- (void)requestUpAndDownList:(RefreshState)refreshState{}
-(void)get_ZFFB_Data {
    
    BTZFFBRequest *api = [BTZFFBRequest new];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        NSLog(@"%@",request.data);
        if ([request.data isKindOfClass:[NSDictionary class]]) {
            
            self.headView.ZFFB_DICT = request.data;
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
-(void)get_BTZS_Data {
    
    if (self.bitaneIndexArray.count > 0) {//刷新时
        BTBitaneIndexListRequest *api =[BTBitaneIndexListRequest new];
        
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            if ([request.data count]) {
                
                for (int i = 0; i < self.bitaneIndexArray.count; i++) {
                    
                    BTBitaneIndexModel *model = self.bitaneIndexArray[i];
                    for (NSDictionary *dict in request.data) {
                        BTBitaneIndexModel *changeModel = [BTBitaneIndexModel objectWithDictionary:dict];
                        if ([dict[@"list"] isKindOfClass:[NSArray class]]) {
                            NSArray *list = dict[@"list"];
                            changeModel.indexDetailListArray = @[].mutableCopy;
                            for (NSDictionary *detailDict in list) {
                                
                                BTBitaneIndexDetailModel *detailModel = [BTBitaneIndexDetailModel objectWithDictionary:detailDict];
                                [changeModel.indexDetailListArray addObject:detailModel];
                            }
                        }
                        if([model.code isEqualToString:changeModel.code]){
                            changeModel.type = [self compareBitaneIndexSecondModel:changeModel firstModel:model];
                            [self.bitaneIndexArray replaceObjectAtIndex:i withObject:changeModel];
                        }
                    }
                }
                
                self.headView.array = self.bitaneIndexArray;
            }
            
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    }else {//第一次进入
        BTBitaneIndexListRequest *api =[BTBitaneIndexListRequest new];
        
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            if ([request.data count]) {
                [self.bitaneIndexArray removeAllObjects];
                for (NSDictionary *dict in request.data) {
                    BTBitaneIndexModel *model = [BTBitaneIndexModel objectWithDictionary:dict];
                    if ([dict[@"list"] isKindOfClass:[NSArray class]]) {
                        NSArray *list = dict[@"list"];
                        model.indexDetailListArray = @[].mutableCopy;
                        for (NSDictionary *detailDict in list) {
                            
                            BTBitaneIndexDetailModel *detailModel = [BTBitaneIndexDetailModel objectWithDictionary:detailDict];
                            [model.indexDetailListArray addObject:detailModel];
                        }
                    }
                    [self.bitaneIndexArray addObject:model];
                }
                self.headView.array = self.bitaneIndexArray;
            }
            
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    }
}
- (NSInteger)compareBitaneIndexSecondModel:(BTBitaneIndexModel*)secondModel firstModel:(BTBitaneIndexModel*)firstModel{
    if (kIsCNY) {
        if (secondModel.priceCNIndex > firstModel.priceCNIndex) {
            return 1;
        }else if (secondModel.priceCNIndex == firstModel.priceCNIndex){
            return 0;
        }else{
            return 2;
        }
    }else{
        if (secondModel.priceUSIndex > firstModel.priceUSIndex) {
            return 1;
        }else if (secondModel.priceUSIndex == firstModel.priceUSIndex){
            return 0;
        }else{
            return 2;
        }
    }
}
-(void)loadBannerData:(RefreshState)state {
    if(state == RefreshStateNormal){
        [self.loadingView showLoading];
    }
    BTDiscoveryBannerReq *bannerApi = [[BTDiscoveryBannerReq alloc] initWithType:2];
    [bannerApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        _bannersArray =@[].mutableCopy;
        NSMutableArray *urls = [NSMutableArray array];
        for (NSDictionary *dic in request.data) {
            [_bannersArray addObject:dic];
            NSString *str =  [getUserCenter getImageURLSizeWithWeight:ScreenWidth*2 andHeight:180*2];
            NSString *url =[NSString stringWithFormat:@"%@?%@",SAFESTRING(dic[@"image"]),str];
            [urls addObject:[NSString stringWithFormat:@"%@",url]];
        }
        if(_bannersArray.count > 0){
            self.rollImageViews.bannerUrls = urls;
            self.rollImageViews.hidden = NO;
            self.headView.bannerView.hidden = NO;
            self.headView.bannerViewH.constant = 180;
            [self.headView.bannerView addSubview:self.rollImageViews];
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 516)];
            self.headView.frame = v.frame;
            [v addSubview:self.headView];
            _mTableView.tableHeaderView = v;
        
        }else{
            self.rollImageViews.hidden =YES;
            self.headView.bannerView.hidden = YES;
            self.headView.bannerViewH.constant = 0;
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 516-180)];
            self.headView.frame = v.frame;
            [v addSubview:self.headView];
            _mTableView.tableHeaderView = v;
        }
        [self.mTableView.mj_header endRefreshing];
    } failure:^(__kindof BTBaseRequest *request) {
        [self.mTableView.mj_header endRefreshing];
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
-(void)loadGongGaoData {
    
    BTListExchangeNewsRequest *api = [BTListExchangeNewsRequest new];
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        NSLog(@"%@",request.data);
        if ([request.data count]) {
            self.rssArray = @[].mutableCopy;
            for (NSDictionary *dict in request.data) {
                
                [self.rssArray addObject:ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans) ? [NSString stringWithFormat:@"%@  %@",dict[@"exchangeNameCn"],dict[@"title"]] : [NSString stringWithFormat:@"%@  %@",dict[@"exchangeNameEn"],dict[@"title"]]];
            }
            
            self.noticeView.titleArray = self.rssArray;
            self.noticeView.titleFont = 14;
            self.noticeView.titleColor = FirstDayColor;
            self.noticeView.BGColor = KClearColor;
            [self.headView.noticeView addSubview:self.noticeView];
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    [self get_BTZS_Data];
    [self get_ZFFB_Data];
    [self loadBannerData:RefreshStateNormal];
    [self loadGongGaoData];
    [self requestUpAndDownList:RefreshStateNormal];
}

//自选
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
    
//    [BTShowLoading show];
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
            if(!appDelegate.listModel){
                self.listModel.userGroupId = ALL_GROUP_ID;
            }else{
                self.listModel = appDelegate.listModel;
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
                [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Refresh_Select_Group object:model];
                appDelegate.listModel = model;
                //
                [self.tabBarController setSelectedIndex:1];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_Switch_List_Bar object:model];
                
            }];
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
         [BTShowLoading hide];
    }];
}

#pragma mark layz
- (BTView *)navagationBackView {
    if (!_navagationBackView) {
        _navagationBackView = [[BTView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, kTopHeight)];
        _navagationBackView.backgroundColor = [UIColor clearColor];
    }
    return _navagationBackView;
}
- (HomeNavgationView *)navagationView {
    if (!_navagationView) {
        _navagationView = [HomeNavgationView loadFromXib];
        _navagationView.frame = CGRectMake(0, 0, ScreenWidth, kTopHeight);
        [_navagationView.groupBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_navagationView.searchBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        _navagationView.groupBtn.tag  = 10001;
        _navagationView.searchBtn.tag = 10000;
    }
    return _navagationView;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)bitaneIndexArray {
    if (!_bitaneIndexArray) {
        _bitaneIndexArray = [NSMutableArray array];
    }
    return _bitaneIndexArray;
}

- (HomeHeadView *)headView {
    if (!_headView) {
        _headView = [HomeHeadView loadFromXib];
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 516);
    }
    return _headView;
}


//轮播图
- (MKRollImagesView*)rollImageViews{
    if(!_rollImageViews){
        [BTThreeManager sharedInstance].typeStr = @"首页";
        _rollImageViews = [[MKRollImagesView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180.0f)];
        _rollImageViews.placeHolderImage = [UIImage imageNamed:@"Mask_list"];
        _rollImageViews.delegate = self;
        [_rollImageViews autoRollEnable:YES];
    }
    return _rollImageViews;
}
#pragma mark --MKRollImagesViewDelegate
//点击轮播
- (void)rollImagesView:(MKRollImagesView *)rollView didClickIndex:(NSInteger)index{
    [MobClick event:@"home_banner"];
//    NSDictionary *dict = self.bannersArray[index];
//    NSString *url = SAFESTRING(dict[@"url"]);
//    H5Node *node =[[H5Node alloc] init];
//    node.webUrl = url;
//    node.title = SAFESTRING(dict[@"title"]);
//    if(url.length > 0){
//        if ([dict[@"url"] containsString:@"invitation2"]) {
//            node.title = [APPLanguageService wyhSearchContentWith:@"yaoqinghaoyou"];
//            [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
//        }else {
//
//            [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
//        }
//    }
    
    NSDictionary *dict = self.bannersArray[index];
    NSInteger urlType = [SAFESTRING(dict[@"urlType"]) integerValue];
    NSString *url = SAFESTRING(dict[@"url"]);
    NSString *refId = SAFESTRING(dict[@"refId"]);
    
    switch (urlType) {
        case 1://内部网页
        {
            if(url.length > 0){
                H5Node *node =[[H5Node alloc] init];
                node.webUrl = url;
                if ([url containsString:@"invitation2"]) {
                    node.title = [APPLanguageService wyhSearchContentWith:@"yaoqinghaoyou"];
                }
                [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
            }
        }
            
            break;
        case 2:// 外部网页
        {
            if(url.length > 0){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
        }
            
            break;
            
        case 3://要闻
        {
            if(refId.length >0){
                [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":refId}];
            }
        }
            
            break;
        case 4://探报
        {
            if(refId.length >0){
                [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":refId,@"bigType":@(6)}];
            }
        }
            
            break;
        case 5://帖子
        {
            if(refId.length >0){
                [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":refId}];
            }
        }
            
            break;
        case 6: //攻略
        {
            if(refId.length >0){
                [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":refId,
                                                                                          @"whereVC":@"攻略"
                                                                                          }];
            }
        }
            break;
        case 7://讨论
        {
            if(refId.length >0){
                [BTCMInstance pushViewControllerWithName:@"TopicVC" andParams:@{@"refId":refId}];
            }
        }
            
            break;
        case 8:{// 我的探力
            if (![getUserCenter isLogined]) {
                [AnalysisService alaysisMine_login];
                [getUserCenter loginoutPullView];
                return;
            }
            BTIsSignInRequest *request = [BTIsSignInRequest new];
            [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
                if ([request.data integerValue]) {//表示已经签到
                    [BTCMInstance pushViewControllerWithName:@"BTNewMyTanLiMain" andParams:nil];
                }else{//未签到
                    [BTCMInstance pushViewControllerWithName:@"BTNewMyTanLiMain" andParams:@{@"isContinue":@(YES)}];
                }
            } failure:^(__kindof BTBaseRequest *request) {
            }];
        }
            break;
            
        default:
            break;
    }
}

- (CCPScrollView *)noticeView {
    if (!_noticeView) {
        _noticeView = [[CCPScrollView alloc] initWithFrame:CGRectMake(45, 1, ScreenWidth-45-15, 38)];
        [_noticeView clickTitleLabel:^(NSInteger index,NSString *titleString) {
            NSLog(@"%ld-----%@",index,titleString);
            [MobClick event:@"home_announcement"];
            [BTCMInstance pushViewControllerWithName:@"BTHomeGongGaoDetail" andParams:nil];
        }];
    }
    return _noticeView;
}


- (void)refreshSelectGroup:(NSNotification*)notify{
    BTGroupListModel *listModel = (BTGroupListModel*)notify.object;
    self.listModel = listModel;
}


- (void)foundTableView {
    self.mTableView = [[SGCenterTableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    [_mTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _mTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.sectionHeaderHeight = PersonalCenterVCPageTitleViewHeight;
    _mTableView.rowHeight = ScreenHeight  - PersonalCenterVCPageTitleViewHeight - kTabBarHeight;
    _mTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_mTableView];
    [_mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (BYListBar*)listBar{
    if(!_listBar){
        _listBar = [[BYListBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        _listBar.isFuture = YES;
        WS(ws)
        _listBar.visibleItemList = [NSMutableArray arrayWithArray:@[[APPLanguageService wyhSearchContentWith:@"resou"],[APPLanguageService wyhSearchContentWith:@"zhangfubang"],[APPLanguageService wyhSearchContentWith:@"diefubang"],[APPLanguageService wyhSearchContentWith:@"chengjiaoebang"],[APPLanguageService wyhSearchContentWith:@"huanshoulvbang"]]];
        _listBar.listBarItemClickBlock = ^(NSString *itemName , NSInteger itemIndex){
            [ws.pageContentCollectionView setPageContentCollectionViewCurrentIndex:itemIndex];
            if (itemIndex == 0) {
                ws.rankHeaderView.ZoDAndCjeL.fixText = @"24hzhangdie";
                ws.rankHeaderView.DqjAndRdL.localText  = @"redu";
            }else {
                ws.rankHeaderView.DqjAndRdL.localText  = @"dangqianjia";
                if (itemIndex == 4) {
                    ws.rankHeaderView.ZoDAndCjeL.fixText = @"huanshoulv";
                }else if (itemIndex == 3) {
                    ws.rankHeaderView.ZoDAndCjeL.fixText = @"chengjiaoe";
                }else {
                    ws.rankHeaderView.ZoDAndCjeL.fixText = @"24hzhangdie";
                }
            }
        };
        [self.listBar itemClickByScrollerWithIndex:0];
    }
    return _listBar;
}

- (SGPageContentCollectionView *)pageContentCollectionView {
    if (!_pageContentCollectionView) {
        
        BTHotSearchVC *hotSearchVC = [[BTHotSearchVC alloc] init];
        hotSearchVC.delegatePersonalCenterChildBaseVC = self;
        
        BTRankingListVC *rankListVC = [[BTRankingListVC alloc] init];
        rankListVC.delegatePersonalCenterChildBaseVC = self;
        rankListVC.selectIndex = 1;
        
        BTRankingListVC *rankListVC1 = [[BTRankingListVC alloc] init];
        rankListVC1.delegatePersonalCenterChildBaseVC = self;
        rankListVC1.selectIndex = 2;
        
        BTRankingListVC *rankListVC2 = [[BTRankingListVC alloc] init];
        rankListVC2.delegatePersonalCenterChildBaseVC = self;
        rankListVC2.selectIndex = 3;
        
        BTRankingListVC *rankListVC3 = [[BTRankingListVC alloc] init];
        rankListVC3.delegatePersonalCenterChildBaseVC = self;
        rankListVC3.selectIndex = 4;
        
        NSArray *childArr = @[hotSearchVC,rankListVC,rankListVC1,rankListVC2,rankListVC3];
        CGFloat ContentCollectionViewHeight = ScreenHeight  - PersonalCenterVCPageTitleViewHeight  - kTabBarHeight;
        _pageContentCollectionView = [[SGPageContentCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ContentCollectionViewHeight) parentVC:self childVCs:childArr];
        _pageContentCollectionView.delegatePageContentCollectionView = self;
    }
    return _pageContentCollectionView;
}

- (void)personalCenterChildBaseVCScrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%.0f  %.0f %.0f",[self topViewHeight],self.mTableView.contentOffset.y,self.mTableView.SG_size.height);
    self.childVCScrollView = scrollView;
    if (self.mTableView.contentOffset.y < [self topViewHeight]) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    } else {
        self.mTableView.contentOffset = CGPointMake(0, [self topViewHeight]);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.contentView addSubview:self.pageContentCollectionView];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.rankHeaderView;
}
- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    _mTableView.scrollEnabled = NO;
}

- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView index:(NSInteger)selectIndex{
    [self.listBar itemClickByScrollerWithIndex:selectIndex];
}

- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView offsetX:(CGFloat)offsetX {
    _mTableView.scrollEnabled = YES;
}
- (HomeSelectView *)rankHeaderView {
    if (!_rankHeaderView) {
        _rankHeaderView = [HomeSelectView loadFromXib];
        _rankHeaderView.frame = CGRectMake(0, 0, ScreenWidth, 70);
        [_rankHeaderView.topView addSubview:self.listBar];
    }
    return _rankHeaderView;
}

@end
