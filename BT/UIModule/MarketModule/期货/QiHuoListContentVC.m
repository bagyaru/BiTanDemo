//
//  QiHuoListContentVC.m
//  BT
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 apple. All rights reserved.
//
//期货内容列表
#import "QiHuoListContentVC.h"
#import "BTFutureContentListApi.h"
#import "FutureListCell.h"
@interface QiHuoListContentVC ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic, strong)BTFutureContentListApi *listApi;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation QiHuoListContentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRequest) name:NSNotification_future_needRequest object:nil];
    [self createUI];
    [self loadData];
}

- (void)createUI{
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    WS(ws)
    _mTableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        [ws requestList:RefreshStatePull];
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:self.mTableView delegate:self];
}

- (void)needRequest{
    if (self.dataArr.count > 0) {
        return;
    }
    NSInteger index = [BTConfigureService shareInstanceService].futureIndex;
    NSArray *vcs = [[self.navigationController visibleViewController] childViewControllers];
    if (index < vcs.count) {
        if ([vcs[index] isEqual:self]) {
            [self requestList:RefreshStateNormal];
        }
    }
    
}

- (void)loadData{
    _dataArr = @[].mutableCopy;
    [self.mTableView reloadData];
}
//请求数据
- (void)requestList:(RefreshState)state{
   
    _listApi = [[BTFutureContentListApi alloc] initWithCode:self.futureCode];
    if (state == RefreshStateNormal) {
        [self.loadingView showLoading];
    }
    [_listApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if(request.data&&[request.data isKindOfClass:[NSArray class]]){
            [self.dataArr removeAllObjects];
            if ([request.data count]) {
                [self.loadingView hiddenLoading];
            } else {
                
                [self.loadingView showNoDataWith:@"zanwushuju"];
            }
            for (NSDictionary *dic in request.data) {
                //                CurrencyModel *model = [CurrencyModel modelWithJSON:dic];
                [self.dataArr addObject:dic];
            }
            [self.mTableView.mj_header endRefreshing];
        }else{
            [self.loadingView hiddenLoading];
        }
        [self.mTableView reloadData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
        [self.mTableView.mj_header endRefreshing];
        
    }];
}

#pragma mark -- BTLoadingView Delegate
- (void)refreshingData{
    [self requestList:RefreshStateNormal];
}

#pragma mark --Customer Accessor
-(UITableView*)mTableView{
    if(!_mTableView){
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        if(IOS_VERSION >=11.0f){
            _mTableView.estimatedSectionHeaderHeight = 0.0;
            _mTableView.estimatedSectionFooterHeight = 0.0;
        }
        _mTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator =NO;
        _mTableView.separatorColor = SeparateColor;
        [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FutureListCell class]) bundle:nil] forCellReuseIdentifier:@"FutureListCell"];
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView = footView;
    }
    return _mTableView;
}

#pragma mark- UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dict = self.dataArr[section];
    NSArray *arr = dict[@"marketInfoVOList"];
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 58.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FutureListCell*cell = [tableView dequeueReusableCellWithIdentifier:@"FutureListCell"];
    NSDictionary *dict = self.dataArr[indexPath.section];
    NSArray *arr = dict[@"marketInfoVOList"];
    MarketModel *model = [MarketModel modelWithJSON:arr[indexPath.row]];
    NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
    model.icon = [NSString stringWithFormat:@"%@?%@",model.icon,str];
    cell.model = model;
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSDictionary *dict = self.dataArr[section];
    NSString *title = SAFESTRING(dict[@"kind"]);
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 28.0f)];
    headerView.backgroundColor = ViewBGColor;
    UILabel *titleLabel = [UILabel labelWithFrame:CGRectZero title:@"" font:FONTOFSIZE(12) textColor:FirstColor];
    titleLabel.text = title;
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(15);
        make.centerY.equalTo(headerView.mas_centerY);
    }];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   return 30.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *point = [NSString stringWithFormat:@"qihuo_%@_details",self.futureCode];
    [MobClick event:point];
    
    NSDictionary *dict = self.dataArr[indexPath.section];
    NSArray *arr = dict[@"marketInfoVOList"];
    MarketModel *model = [MarketModel modelWithJSON:arr[indexPath.row]];
    model.exchangeCode = self.futureCode;
    NSData *data = [model modelToJSONData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [BTCMInstance pushViewControllerWithName:@"QiHuoDetailVC" andParams:dic];
}


@end
