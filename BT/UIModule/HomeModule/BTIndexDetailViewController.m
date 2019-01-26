//
//  BTIndexDetailViewController.m
//  BT
//
//  Created by admin on 2018/6/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTIndexDetailViewController.h"
#import "SGCenterTableView.h"
#import "BTIndexDetailCell.h"
#import "BTIndexDetailSelectView.h"
#import "BTBitaneIndexModel.h"
#import "BTBitaneIndexDetailModel.h"

/*************币详情******************/
#import "BTNaviView.h"
#import "MyOptionCell.h"
#import "NewsCell.h"
#import "QuotesDetailSectionView.h"
#import "QuotesSegment.h"
#import "OptiontimeView.h"

#import "DiscussCurrencyRequest.h"
#import "IntrodueceRequest.h"
#import "YKLineEntity.h"

#import "QutoesDetailMarketRequest.h"
#import "QutoesDetailMarket.h"
#import "QutoesDetailMarketCurrencyRequest.h"

#import "MarketRealtimeRequest.h"
#import "CurrencyModel.h"
#import "FenshiRequest.h"
#import "FenshiModel.h"
#import "KLineHelper.h"
#import "FenshiView.h"
#import "KLineRequest.h"
#import "KLineModel.h"
#import "H5Node.h"
#import "H5ViewController.h"

#import "UIScrollView+PSRefresh.h"
#import "XHFootView.h"
#import "CommentsSameCell.h"

#import "ExchangeRealTimeReq.h"

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

#import "BTBitaneIndexRealtimeRequest.h"
#import "BTVolumnRatioApi.h"
#define kLine_Full_Height (ScreenWidth - 40 - 40)
static NSString *const identifier = @"BTIndexDetailCell";
@interface BTIndexDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BTViewRotationHeaderDelegate,BTLoadingViewDelegate>

@property (nonatomic, strong) SGCenterTableView *tableView;
@property (nonatomic, strong) BTIndexDetailSelectView*selectView;
@property (nonatomic, strong) BTBitaneIndexModel*detailModel;

/*************币详情******************/
@property (nonatomic, strong) KLineHelper *klineHelper;

@property (nonatomic, strong) BTDetailHeaderView *detailHeaderView;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) QuotesSegment *quotesSegmentView;

@property (nonatomic, strong) QuotesDetailSectionView *sectionView;

@property (nonatomic, assign) BOOL isShowFenshiOption;

@property (nonatomic, strong) OptiontimeView *optiontimeView;

@property (nonatomic, strong) OptionIndexView *mainIndexView;

@property (nonatomic, copy)   NSDictionary *dic;

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
@property (nonatomic, assign) BOOL isShowHeadLoading;

@end

