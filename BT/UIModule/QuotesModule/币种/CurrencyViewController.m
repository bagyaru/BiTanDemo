//
//  CurrencyViewController.m
//  BT
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CurrencyViewController.h"
#import "MyOptionCell.h"
#import "MyOptionSectionView.h"
#import "CurrencyRequest.h"
#import "CurrencyModel.h"
#import "MarketRealtimeRequest.h"
#import "BTConfigureService.h"

// 交易所
#import "ExchangeCurrencyReq.h"
#import "ExchangeRealTimeReq.h"
#import "BTExchangeListModel.h"

static NSString *const identifier = @"MyOptionCell";

@interface CurrencyViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,BTLoadingViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewTop;

@property (weak, nonatomic) IBOutlet UITableView *tableViewContainer;

@property (nonatomic, strong) MyOptionSectionView *sectionView;

@property (nonatomic, strong) NSMutableArray *arrData;

@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, assign) NSInteger sortType;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *arrChange;

@property (nonatomic, strong) MarketRealtimeRequest *marketRealtimeRequest;

@property (nonatomic, strong) NSMutableArray *arrKindList;

@property (nonatomic, strong) NSMutableArray *arrKindNameList;

@property (nonatomic, strong) BTLoadingView *loadingView;

@property (nonatomic, strong) NSMutableArray *arrPriceList;

@property (nonatomic, assign) BOOL isCNY;
@property (nonatomic, strong) BTExchangeListModel *exchangeModel;


@property (nonatomic, strong) BTBaseRequest *baseRealTimeRequest;
@property (nonatomic, strong) BTBaseRequest *baseRequest;


@end

@implementation CurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configView];
    self.pageIndex = 1;
    self.sortType = 6;
    if (kIsCNY) {
        self.isCNY = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRequest) name:NSNotification_needRequest object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exchangeDataList:) name:kNotification_ExchangeData_List object:nil];
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
    if(vcs.count == 0){
        [self requestList:RefreshStateNormal];
    }else{
        if (index < vcs.count) {
            if ([vcs[index] isEqual:self]) {
                [self requestList:RefreshStateNormal];
            }
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [AnalysisService alaysisTransaction_page];
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
    [self.sectionView showInViewWith:self.viewTop];
    WS(ws);
    self.sectionView.sortBlock = ^(NSInteger type) {
        [AnalysisService alaysisTransaction_sort_name];
        ws.sortType = type;
        ws.pageIndex = 1;
        [ws requestList:RefreshStateNormal];
    };
    self.sectionView.sortPriceBlock = ^(NSInteger type) {
        [AnalysisService alaysisTransaction_sort_price];
        ws.sortType = type;
        ws.pageIndex = 1;
        [ws requestList:RefreshStateNormal];
    };
    self.sectionView.countBlock = ^(NSInteger type) {
        [AnalysisService alaysisTransaction_sort_deal];
        ws.sortType = type;
        ws.pageIndex = 1;
        [ws requestList:RefreshStateNormal];
    };
    self.sectionView.handleBlock = ^(NSInteger type) {
        [AnalysisService alaysisTransaction_sort_increase];
        ws.sortType = type;
        ws.pageIndex = 1;
        [ws requestList:RefreshStateNormal];
    };
    
    [_tableViewContainer registerNib:[UINib nibWithNibName:NSStringFromClass([MyOptionCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableViewContainer.delegate = self;
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableViewContainer delegate:self];
    _tableViewContainer.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        ws.pageIndex = 1;
        [ws requestList:RefreshStatePull];
    }];
    [_tableViewContainer configToTop:^{
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
    }];
    _tableViewContainer.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        ws.pageIndex++;
        [ws requestList:RefreshStateUp];
        
    }];
//    _tableViewContainer.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
//
//    _tableViewContainer.separatorColor = CLineColor;
//    _tableViewContainer.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewContainer.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    _tableViewContainer.separatorColor = SeparateColor;
    _tableViewContainer.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
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
    MyOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.isCNY = self.isCNY;
    CurrencyModel *model = self.arrData[indexPath.row];
    model.exchangeName = self.exchangeName;
    
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [AnalysisService alaysisTransaction_page_list];
    CurrencyModel *model = self.arrData[indexPath.row];
    model.exchangeName = self.exchangeName;
    
    NSData *data = [model modelToJSONData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:dic];
}

