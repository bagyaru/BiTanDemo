//
//  BTZFFBDetailDetailViewController.m
//  BT
//
//  Created by admin on 2018/7/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTZFFBDetailDetailViewController.h"
#import "BTDiscoveryMainCell.h"
#import "BTRiseDistributionDetailRequest.h"
#import "BTZFFBDetailDetailSetionView.h"
static NSString *const identifier = @"BTDiscoveryMainCell";
@interface BTZFFBDetailDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) BTZFFBDetailDetailSetionView *selectView;
@end

@implementation BTZFFBDetailDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)creatUI {
    self.pageIndex = 1;
    self.title = self.parameters[@"title"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTDiscoveryMainCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = CViewBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        [self requestList:RefreshStatePull];
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
    [self requestList:RefreshStateNormal];
}

- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    BTRiseDistributionDetailRequest *api = [[BTRiseDistributionDetailRequest alloc] initWithDict:@{@"riseDistributionType":self.parameters[@"riseDistributionType"]}];
    WS(weakSelf);
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
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_header endRefreshing];
        }

    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.tableView.mj_header endRefreshing];
        [self.loadingView showErrorWith:request.resultMsg];
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
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.selectView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0f;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    BTDiscoveryMainCell *cell =[tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    cell.selectedIndex = 10;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QutoesDetailMarket *model = self.dataArray[indexPath.row];
    NSData *data = [model modelToJSONData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:dic];
}
#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(BTZFFBDetailDetailSetionView *)selectView  {
    
    if (!_selectView) {
        
        _selectView = [BTZFFBDetailDetailSetionView loadFromXib];
        
    }
    return _selectView;
    
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
