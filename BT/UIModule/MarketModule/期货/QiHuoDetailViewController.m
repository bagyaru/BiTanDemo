//
//  QiHuoDetailViewController.m
//  BT
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QiHuoDetailViewController.h"
#import "QiHuoDetailCell.h"
#import "QiHuoDetailRequest.h"
#import "QiHuoMainObj.h"
#import "QHSetionView.h"
#import "QiHuoKeyAndVouleObj.h"
static NSString *const identifier = @"QiHuoDetailCell";
@interface QiHuoDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) NSMutableDictionary *detailDict;
@property (nonatomic, strong) QHSetionView *headView;
@property (nonatomic, strong) NSString *FuturesId;
@property (nonatomic, strong) QiHuoMainObj *detalsObj;
@end

@implementation QiHuoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.detailDict setDictionary:@{@"合约名称":@"CME Bitcoin Futures",
//                                     @"产品代码":@"BTC",
//                                     @"合约单位":@"5个比特币",
//                                     @"报价":@" USD/BTC",
//                                     @"最小价格波动":@"CME Bitcoin Futures",
//                                     @"合约名称":@"25美元",
//                                     @"交易时间":@"周日-周五 5:00PM-4:00PM",
//                                     @"挂牌合约":@"最近2个季月（3/6/9/12月）及最近2个连续月（不在季月中）到期的",
//                                     @"最后交易日":@"合约到期月的最后一个星期五",
//                                     @"仓位限制":@"当前月份合约不超过1000手，其余月份单个月份/n合约不超过5000手，/n且所有月份合约总数不超过5000手",
//                                     @"大宗交易门槛":@"最少50份合约",
//                                     @"价格限制与暂停交易":@"无价格限制，一定条件下XBT合约的价格变动会触发暂停交易分钟级",
//                                     @"结算":@"现金结算，结算价参考最后",
//                                     @"保证金比率":@"35%",
//                                     }];
    [self creatUI];
    // Do any additional setup after loading the view from its nib.
}
+ (id)createWithParams:(NSDictionary *)params{
    QiHuoDetailViewController *vc = [[QiHuoDetailViewController alloc] init];
    vc.FuturesId = [params objectForKey:@"FuturesId"];
    vc.hidesBottomBarWhenPushed = YES;
    NSLog(@"%@",vc.FuturesId);
    
    return vc;
    
}
-(void)creatUI {
    self.pageIndex = 1;
    self.title = [APPLanguageService wyhSearchContentWith:@"shichangxiangqing"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([QiHuoDetailCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = CViewBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
    }];
    
//    _tableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
//        self.pageIndex++;
//        [self requestList:RefreshStateUp];
//    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
    [self requestList:RefreshStateNormal];
    
}
- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    QiHuoDetailRequest *api = [[QiHuoDetailRequest alloc] initWithFuturesId:self.FuturesId];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            [self.loadingView hiddenLoading];
            _detalsObj = [QiHuoMainObj objectWithDictionary:request.data];
            [self paixunData];
            if ([request.data count] < BTPagesize) {
                self.tableView.mj_footer.hidden = YES;;
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView.mj_header endRefreshing];
        }else if (state == RefreshStateUp){
            if ([request.data count] < BTPagesize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
           _detalsObj = [QiHuoMainObj objectWithDictionary:request.data];
        }
        [self.tableView reloadData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
//返回的数据进行排序
-(void)paixunData {
    
    NSArray *paiXuArr = @[@"合约名称",
                          @"产品代码",
                          @"合约单位",
                          @"报价",
                          @"最小价格波动",
                          @"保证金比率",
                          @"交易时间",
                          @"最后交易日",
                          @"大宗交易门槛",
                          @"结算"];
    
    NSMutableDictionary *moreDetailDict = [[NSMutableDictionary alloc] init];
    
    if (ISNSStringValid(_detalsObj.contractName)) {
        
        [moreDetailDict setObject:_detalsObj.contractName forKey:@"合约名称"];
    }
    if (ISNSStringValid(_detalsObj.productCode)) {
        
        [moreDetailDict setObject:_detalsObj.productCode forKey:@"产品代码"];
    }
    
    if (ISNSStringValid(_detalsObj.contractUnit)) {
        
        [moreDetailDict setObject:_detalsObj.contractUnit forKey:@"合约单位"];
    }
    if (ISNSStringValid(_detalsObj.quotePrice)) {
        
        [moreDetailDict setObject:_detalsObj.quotePrice forKey:@"报价"];
    }
    if (ISNSStringValid(_detalsObj.twistingMin)) {
        
        [moreDetailDict setObject:_detalsObj.twistingMin forKey:@"最小价格波动"];
    }
    if (ISNSStringValid(_detalsObj.tradeDate)) {
        
        [moreDetailDict setObject:_detalsObj.tradeDate forKey:@"交易时间"];
    }
    if (ISNSStringValid(_detalsObj.listingContract)) {
        
        [moreDetailDict setObject:_detalsObj.listingContract forKey:@"挂牌合约"];
    }
    if (ISNSStringValid(_detalsObj.lastTradeDate)) {
        
        [moreDetailDict setObject:_detalsObj.lastTradeDate forKey:@"最后交易日"];
    }
    if (ISNSStringValid(_detalsObj.positionLimit)) {
        
        [moreDetailDict setObject:_detalsObj.positionLimit forKey:@"仓位限制"];
    }
    if (ISNSStringValid(_detalsObj.tradeThreshold)) {
        
        [moreDetailDict setObject:_detalsObj.tradeThreshold forKey:@"大宗交易门槛"];
    }
    if (ISNSStringValid(_detalsObj.suspendTrade)) {
        
        [moreDetailDict setObject:_detalsObj.suspendTrade forKey:@"价格限制与暂停交易"];
    }
    if (ISNSStringValid(_detalsObj.balance)) {
        
        [moreDetailDict setObject:_detalsObj.balance forKey:@"结算"];
    }
    if (ISNSStringValid(_detalsObj.bailRate)) {
        
        [moreDetailDict setObject:_detalsObj.bailRate forKey:@"保证金比率"];
    }
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [keys addObjectsFromArray: [moreDetailDict allKeys]];
    [values addObjectsFromArray: [moreDetailDict allValues]];
    for (int i = 0; i < paiXuArr.count; i++) {
        
        NSString *paiXuStr = paiXuArr[i];
        
        for (int j = 0; j < keys.count; j++) {
            
            NSString *keysStr = keys[j];
            
            if (ISStringEqualToString(keysStr, paiXuStr)) {
                
                QiHuoKeyAndVouleObj *obj = [[QiHuoKeyAndVouleObj alloc] init];
                obj.key = keys[j];
                obj.value = values[j];
                [self.dataArray addObject:obj];
            }
            
        }
        
        
        
    }

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
    QiHuoKeyAndVouleObj *obj = self.dataArray[indexPath.row];
    CGFloat titleW = [obj.key sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(MAXFLOAT, 30)].width;
    CGFloat contentH = [getUserCenter customGetContactHeight:obj.value FontOfSize:13 LabelMaxWidth:ScreenWidth-titleW-34 jianju:4.0];
    NSLog(@"%.0f %.0f",titleW,contentH);
    return 20+contentH;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    QiHuoKeyAndVouleObj *obj = self.dataArray[indexPath.row];
    QiHuoDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //[cell creatUIWith:obj];
    cell.titleL.text = obj.key;
    cell.contentL.text = obj.value;
    [getUserCenter getLabelHight:cell.contentL Float:4.0 AddImage:NO];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
   
    return 52;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headView.titleL.text = _detalsObj.contractCode;
   return self.headView;
}
#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableDictionary *)detailDict {
    
    if (!_detailDict) {
        
        _detailDict = [[NSMutableDictionary alloc] init];
    }
    return _detailDict;
}
-(QHSetionView *)headView {
    
    if (!_headView) {
        
        _headView = [QHSetionView loadFromXib];
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 52);
    }
    return _headView;
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
