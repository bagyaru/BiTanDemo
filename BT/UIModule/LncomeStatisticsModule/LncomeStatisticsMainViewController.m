//
//  LncomeStatisticsMainViewController.m
//  BT
//
//  Created by admin on 2018/3/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LncomeStatisticsMainViewController.h"
#import "OneEntityVoCell.h"
#import "NoLoginView.h"
#import "MessageCenterObj.h"
#import "MessageCenterRequest.h"
#import "ReadAllMessageRequest.h"
#import "UserAccountMainRequest.h"
#import "LncomeStatisticsMainHeadView.h"
#import "LYLOptionPicker.h"
#import "OneEntityVoObj.h"
#import "LncomeStatisticsMainObj.h"
#import "LncomeStatisticsMainSetionView.h"
#import "BTSearchService.h"
static NSString *const identifier = @"OneEntityVoCell";
@interface LncomeStatisticsMainViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) NoLoginView *noLoginView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *JJSArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) LncomeStatisticsMainHeadView *headView;
@property (nonatomic, strong) LncomeStatisticsMainObj *detailObj;
@property (nonatomic, assign) NSInteger queryIndex;
@property (nonatomic, strong) UIView *backHeadView;
@property (nonatomic, strong) UIView *failureHeader;
@end

@implementation LncomeStatisticsMainViewController
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSNotification_addJYTJSuccess
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"refreshRecord"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSNotification_HiddenAssets
                                                  object:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //self.topLayout.constant = iPhoneX?-44.0f:-20.0f;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    //获取通知中心单例对象
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(addJYTJSuccess:) name:NSNotification_addJYTJSuccess object:nil];
    [center addObserver:self selector:@selector(addJYTJSuccess:) name:@"refreshRecord" object:nil];
    [center addObserver:self selector:@selector(HiddenAssets:) name:NSNotification_HiddenAssets object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)addJYTJSuccess:(NSNotification *)notif {
    
    [self requestList:RefreshStateNormal];
}
-(void)HiddenAssets:(NSNotification *)notif {
    [self requestList:RefreshStatePull];
}
-(void)creatUI {
    //[self addNavigationItemViewWithImageNames:@"曲线" isLeft:NO target:self action:@selector(naviBtnClick:) tag:10000];
    self.pageIndex = 1;
    self.queryIndex = 1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OneEntityVoCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = CFontColor4;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    self.headView.frame = self.backHeadView.frame;
    self.headView.heightLayout.constant = iPhoneX?88.0f:64.0f;
    [self.backHeadView addSubview:self.headView];
    _tableView.tableHeaderView = self.backHeadView;
    _tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [AppHelper startRefreshTasks];
        [self requestList:RefreshStatePull];
    }];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:nil delegate:self];
    [AppHelper startRefreshTasks];
    [self requestList:RefreshStateNormal];
    
}
//曲线
-(void)naviBtnClick:(UIButton *)btn {
    if(_detailObj){
        [BTCMInstance pushViewControllerWithName:@"ProfitCurveVC" andParams:@{@"data":_detailObj}];
    }
    
    [AnalysisService alaysisIncome_graph_button];
}
- (void)requestList:(RefreshState)state{
    
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    UserAccountMainRequest *api = [[UserAccountMainRequest alloc] initWithSort:self.queryIndex];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
         [self.failureHeader removeFromSuperview];
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.detailObj.detailVOList removeAllObjects];
            [self.JJSArray  removeAllObjects];
            NSArray *entityVoList = request.data[@"detailVOList"];
            if ([entityVoList count]) {
                self.detailObj = [LncomeStatisticsMainObj objectWithDictionary:request.data];
                self.detailObj.detailVOList = [[NSMutableArray alloc] init];
                for (NSDictionary *dic in entityVoList) {
                    
                    OneEntityVoObj *obj = [OneEntityVoObj objectWithDictionary:dic];
                    obj.jjsOrjjb = 20;
                    [self.detailObj.detailVOList addObject:obj];
                    
                }
            }
    
            [self.tableView.mj_header endRefreshing];
           
        }
        [self loadExchangeJJJLData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.loadingView showErrorWith:request.resultMsg];
        [self creatNavGationView];
    }];
}

