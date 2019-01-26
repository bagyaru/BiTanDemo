//
//  QiHuoDetailVC.m
//  BT
//
//  Created by apple on 2018/7/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QiHuoDetailVC.h"
#import "QuotesDetailSectionView.h"
#import "QuotesSegment.h"
#import "OptiontimeView.h"

#import "YKLineEntity.h"

#import "MarketRealtimeRequest.h"
#import "CurrencyModel.h"
#import "FenshiModel.h"
#import "KLineRequest.h"
#import "KLineModel.h"

#import "Y_StockChartView.h"
#import "Y_KLineGroupModel.h"
#import "UIColor+Y_StockChart.h"

#import "SGPagingView.h"
#import "UIView+SGPagingView.h"
#import "CurrencyViewController.h"
#import "SGCenterTableView.h"
#import "DiscussViewController.h"
#import "IntroduceViewController.h"
#import "MarketDetailViewController.h"

#import "BTDetailHeaderView.h"
#import "BTViewRotationHeader.h"

#import "BTAnalyseViewController.h"
#import "DetailHelper.h"
#import "OptionIndexView.h"

#import "BTFutureKlineApi.h"
#import "BTFutureRealtimePointApi.h"

#import "BTFutureIntroduceVC.h"
#import "BTFutureTotalHoldingVC.h"
#import "BTFutureDMIVC.h"
#import "BTVolumnRatioApi.h"

#define future_kLine_Full_Height (ScreenWidth - 40 - 40)
@interface QiHuoDetailVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,UITextViewDelegate,SGPageContentCollectionViewDelegate,SGPageTitleViewDelegate,SGCenterChildBaseVCDelegate,BTViewRotationHeaderDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;
@property (nonatomic, strong) UIScrollView *childVCScrollView;
@property (nonatomic, strong) SGCenterTableView *tableView;

@property (nonatomic, strong) BTDetailHeaderView *detailHeaderView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) QuotesSegment *quotesSegmentView;

@property (nonatomic, strong) QuotesDetailSectionView *sectionView;

@property (nonatomic, assign) BOOL isShowFenshiOption;

@property (nonatomic, strong) OptiontimeView *optiontimeView;

@property (nonatomic, strong) OptionIndexView *mainIndexView;

@property (nonatomic, strong) BTLoadingView *loadingKLineView;

@property (nonatomic, strong) BTBaseRequest *marketRealtimeRequest;

@property (nonatomic, strong) CurrencyModel *cryModel;

@property (nonatomic, strong) CurrencyModel *priCryModel;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger klineType;
@property (nonatomic, strong) NSMutableArray *arrKLine;

@property (nonatomic, strong) Y_StockChartView *klineView;

@property (nonatomic, strong) BTLoadingView *loadingHeaderView;

@property (nonatomic, assign) BOOL isStartFenshi;
@property (nonatomic, strong) UIView *viewRotation;

@property (nonatomic, assign) BOOL isCNY;

@property (nonatomic, assign) BOOL isFullScreen;

@property (nonatomic, strong) NSTimer *timerOfTime;

@property (nonatomic, assign) BOOL isShizhi;

@property (nonatomic, assign) BOOL isScrollRight;

@property (nonatomic, strong) FenshiModel *pri20model;

@property (nonatomic, strong) UIImageView *imageViewGradient;

@property (strong, nonatomic) BTViewRotationHeader *viewRotationHeader;
@property (nonatomic, strong) dispatch_source_t sourceTimer;
@property (nonatomic, assign)BOOL isShowHeadLoading;

@end

@implementation QiHuoDetailVC

static CGFloat const PersonalCenterVCPageTitleViewHeight = 44;

