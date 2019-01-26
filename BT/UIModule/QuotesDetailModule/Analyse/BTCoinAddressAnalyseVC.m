//
//  BTCoinAddressAnalyseVC.m
//  BT
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTCoinAddressAnalyseVC.h"
#import "LineViewTableViewCell.h"

#import "BTCoinHoldReq.h"

#import "NSDate+Extent.h"
#import "BTDistributeCell.h"
#import "BTCoinDetailCell.h"

#import "BTTopAddressTrendApi.h"
#import "BTAddressTopDetailApi.h"
#import "BTCoinDetailHeader.h"

@interface BTCoinAddressAnalyseVC ()<UITableViewDataSource,UITableViewDelegate,BTLoadingViewDelegate>

@property (nonatomic,strong)  UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *coinDetailArr;
@property (nonatomic, strong) NSDictionary *coinHoldInfo;
@property (nonatomic, strong) NSDictionary *topTenTrendInfo;

@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) NSString *kindCode;
@property (nonatomic, strong)BTCoinDetailHeader *coinDetailHeader;

@end

@implementation BTCoinAddressAnalyseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [APPLanguageService sjhSearchContentWith:@"chibidizhifenxi"];
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
    self.coinDetailArr = @[].mutableCopy;
    //    for(NSInteger i = 0 ;i < 5; i++){
    //        BTCoinDetailModel *model = [[BTCoinDetailModel alloc] init];
    //        model.isExpand = NO;
    //        [self.coinDetailArr addObject:model];
    //        [self.tableView reloadData];
    //    }
    self.coinHoldInfo = @{};
    NSDictionary *dict = (NSDictionary*)self.parameters;
    self.kindCode = SAFESTRING(dict[@"kindCode"]);
    [self requestCoinHold];
    [self requestTopAddressTrend];
    [self requestTopAddressDetail];
}

//
- (void)refreshingData{
    
}

- (void)requestCoinHold{
    BTCoinHoldReq *api = [[BTCoinHoldReq alloc] initWithKindCode:self.kindCode];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if(request.data&&[request.data isKindOfClass:[NSDictionary class]]){
            self.coinHoldInfo = request.data;
            [self.tableView reloadData];
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
    }];
}

//
- (void)requestTopAddressTrend{
    BTTopAddressTrendApi *api = [[BTTopAddressTrendApi alloc] initWithKindCode:self.kindCode];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if(request.data&&[request.data isKindOfClass:[NSDictionary class]]){
            self.topTenTrendInfo = request.data;
            [self.tableView reloadData];
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
    }];
}

- (void)requestTopAddressDetail{
    BTAddressTopDetailApi *api = [[BTAddressTopDetailApi alloc] initWithKindCode:self.kindCode];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if(request.data&&[request.data isKindOfClass:[NSArray class]]){
            for (NSDictionary *dict in request.data) {
                BTCoinDetailModel *model = [BTCoinDetailModel objectWithDictionary:dict];
                model.isExpand = NO;
                [self.coinDetailArr addObject:model];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

#pragma mark- UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        case 1:
            return 1;
            break;
        case 2:
            return self.coinDetailArr.count;
            break;
            
            break;
            
        default:
            break;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            return 316.0f;
        }
            break;
        case 1:
            return 340.0f;
            break;
        case 2:{
            BTCoinDetailModel *model = self.coinDetailArr[indexPath.row];
            CGFloat count = 0;
            if([model.addressDetailVoList isKindOfClass:[NSArray class]]){
                count = model.addressDetailVoList.count;
            }
            if(model.isExpand){
                return 40.0f +44 + count*30 + 52.0f;
            }else{
                return 40.0f + 52.0f;
            }
        }
            
            break;
    }
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        LineViewTableViewCell *lineCell = [[LineViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        lineCell.selectionStyle = UITableViewCellSelectionStyleNone;
        lineCell.isNoDetail = YES;
        lineCell.info = self.coinHoldInfo;
        return lineCell;
        
    }else if(indexPath.section == 1){
        BTDistributeCell *distributeCell = [[BTDistributeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        distributeCell.info = self.topTenTrendInfo;
        distributeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return distributeCell;
    }else{
        BTCoinDetailModel *model = self.coinDetailArr[indexPath.row];
        BTCoinDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTCoinDetailCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.index = indexPath.row;
        cell.model = model;
        return cell;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0) {
        return nil;
    }else if(section == 1){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 6)];
        view.backgroundColor = isNightMode? ViewBGNightColor :ViewBGDayColor;
        return view;
    }else{
        if (self.coinDetailArr.count ==0) {
            return nil;
        }
        return self.coinDetailHeader;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0) {
        return 0.01;
    }else if(section == 1){
        return 6.0f;
        
    }else{
        if (self.coinDetailArr.count ==0) {
            return 0.01;
        }
        return 50.0f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2){
        BTCoinDetailModel *currentModel = self.coinDetailArr[indexPath.row];
        CGFloat count = 0;
        if([currentModel.addressDetailVoList isKindOfClass:[NSArray class]]){
            count = currentModel.addressDetailVoList.count;
        }
        if(count == 0) return;
        for(BTCoinDetailModel *model in self.coinDetailArr){
            if(model !=currentModel){
                model.isExpand = NO;
            }
        }
        currentModel.isExpand = !currentModel.isExpand;
        if(!currentModel.isExpand){
            [MobClick event:@"analysis_address_details"];
        }
        [self.tableView reloadData];
    }
}

#pragma mark -- Customer Accessory
- (UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tag = 1106;
        if(IOS_VERSION >=11.0f){
            _tableView.estimatedSectionHeaderHeight = 0.0;
            _tableView.estimatedSectionFooterHeight = 0.0;
        }
        [_tableView registerNib:[UINib nibWithNibName:@"BTCoinDetailCell" bundle:nil] forCellReuseIdentifier:@"BTCoinDetailCell"];
        _tableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (BTCoinDetailHeader*)coinDetailHeader{
    if(!_coinDetailHeader){
        _coinDetailHeader = [BTCoinDetailHeader loadFromXib];
        _coinDetailHeader.frame = CGRectMake(0, 0, ScreenWidth, 50);
    }
    return _coinDetailHeader;
}

@end