//获取交易所自动授权交易记录
-(void)loadExchangeJJJLData {
    NSArray *exchangeCodeArray = @[@"binance",@"huobi.pro",@"okex"];
    NSArray *exchangeNameArray = @[@"币安",@"火币pro",@"OKEx"];
    for (int i = 0; i < exchangeNameArray.count; i++) {
        
        if ([[BTSearchService sharedService] readExchangeAuthorizedWithExchangeName:exchangeNameArray[i] userId:[NSString stringWithFormat:@"%ld",getUserCenter.userInfo.userId]]) {
            OneEntityVoObj *model         = [OneEntityVoObj objectWithDictionary:[AppHelper getExchangeTotolInfo:exchangeCodeArray[i]]];
            model.exchangeName            = exchangeNameArray[i];
            model.jjsOrjjb                = 10;
            self.detailObj.currencyCount += model.btcCount;
            
            self.detailObj.balance       += kIsCNY?model.priceCny:model.priceUsd;
            
            self.detailObj.positionCapitalizationCurrency += model.btcCount;
            self.detailObj.positionCapitalCurrency +=model.btcCount;
            //市值 本金
            self.detailObj.positionCapital        += kIsCNY?model.priceCny:model.priceUsd;
            self.detailObj.positionCapitalization += kIsCNY?model.priceCny:model.priceUsd;
            
            [self.JJSArray addObject:model];
        }
    }
    if (self.JJSArray.count > 0) {
        
        if (self.queryIndex == 1 || self.queryIndex == 3) {
           
            //升序
            self.JJSArray =  [NSMutableArray arrayWithArray:[self.JJSArray sortedArrayUsingComparator:^NSComparisonResult(OneEntityVoObj *obj1, OneEntityVoObj  *obj2) {
                return [@(obj2.btcCount) compare:@(obj1.btcCount)];
            }]];
        } else {
            
            //降序
            self.JJSArray =  [NSMutableArray arrayWithArray:[self.JJSArray sortedArrayUsingComparator:^NSComparisonResult(OneEntityVoObj *obj1, OneEntityVoObj   *obj2) {
                return [@(obj1.btcCount) compare:@(obj2.btcCount)];
            }]];
        }
    }
    if (self.detailObj.detailVOList.count <= 0 && self.JJSArray.count <= 0) {
        
        self.addBtn.hidden = YES;
        [self.loadingView showLncomeStatisticsView];
        [self creatNavGationView];
    }else {
        [self.loadingView hiddenLoading];
        self.addBtn.hidden = NO;
        [self.failureHeader removeFromSuperview];
        [self refreshUI];
    }
    [self.tableView reloadData];
}

//
-(void)creatNavGationView {
    UIView *HeadView = [[UIView alloc] init];
    HeadView.frame = CGRectMake(0, 0, ScreenWidth, iPhoneX?255:231);
    [self.view addSubview:HeadView];
    HeadView.frame = CGRectMake(0, 0, ScreenWidth, iPhoneX?205:191);
    self.failureHeader = HeadView;
    LncomeStatisticsMainHeadView * mainView = [LncomeStatisticsMainHeadView loadFromXib];
    mainView.frame = CGRectMake(0, 0, ScreenWidth, 125);
    mainView.frame = HeadView.frame;
    mainView.heightLayout.constant = iPhoneX?88.0f:64.0f;
    [HeadView addSubview:mainView];
    mainView.bottomConst.constant = 0;
    LncomeStatisticsMainObj *obj = [[LncomeStatisticsMainObj alloc] init];
    mainView.obj = obj;
    mainView.paixunBtn.hidden = YES;
    mainView.paixuSJb.hidden = YES;
}
-(void)refreshUI {
    self.headView.obj = self.detailObj;
}

