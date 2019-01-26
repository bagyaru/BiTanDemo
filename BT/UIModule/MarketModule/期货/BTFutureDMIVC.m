//
//  BTFutureDMIVC.m
//  BT
//
//  Created by apple on 2018/7/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTFutureDMIVC.h"
#import "FutureLineViewCell.h"
#import "BTOkexTrendApi.h"
#import "FutureTrendCell.h"

@interface BTFutureDMIVC ()<UITableViewDataSource,UITableViewDelegate,BTLoadingViewDelegate,FutureLineViewCellDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) BTLoadingView *loadingView;

@property (nonatomic, strong)BTOkexTrendApi *api;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSArray *okexHistogramData;
@property (nonatomic, copy) NSArray *okexPolylineData;


@end

@implementation BTFutureDMIVC

static NSString *trendCellIdentifier = @"FutureTrendCell";
static NSString *lineCellIdentifier = @"FutureLineViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}

- (void)createUI{
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:nil delegate:self];
}

- (void)loadData{
    self.type = 1;
    [self requestPolyline:RefreshStateNormal];
}
//
- (void)refreshingData{
    [self requestPolyline:RefreshStateNormal];
}

- (void)requestPolyline:(RefreshState)state{
    if(_api){
        [_api stop];
    }
    if(state == RefreshStateNormal){
         [self.loadingView showLoading];
    }
   _api = [[BTOkexTrendApi alloc] initWithCode:self.code type:self.type];
    [_api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if(request.data &&[request.data isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary*)request.data;
            NSArray * okexHistogramData= dict[@"okexHistogramData"];
            if([okexHistogramData isKindOfClass:[NSArray class]]){
                self.okexHistogramData = okexHistogramData;
            }
            NSArray * okexPolylineData= dict[@"okexPolylineData"];
            if([okexPolylineData isKindOfClass:[NSArray class]]){
                self.okexPolylineData = okexPolylineData;
            }
            [self.tableView reloadData];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
    
}
     
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark- UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        if(self.okexPolylineData.count == 0) return 0;
        return 1;
    }
    if(self.okexHistogramData.count == 0) return 0;
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        FutureLineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lineCellIdentifier];
        cell.title = @"LTCQuxiangzhibiao";
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.info = self.okexPolylineData;
        return cell;
    }
    FutureTrendCell *cell = [tableView dequeueReusableCellWithIdentifier:trendCellIdentifier];
    cell.dataArr = self.okexHistogramData;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 305.0f;
    }
    return 305.0f;
}

#pragma mark -- Customer Accessory
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tag = 1104;
        if(IOS_VERSION >=11.0f){
            _tableView.estimatedSectionHeaderHeight = 0.0;
            _tableView.estimatedSectionFooterHeight = 0.0;
        }
        [_tableView registerClass:[FutureLineViewCell class]  forCellReuseIdentifier:lineCellIdentifier];
        [_tableView registerClass:[FutureTrendCell class]  forCellReuseIdentifier:trendCellIdentifier];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)refreshDataWithType:(NSInteger)type{
    self.type = type;
    [self requestPolyline:RefreshStatePull];
}

@end