- (CGFloat)topViewHeight{
    return 470.0f +60.0f +29 - 20.0f;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        self.isCNY = NO;
        if (kIsCNY) {
            self.isCNY = YES;
        }else{
            self.isCNY = NO;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.klineType = 0;
    [self foundTableView];
    [self configView];
    [self fetchVolumnRatio];
    [self requestKLine:RefreshStateNormal];
    [self startTimer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(acceptMsgOfSubView:)
                                                 name:@"kline_scroll" object:nil];
    
}

- (void)acceptMsgOfSubView:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *canScroll = userInfo[@"canScroll"];
    if ([canScroll isEqualToString:@"1"]) {
        self.tableView.scrollEnabled = YES;
    }else if([canScroll isEqualToString:@"0"]) {
        self.tableView.scrollEnabled = NO;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark --Create UI
- (void)foundTableView {
    CGFloat tableViewH = self.view.frame.size.height;
    self.tableView = [[SGCenterTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tableViewH) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionHeaderHeight = PersonalCenterVCPageTitleViewHeight;
    _tableView.rowHeight = self.view.frame.size.height - PersonalCenterVCPageTitleViewHeight;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
}
//
- (UIView*)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, ScreenWidth, [self topViewHeight])];
        [_headerView addSubview:self.detailHeaderView];
        [self.detailHeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_headerView);
        }];
    }
    return _headerView;
}

- (BTDetailHeaderView*)detailHeaderView{
    if(!_detailHeaderView){
        _detailHeaderView = [BTDetailHeaderView loadFromXib];
    }
    return _detailHeaderView;
}

- (SGPageTitleView *)pageTitleView {
    if (!_pageTitleView) {
        NSArray *titleArr;
        if(![[self getExchangeCode] isEqualToString:@"okex"]){
            titleArr = @[[APPLanguageService sjhSearchContentWith:@"jianjie"],[APPLanguageService sjhSearchContentWith:@"lunbi"]];
        }else{
            titleArr  = @[[APPLanguageService sjhSearchContentWith:@"jianjie"],[APPLanguageService sjhSearchContentWith:@"cicangzongliang"],[APPLanguageService sjhSearchContentWith:@"quxiangzhibiao"],[APPLanguageService sjhSearchContentWith:@"lunbi"]];
        }
        SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
        configure.titleSelectedColor = kHEXCOLOR(0x108ee9);
        configure.indicatorColor = kHEXCOLOR(0x108ee9);
        configure.titleColor = FirstColor;
        _pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, ScreenWidth, PersonalCenterVCPageTitleViewHeight) delegate:self titleNames:titleArr configure:configure];
        _pageTitleView.backgroundColor = isNightMode ? ViewContentBgColor :CWhiteColor;
    }
    return _pageTitleView;
}

- (SGPageContentCollectionView *)pageContentCollectionView {
    if (!_pageContentCollectionView) {
        BTFutureIntroduceVC *introduceVC = [[BTFutureIntroduceVC alloc] init];
        introduceVC.delegatePersonalCenterChildBaseVC = self;
        introduceVC.code = [self getKindCode];
        introduceVC.futureCode = [self getExchangeCode];
        
        DiscussViewController *discussVC = [[DiscussViewController alloc] init];
        discussVC.delegatePersonalCenterChildBaseVC = self;
        discussVC.kindCode = [NSString stringWithFormat:@"%@@%@",[self getExchangeCode],[self getKindCode]];
        discussVC.postCode = [NSString stringWithFormat:@"[%@,%@](2&%@&%@&%@)",[self getExchangeCode],[self getKindName],[self getExchangeCode],[self getKindName],[self getKindCode]];
        discussVC.type = 4;
        
        NSArray *childArr;
        if(![[self getExchangeCode] isEqualToString:@"okex"]){
            childArr = @[introduceVC,discussVC];
        }else{
            BTFutureTotalHoldingVC *totalHoldingVC = [[BTFutureTotalHoldingVC alloc] init];
            totalHoldingVC.delegatePersonalCenterChildBaseVC = self;
            totalHoldingVC.code = [self getKindCode];
            totalHoldingVC.futureCode = [self getExchangeCode];
            
            BTFutureDMIVC *dmiVC = [[BTFutureDMIVC alloc] init];
            dmiVC.delegatePersonalCenterChildBaseVC = self;
            dmiVC.code = [self getKindCode];
            dmiVC.futureCode = [self getExchangeCode];
            childArr = @[introduceVC,totalHoldingVC,dmiVC,discussVC];
        }
        
        CGFloat ContentCollectionViewHeight = self.view.frame.size.height  - PersonalCenterVCPageTitleViewHeight; //- PersonalCenterVCNavHeight;
        _pageContentCollectionView = [[SGPageContentCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ContentCollectionViewHeight) parentVC:self childVCs:childArr];
        _pageContentCollectionView.delegatePageContentCollectionView = self;
    }
    return _pageContentCollectionView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.childVCScrollView && _childVCScrollView.contentOffset.y > 0) {
        self.tableView.contentOffset = CGPointMake(0, [self topViewHeight]);
    }
    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY < [self topViewHeight]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pageTitleViewToTop" object:nil];
    }
}
- (void)personalCenterChildBaseVCScrollViewDidScroll:(UIScrollView *)scrollView {
    self.childVCScrollView = scrollView;
    if (self.tableView.contentOffset.y < [self topViewHeight]) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    } else {
        self.tableView.contentOffset = CGPointMake(0, [self topViewHeight]);
        scrollView.showsVerticalScrollIndicator = YES;
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
    return self.pageTitleView;
}

