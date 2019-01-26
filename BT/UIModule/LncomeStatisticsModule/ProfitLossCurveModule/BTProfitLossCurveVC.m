//
//  BTProfitLossCurveVC.m
//  BT
//
//  Created by apple on 2018/3/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTProfitLossCurveVC.h"
#import "MenuHrizontal.h"
#import "BTProfitLossCurveHeaderView.h"
#import "UILabel+Factory.h"
#import "BTLineChartView.h"
#import "ProfitLossCurveRequest.h"
#import "NSDate+Extent.h"

#define CURVE_PAGE_SIZE 30
@interface BTProfitLossCurveVC ()<MenuHrizontalDelegate,UITableViewDelegate>
@property (nonatomic, copy)NSDictionary *dict;
@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) BTProfitLossCurveHeaderView *profitLossCurveHeader;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) MenuHrizontal *menuBtn;
@property (nonatomic, strong) BTLineChartView *lineChartView;
@property (nonatomic, strong)NSMutableArray *dataArr;
@property (nonatomic, strong)NSMutableArray *xLabelArr;
@property (nonatomic, strong)NSMutableArray *numArr;
@property (nonatomic, strong)UIView *hintFootView;
@property (nonatomic, strong)UIView *showInfoView;
@property (nonatomic, strong) UILabel *dateL;
@property (nonatomic, strong)UILabel *profitL;

@end

@implementation BTProfitLossCurveVC

+ (id)createWithParams: (NSDictionary *)params{
    BTProfitLossCurveVC *vc = [[BTProfitLossCurveVC alloc] init];
    [vc updateParams:params];
    return vc;
}

- (void)updateParams:(NSDictionary *)params{
    self.dict = params;
}
#pragma mark -- Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}
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
- (void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark --Create UI
- (void)createUI{
    [self.view addSubview:self.naviView];
    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo(iPhoneX?88.0f:64.0f);
    }];
    [self.view addSubview:self.profitLossCurveHeader];
    self.profitLossCurveHeader.frame =CGRectMake(0, 0, ScreenWidth, 180.0f-64.0f);
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.naviView.mas_bottom);
    }];
    self.mTableView.tableHeaderView = self.profitLossCurveHeader;
}

#pragma mark --Load Data
- (void)loadData{
    UIView *footView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-(iPhoneX?88.0f:64.0f)-self.profitLossCurveHeader.height)];
    [footView addSubview:self.lineChartView];
    
    [self.lineChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(footView);
        make.top.equalTo(footView).offset(40);
        make.bottom.equalTo(footView.mas_bottom).offset(-60);
    }];
    footView.backgroundColor = [UIColor whiteColor];
    [footView addSubview:self.showInfoView];
    self.showInfoView.frame =CGRectMake(0, 0, ScreenWidth, 40);
    self.showInfoView.hidden = YES;
    
    self.mTableView.tableFooterView = footView;
    _dataArr =@[].mutableCopy;
    _xLabelArr =@[].mutableCopy;
    _numArr =@[].mutableCopy;
    self.profitLossCurveHeader.detailObj = self.dict[@"data"];
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHintInfo:) name:@"KShowProfitInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noShowHintInfo:) name:@"KNoShowProfitInfo" object:nil];
}

- (void)showHintInfo:(NSNotification*)notify{
    self.showInfoView.hidden = NO;
    NSDictionary *dict =notify.object;
    NSString *dateStr =dict[@"date"];
    NSString *profit =dict[@"profit"];
    self.dateL.text =[NSDate getTimeStrFromInterval:dateStr andFormatter:@"yyyy-MM-dd"];
    self.profitL.text =[NSString stringWithFormat:@"%.2f",[profit doubleValue]];
}
- (void)noShowHintInfo:(NSNotification*)notify{
    self.showInfoView.hidden = YES;
}
- (void)requestData{
    ProfitLossCurveRequest *request =[[ProfitLossCurveRequest alloc]initWithCurrentPage:1 pageSize:CURVE_PAGE_SIZE];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        NSLog(@"data %@",request.data);
        if([request.data isKindOfClass:[NSArray class]]){
            [_dataArr addObjectsFromArray:request.data];
        }
        [self processLineChartData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

- (void)processLineChartData{
    if(_dataArr.count ==0){
        self.mTableView.tableFooterView = self.hintFootView;
        return;
    }
    for(NSDictionary *dict in _dataArr){
        NSString *dateStr= SAFESTRING(dict[@"date"]);
        [_xLabelArr addObject:dateStr];
        [_numArr addObject:@([SAFESTRING(dict[@"blance"]) doubleValue])];
    }
    NSNumber *max = [_numArr valueForKeyPath:@"@max.self"];
    NSNumber *min = [_numArr valueForKeyPath:@"@min.self"];
    //NSNumber *avg = [_numArr valueForKeyPath:@"@avg.self"];
    if(_numArr.count ==1){
        CGFloat amin =[max doubleValue] *0.95;
        CGFloat amax =[max doubleValue] *1.05;
        CGFloat value = (amax -amin)/4;
        self.lineChartView.scaleNums = @[@(amin+3*value),@(amin+2*value),@(amin+value)];
        
    }else if(_numArr.count>1){
        CGFloat value =([max doubleValue]-[min doubleValue])/4;
        self.lineChartView.scaleNums = @[@([min doubleValue]+3*value),@([min doubleValue]+2*value),@([min doubleValue]+value)];
    }else{
        self.lineChartView.scaleNums =@[];
    }
    self.lineChartView.lineChartXLabelArray = _xLabelArr;
    self.lineChartView.LineChartDataArray = _numArr;
}

#pragma mark --Custom Accessor
- (UIView *)naviView{
    if(!_naviView){
        _naviView =[[UIView alloc] initWithFrame:CGRectZero];
        _naviView.backgroundColor = kHEXCOLOR(0x2C3744);
        BTButton *leftBtn = [BTButton buttonWithType:UIButtonTypeCustom];
        [_naviView addSubview:leftBtn];
        [leftBtn addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
        [leftBtn setImage:[UIImage imageNamed:@"return_back"] forState:UIControlStateNormal];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(_naviView);
            make.width.height.mas_equalTo(44.0f);
        }];
        
        UILabel *titleLabel = [UILabel labelWithFrame:CGRectZero title:@"收益曲线" font:[UIFont systemFontOfSize:16.0f] textColor:  kHEXCOLOR(0xFFFFFF)];
        [_naviView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(leftBtn);
            make.centerX.equalTo(_naviView);
        }];
    }
    return _naviView;
}

