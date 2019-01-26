//
//  BTAnalyseViewController.m
//  BT
//
//  Created by apple on 2018/6/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTAnalyseViewController.h"
#import "AnalyseBaseDataTableViewCell.h"
#import "MarketValueTableViewCell.h"
#import "HorizontalBarTableViewCell.h"
#import "HorizontalBarModel.h"
#import "VerticalBarTableViewCell.h"
#import "LineViewTableViewCell.h"


#import "BTCoinBaseInfoReq.h"
#import "BTCoinVolumnReq.h"
#import "BTCoinHoldReq.h"

#import "NSDate+Extent.h"
#import "BTPingjiViewCell.h"

@interface BTAnalyseViewController ()<UITableViewDataSource,UITableViewDelegate,BTLoadingViewDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *horizontalDataArray;

@property (nonatomic, strong) NSArray *barArr;

@property (nonatomic, strong) BTCoinBaseInfo *baseInfo;
@property (nonatomic, strong) NSDictionary *coinHoldInfo;

@property (nonatomic, strong) BTLoadingView *loadingView;


@end

@implementation BTAnalyseViewController

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
    self.barArr = @[];
    self.coinHoldInfo = @{};
    
    [self requestBaseInfo];
    [self requestCoinVolumnProportion];
    [self requestCoinHold];
}

//
- (void)refreshingData{
    [self requestBaseInfo];
}

- (void)requestBaseInfo{
    [self.loadingView showLoading];
    BTCoinBaseInfoReq *baseApi = [[BTCoinBaseInfoReq alloc] initWithKindCode:self.kindCode];
    [baseApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if(request.data &&[request.data isKindOfClass:[NSDictionary class]]){
            _baseInfo = [BTCoinBaseInfo objectWithDictionary:request.data];
            [self.tableView reloadData];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

- (void)requestCoinVolumnProportion{
    BTCoinVolumnReq *api = [[BTCoinVolumnReq alloc] initWithKindCode:self.kindCode];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data &&[request.data isKindOfClass:[NSDictionary class]]){
            _horizontalDataArray = @[].mutableCopy;
            NSArray *arr = request.data[@"exchangeRateList"];
            if([arr isKindOfClass:[NSArray class]]){
                //添加一个空的数据座位第一行
                HorizontalBarModel *headerModel = [[HorizontalBarModel alloc] init];
                headerModel.mainTitle = SAFESTRING(request.data[@"totalVolume"]);
                [_horizontalDataArray addObject:headerModel];
                for (int i = 0; i<arr.count; i++) {
                    NSDictionary *dict = arr[i];
                    HorizontalBarModel *model = [HorizontalBarModel new];
                    model.mainTitle = SAFESTRING(dict[@"key"]);
                    model.tradeAmount = [SAFESTRING(dict[@"volume"]) doubleValue];// 123456.00;
                    model.proportion = [SAFESTRING(dict[@"rate"]) doubleValue];
                    model.progressScale = [SAFESTRING(dict[@"rate"]) doubleValue];
                    [_horizontalDataArray addObject:model];
                    
                }
                [self.tableView reloadData];
            }
            
            NSArray *barArr = request.data[@"tradePairRateList"];
            if([barArr isKindOfClass:[NSArray class]]){
                self.barArr = barArr;
                [self.tableView reloadData];
            }
            
        }
        
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

- (void)requestCoinHold{
    BTCoinHoldReq *api = [[BTCoinHoldReq alloc] initWithKindCode:self.kindCode];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data&&[request.data isKindOfClass:[NSDictionary class]]){
            self.coinHoldInfo = request.data;
            [self.tableView reloadData];
            
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
}

#pragma mark- UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
        case 1:
            return 1;
            break;
        case 2:
            return (self.horizontalDataArray.count <= 1)? 0: self.horizontalDataArray.count;
            break;
        case 3:{
            if(self.barArr.count == 0){
                return 0;
            }
            return 1;
        }
            
            break;
        case 4:{
            if(self.coinHoldInfo.count>0){
                NSArray *addressList = self.coinHoldInfo[@"addressList"];
                if(addressList.count ==0){
                    return 0;
                }
                return 1;
            }
            return 0;
        }
            
            
            break;
            
        default:
            break;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:{
            if(SAFESTRING(self.baseInfo.reputation).length == 0) return RELATIVE_WIDTH(130);
            return RELATIVE_WIDTH(130) +40.0f;
        }
           
            break;
        case 1:
            return RELATIVE_WIDTH(130)+RELATIVE_WIDTH(6);
            break;
        case 2:
            if (indexPath.row == 0) {
                return RELATIVE_WIDTH(46);
            }else{
                return RELATIVE_WIDTH(40);
            }
            break;
        case 3:
            return 300.0f - 9;
            
        case 4:
            return 331.0f - 9;
        default:
            break;
    }
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"";
    Class tableViewClass;
    switch (indexPath.section) {
        case 0:
            cellID = @"baseDataCellID";
            tableViewClass = [AnalyseBaseDataTableViewCell class];
            break;
        case 1:
            cellID = @"marketValueCellID";
            tableViewClass = [MarketValueTableViewCell class];
            break;
            
        case 2:
            cellID = @"horizontalCellID";
            tableViewClass = [HorizontalBarTableViewCell class];
            break;
        case 3:
            cellID = @"verticalCellID";
            tableViewClass = [VerticalBarTableViewCell class];
            break;
        case 4:
            cellID = @"lineCellID";
            tableViewClass = [LineViewTableViewCell class];
            break;
        default:
            break;
    }
    UITableViewCell *cell;
    //解决 horizontalbar 滑动出现的bug
    if([cellID  isEqualToString:@"horizontalCellID"]){
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    }
    if (!cell) {
        cell = [[tableViewClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.section) {
        case 0:{
            AnalyseBaseDataTableViewCell *baseCell = (AnalyseBaseDataTableViewCell*)cell;
            baseCell.info = self.baseInfo;
        }
            
            break;
        case 1:{
            NSString *kind;
            if([SAFESTRING(self.kindCode) containsString:@"/"]){
                kind = [[SAFESTRING(self.kindCode) componentsSeparatedByString:@"/"] firstObject];
            }else{
                kind = SAFESTRING(self.kindCode);
            }
            MarketValueTableViewCell *marketCell = (MarketValueTableViewCell*)cell;
            marketCell.info = self.baseInfo;
            marketCell.kind = kind;
            
        }
            break;
        case 2:
            [(HorizontalBarTableViewCell*)cell parseData:self.horizontalDataArray[indexPath.row] row:indexPath.row];
            break;
            
        case 3:{
            VerticalBarTableViewCell *verticalBarCell = (VerticalBarTableViewCell*)cell;
            verticalBarCell.info = self.barArr;
        }
            break;
        case 4:{
            
            LineViewTableViewCell *lineCell = (LineViewTableViewCell*)cell;
            lineCell.info = self.coinHoldInfo;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 4){
        [MobClick event:@"analysis_address"];
        [BTCMInstance pushViewControllerWithName:@"BTCoinAddressAnalyseVC" andParams:@{@"kindCode":SAFESTRING(self.kindCode)}];
    }
}
#pragma mark -- Customer Accessory
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tag = 1101;
        if(IOS_VERSION >=11.0f){
            _tableView.estimatedSectionHeaderHeight = 0.0;
            _tableView.estimatedSectionFooterHeight = 0.0;
        }
        
        _tableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

@end