#pragma mark - - - SGPageTitleViewDelegate - SGPageContentCollectionViewDelegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentCollectionView setPageContentCollectionViewCurrentIndex:selectedIndex];
    //
    if(selectedIndex == 0){
        [AnalysisService alaysisDetail_prospectus];
    }else if(selectedIndex ==1){
        [MobClick event:@"analysis"];
    }else if(selectedIndex ==2){
        [AnalysisService alaysisDetail_discussion];
    }else if(selectedIndex == 3){
        [AnalysisService alaysisDetail_market];
    }
}

- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    _tableView.scrollEnabled = NO;
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView offsetX:(CGFloat)offsetX {
    _tableView.scrollEnabled = YES;
}
//
- (NSString*)getKindCode{
    NSString *strCode = @"";
    NSDictionary *dict = self.parameters;
    if ([dict.allKeys containsObject:@"kindCode"]) {
        strCode = SAFESTRING(dict[@"kindCode"]);
    }
   return strCode;
}

- (NSString*)getKindName{
    NSString *strCode = @"";
    NSDictionary *dict = self.parameters;
    if ([dict.allKeys containsObject:@"kindName"]) {
        strCode = SAFESTRING(dict[@"kindName"]);
    }
    return strCode;
}
- (NSString*)getExchangeCode{
    NSDictionary *dict = self.parameters;
    NSString *exchangeCode = SAFESTRING(dict[@"exchangeCode"]);
    if([dict.allKeys containsObject:@"exchangeCode"]&& exchangeCode.length>0){
        return dict[@"exchangeCode"];
    }
    return @"";
}

- (void)startTimer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:[BTConfigureService shareInstanceService].timeSepa target:self selector:@selector(fetchList) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
}
- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}
- (void)fetchList{
    if(!self.isShowHeadLoading){
        [self requestRealTime:RefreshStateNormal];
    }else{
        [self requestRealTime:RefreshStatePull];
    }
}
#pragma mark - BTLoadingViewDelegate

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [AnalysisService alaysisDetail_page];
    //好评引导
    if (![UserDefaults boolForKey:isOrNoGoodGuideTishi]) {
        
        NSInteger i = [UserDefaults integerForKey:BTGoodGuideTishi];
        i++;
        [UserDefaults setInteger:i forKey:BTGoodGuideTishi];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopTimer];
    [self stopKlineTimer];
}

