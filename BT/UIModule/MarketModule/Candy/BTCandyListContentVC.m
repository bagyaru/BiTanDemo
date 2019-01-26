//
//  BTCandyListContentVC.m
//  BT
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTCandyListContentVC.h"
#import "BTCandyListCell.h"
#import "InformationModuleRequest.h"
#import "FastInfomationObj.h"

@interface BTCandyListContentVC ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation BTCandyListContentVC

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

- (void)loadData{
    _dataArray = @[].mutableCopy;
}

//请求数据
- (void)requestList:(RefreshState)state{
    
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    InformationModuleRequest *_api = [[InformationModuleRequest alloc] initWithType:@"7" keyword:@"" pageIndex:self.pageIndex subType:self.type];
    [_api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            if ([request.data count]) {
                
                [self.loadingView hiddenLoading];
            } else {
                
                [self.loadingView showNoDataWith:@"zanwushuju"];
            }
            for (NSDictionary *dic in request.data) {
                FastInfomationObj *obj = [FastInfomationObj objectWithDictionary:dic];
                
                if (ISNSStringValid(obj.imgUrl)) {
                    
                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:80*2 andHeight:80*2];
                    obj.imgUrl = [NSString stringWithFormat:@"%@?%@",obj.imgUrl,str];
                }
                [self.dataArray addObject:obj];
                
            }
            [self.mTableView.mj_header endRefreshing];
            if (!request.hasNext) {
                self.mTableView.mj_footer.hidden = YES;
            }else{
                self.mTableView.mj_footer.hidden = NO;
                [self.mTableView.mj_footer endRefreshing];
            }
        }else if (state == RefreshStateUp){
            [self.mTableView.mj_header endRefreshing];
            if ([request.data count] < BTPagesize) {
                [self.mTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.mTableView.mj_footer endRefreshing];
            }
            for (NSDictionary *dic in request.data) {
                
                
                FastInfomationObj *obj = [FastInfomationObj objectWithDictionary:dic];
                if (ISNSStringValid(obj.imgUrl)) {
                    
                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:80*2 andHeight:80*2];
                    obj.imgUrl = [NSString stringWithFormat:@"%@?%@",obj.imgUrl,str];
                }
                [self.dataArray addObject:obj];
            }
        }
        [self.mTableView reloadData];
      
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.mTableView.mj_header endRefreshing];
        [self.mTableView.mj_footer endRefreshing];
        [self.loadingView showErrorWith:request.resultMsg];
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
        _mTableView.showsVerticalScrollIndicator = NO;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTCandyListCell class]) bundle:nil] forCellReuseIdentifier:@"BTCandyListCell"];
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView = footView;
    }
    return _mTableView;
}

#pragma mark- UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 110.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTCandyListCell*cell = [tableView dequeueReusableCellWithIdentifier:@"BTCandyListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell creatUIWith:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *points = @{@"71":@"candy_airdrop_list",@"72":@"candy_platform_list",@"73":@"candy_app_list",@"74":@"candy_tel_list"};
    NSString *value = points[SAFESTRING(@(self.type))];
    [MobClick event:value];
    
    FastInfomationObj *model = self.dataArray[indexPath.row];
    [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":model.infoID,
                                                                              @"whereVC":@"tg"
                                                                              }];
}

@end