- (BTProfitLossCurveHeaderView*)profitLossCurveHeader{
    if(!_profitLossCurveHeader){
        _profitLossCurveHeader = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BTProfitLossCurveHeaderView class]) owner:self options:nil][0];
    }
    return _profitLossCurveHeader;
}

- (MenuHrizontal*)menuBtn{
    if(!_menuBtn){
        _menuBtn =[[MenuHrizontal alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 34.0f)];
        _menuBtn.delegate = self;
        _menuBtn.backgroundColor = kHEXCOLOR(0x2C3744);
        _menuBtn.lineBtnArr =@[@{@"name":@"每天"}];
        [_menuBtn clickButtonAtIndex:0];
    }
    return _menuBtn;
}

- (UIView*)showInfoView{
    if(!_showInfoView){
        _showInfoView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        _showInfoView.backgroundColor =kHEXCOLOR(0x3C3D4B);
        
        UILabel *dateInfoL =[UILabel labelWithFrame:CGRectZero title:@"时间:" font:[UIFont systemFontOfSize:13.0f]textColor: [UIColor whiteColor]];
        UILabel *dateL =[UILabel labelWithFrame:CGRectZero title:@"" font:[UIFont systemFontOfSize:13.0f]textColor: [UIColor whiteColor]];
        UILabel *profitInfoL =[UILabel labelWithFrame:CGRectZero title:@"收益:" font:[UIFont systemFontOfSize:13.0f]textColor: [UIColor whiteColor]];
        UILabel *profitL =[UILabel labelWithFrame:CGRectZero title:@"" font:[UIFont systemFontOfSize:13.0f]textColor: [UIColor whiteColor]];
        [_showInfoView addSubview:dateInfoL];
        [_showInfoView addSubview:dateL];
        [_showInfoView addSubview:profitInfoL];
        [_showInfoView addSubview:profitL];
        self.dateL =dateL;
        self.profitL = profitL;
        
        [dateInfoL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_showInfoView).offset(15);
            make.centerY.equalTo(_showInfoView.mas_centerY);
        }];
        [dateL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dateInfoL.mas_right).offset(5);
            make.centerY.equalTo(_showInfoView.mas_centerY);
        }];
        [profitInfoL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(dateL.mas_right).offset(30);
            make.centerY.equalTo(_showInfoView.mas_centerY);
        }];
        [profitL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(profitInfoL.mas_right).offset(5);
            make.centerY.equalTo(_showInfoView.mas_centerY);
        }];
    }
    return _showInfoView;
}

-(UITableView*)mTableView{
    if(!_mTableView){
        _mTableView =[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.scrollEnabled =NO;
        _mTableView.delegate=self;
        if(IOS_VERSION >= 11.0f){
            _mTableView.estimatedSectionHeaderHeight=0.0;
            _mTableView.estimatedSectionFooterHeight=0.0;
        }
        _mTableView.backgroundColor = [UIColor whiteColor];
        _mTableView.bounces = NO;
        _mTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _mTableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator =NO;
    }
    return _mTableView;
}

- (BTLineChartView*)lineChartView{
    if(!_lineChartView){
        _lineChartView = [[BTLineChartView alloc]init];
        _lineChartView.backgroundColor = [UIColor whiteColor];
        //_lineChartView.bounds = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
        _lineChartView.lineChartYLabelArray = @[];
        
    }
    return _lineChartView;
}

- (UIView*)hintFootView{
    if(!_hintFootView){
        _hintFootView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
        UIImageView *imageV =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"unCurveRecord"]];
        [_hintFootView addSubview:imageV];
        UILabel *label =[UILabel labelWithFrame:CGRectZero title:@"暂无曲线记录" font:[UIFont systemFontOfSize:14.0f] textColor:kHEXCOLOR(0x6F6F6F)];
        label.textAlignment = NSTextAlignmentCenter;
        [_hintFootView addSubview:label];
        
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_hintFootView.mas_centerX);
            make.top.equalTo(_hintFootView).offset(83.0f);
            make.width.mas_equalTo(110.0f);
            make.height.mas_equalTo(70.0f);
        }];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageV.mas_bottom).offset(37.0f);
            make.left.right.equalTo(_hintFootView);
        }];
    }
    return _hintFootView;
}
#pragma mark -UITableView Delegate

#pragma mark -- Event Response
- (void)pop{
    [BTCMInstance popViewController:nil];
}
@end
