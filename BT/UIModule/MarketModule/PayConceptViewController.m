//
//  PayConceptViewController.m
//  BT
//
//  Created by apple on 2018/4/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PayConceptViewController.h"
#import "PayConceptCell.h"
#import "PayConceptHeaderView.h"
#import "MyOptionSectionView.h"
#import "BTConceptDetailRequest.h"
#import "PayConceptModel.h"
#import "CurrencyModel.h"
#import "BTLoadingView.h"
@interface PayConceptViewController ()

@property (nonatomic, strong) PayConceptHeaderView *headerView;
@property (nonatomic, strong) NSString *conceptId;
@property (nonatomic, assign) NSInteger sortType;
@property (nonatomic, strong) PayConceptModel *detailModel;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) UIView *sectionHeaderView;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation PayConceptViewController

+ (id)createWithParams: (NSDictionary *)params{
    PayConceptViewController *vc = [[PayConceptViewController alloc] init];
    [vc updateParams:params];
    return vc;
}

- (void)updateParams:(NSDictionary *)params{
    self.conceptId = SAFESTRING(params[@"conceptId"]);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopTimer];
}
- (void)createOtherViews{
    self.loadingView =[[BTLoadingView alloc]initWithParentView:self.view aboveSubView:nil delegate:nil];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSString*)nibNameOfCell{
    return @"PayConceptCell";
}
- (NSString*)cellIdentifier{
    return [self nibNameOfCell];
}

- (void)startTimer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:[BTConfigureService shareInstanceService].timeSepa target:self selector:@selector(refreshListData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
    
}

- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}

- (void)loadData{
    self.sortType = 8;
    self.mTableView.tableHeaderView = self.headerView;
    [self requestData:RefreshStateNormal];
}

//定时器刷新数据
- (void)refreshListData{
    NSArray *visibleArray =  [self.mTableView indexPathsForVisibleRows];
    NSMutableArray *visibleData = @[].mutableCopy;
    
    for (NSInteger i = 0; i < visibleArray.count; i++) {
        NSIndexPath *indexPath = visibleArray[i];
        CurrencyModel *model = self.dataArray[indexPath.row];
        [visibleData addObject:model];
    }
    if (visibleData.count == 0) {
        return;
    }
    BTConceptDetailRequest *api = [[BTConceptDetailRequest alloc]initWithId:self.conceptId sortType:self.sortType];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        NSInteger i = -1;
        PayConceptModel *contentModel = [PayConceptModel objectWithDictionary:request.data];
        _detailModel =contentModel;
        [self setHeaderViewContent];
        for(CurrencyModel *model  in visibleData){
            i++;
            NSIndexPath *indexPath = visibleArray[i];
            for(NSDictionary *dict in contentModel.marketInfoVOList){
                CurrencyModel *changeModel =[CurrencyModel modelWithJSON:dict];
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
                changeModel.icon = [NSString stringWithFormat:@"%@?%@",changeModel.icon,str];
                if([model.kindCode isEqualToString:changeModel.kindCode]){
                    changeModel.type = [self compareSecondModel:changeModel  firstModel:model];
                    [self.dataArray replaceObjectAtIndex:indexPath.row withObject:changeModel];
                }
            }
        }
        
        [self.mTableView reloadData];
        
        
    }failure:^(__kindof BTBaseRequest *request) {
        
    }];
    
}
- (NSInteger)compareSecondModel:(CurrencyModel*)secondModel firstModel:(CurrencyModel*)firstModel{
    if (kIsCNY) {
        if ([secondModel.priceCNY doubleValue] > [firstModel.priceCNY doubleValue]) {
            return 1;
        }else if ([secondModel.priceCNY doubleValue] == [firstModel.priceCNY doubleValue]){
            return 0;
        }else{
            return 2;
        }
    }else{
        if ([secondModel.priceUSD doubleValue] > [firstModel.priceUSD doubleValue]) {
            return 1;
        }else if ([secondModel.priceUSD doubleValue] == [firstModel.priceUSD doubleValue]){
            return 0;
        }else{
            return 2;
        }
    }
}
//请求数据
- (void)requestData:(RefreshState)state{
    if(state == RefreshStateNormal){
        [self.loadingView showLoading];
    }
    BTConceptDetailRequest *api = [[BTConceptDetailRequest alloc]initWithId:self.conceptId sortType:self.sortType];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        self.dataArray = @[].mutableCopy;
        if(request.data&&[request.data isKindOfClass:[NSDictionary class]]){
            PayConceptModel *model = [PayConceptModel objectWithDictionary:request.data];
            _detailModel = model;
            for(NSDictionary *dict in model.marketInfoVOList){
                CurrencyModel *marketModel = [CurrencyModel modelWithJSON:dict];
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
                marketModel.icon = [NSString stringWithFormat:@"%@?%@",marketModel.icon,str];
                [self.dataArray addObject:marketModel];
            }
            [self.mTableView reloadData];
            [self setHeaderViewContent];
            
        }
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

- (void)setHeaderViewContent{
    self.headerView.model =_detailModel;
    self.title = _detailModel.conceptClassifyName;
}
#pragma mark -- Custom Accessor
- (UIView*)headerView{
    if(!_headerView){
        _headerView = [PayConceptHeaderView loadFromXib];
        _headerView.frame = CGRectMake(0, 0, ScreenWidth, 166.0f);
    }
    return _headerView;
}

- (UIView*)sectionHeaderView{
    if(!_sectionHeaderView){
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 88.0f)];
        view.backgroundColor = isNightMode?ViewBGNightColor :CWhiteColor;
        UILabel *label =[UILabel labelWithFrame:CGRectZero title:[APPLanguageService wyhSearchContentWith:@"hangqing"] font:[UIFont fontWithName:@"PingFangSC-Medium" size:16] textColor: FirstColor];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.top.equalTo(view);
            make.height.mas_equalTo(50.0f);
        }];
        MyOptionSectionView *sectionView =  [MyOptionSectionView loadFromXib];
        sectionView.type = SectionViewTypeMarket;
        sectionView.isShizhi = YES;
        sectionView.frame =CGRectMake(0, 50.0f, ScreenWidth, 38.0f);
        [view addSubview:sectionView];
        
        WS(ws);
        sectionView.sortBlock = ^(NSInteger type) {
            ws.sortType = type;
            [ws requestData:RefreshStatePull];
        };
        
        sectionView.sortShizhiBlock = ^(NSInteger type) {
            ws.sortType = type;
            [ws requestData:RefreshStatePull];
        };
        sectionView.sortPriceBlock = ^(NSInteger type) {
            ws.sortType = type;
            [ws requestData:RefreshStatePull];
        };
        sectionView.countBlock = ^(NSInteger type) {
            ws.sortType = type;
            [ws requestData:RefreshStatePull];
        };
        sectionView.handleBlock = ^(NSInteger type) {
            ws.sortType = type;
            [ws requestData:RefreshStatePull];
        };
        _sectionHeaderView =view;
    }
    return _sectionHeaderView;
}
#pragma mark -- UITableView Delegate DataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PayConceptCell *cell =[tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76.0f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 88.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CurrencyModel *model =self.dataArray[indexPath.row];
    NSData *data = [model modelToJSONData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:dic];
}

@end
