//
//  BTICOListContentVC.m
//  BT
//
//  Created by apple on 2018/8/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTICOListContentVC.h"
#import "BTICOListCell.h"
#import "BTICOListApi.h"
#import "BTICOListModel.h"

@interface BTICOListContentVC ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>

@property (nonatomic,strong) UITableView *mTableView;

@property (nonatomic, strong)BTICOListApi *listApi;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation BTICOListContentVC

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
        ws.pageIndex = 1;
        [ws requestList:RefreshStatePull];
    }];
    _mTableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        ws.pageIndex ++;
        [ws requestList:RefreshStateUp];
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
    self.pageIndex = 1;
    self.dataArr = @[].mutableCopy;
}

//请求数据
- (void)requestList:(RefreshState)state{
    _listApi = [[BTICOListApi alloc] initWithType:self.type pageIndex:self.pageIndex];
    if (state == RefreshStateNormal) {
        [self.loadingView showLoading];
    }
    [_listApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if(request.data&&[request.data isKindOfClass:[NSArray class]]){
           
            if(state == RefreshStateNormal || state == RefreshStatePull){
                self.dataArr = @[].mutableCopy;
                if ([request.data count]) {
                    [self.loadingView hiddenLoading];
                } else {
                    
                    [self.loadingView showNoDataWith:@"zanwushuju"];
                }
                for (NSDictionary *dic in request.data) {
                    BTICOListModel *model = [BTICOListModel objectWithDictionary:dic];
                    [self.dataArr addObject:model];
                }
                [self.mTableView.mj_header endRefreshing];
                NSString *hasNext = SAFESTRING(request.responseObject[@"hasNext"]);
                if ([hasNext isEqualToString:@"0"]) {
                    self.mTableView.mj_footer.hidden = YES;
                }else{
                    self.mTableView.mj_footer.hidden = NO;
                    [self.mTableView.mj_footer endRefreshing];
                }
            }else if(state == RefreshStateUp){
                NSString *hasNext = SAFESTRING(request.responseObject[@"hasNext"]);
                for (NSDictionary *dic in request.data) {
                    BTICOListModel *model = [BTICOListModel objectWithDictionary:dic];
                    [self.dataArr addObject:model];
                }
                if([hasNext isEqualToString:@"1"]){
                    [self.mTableView.mj_footer endRefreshing];
                }else{
                    [self.mTableView.mj_footer endRefreshingWithNoMoreData];
                }
                
            }
            
        }else {
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
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTICOListCell class]) bundle:nil] forCellReuseIdentifier:@"BTICOListCell"];
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView = footView;
    }
    return _mTableView;
}

#pragma mark- UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 98.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTICOListCell*cell = [tableView dequeueReusableCellWithIdentifier:@"BTICOListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BTICOListModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *points = @{@"1":@"ico_ing_list",@"0":@"ico_coming_list",@"2":@"ico_end_list"};
    NSString *value = points[SAFESTRING(@(self.type))];
    [MobClick event:value];
    
    BTICOListModel *model = self.dataArr[indexPath.row];
    [BTCMInstance pushViewControllerWithName:@"BTICODetailViewController" andParams:@{@"id":SAFESTRING(model.mID)}];
}


@end