#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    [AppHelper startRefreshTasks];
    [self requestList:RefreshStateNormal];
}
-(void)addLncomeStatistics {
    
    [AnalysisService alaysisIncome_add_button];
    [BTCMInstance pushViewControllerWithName:@"BTNewAddRecord" andParams:@{@"kind":@""}];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return (self.detailObj.detailVOList.count > 0 && self.JJSArray.count > 0) ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.detailObj.detailVOList.count > 0 && self.JJSArray.count > 0) {
        
        if (section == 0) return self.JJSArray.count;
        if (section == 1) return self.detailObj.detailVOList.count;
    }
    return self.JJSArray.count > 0 ? self.JJSArray.count : self.detailObj.detailVOList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    return 68;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   LncomeStatisticsMainSetionView *setionV = [LncomeStatisticsMainSetionView loadFromXib];
    setionV.frame = CGRectMake(0, 0, ScreenWidth, 40);
    
    if (self.detailObj.detailVOList.count > 0 && self.JJSArray.count > 0) {
        
    if (section == 0) {
        setionV.IV.image = IMAGE_NAMED(@"ic_jiaoyisuo");
        setionV.typeL.text = [APPLanguageService wyhSearchContentWith:@"jiaoyisuo"];
    } else {
        setionV.IV.image = IMAGE_NAMED(@"ic_jiaoyibi");
        setionV.typeL.text = [APPLanguageService wyhSearchContentWith:@"jiaoyibi"];
    }
        
    }else {
        
        if (self.JJSArray.count > 0) {
            setionV.IV.image = IMAGE_NAMED(@"ic_jiaoyisuo");
            setionV.typeL.text = [APPLanguageService wyhSearchContentWith:@"jiaoyisuo"];
        }else {
            setionV.IV.image = IMAGE_NAMED(@"ic_jiaoyibi");
            setionV.typeL.text = [APPLanguageService wyhSearchContentWith:@"jiaoyibi"];
        }
    }
    return setionV;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    OneEntityVoObj *obj;
    BOOL lineHidden = NO;
    if (self.detailObj.detailVOList.count > 0 && self.JJSArray.count > 0) {
        if (indexPath.section == 0) {
            obj = self.JJSArray[indexPath.row];
        }else {
            
            obj = self.detailObj.detailVOList[indexPath.row];
            
            if (indexPath.row == self.detailObj.detailVOList.count-1) lineHidden = YES;
        }
    }else {
        
        if (self.JJSArray.count > 0) {
           obj = self.JJSArray[indexPath.row];
            if (indexPath.row == self.JJSArray.count-1) lineHidden = YES;
        }else {
           obj = self.detailObj.detailVOList[indexPath.row];
            if (indexPath.row == self.detailObj.detailVOList.count-1) lineHidden = YES;
        }
    }
    OneEntityVoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.setion = indexPath.section;
    cell.lineL.hidden = lineHidden;
    [cell creatUIWith:obj];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    OneEntityVoObj *obj;
    if (self.detailObj.detailVOList.count > 0 && self.JJSArray.count > 0) {
        if (indexPath.section == 0) {
            obj = self.JJSArray[indexPath.row];
        }else {
            
            obj = self.detailObj.detailVOList[indexPath.row];
        }
    }else {
        
        if (self.JJSArray.count > 0) {
            obj = self.JJSArray[indexPath.row];
        }else {
            obj = self.detailObj.detailVOList[indexPath.row];
        }
    }
    if (obj.jjsOrjjb == 20) {
         [BTCMInstance pushViewControllerWithName:@"ProfitLossStatVC" andParams:@{@"kindCode":SAFESTRING(obj.kind),@"balance":SAFESTRING(@(obj.balance)),@"count":SAFESTRING(@(obj.countNumb)),@"earnings":SAFESTRING(@(obj.earnings)),@"realPrice":SAFESTRING(@(obj.realPrice)),@"currencyCount":@(obj.currencyCount)}];
    }else {
        
        [BTCMInstance pushViewControllerWithName:@"BTExchangeDetailLncome" andParams:@{@"model":obj}];
    }
   
}

