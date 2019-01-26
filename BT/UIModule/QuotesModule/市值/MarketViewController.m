//
//  MarketViewController.m
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MarketViewController.h"
#import "MarketCell.h"
#import "MyOptionSectionView.h"
#import "MarketRequest.h"
#import "MarketModel.h"
#import "BTRefreshHeader.h"
#import "MarketRealtimeRequest.h"
#import "BTConfigureService.h"
#import "AlertView.h"
#import "NewFeatureTipsView.h"
static NSString *const identifier = @"MarketCell";

@interface MarketViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,BTLoadingViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewTop;

@property (nonatomic, strong) MyOptionSectionView *sectionView;

@property (weak, nonatomic) IBOutlet UITableView *tableViewContainer;

@property (nonatomic, strong) NSMutableArray *arrData;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, assign) NSInteger sortType;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *arrChange;

@property (nonatomic, strong) MarketRealtimeRequest *marketRealtimeRequest;

@property (nonatomic, strong) NSMutableArray *arrKindList;

@property (nonatomic, strong) NSMutableArray *arrKindNameList;

@property (nonatomic, strong) BTLoadingView *loadingView;

@property (nonatomic, strong) AlertView *alertView;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, assign) NSInteger orderNumber;

@property (nonatomic, strong) NSMutableArray *arrKSortNameList;

@property (nonatomic, strong) NSMutableArray *arrPriceList;

@property (nonatomic, assign) BOOL isCNY;

@property (nonatomic, strong) NewFeatureTipsView *NewFeatureView;

@end