- (void)fetchList{
    NSArray *visibleArray =  [self.tableViewContainer indexPathsForVisibleRows];
    [self.arrKindList removeAllObjects];
    [self.arrKindNameList removeAllObjects];
    [self.arrPriceList removeAllObjects];
    for (NSInteger i = 0; i < visibleArray.count; i++) {
        NSIndexPath *indexPath = visibleArray[i];
        CurrencyModel *model = self.arrData[indexPath.row];
        [self.arrKindNameList addObject:model.kindName];
        //交易所 kindCode为空
        [self.arrKindList addObject:model.kind];
        if (self.isCNY) {
            [self.arrPriceList addObject:@(model.legalTendeCNY)];
        }else{
            [self.arrPriceList addObject:@(model.legalTendeUSD)];
        }
        
    }
    if (self.arrKindList.count == 0) {
        return;
    }
    
    if([self.exchangeCode isEqualToString:k_Net_Code]){
        _baseRealTimeRequest = [[MarketRealtimeRequest alloc] initWithMarketType:2 kindList:self.arrKindList];
    }else{
        _baseRealTimeRequest = [[ExchangeRealTimeReq alloc] initWithExchangeCode:self.exchangeCode kindList:self.arrKindList];
    }
    [_baseRealTimeRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.arrChange removeAllObjects];
        NSInteger i = -1;
        for (NSString *strCode in self.arrKindList) {
            i++;
            for (NSDictionary *dic in request.data) {
                CurrencyModel *model = [CurrencyModel modelWithJSON:dic];
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
                model.icon = [NSString stringWithFormat:@"%@?%@",model.icon,str];
                if ([model.kind isEqualToString:strCode]) {
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
                CurrencyModel *model1 = self.arrChange[i];
                CurrencyModel *model2 = self.arrData[indexPath.row];
                model1.icon = model2.icon;
                if ([model1.kind isEqualToString:model2.kind]) {
                    [self.arrData insertObject:model1 atIndex:indexPath.row];
                    [self.arrData removeObjectAtIndex:indexPath.row + 1];
                }
            }
        }
        [self.tableViewContainer reloadData];

        
    } failure:^(__kindof BTBaseRequest *request) {
         [self.loadingView showErrorWith:request.resultMsg];
    }];
}

- (NSInteger)comparePrice:(CurrencyModel *)model index:(NSInteger)i{
    if (self.isCNY) {
        if (model.legalTendeCNY > [self.arrPriceList[i] doubleValue]) {
            return 1;
        }else if (model.legalTendeCNY  == [self.arrPriceList[i] doubleValue]){
            return 0;
        }else{
            return 2;
        }
    }else{
        if (model.legalTendeUSD  > [self.arrPriceList[i] doubleValue]) {
            return 1;
        }else if (model.legalTendeUSD  == [self.arrPriceList[i] doubleValue]){
            return 0;
        }else{
            return 2;
        }
    }
}

//请求数据
- (void)requestList:(RefreshState)state{
    if([self.exchangeCode isEqualToString:k_Net_Code]){
        _baseRequest = [[CurrencyRequest alloc] initWithCurrencyCode:self.currencyCode marketType:2 pageIndex:self.pageIndex sortType:self.sortType];
        
    }else{
        _baseRequest =[[ExchangeCurrencyReq alloc] initWithCurrencyCode:self.currencyCode exchangeCode:SAFESTRING(self.exchangeCode) pageIndex:self.pageIndex sortType:self.sortType];
    }
    
    if (state == RefreshStateNormal) {
        [self.loadingView showLoading];
    }
    [_baseRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.arrData removeAllObjects];
            if(![request.data isKindOfClass:[NSArray class]]) return;
            for (NSDictionary *dic in request.data) {
                CurrencyModel *model = [CurrencyModel modelWithJSON:dic];
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
                model.icon = [NSString stringWithFormat:@"%@?%@",model.icon,str];
                [self.arrData addObject:model];
            }
            [self.tableViewContainer.mj_header endRefreshing];
            [self.tableViewContainer.mj_footer endRefreshing];
            if ([request.data count] < BTPagesize) {
                [self.tableViewContainer.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.tableViewContainer.mj_footer.hidden = NO;
                [self.tableViewContainer.mj_footer endRefreshing];
            }
//            NSString *hasNext = SAFESTRING(request.responseObject[@"hasNext"]);
//            if ([hasNext isEqualToString:@"0"]) {
//                self.tableViewContainer.mj_footer.hidden = YES;
//            }else{
//                self.tableViewContainer.mj_footer.hidden = NO;
//                [self.tableViewContainer.mj_footer endRefreshing];
//            }
        }else if (state == RefreshStateUp){
            for (NSDictionary *dic in request.data) {
                CurrencyModel *model = [CurrencyModel modelWithJSON:dic];
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
//            if ([request.data count] < BTPagesize) {
//
//            }else{
//                [self.tableViewContainer.mj_footer endRefreshing];
//            }
            
        }
        [self.tableViewContainer reloadData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
        [self.tableViewContainer.mj_header endRefreshing];
        [self.tableViewContainer.mj_footer endRefreshing];
    }];
}

#pragma mark - Lazy
- (MyOptionSectionView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MyOptionSectionView class]) owner:self options:nil][0];
        _sectionView.isSelectCount = YES;
        _sectionView.btnCount.selected = YES;
        _sectionView.type = SectionViewTypeCurrentcy;
    }
    return _sectionView;
}

- (NSMutableArray *)arrData{
    if (!_arrData) {
        _arrData = [NSMutableArray array];
    }
    return _arrData;
}

- (NSMutableArray *)arrPriceList{
    if (!_arrPriceList) {
        _arrPriceList = [NSMutableArray array];
    }
    return _arrPriceList;
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

- (void)exchangeDataList:(NSNotification*)notify{
    [self requestList:RefreshStateNormal];
}

@end