//选择排序
-(void)paixunBtnClick {
    
    [LYLOptionPicker showOptionPickerInView:[[[UIApplication sharedApplication] delegate] window] dataSource:@[@[[APPLanguageService wyhSearchContentWith:@"zuigaochiyoushu"],[APPLanguageService wyhSearchContentWith:@"zuidichiyoushu"],[APPLanguageService wyhSearchContentWith:@"zuigaochiyoujine"],[APPLanguageService wyhSearchContentWith:@"zuidichiyoujine"]]] determineChoose:^(NSArray *indexes, id selectedItems) {
         NSLog(@"%@,%@",indexes[0],selectedItems[0]);
        [self.headView.paixunBtn setTitle:selectedItems[0] forState:UIControlStateNormal];
        self.queryIndex = [indexes[0] integerValue] + 1;
        [self requestList:RefreshStateNormal];
    }];
}
//添加记录
- (IBAction)addBtnClick:(UIButton *)sender {
    
    [AnalysisService alaysisIncome_add_button];
    [BTCMInstance pushViewControllerWithName:@"BTNewAddRecord" andParams:@{@"kind":@""}];
}

#pragma mark - lazy

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)JJSArray {
    
    if (!_JJSArray) {
        
        _JJSArray = [NSMutableArray array];
    }
    return _JJSArray;
}
- (NoLoginView *)noLoginView{
    if (!_noLoginView) {
        _noLoginView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NoLoginView class]) owner:self options:nil][0];
    }
    return _noLoginView;
}
-(LncomeStatisticsMainHeadView *)headView {
    
    if (!_headView) {
        
        _headView = [LncomeStatisticsMainHeadView loadFromXib];
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 125);
        [_headView.paixunBtn addTarget:self action:@selector(paixunBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //[_headView.eyeBtn addTarget:self action:@selector(eyeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headView;
}
-(LncomeStatisticsMainObj *)detailObj {
    
    if (!_detailObj) {
        
        _detailObj = [[LncomeStatisticsMainObj alloc] init];
    }
    
    return _detailObj;
}
-(UIView *)backHeadView {
    if (!_backHeadView) {
        _backHeadView = [[UIView alloc] init];
        _backHeadView.frame = CGRectMake(0, 0, ScreenWidth, iPhoneX?255:231);
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
}
#pragma mark --Custom Accessor
- (UIView *)naviView{
    if(!_naviView){
        _naviView =[[UIView alloc] initWithFrame:CGRectZero];
        _naviView.backgroundColor = kHEXCOLOR(0xffffff);
        BTButton *leftBtn = [BTButton buttonWithType:UIButtonTypeCustom];
        [_naviView addSubview:leftBtn];
        [leftBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(_naviView);
            make.width.height.mas_equalTo(44.0f);
        }];
        UILabel *titleLabel = [UILabel labelWithFrame:CGRectZero title:[APPLanguageService wyhSearchContentWith:@"bijizhang"] font:[UIFont systemFontOfSize:16.0f] textColor:kHEXCOLOR(0x111210)];
        [_naviView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftBtn);
            make.centerX.equalTo(_naviView);
        }];
        UILabel *line = [[UILabel alloc] init];
        [_naviView addSubview:line];
        line.backgroundColor = CLineColor;
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(_naviView);
            make.height.mas_equalTo(0.5f);
        }];
    }
    return _naviView;
}
#pragma mark -- Event Response
- (void)pop{
    [BTCMInstance popViewController:nil];
}

@end
