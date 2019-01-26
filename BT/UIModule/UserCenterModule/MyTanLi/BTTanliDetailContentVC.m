//
//  BTTanliDetailContentVC.m
//  BT
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTTanliDetailContentVC.h"
#import "HistoryTableViewCell.h"
#import "HistoryModel.h"
#import "TPHistoryTPRequest.h"
#import "BTTPDetailReq.h"

@interface BTTanliDetailContentVC ()<BTLoadingViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) UITableView *mTableView;

@end

@implementation BTTanliDetailContentVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRequest) name:NSNotification_future_needRequest object:nil];
}

- (void)needRequest{
    if (self.dataArray.count > 0) {
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

- (void)creatUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.pageIndex = 1;
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.mTableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
    }];
    
    self.mTableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        self.pageIndex ++;
        [self requestList:RefreshStateUp];
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:self.mTableView delegate:self];
}

//
- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    BTTPDetailReq *request = [[BTTPDetailReq alloc] initWithType:self.isIncome ?2 : 1 pageIndex:self.pageIndex];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {

        [self.mTableView.mj_header endRefreshing];
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            if ([request.data count] > 0) {
                
                [self.loadingView hiddenLoading];
                [self.dataArray removeAllObjects];
                for (NSDictionary *dic in request.data) {
                    HistoryModel *model = [HistoryModel modelWithJSON:dic];
                    [self.dataArray addObject:model];
                }
            }else{
                [self.loadingView showNoDataWith:@"zanwushuju"];
            }
            if ([request.data count] < BTPagesize) {
                self.mTableView.mj_footer.hidden = YES;;
            }else{
                
                [self.mTableView.mj_footer endRefreshing];
            }
        }else if (state == RefreshStateUp){
            if ([request.data count] < BTPagesize) {
                self.mTableView.mj_footer.hidden = YES;;
            }else{
                
                [self.mTableView.mj_footer endRefreshing];
            }
            
            for (NSDictionary *dic in request.data) {
                HistoryModel *model = [HistoryModel modelWithJSON:dic];
                [self.dataArray addObject:model];
            }
        }
        [self.mTableView reloadData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
        [self.mTableView.mj_header endRefreshing];
        [self.mTableView.mj_footer endRefreshing];
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
    return RELATIVE_WIDTH(68);
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HistoryTableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"HistoryTableViewCell"];
    cell.isIncome = self.isIncome;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell parseData:self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
        [_mTableView registerClass:[HistoryTableViewCell class] forCellReuseIdentifier:@"HistoryTableViewCell"];
        _mTableView.backgroundColor = CViewBgColor;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator = NO;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView = footView;
    }
    return _mTableView;
}


@end
