//
//  NewCurrencyOnSaleViewController.m
//  BT
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewCurrencyOnSaleViewController.h"
#import "NewCurrencyOnSaleTableViewCell.h"
#import "NewCurrencyListRequest.h"
#import "QuotesDetailViewController.h"

@interface NewCurrencyOnSaleViewController ()<UITableViewDataSource,UITableViewDelegate,BTLoadingViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
/**请求数据的页数 用于刷新*/
@property (nonatomic, assign) NSInteger pageIndex;
/**请求失败的刷新界面*/
@property (nonatomic, strong) BTLoadingView *loadingView;
/**数据数组*/
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation NewCurrencyOnSaleViewController


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView =[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        if(IOS_VERSION >= 11.0f){
            _tableView.estimatedRowHeight = 0.0;
            _tableView.estimatedSectionHeaderHeight=0.0;
            _tableView.estimatedSectionFooterHeight=0.0;
        }
        _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.showsVerticalScrollIndicator =NO;
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    
}

#pragma mark - 初始化界面
-(void)creatUI{
    self.title = [APPLanguageService wyhSearchContentWith:@"xinbishangxian"];
    //顶部分区提示栏
    UIView *topView = [[UIView alloc] init];
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(RELATIVE_WIDTH(36));
    }];
    //top视图上的标签初始化
    NSArray *titleArray = @[[NSString stringWithFormat:@"%@ / %@",[APPLanguageService sjhSearchContentWith:@"mingcheng"],[APPLanguageService sjhSearchContentWith:@"chengjiaoliang"]],
                            [APPLanguageService sjhSearchContentWith:@"zuixinjia"],
                            [APPLanguageService sjhSearchContentWith:@"24hzhangdie"]];
    CGFloat labelH = RELATIVE_WIDTH(17);
    for (int i = 0; i<3; i++) {
        UILabel *label = [[UILabel alloc] init];
        [topView addSubview:label];
        label.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(12)];
        label.textColor = ThirdColor;
        label.text = titleArray[i];
        if (i==0) {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.view.mas_left).offset(RELATIVE_WIDTH(15));
                make.centerY.equalTo(topView);
                make.height.mas_equalTo(labelH);
            }];
            
        }else if (i==1){
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(topView).offset(RELATIVE_WIDTH(168));
                make.centerY.equalTo(topView);
                make.height.mas_equalTo(labelH);
            }];
        }else{
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(topView);
                make.right.equalTo(topView).offset(RELATIVE_WIDTH(-15));
                make.height.mas_equalTo(labelH);
            }];
        }
    }
    
    
    //添加下划线
    UIView *lineView = [[UIView alloc] init];
    [topView addSubview:lineView];
    lineView.backgroundColor = SeparateColor;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView);
        make.right.equalTo(topView);
        make.bottom.equalTo(topView).offset(RELATIVE_WIDTH(-1));
        make.height.mas_equalTo(RELATIVE_WIDTH(1));
    }];
    
    
    //添加tableView
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(topView.mas_bottom);
    }];
    
    self.tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
    }];
    
    self.tableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        self.pageIndex++;
        [self requestList:RefreshStateUp];
    }];
    
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:self.tableView delegate:self];
    [self requestList:RefreshStateNormal];
    
    
}

- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    
    //网络请求
    NewCurrencyListRequest *api = [[NewCurrencyListRequest alloc] initWithNewCurrencyList:self.pageIndex];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
       
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            if ([request.data count]) {
                
                [self.loadingView hiddenLoading];
            } else {
                
                [self.loadingView showNoDataWith:@"zanwushuju"];
            }
            for (NSDictionary *dic in request.data) {
                NewCurrencyModel *model = [NewCurrencyModel objectWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            
            DLog(@"++++++%ld++++",[request.data count]);
            [self.tableView.mj_header endRefreshing];
            if ([request.data count] < BTPagesize) {
                self.tableView.mj_footer.hidden = YES;;
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else if (state == RefreshStateUp){
            if ([request.data count] < BTPagesize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }

            for (NSDictionary *dic in request.data) {
                NewCurrencyModel *model = [NewCurrencyModel objectWithDictionary:dic];
                [self.dataArray addObject:model];
            }
        }
        [self.tableView reloadData];
    } failure:^(__kindof BTBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.loadingView showErrorWith:request.resultMsg];
    }];
    
    
}

#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    [self requestList:RefreshStateNormal];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    NewCurrencyOnSaleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[NewCurrencyOnSaleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NewCurrencyModel *model = self.dataArray[indexPath.row];
    [cell parseData:model];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return RELATIVE_WIDTH(60);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [AnalysisService alaysisfind_page_new_currency_detail];
    NewCurrencyModel *model = self.dataArray[indexPath.row];
    if (model.has) {
        NSData *data = [model modelToJSONData];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:dic];
    }
    
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