- (void)configView{
    WS(ws);
    [self configKLineView];
    NSString *strCode = [NSString stringWithFormat:@"%@,%@",[self getExchangeCode],[self getKindName]];
    //
    
    self.title = strCode;
    [self.quotesSegmentView showInViewWith:self.detailHeaderView.viewSegment];
    self.tableView.tableHeaderView = self.headerView;
    self.detailHeaderView.type = self.klineType;

    self.detailHeaderView.scrollViewWidthConst.constant = ScreenWidth;
    self.loadingKLineView = [[BTLoadingView alloc] initWithParentView:self.detailHeaderView.klineBgView aboveSubView:nil delegate:nil];
    
//    self.loadingHeaderView = [[BTLoadingView alloc] initWithParentView:self.detailHeaderView.viewQuotesHeader aboveSubView:nil delegate:nil];
    
    self.quotesSegmentView.fenshiTitle = [APPLanguageService sjhSearchContentWith:@"fenshi"];
    self.quotesSegmentView.indexTitle = [APPLanguageService sjhSearchContentWith:@"more"];
    
    //全屏
    self.quotesSegmentView.fullScreenBlock = ^{
        ws.isFullScreen = YES;
        ws.tableView.tableHeaderView  = nil;
        ws.detailHeaderView.isFullScreen = YES;
        //全屏覆盖的view
        ws.viewRotation = [[NSBundle mainBundle] loadNibNamed:@"QuotesRotationView" owner:ws options:nil][0];
        ws.viewRotation.backgroundColor = isNightMode?ViewContentBgColor :CWhiteColor;
        ws.detailHeaderView.scrollViewFenshi.backgroundColor = isNightMode?ViewContentBgColor :CWhiteColor;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:ws.viewRotation];
        [ws.viewRotation mas_makeConstraints:^(MASConstraintMaker *make) {
            if (iPhoneX) {
                make.width.mas_equalTo(window.frame.size.height - 20);
                make.height.equalTo(window.mas_width);
                make.centerX.equalTo(window);
                make.centerY.equalTo(window.mas_centerY).offset(20);
            }else{
                make.width.equalTo(window.mas_height);
                make.height.equalTo(window.mas_width);
                make.center.equalTo(window);
            }
        }];
        //头部
        ws.viewRotationHeader = [[[NSBundle mainBundle] loadNibNamed:@"BTViewRotationHeader" owner:ws options:nil] lastObject];
        CurrencyModel *model = ws.cryModel;
        model.kind = [ws getKindName];
        ws.viewRotationHeader.cryModel = model;
        ws.viewRotationHeader.delegate = ws;
        [ws.viewRotation addSubview:ws.viewRotationHeader];
        [ws.viewRotationHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(ws.viewRotation);
            make.right.equalTo(ws.viewRotation).offset(iPhoneX?(-15):0);
            make.height.mas_equalTo(50);
        }];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        ws.quotesSegmentView.isShowFullScreen = NO;
        //选择类型view
        [ws.viewRotation addSubview:ws.quotesSegmentView];
        [ws.quotesSegmentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.viewRotationHeader.mas_bottom);
            make.left.right.equalTo(ws.viewRotation);
            make.height.mas_equalTo(30);
        }];
        
        //k线图
        [ws.viewRotation addSubview:ws.detailHeaderView.scrollViewFenshi];
        [ws.detailHeaderView.scrollViewFenshi mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.quotesSegmentView.mas_bottom);
            make.left.right.equalTo(ws.viewRotation);
            make.bottom.equalTo(ws.viewRotation);
        }];
        
        //浮层
        [ws.viewRotation addSubview:ws.detailHeaderView.horizotalKlineIndicator];
        [ws.detailHeaderView.horizotalKlineIndicator mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.quotesSegmentView.mas_bottom).offset(-30);
            make.left.equalTo(ws.viewRotation).offset(0);
            make.right.equalTo(ws.viewRotation);
            make.height.mas_offset(30);
        }];
        
        [ws.viewRotation addSubview:ws.detailHeaderView.timelineWarningView];
        [ws.detailHeaderView.timelineWarningView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ws.quotesSegmentView.mas_bottom).offset(-30);
            make.left.equalTo(ws.viewRotation).offset(0);
            make.right.equalTo(ws.viewRotation);
            make.height.mas_offset(30);
        }];
        
        [ws resetKlineFrame];
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        ws.viewRotation.transform = CGAffineTransformMakeRotation(M_PI_2);
        ws.klineView.isFullScreen = YES;
        [ws.klineView reloadData];
    };
    //
    self.quotesSegmentView.segmentBlock = ^(NSInteger segmentType,QuotesSegment *segment, BOOL isShowFenshiOption,BOOL isHideAlpha) {
        ws.isShowFenshiOption = isShowFenshiOption;
        if (isShowFenshiOption) {
            if(segmentType == 0){//分时数据
                [ws stopKlineTimer];
                ws.optiontimeView.hiddenblock = ^{
                    segment.isShow = NO;
                };
                __strong __typeof(ws)strongSelf = ws;
                strongSelf.optiontimeView.optionTypeBlock = ^(NSInteger type,NSString *str) {
                    ws.quotesSegmentView.fenshiTitle = str;
                    [ws resetKlineFrame];
                    ws.klineType = type;
                    [ws requestKLine:RefreshStateNormal];
                };
                if (ws.isFullScreen) {
                    __strong __typeof(ws)strongSelf = ws;
                    strongSelf.optiontimeView.viewRotation = strongSelf.viewRotation;
                    [strongSelf.optiontimeView showInParentView:strongSelf.viewRotation relativeView:strongSelf.quotesSegmentView];
                }else{
                    __strong __typeof(ws)strongSelf = ws;
                    strongSelf.optiontimeView.viewRotation = nil;
                    [strongSelf.optiontimeView showInParentView:strongSelf.view relativeView:strongSelf.quotesSegmentView];
                }
            }else{//指标
                
                [ws stopKlineTimer];
                
                ws.mainIndexView.hiddenblock = ^{
                    segment.isShow = NO;
                };
                ws.mainIndexView.mainTag = [AppHelper mainIndex];
                ws.mainIndexView.accessoryTag = [AppHelper accessoryIndex];
                
                ws.mainIndexView.dataArr = [DetailHelper mainIndexArr];
                
                __strong __typeof(ws)strongSelf = ws;
                strongSelf.mainIndexView.optionTypeBlock = ^(NSInteger type,NSString *str) {
                    // 主要指标 显示不同的主要样式
                    if(type <= 104){
                        [ws.klineView refreshWithAccesoryLineStatus:type];
                        [AppHelper saveAccessoryIndex:SAFESTRING(@(type))];
                        
                    }else{
                        [ws.klineView refreshWithTargetLineStatus:type];
                        [AppHelper saveMainIndex:SAFESTRING(@(type))];
                        
                    }
                };
                if (ws.isFullScreen) {
                    __strong __typeof(ws)strongSelf = ws;
                    strongSelf.mainIndexView.viewRotation = strongSelf.viewRotation;
                    [strongSelf.mainIndexView showInParentView:strongSelf.viewRotation relativeView:strongSelf.quotesSegmentView];
                }else{
                    __strong __typeof(ws)strongSelf = ws;
                    strongSelf.mainIndexView.viewRotation = nil;
                    [strongSelf.mainIndexView showInParentView:strongSelf.view relativeView:strongSelf.quotesSegmentView];
                }
            }
            
        }else{
            [ws stopKlineTimer];
            if (segmentType != 0 &&segmentType!= 16) {
                [ws resetKlineFrame];
                ws.klineType = segmentType;
                [ws requestKLine:RefreshStateNormal];
                
            }else{
                if(segmentType == 16){
                    [ws.mainIndexView fromeWithTitle:ws.quotesSegmentView.indexTitle];
                    
                }else if(segmentType == 0){//分时
                    if([ws.quotesSegmentView.fenshiTitle isEqualToString:[APPLanguageService sjhSearchContentWith:@"fenshi"]]){
                        [ws resetKlineFrame];
                        ws.klineType = 0;
                        [ws requestKLine:RefreshStateNormal];
                        
                        //定时器
                        [ws startKlineTimer];
                        
                    }else{
                        [ws.optiontimeView fromeWithTitle:ws.quotesSegmentView.fenshiTitle];
                    }
                    
                }
            }
        }
    };
}
- (void)resetKlineFrame{
    if (iPhoneX) {
        self.detailHeaderView.scrollViewWidthConst.constant = ScreenHeight - 50;
    }else{
        self.detailHeaderView.scrollViewWidthConst.constant = ScreenHeight;
    }
    if (self.isFullScreen) {
        self.klineView.frame = CGRectMake(0, 0, iPhoneX?(ScreenHeight - 50): ScreenHeight, future_kLine_Full_Height);
    }
}
//
- (void)configKLineView{
    _klineView = [[Y_StockChartView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 390.0f)];
    _klineView.backgroundColor = [UIColor backgroundColor];
    [self.detailHeaderView.scrollViewFenshi addSubview:self.klineView];
}
- (void)fetchVolumnRatio{
    BTVolumnRatioApi *volumnRatioApi =  [[BTVolumnRatioApi alloc] initWithCode:[self getKindCode] exchangeCode:[self getExchangeCode] isFuture:1];
    [volumnRatioApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data&&SAFESTRING(request.data).length >0){
            self.klineView.ratio = [SAFESTRING(request.data) doubleValue];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
//k线网络请求
- (void)requestKLine:(RefreshState)state{
    NSInteger type ;
    if(self.klineType == 0 ){
        type = 1;
    }else{
        type = self.klineType;
    }
    NSString *strCode = [self getKindCode];
    if (strCode.length == 0) {
        return;
    }
    self.detailHeaderView.type = self.klineType;
    BTFutureKlineApi *kRequest = [[BTFutureKlineApi alloc] initWithKind:strCode klineType:type futureCode:[self getExchangeCode]];
    if(state == RefreshStateNormal){
        [self.loadingKLineView showLoading];
    }
    [kRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        
        [self.arrKLine removeAllObjects];
        __block KLineModel *primodel;
        
        NSArray<NSDictionary*> *data = request.data;
        
        if([data isKindOfClass:[NSDictionary class]]){
            [self.loadingKLineView showNoDataWith:@"zanwushuju"];
        }
        
        if([data isKindOfClass:[NSArray class]]){
            if(data.count == 0){
                [self.loadingKLineView showNoDataWith:@"zanwushuju"];
                return;
            }else{
                [self.loadingKLineView hiddenLoading];
            }
            
        }
        //        int numberOfLinesPerDay = 1;
        //        double lastVol = 0;
        //        if ([data count] > 1) {
        //            KLineModel *first = [KLineModel modelWithJSON:[data objectAtIndex:0]];
        //            KLineModel *second = [KLineModel modelWithJSON:[data objectAtIndex:1]];
        //            long long timeSeconds = (second.currentTime - first.currentTime);
        //
        //            if(timeSeconds != 0){
        //                numberOfLinesPerDay = round(86400000 / timeSeconds);
        //            }
        //
        //            // 一天最多1440分钟
        //            numberOfLinesPerDay = MAX(MIN(numberOfLinesPerDay, 1440), 1);
        //            lastVol = first.volume / ((double) numberOfLinesPerDay);
        //        }
        for(NSUInteger i = 0; i<data.count; i++){
            NSDictionary *dic = data[i];
            KLineModel *model = [KLineModel modelWithJSON:dic];
            YKLineEntity * entity = [[YKLineEntity alloc]init];
            entity.high = model.maxPrice;
            entity.low = model.minPrice;
            
            entity.close = model.closePrice;
            entity.highStr = [DigitalHelperService isTransformWithDouble:model.maxPrice];
            entity.lowStr = [DigitalHelperService isTransformWithDouble:model.minPrice];
            entity.closeStr = [DigitalHelperService isTransformWithDouble:model.closePrice];
            entity.time = model.currentTime;
            
            if (self.klineType >=10) {
                entity.date = [[NSDate dateWithTimeIntervalSince1970:model.currentTime / 1000.0] stringWithFormat:@"MM/dd"];
            }else{
                entity.date = [[NSDate dateWithTimeIntervalSince1970:model.currentTime / 1000.0] stringWithFormat:@"HH:mm"];
            }
            
            if (primodel) {
                //                double priAverage = primodel.volume / numberOfLinesPerDay;
                //                // 有时会出现前一个点量为0的情况
                //                if (priAverage == 0) {
                //                    priAverage = model.volume / numberOfLinesPerDay;
                //                }
                //                double newVol = priAverage + model.volume - primodel.volume;
                //                newVol = MIN(MAX(newVol, priAverage * 0.3), priAverage * 3);
                //                entity.volume = newVol;
                entity.volume = model.volume;
                entity.open = primodel.closePrice;
                entity.preClosePx = primodel.closePrice;
            }else{
                entity.volume = model.volume; /// numberOfLinesPerDay;
                entity.open = model.openPrice;
            }
            
            entity.openStr = [DigitalHelperService isTransformWithDouble:entity.open];
            primodel = model;
            [self.arrKLine addObject:entity];
        }
        
        if (self.isFullScreen) {
            if (iPhoneX) {
                self.klineView.frame = CGRectMake(0, 0, ScreenHeight - 50, future_kLine_Full_Height);
            }else{
                self.klineView.frame = CGRectMake(0, 0, ScreenHeight, future_kLine_Full_Height);
            }
            
        }else{
            self.klineView.frame = CGRectMake(0, 0, ScreenWidth, 390);
        }
        Y_StockChartCenterViewType type;
        if(self.klineType ==0){
            type = Y_StockChartcenterViewTypeTimeLine;
        }else{
            type = Y_StockChartcenterViewTypeKline;
        }
        
        self.klineView.isUpdateTimeLine = YES;
        Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:self.arrKLine];
        [self.klineView refreshKlineType:type data:groupModel.models];
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingKLineView showErrorWith:request.resultMsg];
        
    }];
}
//请求一条分时数据
- (void)requestRealTime:(RefreshState)state{
    if(state == RefreshStateNormal){
        [self.loadingHeaderView showLoading];
    }
    NSMutableArray *arrKindList = [NSMutableArray array];
    BOOL isCurrency = NO;
    [arrKindList addObject:[self getKindCode]];
    self.marketRealtimeRequest = [[BTFutureRealtimePointApi alloc] initWithFutureCode:[self getExchangeCode] kindList:arrKindList];
    
    [self.marketRealtimeRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingHeaderView hiddenLoading];
        self.isShowHeadLoading = YES;
        if ([request.data isKindOfClass:[NSNull class]]) {
            return;
        }
        FenshiModel *fenshiModel;
        for (NSDictionary *dic in request.data) {
            fenshiModel = [[FenshiModel alloc] init];
            if(![[self getKindCode] containsString:@"/"]) {//市值
                fenshiModel.priceCNY = [dic[@"priceCNY"] doubleValue];
                fenshiModel.priceUSD = [dic[@"priceUSD"] doubleValue];
                if (self.isCNY) {
                    fenshiModel.price = fenshiModel.priceCNY;
                    fenshiModel.maxPrice = [dic[@"maxPriceCNY"] doubleValue];
                    fenshiModel.minPrice = [dic[@"minPriceCNY"] doubleValue];
                }else{
                    fenshiModel.price = fenshiModel.priceUSD;
                    fenshiModel.maxPrice = [dic[@"maxPriceUSD"] doubleValue];
                    fenshiModel.minPrice = [dic[@"minPriceUSD"] doubleValue];
                }
            }else{
                fenshiModel.price = [dic[@"price"] doubleValue];
                fenshiModel.maxPrice = [dic[@"maxPrice"] doubleValue];
                fenshiModel.minPrice = [dic[@"minPrice"] doubleValue];
            }
            fenshiModel.isCurrency = isCurrency;
            //接口不一致，返回数据不一样
            fenshiModel.time =  [SAFESTRING(dic[@"currentTime"]) longLongValue];
            fenshiModel.volum = [dic[@"volum"] doubleValue];
            fenshiModel.totalVolum = [dic[@"volum"] doubleValue];
            
            self.cryModel = [CurrencyModel modelWithJSON:dic];
        }
        
        if(self.klineType == 0){
            //fen
            NSArray *arr = [DetailHelper updateItem:fenshiModel arr:self.arrKLine];
            if(arr.count == 0) return;
            Y_StockChartCenterViewType type;
            type = Y_StockChartcenterViewTypeTimeLine;
            Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:arr];
            [self.klineView refreshKlineType:type data:groupModel.models];
            //
            [self.klineView refreshTimeLine];
        }
        
        //实时刷新头部视图
        self.detailHeaderView.cryModel = self.cryModel;
        //变化刷新变化颜色
        self.detailHeaderView.priCryModel = self.cryModel.modelCopy;
    } failure:^(__kindof BTBaseRequest *request) {
        //        [self.loadingHeaderView showErrorWith:request.resultMsg];
        [self.loadingHeaderView hiddenLoading];
    }];
}
#pragma mark - Lazy
- (NSMutableArray *)arrKLine{
    if (!_arrKLine) {
        _arrKLine = [NSMutableArray array];
    }
    return _arrKLine;
}

