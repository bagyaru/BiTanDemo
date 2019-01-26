//
//  BTExchangeViewController.m
//  BT
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTExchangeViewController.h"
#import "BTExchangeListModel.h"
#import "BTExchangeHeaderView.h"
#import "ExchangeSelectCell.h"
#import "ExchangeListRequest.h"
#import "BTOnlineExchangeReq.h"

@interface BTExchangeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic,assign)BOOL isFrist;

@end

static NSString *cellIdentifier = @"ExchangeSelectCell";
@implementation BTExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    self.view.backgroundColor = ViewBGColor;
}

- (void)viewWillAppear:(BOOL)animated{
    
    if(!_isFrist){
        [self requestList:RefreshStateNormal];
        _isFrist= true;
    }else{
        
    }
}

- (void)createUI{
    [self.view addSubview: self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    WS(ws)
    self.mTableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        ws.index = 1;
        [ws requestList:RefreshStatePull];
    }];
    if(self.type == -1){
        self.mTableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
            ws.index ++;
            [ws requestList:RefreshStateUp];
        }];
    }
    self.index = 1;
    self.dataArray = @[].mutableCopy;
}
- (void)requestList:(RefreshState)state{
    BTOnlineExchangeReq *req = [[BTOnlineExchangeReq alloc] initWithIndex:self.index category:SAFESTRING(@(self.type)) keywords:@""];
    [req requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
       if(request.data&&[request.data isKindOfClass:[NSArray class]]){
             [self.mTableView.mj_header endRefreshing];
             if(state == RefreshStateNormal || state == RefreshStatePull){
                 [self.dataArray removeAllObjects];
                 for(NSDictionary *dict in request.data){
                     BTExchangeListModel *model = [BTExchangeListModel objectWithDictionary:dict];
                     [self.dataArray addObject:model];
                 }
                 NSString *hasNext = SAFESTRING(request.responseObject[@"hasNext"]);
                 if ([hasNext isEqualToString:@"0"]) {
                     self.mTableView.mj_footer.hidden = YES;
                 }else{
                     self.mTableView.mj_footer.hidden = NO;
                     [self.mTableView.mj_footer endRefreshing];
                 }
                 
             }else if(state == RefreshStateUp){
                 NSString *hasNext = SAFESTRING(request.responseObject[@"hasNext"]);
                 for(NSDictionary *dict in request.data){
                     BTExchangeListModel *model = [BTExchangeListModel objectWithDictionary:dict];
                     [self.dataArray addObject:model];
                 }
                 if([hasNext isEqualToString:@"1"]){
                     [self.mTableView.mj_footer endRefreshing];
                 }else{
                     [self.mTableView.mj_footer endRefreshingWithNoMoreData];
                 }
            }
           
        }
        [self.mTableView reloadData];
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

#pragma mark --Customer Accessor
-(UITableView*)mTableView{
    if(!_mTableView){
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        if(IOS_VERSION >=11.0f){
            _mTableView.estimatedSectionHeaderHeight=0.0;
            _mTableView.estimatedSectionFooterHeight=0.0;
        }
        _mTableView.backgroundColor = kHEXCOLOR(0xF5F5F5);
        _mTableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator = NO;
        [_mTableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
        _mTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        _mTableView.separatorColor = SeparateColor;
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView =footView;
    }
    return _mTableView;
}
#pragma mark- UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 48.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExchangeSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BTExchangeListModel *model = self.dataArray[indexPath.row];
    //    打点
    NSString *exPoint = [model.exchangeCode stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    [MobClick event:exPoint];
    if(self.type == 5){//期货
        [BTCMInstance pushViewControllerWithName:@"FutureList" andParams:@{@"model":model}];
    }else{
        if([model.category isEqualToString:@"5"]){//期货
            [BTCMInstance pushViewControllerWithName:@"FutureList" andParams:@{@"model":model}];
        }else{
            [BTCMInstance pushViewControllerWithName:@"BTExchangeContainerVC" andParams:@{@"model":model}];
            [MobClick event:@"exchange_details"];
        }
    }
    
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BTExchangeHeaderView *headerView = [BTExchangeHeaderView loadFromXib];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, 34.0f);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34.0f;
}


@end
