//
//  MarketDetailViewController.m
//  BT
//
//  Created by apple on 2018/6/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MarketDetailViewController.h"
#import "MyOptionCell.h"
#import "QutoesDetailMarketCurrencyRequest.h"
#import "QutoesDetailMarketRequest.h"

@interface MarketDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;

@end

@implementation MarketDetailViewController

static NSString *const identifierMarket = @"MyOptionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}

- (void)createUI{
    self.view.backgroundColor = ViewBGColor;
    [self.view addSubview:self.mTableView];
//    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _mTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    _mTableView.separatorColor = SeparateColor;
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:nil delegate:nil];
}

- (void)loadData{
    NSString *kindCode = self.kindCode;
    if([kindCode containsString:@"/"]){
        [self requestWithMarketCurrency];
    }else{
        [self requestWithMarket];
    }
}

//市场 市值页面过来
- (void)requestWithMarket{
    [self.loadingView showLoading];
    NSString *strCode = self.kindCode;
    QutoesDetailMarketRequest *request = [[QutoesDetailMarketRequest alloc] initWithkind:strCode];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(![request.data isKindOfClass:[NSArray class]]){
            [self.loadingView showNoDataWith:@"zanwushuju"];
            return;
        }
        
        if([request.data count] == 0){
            [self.loadingView showNoDataWith:@"zanwushuju"];
            return;
        }
        [self.loadingView hiddenLoading];
        self.dataArray = @[].mutableCopy;
        for (NSDictionary *dic in request.data) {
            QutoesDetailMarket *market = [QutoesDetailMarket modelWithJSON:dic];
            [self.dataArray  addObject:market];
        }
        
        [self.mTableView reloadData];
    } failure:^(__kindof BTBaseRequest *request) {
        //简介没有
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

//市场 交易对页面过来
- (void)requestWithMarketCurrency{
     [self.loadingView showLoading];
    NSString *strCode = self.kindCode;
    QutoesDetailMarketCurrencyRequest *request = [[QutoesDetailMarketCurrencyRequest alloc] initWithkind:strCode];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(![request.data isKindOfClass:[NSArray class]]){
            [self.loadingView showNoDataWith:@"zanwushuju"];
            return;
        }
        if([request.data count] == 0){
            [self.loadingView showNoDataWith:@"zanwushuju"];
            return;
        }
        [self.loadingView hiddenLoading];
        self.dataArray = @[].mutableCopy;
        for (NSDictionary *dic in request.data) {
            QutoesDetailMarket *market = [QutoesDetailMarket modelWithJSON:dic];
            [self.dataArray addObject:market];
        }
       
        [self.mTableView reloadData];
    } failure:^(__kindof BTBaseRequest *request) {
        //简介没有
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}


#pragma mark --Customer Accessor
-(UITableView*)mTableView{
    if(!_mTableView){
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.tag = 1105;
        if(IOS_VERSION >=11.0f){
            _mTableView.estimatedSectionHeaderHeight = 0.0;
            _mTableView.estimatedSectionFooterHeight = 0.0;
        }
        _mTableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator =NO;
        [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyOptionCell class]) bundle:nil] forCellReuseIdentifier:identifierMarket];
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView =footView;
    }
    return _mTableView;
}

#pragma mark- UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 76.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierMarket forIndexPath:indexPath];
    cell.isCNY = kIsCNY;
    cell.isShiZhi = !([self.kindCode containsString:@"/"]);
    QutoesDetailMarket *model = self.dataArray[indexPath.row];
    model.isNoImage = YES;
    cell.marketModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QutoesDetailMarket*model = self.dataArray[indexPath.row];
    NSData *data = [model modelToJSONData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:dic];
}


@end