@implementation MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configView];
    self.pageIndex = 1;
    self.sortType = 8;
    self.orderNumber = 1;
    if (kIsCNY) {
        self.isCNY = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRequest) name:NSNotification_needRequest object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)needRequest{
    if (self.arrData.count > 0) {
        return;
    }
    NSInteger index = [BTConfigureService shareInstanceService].index;
    NSArray *vcs = [[self.navigationController visibleViewController] childViewControllers];
    if (index < vcs.count) {
        if ([vcs[index] isEqual:self]) {
            [self requestList:RefreshStateNormal];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (ISNSStringValid([APPLanguageService readNewFeatureTipsType])&&!ISNSStringValid([APPLanguageService readIsOrNoPromptType])) {//如果新功能已提示 但是引导用户页面没提示
        
        [self creatGuideTheUser];
    }
    
    // 修复记录页面返回的bug
    if (self.arrData.count > 0) {
        return;
    }
    NSInteger index = [BTConfigureService shareInstanceService].index;
    NSArray *vcs = [[self.navigationController visibleViewController] childViewControllers];
    if (index < vcs.count) {
        if ([vcs[index] isEqual:self]) {
            [self requestList:RefreshStateNormal];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [AnalysisService alaysisMarket_page];
    NSInteger index = [BTConfigureService shareInstanceService].index;
    NSArray *vcs = [[self.navigationController visibleViewController] childViewControllers];
    if (index < vcs.count) {
        if ([vcs[index] isEqual:self]) {
            [self startTimer];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopTimer];
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

- (void)configView{
    self.sectionView.isShizhi = YES;
    [self.sectionView showInViewWith:self.viewTop];
    WS(ws);
    self.sectionView.sortBlock = ^(NSInteger type) {
        [AnalysisService alaysisMarket_sort_name];
        ws.sortType = type;
        ws.pageIndex = 1;
        [ws requestList:RefreshStateNormal];
    };
    
    self.sectionView.sortShizhiBlock = ^(NSInteger type) {
        [AnalysisService alaysisMarket_sort_market];
        ws.sortType = type;
        ws.pageIndex = 1;
        [ws requestList:RefreshStateNormal];
    };
    self.sectionView.sortPriceBlock = ^(NSInteger type) {
        [AnalysisService alaysisMarket_sort_price];
        ws.sortType = type;
        ws.pageIndex = 1;
        [ws requestList:RefreshStateNormal];
    };
    self.sectionView.countBlock = ^(NSInteger type) {
        [AnalysisService alaysisMarket_sort_deal];
        ws.sortType = type;
        ws.pageIndex = 1;
        [ws requestList:RefreshStateNormal];
    };
    self.sectionView.handleBlock = ^(NSInteger type) {
        [AnalysisService alaysisMarket_sort_increase];
        ws.sortType = type;
        ws.pageIndex = 1;
        [ws requestList:RefreshStateNormal];
    };
    [_tableViewContainer registerNib:[UINib nibWithNibName:NSStringFromClass([MarketCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableViewContainer.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
    }];
    [_tableViewContainer configToTop:^{
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
    }];
    _tableViewContainer.delegate = self;
    
    _tableViewContainer.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        self.pageIndex++;
        [self requestList:RefreshStateUp];
    }];
    
    _tableViewContainer.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableViewContainer delegate:self];
  
}

- (void)fetchList{
    NSArray *visibleArray =  [self.tableViewContainer indexPathsForVisibleRows];
    [self.arrKindList removeAllObjects];
    [self.arrKSortNameList removeAllObjects];
    [self.arrKindNameList removeAllObjects];
    [self.arrPriceList removeAllObjects];
    for (NSInteger i = 0; i < visibleArray.count; i++) {
        NSIndexPath *indexPath = visibleArray[i];
        MarketModel *model = self.arrData[indexPath.row];
        [self.arrKindList addObject:model.kindCode];
        [self.arrKSortNameList addObject:@(model.capitalizationSort)];
        [self.arrKindNameList addObject:model.kindName];
        if (self.isCNY) {
            [self.arrPriceList addObject:model.priceCNY];
        }else{
            [self.arrPriceList addObject:model.priceUSD];
        }
        
    }
    if (self.arrKindList.count == 0) {
        return;
    }
    self.marketRealtimeRequest = [[MarketRealtimeRequest alloc] initWithMarketType:1 kindList:self.arrKindList];
    [self.marketRealtimeRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.arrChange removeAllObjects];
        NSInteger i = -1;
        for (NSString *strCode in self.arrKindList) {
            i++;
            for (NSDictionary *dic in request.data) {
                MarketModel *model = [MarketModel modelWithJSON:dic];
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
                model.icon = [NSString stringWithFormat:@"%@?%@",model.icon,str];
                if ([model.kindCode isEqualToString:strCode]) {
                    model.capitalizationSort = [self.arrKSortNameList[i] integerValue];
                     model.kindName = self.arrKindNameList[i];
                    NSInteger type = [self comparePrice:model index:i];
                    model.type = type;
                    [self.arrChange addObject:model];
                }
            }
        }
        for (NSInteger i = 0; i < visibleArray.count; i++) {
            if (i < self.arrChange.count) {
                NSIndexPath *indexPath = visibleArray[i];
                MarketModel *model1 = self.arrChange[i];
                MarketModel *model2 = self.arrData[indexPath.row];
                model1.icon = model2.icon;
                //处理一下数据,防止数据不一致的问题
                model1.capitalizationUSD = model2.capitalizationUSD;
                model1.capitalization = model2.capitalization;
                if ([model1.kindCode isEqualToString:model2.kindCode]) {
                    [self.arrData insertObject:model1 atIndex:indexPath.row];
                    [self.arrData removeObjectAtIndex:indexPath.row + 1];
                }
            }
        }
//        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableViewContainer reloadData];
//        });
        
    } failure:^(__kindof BTBaseRequest *request) {
         [self.loadingView showErrorWith:request.resultMsg];
    }];
}

- (NSInteger)comparePrice:(MarketModel *)model index:(NSInteger)i{
    if (self.isCNY) {
        if ([model.priceCNY doubleValue] > [self.arrPriceList[i] doubleValue]) {
            return 1;
        }else if ([model.priceCNY doubleValue] == [self.arrPriceList[i] doubleValue]){
            return 0;
        }else{
            return 2;
        }
    }else{
        if ([model.priceUSD doubleValue] > [self.arrPriceList[i] doubleValue]) {
            return 1;
        }else if ([model.priceUSD doubleValue] == [self.arrPriceList[i] doubleValue]){
            return 0;
        }else{
            return 2;
        }
    }
   
}

- (void)requestList:(RefreshState)state{
   
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    MarketRequest *market = [[MarketRequest alloc] initWithCurrencyCode:@"" marketType:1 pageIndex:self.pageIndex sortType:self.sortType];
    [market requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.loadingView hiddenLoading];
            [self.tableViewContainer.mj_header endRefreshing];
            [self.tableViewContainer.mj_footer endRefreshing];
            [self.arrData removeAllObjects];
            if(![request.data isKindOfClass:[NSArray class]]) return;
            for (NSDictionary *dic in request.data) {
                MarketModel *model = [MarketModel modelWithJSON:dic];
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
                model.icon = [NSString stringWithFormat:@"%@?%@",model.icon,str];
                [self.arrData addObject:model];
            }
            NSString *hasNext = SAFESTRING(request.responseObject[@"hasNext"]);
            if ([hasNext isEqualToString:@"0"]) {
                self.tableViewContainer.mj_footer.hidden = YES;
            }else{
                self.tableViewContainer.mj_footer.hidden = NO;
                [self.tableViewContainer.mj_footer endRefreshing];
            }
        }else if (state == RefreshStateUp){
            for (NSDictionary *dic in request.data) {
                MarketModel *model = [MarketModel modelWithJSON:dic];
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
                model.icon = [NSString stringWithFormat:@"%@?%@",model.icon,str];
                [self.arrData addObject:model];
            }
            NSString *hasNext = SAFESTRING(request.responseObject[@"hasNext"]);
            if([hasNext isEqualToString:@"1"]){
                [self.tableViewContainer.mj_footer endRefreshing];
                
            }else{
                [self.tableViewContainer.mj_footer endRefreshingWithNoMoreData];
            }
            
        }
        [self.tableViewContainer reloadData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.tableViewContainer.mj_header endRefreshing];
        [self.tableViewContainer.mj_footer endRefreshing];
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    self.pageIndex = 1;
    [self requestList:RefreshStateNormal];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MarketCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.isCNY = self.isCNY;
    cell.model = self.arrData[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [AnalysisService alaysisMarket_page_list];
    MarketModel *model = self.arrData[indexPath.row];
    NSData *data = [model modelToJSONData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:dic];
}
    
#pragma mark - UIScrollDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.marketRealtimeRequest stop];
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [self startTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self startTimer];
}
#pragma mark - 创建提示视图
-(void)creatAlertView {
    
   [self creatNewFeatureTips];
}
#pragma mark - 新功能提示
-(void)creatNewFeatureTips {
    
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.6;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.backView];
    self.NewFeatureView.backgroundColor = [UIColor clearColor];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.NewFeatureView];
    [self.NewFeatureView.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.NewFeatureView.goDetailBtn addTarget:self action:@selector(goDetailBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [APPLanguageService writeNewFeatureTipsType:NewFeatureTips];
}
-(void)goDetailBtnClick {
    
    [AnalysisService alaysisHome_windows_button_01];
    [self.NewFeatureView removeFromSuperview];
    [self.backView removeFromSuperview];
    self.NewFeatureView = nil;
    self.backView  = nil;
    if (![getUserCenter isLogined]) {
        [getUserCenter loginoutPullView];
        return;
    }
    [BTCMInstance pushViewControllerWithName:@"LncomeStatisticsMain" andParams:nil];
}
-(void)closeBtnClick {
    
    [AnalysisService alaysisHome_windows_button_00];
    [self.NewFeatureView removeFromSuperview];
    [self.backView removeFromSuperview];
    self.NewFeatureView = nil;
    self.backView  = nil;
    [self creatGuideTheUser];
}

#pragma mark - 初次引导用户操作
-(void)creatGuideTheUser {
    
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0.6;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.backView];
    self.alertView.backgroundColor = [UIColor clearColor];
    self.alertView.labelL1.text = @"点击 “名称” 按照字母排序";
    self.alertView.labelL2.hidden = YES;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.alertView];
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(regionTableViewTap)];
    [self.alertView addGestureRecognizer:g];
}
-(void)regionTableViewTap {
    self.orderNumber++;
    if (self.orderNumber == 2) {
        
        self.alertView.leftLayout.constant = 100;
        self.alertView.labelL1.text = @"点击按照成交量排序";
        self.alertView.labelL2.hidden = YES;
    }
    if (self.orderNumber == 3) {
        
        self.alertView.labelL1.text = @"点击按照价格排序";
        self.alertView.labelL2.hidden = NO;
        self.alertView.labelL2.text = @"(价格为全网前十大交易所加权值哦)";
        self.alertView.leftLayout.constant = 170;
    }
    if (self.orderNumber == 4) {
        
        self.alertView.leftLayout.constant = ScreenWidth-60;
        self.alertView.labelL1.text = @"点击按照24H涨幅排序";
        self.alertView.labelL2.hidden = YES;
    }
    if (self.orderNumber == 5) {
        
        [self.alertView removeFromSuperview];
        [self.backView removeFromSuperview];
        self.alertView = nil;
        self.backView  = nil;
        [APPLanguageService writeIsOrNoPromptType:promptType];
    }
}

