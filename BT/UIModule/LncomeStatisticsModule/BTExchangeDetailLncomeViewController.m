//
//  BTExchangeDetailLncomeViewController.m
//  BT
//
//  Created by admin on 2018/5/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTExchangeDetailLncomeViewController.h"
#import "BTExchangeDetailLncomeCell.h"
#import "NoLoginView.h"
#import "MessageCenterObj.h"
#import "MessageCenterRequest.h"
#import "ReadAllMessageRequest.h"

#import "LncomeStatisticsMainHeadView.h"
#import "LYLOptionPicker.h"
#import "OneEntityVoObj.h"
#import "LncomeStatisticsMainObj.h"
#import "LncomeStatisticsMainSetionView.h"
#import "OneEntityVoObj.h"
#import "BTExchangeAccountDetailApi.h"

#import "ExchangeProfitHeadView.h"


static NSString *const identifier = @"BTExchangeDetailLncomeCell";
@interface BTExchangeDetailLncomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) NoLoginView *noLoginView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) ExchangeProfitHeadView *headView;
@property (nonatomic, assign) NSInteger queryIndex;
@property (nonatomic, strong) UIView *backHeadView;
@property (nonatomic, strong) OneEntityVoObj *detailModel;
@end

@implementation BTExchangeDetailLncomeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.detailModel = self.parameters[@"model"];
    [self creatUI];
}

-(void)creatUI {
    
    self.pageIndex = 1;
    self.queryIndex = 1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTExchangeDetailLncomeCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.separatorColor = kHEXCOLOR(0xdddddd);
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    self.headView.frame = self.backHeadView.frame;
    self.headView.heightLayout.constant = iPhoneX?88.0f:64.0f;
    [self.backHeadView addSubview:self.headView];
    _tableView.tableHeaderView = self.backHeadView;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self refreshUI];
   
    //处理冻结的数据
    NSArray *arr =[self concatFirstArr:[AppHelper getExchangeData:self.detailModel.exchange]];
    if(arr.count == 0){
        self.headView.info = @{};
        //[self.loadingView showNoDataWith:@"zanwushuju"];
        return;
    }
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:nil delegate:nil];
    NSMutableArray *mutaArr = @[].mutableCopy;
    for(NSDictionary *dict in arr){
        NSDictionary *params = @{
                                 @"count": SAFESTRING(dict[@"count"]),
                                 @"freezeCount":SAFESTRING(dict[@"frozonCount"]).length>0?SAFESTRING(dict[@"frozonCount"]):@"0",
                                 @"kind": SAFESTRING(dict[@"kind"])
                                 };
        [mutaArr addObject:params];
    }
    
    NSDictionary *params = @{
                             @"bookkeeptingExchangeCurrencyVOList":mutaArr,
                             @"exchange":SAFESTRING(self.detailModel.exchange)
                             };
    [self.loadingView showLoading];
    BTExchangeAccountDetailApi *api = [[BTExchangeAccountDetailApi alloc] initWithAccountData:@[params]];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if([request.data isKindOfClass:[NSDictionary class]]){
            NSArray *exchangeVOList = request.data[@"exchangeVOList"];
            if(exchangeVOList.count >0){
                NSDictionary *dict = exchangeVOList.firstObject;
                NSArray *info = dict[@"bookkeeptingExchangeCurrencyVOList"];
                [self.dataArray addObjectsFromArray:info];
                [_tableView reloadData];
            }
            self.headView.info = request.data;
            [self.loadingView hiddenLoading];
        }
    } failure:^(__kindof BTBaseRequest *request) {
         [self.loadingView showNoDataWith:@"zanwushuju"];
    }];
}

-(void)refreshUI {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 68;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    BTExchangeDetailLncomeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dict = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - lazy

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(ExchangeProfitHeadView *)headView {
    if (!_headView) {
        _headView = [ExchangeProfitHeadView loadFromXib];
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 231);
        _headView.titleL.text     = self.detailModel.exchangeName;
//        [_headView.eyeBtn addTarget:self action:@selector(eyeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headView;
}

-(UIView *)backHeadView {
    
    if (!_backHeadView) {
        _backHeadView = [[UIView alloc] init];
        _backHeadView.frame = CGRectMake(0, 0, ScreenWidth, (iPhoneX?215.0f:191.0f)+40);
    }
    
    return _backHeadView;
}
-(void)eyeBtnClick {
    
    if (ISNSStringValid([APPLanguageService readIsOrNoEyesType])) {
        
        if (ISStringEqualToString([APPLanguageService readIsOrNoEyesType], @"闭")) {
            
            [self.headView.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-zhengyan"] forState:UIControlStateNormal];
            [APPLanguageService writeIsOrNoEyesType:@"睁"];
        } else {
            [AnalysisService alaysisMine_income_card_behind];
            [self.headView.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-biyan"] forState:UIControlStateNormal];
            [APPLanguageService writeIsOrNoEyesType:@"闭"];
        }
    }else {
        [AnalysisService alaysisMine_income_card_behind];
        [self.headView.eyeBtn setImage:[UIImage imageNamed:@"ic_wodezichan-biyan"] forState:UIControlStateNormal];
        [APPLanguageService writeIsOrNoEyesType:@"闭"];
    }
    [self refreshUI];
    [self.tableView reloadData];
    [[NSNotificationCenter  defaultCenter] postNotificationName:NSNotification_HiddenAssets object:nil];
}

- (NSArray*)concatFirstArr:(NSArray *)firstArr{
    if(firstArr.count == 0) return @[];
    NSMutableArray *arrData = @[].mutableCopy;
    [arrData addObjectsFromArray:firstArr];
    NSArray *sortArray =
    [arrData sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDictionary *dic1 = (NSDictionary*)obj1;
        NSDictionary *dic2 = (NSDictionary*)obj2;
        
        NSString *name1 = dic1[@"kind"];
        NSString *name2 = dic2[@"kind"];
        
        return [name1 compare:name2];
    }];
    
    
    NSMutableArray *arr = [NSMutableArray array];
    
    NSDictionary *firstInfo = sortArray.firstObject;
    __block NSString *referenceName = firstInfo[@"kind"];
    __block NSString *referType = firstInfo[@"type"];
    __block double totalFee = 0.00;
    __block double frozonFee = 0.00;
    
    [sortArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *userInfo = (NSDictionary*)obj;
        NSString *name = userInfo[@"kind"];
        NSString *type = userInfo[@"type"];
        double price = [userInfo[@"count"] doubleValue];
        if ([referenceName isEqualToString:name]) {
            //名称相同 累加价格
            if([type isEqualToString:@"trade"]){
                totalFee += price;
            }else{
                frozonFee += price;
            }
        }else {
            //名称不同 将价格保存到新数组中
            //if([referenceName isEqualToString:name]){
            [arr addObject:@{@"kind":referenceName,@"count":SAFESTRING(@(totalFee).p8fString),@"type":referType,@"frozonConnt":SAFESTRING(@(frozonFee).p8fString)}];
            
            //同时重置全局变量
            totalFee = price;
            referenceName = name;
            referType = type;
        }
    }];
   
    //最后一组数据必定会跳出循环，因此在循环结束时加到数组中
    [arr addObject:@{@"kind":referenceName,@"count":SAFESTRING(@(totalFee).p8fString),@"type":referType,@"frozonCount":SAFESTRING(@(frozonFee).p8fString)}];
    
    return arr;
}

@end