@implementation BTIndexDetailViewController
//static CGFloat const PersonalCenterVCPageTitleViewHeight = 44;
static CGFloat const KLineHeight = 380;
- (CGFloat)topViewHeight{
     return 470.0f +60.0f +29 -30;
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
    self.detailModel = self.parameters[@"model"];
    self.dic = @{@"kindCode":self.detailModel.code,@"exchangeCode":self.detailModel.exchangeCode};
    self.klineType = 0;
    [self foundTableView];
    [self configView];
    [self fetchList];
    [self fetchVolumnRatio];
    [self requestKLine];
    [self startTimer];
    // Do any additional setup after loading the view.
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
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopTimer];
}
#pragma mark --Create UI
- (void)foundTableView {
    self.title = @"BTC指数";
    //CGFloat tableViewH = self.view.frame.size.height;
    self.tableView = [[SGCenterTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-kTopHeight) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTIndexDetailCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_tableView.rowHeight = self.view.frame.size.height - PersonalCenterVCPageTitleViewHeight;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    if (ISStringEqualToString(self.detailModel.code, @"BTC")) {
        
        self.selectView.indexProfileStr = [APPLanguageService wyhSearchContentWith:@"BTC_zhishushuoming"];
        [MobClick event:@"home_BTC"];
    }
    if (ISStringEqualToString(self.detailModel.code, @"ETH")) {
        
        self.selectView.indexProfileStr = [APPLanguageService wyhSearchContentWith:@"ETH_zhishushuoming"];
        [MobClick event:@"home_ETH"];
    }
    if (ISStringEqualToString(self.detailModel.code, @"BITANE")) {
        
        self.selectView.indexProfileStr = [APPLanguageService wyhSearchContentWith:@"Bitane_zhishushuoming"];
        self.selectView.typeL.fixText = @"mingcheng";
        [MobClick event:@"home_Bitane"];
    }
    _tableView.sectionHeaderHeight = [self.selectView getHeight];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailModel.indexDetailListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58.0f;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTIndexDetailCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index        = indexPath.row;
    cell.exchangeCode = self.detailModel.code;
    cell.model        = self.detailModel.indexDetailListArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.selectView;
}
- (NSString*)getKindCode{
    NSString *strCode;
    if ([self.dic.allKeys containsObject:@"kindCode"]) {
        strCode = SAFESTRING(self.dic[@"kindCode"]);
    }
    if ([self.dic.allKeys containsObject:@"currencyCode"]) {
        strCode = self.dic[@"currencyCode"];
        if ([self.dic.allKeys containsObject:@"currencyCodeRelation"]) {
            if ([self.dic[@"currencyCodeRelation"] length] > 0) {
                strCode = [NSString stringWithFormat:@"%@/%@",strCode,self.dic[@"currencyCodeRelation"]];
            }
        }
    }
    return strCode;
}

- (NSString*)getExchangeName{
    if([self.dic.allKeys containsObject:@"exchangeCode"]&&[self.dic.allKeys containsObject:@"exchangeName"]){
        return SAFESTRING(self.dic[@"exchangeName"]).length>0 ? SAFESTRING(self.dic[@"exchangeName"]) :SAFESTRING([APPLanguageService sjhSearchContentWith:@"quanwang"]);
    }else {
        return SAFESTRING([APPLanguageService sjhSearchContentWith:@"quanwang"]);
    }
}
- (NSString*)getExchangeCode{
    NSString *exchangeCode = SAFESTRING(self.dic[@"exchangeCode"]);
    if([self.dic.allKeys containsObject:@"exchangeCode"]&& exchangeCode.length>0){
        return self.dic[@"exchangeCode"];
    }else{
        return k_Net_Code;
    }
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
- (void)configView{
    WS(ws);
    [self configKLineView];
    self.title = self.detailModel.name; //strCode;
    [self.quotesSegmentView showInViewWith:self.detailHeaderView.viewSegment];
    self.tableView.tableHeaderView = self.headerView;
    self.detailHeaderView.type = self.klineType;
    self.detailHeaderView.scrollViewWidthConst.constant = ScreenWidth;
    self.loadingKLineView = [[BTLoadingView alloc] initWithParentView:self.detailHeaderView.klineBgView aboveSubView:nil delegate:self];
    
//    self.loadingHeaderView = [[BTLoadingView alloc] initWithParentView:self.detailHeaderView.viewQuotesHeader aboveSubView:nil delegate:self];
    
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
        ws.viewRotationHeader.cryModel = ws.cryModel;
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
                ws.optiontimeView.hiddenblock = ^{
                    segment.isShow = NO;
                };
                __strong __typeof(ws)strongSelf = ws;
                strongSelf.optiontimeView.optionTypeBlock = ^(NSInteger type,NSString *str) {
                    ws.quotesSegmentView.fenshiTitle = str;
                    [ws resetKlineFrame];
                    ws.klineType = type;
                    [ws requestKLine];
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
            if (segmentType != 0 &&segmentType!= 13) {
                [ws resetKlineFrame];
                ws.klineType = segmentType;
                [ws requestKLine];
                
            }else{
                if(segmentType == 13){
                    [ws.mainIndexView fromeWithTitle:ws.quotesSegmentView.indexTitle];
                    
                }else if(segmentType == 0){
                    if([ws.quotesSegmentView.fenshiTitle isEqualToString:[APPLanguageService sjhSearchContentWith:@"fenshi"]]){
                        [ws resetKlineFrame];
                        ws.klineType = 0;
                        [ws requestKLine];
                        
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
        self.klineView.frame = CGRectMake(0, 0, iPhoneX?(ScreenHeight - 50): ScreenHeight, kLine_Full_Height);
    }
}
//
- (void)configKLineView{
    _klineView = [[Y_StockChartView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, KLineHeight)];
    _klineView.backgroundColor = [UIColor backgroundColor];
    [self.detailHeaderView.scrollViewFenshi addSubview:self.klineView];
}
- (void)fetchVolumnRatio{
    BTVolumnRatioApi *volumnRatioApi =  [[BTVolumnRatioApi alloc] initWithCode:[self getKindCode] exchangeCode:[self getExchangeCode] isFuture:0];
    [volumnRatioApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data&&SAFESTRING(request.data).length >0){
            self.klineView.ratio = [SAFESTRING(request.data) doubleValue];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
//k线网络请求
- (void)requestKLine{
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
    KLineRequest *kRequest = [[KLineRequest alloc] initWithKind:strCode klineType:type exchangeCode:SAFESTRING([self getExchangeCode])];
    [self.loadingKLineView showLoading];
    [kRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingKLineView hiddenLoading];
        
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
                self.klineView.frame = CGRectMake(0, 0, ScreenHeight - 50, kLine_Full_Height);
            }else{
                self.klineView.frame = CGRectMake(0, 0, ScreenHeight, kLine_Full_Height);
            }
            
        }else{
            self.klineView.frame = CGRectMake(0, 0, ScreenWidth, KLineHeight);
        }
        
        if(self.arrKLine.count == 0) return;
        Y_StockChartCenterViewType type;
        if(self.klineType ==0){
            type = Y_StockChartcenterViewTypeTimeLine;
        }else{
            type = Y_StockChartcenterViewTypeKline;
        }
        
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
    NSInteger marketType = 1;
    BOOL isCurrency = NO;
    if([[self getKindCode] containsString:@"/"]){
        isCurrency = YES;
        marketType = 2;
    }else{
        marketType  = 1;
    }
    [arrKindList addObject:[self getKindCode]];
    self.marketRealtimeRequest = [[BTBitaneIndexRealtimeRequest alloc] initWithKindList:arrKindList];
    [self.marketRealtimeRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingHeaderView hiddenLoading];
        self.isShowHeadLoading = YES;
        if ([request.data isKindOfClass:[NSNull class]]) {
            return;
        }
        FenshiModel *fenshiModel;
        for (NSDictionary *dic in request.data) {
            fenshiModel = [[FenshiModel alloc] init];
            if (self.isShizhi) {
                fenshiModel.priceCNY = [dic[@"priceCNY"] doubleValue];
                fenshiModel.priceUSD = [dic[@"priceUSD"] doubleValue];
                if (self.isCNY) {
                    fenshiModel.price = fenshiModel.priceCNY;
                }else{
                    fenshiModel.price = fenshiModel.priceUSD;
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
        //实时刷新头部视图
        self.detailHeaderView.cryModel = self.cryModel;
        //变化刷新变化颜色
        self.detailHeaderView.priCryModel = self.cryModel.modelCopy;
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingHeaderView hiddenLoading];
        //[self.loadingHeaderView showErrorWith:request.resultMsg];
    }];
}
#pragma mark - BTLoadingViewDelegate
-(void)refreshingData {
    [self requestKLine];
}
#pragma mark lazy
-(BTIndexDetailSelectView *)selectView {
    
    if (!_selectView) {
        
        _selectView = [BTIndexDetailSelectView loadFromXib];
    }
    return _selectView;
}
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
- (NSMutableArray *)arrKLine{
    if (!_arrKLine) {
        _arrKLine = [NSMutableArray array];
    }
    return _arrKLine;
}

- (OptiontimeView *)optiontimeView{
    if (!_optiontimeView) {
        _optiontimeView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([OptiontimeView class]) owner:self options:nil][0];
        _optiontimeView.dataArr = [DetailHelper BTBitaneIndexFenshiSelectArr];
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
    self.klineView.frame = CGRectMake(0, 0, ScreenWidth, KLineHeight);
    [UIView animateWithDuration:0.3 animations:^{
        self.viewRotation.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self.viewRotation removeFromSuperview];
    }];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.klineView reloadData];
    [self.tableView reloadData];
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
