//
//  BTPriceWarningVC.m
//  BT
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPriceWarningVC.h"
#import "BTPriceWarningCell.h"

#import "BTSavePriceWarnReq.h"
#import "BTPriceWarnInfoReq.h"
#import "MarketRealtimeRequest.h"
#import "ExchangeRealTimeReq.h"
#import "BTCoinDetailPao.h"
@interface BTPriceWarningVC ()<BTLoadingViewDelegate>

@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, copy) BTPriceWarningModel *contentModel;
@property (nonatomic, assign)BTCoinDetailPao *coinPao;
@property (nonatomic, strong)BTBaseRequest *marketRealtimeRequest;
@property (nonatomic, strong)CurrencyModel *cryModel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) BTLoadingView *loadingView;

@end

@implementation BTPriceWarningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [APPLanguageService wyhSearchContentWith:@"jiageyujing"];
//    [self addNavigationItemWithImageNames:@[@"done.png"] isLeft:NO target:self action:@selector(done:) tags:@[@2000]];
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:[APPLanguageService wyhSearchContentWith:@"wangcheng_password"] style:UIBarButtonItemStylePlain target:self action:@selector(done:)];
    [rightBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                           NSForegroundColorAttributeName : UIColorHex(999999)} forState:UIControlStateDisabled];
    [rightBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                           NSForegroundColorAttributeName : MainBg_Color} forState:UIControlStateNormal];
    [rightBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                           NSForegroundColorAttributeName : MainBg_Color} forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightBarItem;
//    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self stopTimer];
}
- (NSString*)cellIdentifier{
    return  [self nibNameOfCell];
}

- (NSString*)nibNameOfCell{
    return @"BTPriceWarningCell";
}

- (void)createOtherViews{
    [self.view addSubview:self.coinPao];
    [self.coinPao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(80);
    }];
    self.coinPao.backgroundColor = [UIColor whiteColor];
    self.mTableView.separatorColor = SeparateColor;
    self.mTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.mTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(92, 0, 0, 0));
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:nil delegate:self];
}

- (void)loadData{
    [self startTimer];
    [self requestInfo];
}

- (void)requestInfo{
    [self.loadingView showLoading];
    BTPriceWarnInfoReq *api = [[BTPriceWarnInfoReq alloc] initWithKind:SAFESTRING(self.dic[@"kindCode"]) exchange:SAFESTRING(self.dic[@"exchangeCode"])];
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if(request.data&&[request.data isKindOfClass:[NSDictionary class]]){
            _contentModel = [BTPriceWarningModel objectWithDictionary:request.data];
            if(_contentModel){
                NSMutableArray *mutaArr =@[].mutableCopy;
                NSArray *titles =@[[APPLanguageService wyhSearchContentWith:@"jiagezhangdao"],[APPLanguageService wyhSearchContentWith:@"jiagediedao"],[APPLanguageService wyhSearchContentWith:@"24Hzhangfuchaoguo"],[APPLanguageService wyhSearchContentWith:@"24Hdiefuchaoguo"]];
                
                NSString *kindCode =self.dic[@"kindCode"];
                NSString *unit = @"";
                if([kindCode containsString:@"/"]){
                    NSArray *arr = [kindCode componentsSeparatedByString:@"/"];
                    unit = [arr lastObject];
                }else{
                    if(ISStringEqualToString([APPLanguageService readLegalTendeType], @"1") ){
                        unit = @"CNY";
                    }else{
                        unit = @"USD";
                    }
                }
        
                NSArray *units =  @[unit,unit,@"%",@"%"];
                NSArray *values;
                NSArray *switchs;
                if(self.contentModel){
                    values =@[@(self.contentModel.risePrice),@(self.contentModel.dropPrice),@(self.contentModel.riseRose),@(self.contentModel.dropRose)];
                    switchs = @[@(self.contentModel.risePriceStatus),@(self.contentModel.dropPriceStatus),@(self.contentModel.riseRoseStatus),@(self.contentModel.dropRoseStatus)];
                }
                NSArray *placeholders=@[[APPLanguageService sjhSearchContentWith:@"tongzhijiage"],[APPLanguageService sjhSearchContentWith:@"tongzhijiage"],[APPLanguageService sjhSearchContentWith:@"tongzhizhangfu"],[APPLanguageService sjhSearchContentWith:@"tongzhidiefu"]];
                for(NSUInteger i =0;i<titles.count;i++){
                    BTPriceWarningModel *model =[[BTPriceWarningModel alloc] init];
                    model.name = titles[i];
                    model.unit = units[i];
                    model.placeHolder = placeholders[i];
                    model.index = i;
                    [mutaArr addObject:model];
                    if(values.count>0){
                        model.value = values[i];
                        model.isSwitch = [switchs[i] boolValue];
                    }
                    
                }
                self.dataArray =mutaArr;
                [self.mTableView reloadData];
            }
        }
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BTPriceWarningCell *cell =[tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model =self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   return  58.0f;
}

#pragma mark -- Event Response
//完成
- (void)done:(UIButton*)btn{
    [self.view endEditing:YES];
    btn.enabled = NO;
    BTPriceWarningModel *model = self.dataArray[0];
    BTPriceWarningModel *model1 =self.dataArray[1];
    BTPriceWarningModel *model2 =self.dataArray[2];
    BTPriceWarningModel *model3 =self.dataArray[3];
    NSDictionary *dict =@{
                          @"dropPrice": @([model1.value doubleValue]),
                          @"dropPriceStatus": @(model1.isSwitch),
                          @"dropRose": @([model3.value doubleValue]),
                          @"dropRoseStatus":  @(model3.isSwitch),
                          @"exchangeCode": SAFESTRING(self.dic[@"exchangeCode"]),
                          @"kind": SAFESTRING(self.dic[@"kindCode"]),
                          @"legalType": @0,
                          @"priceWarningId": _contentModel.priceWarningId?@(_contentModel.priceWarningId):@"",
                          @"risePrice": @([model.value doubleValue]),
                          @"risePriceStatus":  @(model.isSwitch),
                          @"riseRose": @([model2.value doubleValue]),
                          @"riseRoseStatus":  @(model2.isSwitch)
                          };
    NSLog(@"%@",dict);
    BTSavePriceWarnReq *api = [[BTSavePriceWarnReq alloc] initWithDict:dict];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data){
            [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"success"] wait:YES];
            [BTCMInstance popViewController:nil];
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        
        btn.enabled = YES;
    }];
    
}

