//
//  BTColleageVC.m
//  BT
//
//  Created by apple on 2018/11/27.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTColleageVC.h"
#import "BTColleageListCell.h"
#import "BTColleageListReq.h"

@interface BTColleageVC ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) BTLoadingView *loadingView;

@end

@implementation BTColleageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}

- (void)createUI{
    self.title = [APPLanguageService sjhSearchContentWith:@"bitanxueyuan"];
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:self.mTableView delegate:self];
}

- (void)loadData{
    _dataArr = @[].mutableCopy;
    [self requestData:RefreshStateNormal];
}

- (void)requestData:(RefreshState)state{
    if(state == RefreshStateNormal){
        [self.loadingView showLoading];
    }
    BTColleageListReq *api = [[BTColleageListReq alloc] init];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data&& [request.data isKindOfClass:[NSArray class]]){
           if ([request.data count]) {
                [self.loadingView hiddenLoading];
            } else {
                [self.loadingView showNoDataWith:@"zanwushuju"];
            }
            self.dataArr = request.data;
            
        }
       
        [self.mTableView reloadData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
    
}

//
- (void)refreshingData{
    
    
}

#pragma mark --Customer Accessor
- (UITableView*)mTableView{
    if(!_mTableView){
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        if(IOS_VERSION >=11.0f){
            _mTableView.estimatedSectionHeaderHeight=0.0;
            _mTableView.estimatedSectionFooterHeight=0.0;
        }
        [_mTableView registerNib:[UINib nibWithNibName:@"BTColleageListCell" bundle:nil] forCellReuseIdentifier:@"BTColleageListCell"];
        _mTableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator =NO;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView = footView;
    }
    return _mTableView;
}

#pragma mark -- UITableView Delegate DataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTColleageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTColleageListCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = self.dataArr[indexPath.section];
    if([dict isKindOfClass:[NSDictionary class]]){
        NSArray *arr = dict[@"child"];
        NSDictionary *data = arr[indexPath.row];
        cell.dict = data;
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dict = self.dataArr[section];
    if([dict isKindOfClass:[NSDictionary class]]){
        NSArray *arr = dict[@"child"];
        return arr.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140.0f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSMutableArray *mutaArr = @[].mutableCopy;
    for(NSDictionary *dict in self.dataArr){
        [mutaArr addObject:SAFESTRING(dict[@"name"])];
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 37.0f)];
    headerView.backgroundColor = isNightMode ?ViewContentBgColor :CWhiteColor;
    
    UIView *indicatorView = [[UIView alloc] initWithFrame:CGRectZero];
    indicatorView.backgroundColor = MainBg_Color;
    [headerView addSubview:indicatorView];
    [indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView).offset(15);
        make.bottom.equalTo(headerView.mas_bottom).offset(-5);
        make.width.mas_equalTo(4);
        make.height.mas_equalTo(15);
    }];
    
    UILabel *titleLabel = [UILabel labelWithFrame:CGRectZero title:mutaArr[section] font:FONTOFSIZE(16) textColor:FirstColor];
    [headerView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(indicatorView.mas_right).offset(10);
        make.centerY.equalTo(indicatorView.mas_centerY);
    }];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 37.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataArr[indexPath.section];
    if([dict isKindOfClass:[NSDictionary class]]){
        NSArray *arr = dict[@"child"];
        NSDictionary *data = arr[indexPath.row];
        
        NSDictionary *info  = [self getPointsDict];
        NSString *key = SAFESTRING(data[@"value"]);
        [MobClick event:info[key]];
        
        [BTCMInstance pushViewControllerWithName:@"BTColleageDetailVC" andParams:data];
    }
}

- (NSDictionary*)getPointsDict{
    return @{
             @"11":@"school_blockchain",
             @"12":@"school_buy_Cy.",
             @"13":@"school_main_Cy.",
             @"21":@"school_candles",
             @"22":@"school_zhibiao",
             @"23":@"school_state",
             @"31":@"school_attitude",
             @"32":@"school_skills",
             @"33":@"school_experience"
             };
}
@end
