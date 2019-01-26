//
//  BTTPRewardDetailVC.m
//  BT
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTTPRewardDetailVC.h"
#import "BTTPRewardRecordReq.h"
#import "BTTPRewardModel.h"
#import "BTTPRewardCell.h"

@interface BTTPRewardDetailVC ()<BTLoadingViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) UITableView *mTableView;

@end

@implementation BTTPRewardDetailVC
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
    BTTPRewardRecordReq *request = [[BTTPRewardRecordReq alloc] initWithType:self.isNoReward? 2 : 1 pageIndex:self.pageIndex];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            
            if ([request.data count] == 0) {
                [self.loadingView showNoDataWith:@"zanwushuju"];
                return;
            }
            [self.loadingView hiddenLoading];
            [self.dataArray removeAllObjects];
            for (NSDictionary *dic in request.data) {
                BTTPRewardModel *model = [BTTPRewardModel modelWithJSON:dic];
                [self.dataArray addObject:model];
            }
            [self.mTableView reloadData];
            [self.mTableView.mj_header endRefreshing];
            if ([request.data count] < BTPagesize) {
                self.mTableView.mj_footer.hidden = YES;;
            }else{
                [self.mTableView.mj_footer endRefreshing];
            }
        }else if (state == RefreshStateUp){
            for (NSDictionary *dic in request.data) {
                BTTPRewardModel *model = [BTTPRewardModel modelWithJSON:dic];
                [self.dataArray addObject:model];
            }
            [self.mTableView reloadData];
            if ([request.data count] < BTPagesize) {
                [self.mTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.mTableView.mj_footer endRefreshing];
            }
        }
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
    return 116.0f;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BTTPRewardCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"BTTPRewardCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //1资讯2帖子3探报 4讨论
    BTTPRewardModel *model = self.dataArray[indexPath.row];
    if(model.isDeleted){
        return;
    }
    if(model.articleType == 1){
        [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":SAFESTRING(@(model.articleId)),@"bigType":@(2)}];
        
    }else if(model.articleType == 2){
        [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":[NSString stringWithFormat:@"%@",@(model.articleId)]} completion:^(id obj) {
             self.pageIndex = 1;
            [self requestList:RefreshStatePull];
        }];
        
    }else if(model.articleType == 3){
        [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":SAFESTRING(@(model.articleId)),@"bigType":@(6)}];
    }else if(model.articleType == 4){//讨论
        [BTCMInstance pushViewControllerWithName:@"TopicVC" andParams:@{@"refId":@(model.articleId)}];
    }
}

#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark --Customer Accessor
- (UITableView*)mTableView{
    if(!_mTableView){
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        if(IOS_VERSION >=11.0f){
            _mTableView.estimatedSectionHeaderHeight = 0.0;
            _mTableView.estimatedSectionFooterHeight = 0.0;
        }
        [_mTableView registerNib:[UINib nibWithNibName:@"BTTPRewardCell" bundle:nil] forCellReuseIdentifier:@"BTTPRewardCell"];
        _mTableView.backgroundColor = CViewBgColor;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator = NO;
        _mTableView.separatorInset = UIEdgeInsetsMake(15, 0, 0, 0);
        _mTableView.separatorColor = SeparateColor;
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView = footView;
    }
    return _mTableView;
}


@end
