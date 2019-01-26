//
//  FOTRankingListVC.m
//  BT
//
//  Created by apple on 2018/11/12.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTRankingListVC.h"
#import "BTConceptUpDownRequest.h"
#import "QutoesDetailMarket.h"
#import "BTDiscoveryMainCell.h"
@interface BTRankingListVC ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>{
    BTConceptUpDownRequest *api;
}

@property (nonatomic, strong)  UITableView *mTableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong)BTLoadingView *loadingView;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation BTRankingListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopTimer];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startTimer];
}

- (void)creatUI {
    self.pageIndex = 1;
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    WS(ws)
//    _mTableView.mj_header = [FOTRefreshHeader headerWithRefreshingBlock:^{
//        ws.pageIndex = 1;
//        [ws requestList:RefreshStatePull];
//    }];
//    
//    _mTableView.mj_footer = [FOTRefreshFooter footerWithRefreshingBlock:^{
//        ws.pageIndex++;
//        [ws requestList:RefreshStateUp];
//    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_mTableView delegate:self];
    [self requestList:RefreshStateNormal];
}

- (void)requestList:(RefreshState)refreshState{
    if(refreshState == RefreshStateNormal){
        [self.loadingView showLoading];
    }
    //请求在执行时，取消
    if(api&&(api.isExecuting)){
        [api stop];
    }
    WS(weakSelf)
    api = [[BTConceptUpDownRequest alloc]initWithKind:self.selectIndex];
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [weakSelf.loadingView hiddenLoading];
        weakSelf.dataArray = @[].mutableCopy;
        if(request.data&&[request.data isKindOfClass:[NSArray class]]){
            
            for(NSDictionary *dict in request.data){
                QutoesDetailMarket *model = [QutoesDetailMarket objectWithDictionary:dict];
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
                model.icon = [NSString stringWithFormat:@"%@?%@",model.icon,str];
                [weakSelf.dataArray addObject:model];
            }
            
            [weakSelf.mTableView.mj_header endRefreshing];
            [weakSelf.mTableView reloadData];
            
        }
    } failure:^(__kindof BTBaseRequest *request) {
        [weakSelf.mTableView.mj_header endRefreshing];
        [weakSelf.loadingView showErrorWith:request.resultMsg];
    }];
}
#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    [self requestList:RefreshStateNormal];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64.0f;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BTDiscoveryMainCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BTDiscoveryMainCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    cell.selectedIndex = self.selectIndex;
    cell.model = self.dataArray[indexPath.row];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QutoesDetailMarket *model = self.dataArray[indexPath.row];
    NSData *data = [model modelToJSONData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:dic];
    
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
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTDiscoveryMainCell class]) bundle:nil] forCellReuseIdentifier:@"BTDiscoveryMainCell"];
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView = footView;
    }
    return _mTableView;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
- (void)requestData{
 
    NSArray *visibleArray =  [self.mTableView indexPathsForVisibleRows];
    NSMutableArray *visibleData = @[].mutableCopy;
    
    for (NSInteger i = 0; i < visibleArray.count; i++) {
        NSIndexPath *indexPath = visibleArray[i];
        QutoesDetailMarket *model = self.dataArray[indexPath.row];
        [visibleData addObject:model];
    }
    if (visibleData.count == 0) {
        return;
    }
    BTConceptUpDownRequest *apiRequest =[[BTConceptUpDownRequest alloc]initWithKind:self.selectIndex];
    [apiRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        NSInteger i = -1;
        for(QutoesDetailMarket *model  in visibleData){
            i++;
            NSIndexPath *indexPath = visibleArray[i];
            for(NSDictionary *dict in request.data){
                QutoesDetailMarket *changeModel =[QutoesDetailMarket objectWithDictionary:dict];
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
                changeModel.icon = [NSString stringWithFormat:@"%@?%@",changeModel.icon,str];
                if([model.kindCode isEqualToString:changeModel.kindCode]){
                    changeModel.type = [self compareSecondModel:changeModel  firstModel:model];
                    [self.dataArray replaceObjectAtIndex:indexPath.row withObject:changeModel];
                }
            }
        }
        
        [self.mTableView reloadData];
        
        
    }failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

- (NSInteger)compareSecondModel:(QutoesDetailMarket*)secondModel firstModel:(QutoesDetailMarket*)firstModel{
    if (kIsCNY) {
        if ([secondModel.priceCNY doubleValue] > [firstModel.priceCNY doubleValue]) {
            return 1;
        }else if ([secondModel.priceCNY doubleValue] == [firstModel.priceCNY doubleValue]){
            return 0;
        }else{
            return 2;
        }
    }else{
        if ([secondModel.priceUSD doubleValue] > [firstModel.priceUSD doubleValue]) {
            return 1;
        }else if ([secondModel.priceUSD doubleValue] == [firstModel.priceUSD doubleValue]){
            return 0;
        }else{
            return 2;
        }
    }
}

@end