#pragma mark - Lazy
- (MyOptionSectionView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MyOptionSectionView class]) owner:self options:nil][0];
        _sectionView.type = SectionViewTypeMarket;
    }
    return _sectionView;
}

- (NSMutableArray *)arrKSortNameList{
    if (!_arrKSortNameList) {
        _arrKSortNameList = [NSMutableArray array];
    }
    return _arrKSortNameList;
}

- (NSMutableArray *)arrPriceList{
    if (!_arrPriceList) {
        _arrPriceList = [NSMutableArray array];
    }
    return _arrPriceList;
}

- (NSMutableArray *)arrData{
    if (!_arrData) {
        _arrData = [NSMutableArray array];
    }
    return _arrData;
}

- (NSMutableArray *)arrKindList{
    if (!_arrKindList) {
        _arrKindList = [NSMutableArray array];
    }
    return _arrKindList;
}

- (NSMutableArray *)arrKindNameList{
    if (!_arrKindNameList) {
        _arrKindNameList = [NSMutableArray array];
    }
    return _arrKindNameList;
}

- (NSMutableArray *)arrChange{
    if (!_arrChange) {
        _arrChange = [NSMutableArray array];
    }
    return _arrChange;
}
-(AlertView *)alertView {
    
    if (!_alertView) {
        
        _alertView = [AlertView loadFromXib];
        _alertView.frame = ScreenBounds;
    }
    
    return _alertView;
}
-(UIView *)backView {
    
    if (!_backView) {
        
        _backView = [[UIView alloc] init];
        _backView.frame = ScreenBounds;
    }
    
    return _backView;
}
-(NewFeatureTipsView *)NewFeatureView {
    
    if (!_NewFeatureView) {
        
        _NewFeatureView = [NewFeatureTipsView loadFromXib];
        _NewFeatureView.frame = ScreenBounds;
    }
    
    return _NewFeatureView;
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