- (OptiontimeView *)optiontimeView{
    if (!_optiontimeView) {
        _optiontimeView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OptiontimeView class]) owner:self options:nil][0];
        _optiontimeView.dataArr = [DetailHelper fenshiSelectArr];
    }
    return _optiontimeView;
}

- (OptionIndexView *)mainIndexView{
    if (!_mainIndexView) {
        _mainIndexView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OptionIndexView class]) owner:self options:nil][0];
        
    }
    return _mainIndexView;
}

- (QuotesSegment *)quotesSegmentView{
    if (!_quotesSegmentView) {
        _quotesSegmentView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([QuotesSegment class]) owner:self options:nil][0];
    }
    return _quotesSegmentView;
}

- (void)exitFullScreen{
    self.tableView.tableHeaderView = self.headerView;
    self.isFullScreen = NO;
    self.detailHeaderView.isFullScreen = NO;
    self.klineView.isFullScreen = NO;
    self.detailHeaderView.type = self.klineType;
    [self.headerView addSubview:self.detailHeaderView];
    self.detailHeaderView.scrollViewWidthConst.constant = ScreenWidth;
    
    [self.detailHeaderView addSubview:self.detailHeaderView.viewSegment];
    [self.quotesSegmentView showInViewWith:self.detailHeaderView.viewSegment];
    self.quotesSegmentView.isShowFullScreen = YES;
    [self.detailHeaderView addSubview:self.detailHeaderView.scrollViewFenshi];
    
    [self.detailHeaderView.scrollViewFenshi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.detailHeaderView);
        make.bottom.equalTo(self.detailHeaderView.mas_bottom).offset(-10);
        make.top.equalTo(self.detailHeaderView.viewSegment.mas_bottom);
    }];
    
    [self.detailHeaderView addSubview:self.detailHeaderView.viewWarning];
    [self.detailHeaderView.viewWarning mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailHeaderView.viewSegment.mas_top);
        make.left.right.equalTo(self.detailHeaderView);
        make.height.mas_offset(40.0f);
    }];
    
    [self.detailHeaderView addSubview:self.detailHeaderView.timelineWarningView];
    [self.detailHeaderView.timelineWarningView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailHeaderView.viewSegment.mas_top);
        make.left.right.equalTo(self.detailHeaderView);
        make.height.mas_offset(40.0f);
    }];
    
    [self.detailHeaderView.viewSegment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.detailHeaderView);
        make.top.equalTo(self.detailHeaderView.viewQuotesHeader.mas_bottom);
        make.height.mas_equalTo(40.0f);
    }];
    self.klineView.frame = CGRectMake(0, 0, ScreenWidth, 390.0f);
    [UIView animateWithDuration:0.3 animations:^{
        self.viewRotation.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.viewRotation removeFromSuperview];
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.klineView reloadData];
    [self.tableView reloadData];
}

- (void)startKlineTimer{
    
}

- (void)stopKlineTimer{
    if(_sourceTimer){
        dispatch_source_cancel(_sourceTimer);
        _sourceTimer = nil;
    }
}


@end