- (void)saveRequest{
    
    
}

+ (id)createWithParams: (NSDictionary *)params{
    BTPriceWarningVC *vc = [[BTPriceWarningVC alloc] init];
    [vc updateParams:params];
    return vc;
}

- (void)updateParams:(NSDictionary *)params{
    self.dic = params;
}

- (NSString*)getKindCode{
    return SAFESTRING(self.dic[@"kindCode"]);
}
- (NSString*)getExchangeCode{
    return SAFESTRING(self.dic[@"exchangeCode"]);
}
//请求一条分时数据
- (void)requestRealTime{
    NSMutableArray *arrKindList = [NSMutableArray array];
    NSInteger marketType = 1;
    BOOL isCurrency = NO;
    if([[self getKindCode] containsString:@"/"]){
        isCurrency = YES;
        marketType = 2;
    }else{
        marketType  = 1;
    }
    [arrKindList addObject:[self getKindCode]];
    if([[self getExchangeCode] isEqualToString:k_Net_Code]){
        self.marketRealtimeRequest = [[MarketRealtimeRequest alloc] initWithMarketType:marketType kindList:arrKindList];
    }else{
        self.marketRealtimeRequest = [[ExchangeRealTimeReq alloc] initWithExchangeCode:[self getExchangeCode] kindList:arrKindList];
    }
    [self.marketRealtimeRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if ([request.data isKindOfClass:[NSNull class]]) {
            return;
        }
        for (NSDictionary *dic in request.data) {
            
            self.cryModel = [CurrencyModel modelWithJSON:dic];
        }
        self.coinPao.cryModel = self.cryModel;
        self.coinPao.priCryModel = self.cryModel.modelCopy;
        
    } failure:^(__kindof BTBaseRequest *request) {
        //        [self.loadingHeaderView showErrorWith:request.resultMsg];
    }];
}
- (BTCoinDetailPao*)coinPao{
    if(!_coinPao){
        _coinPao = [BTCoinDetailPao loadFromXib];
        _coinPao.isPriceWarning = YES;
//        [_coinPao layoutIfNeeded];
    }
    return _coinPao;
}

- (void)startTimer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:[BTConfigureService shareInstanceService].timeSepa target:self selector:@selector(fetchList) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
}
- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}
- (void)fetchList{
    [self requestRealTime];
}
- (void)refreshingData{
    [self requestInfo];
}

@end
