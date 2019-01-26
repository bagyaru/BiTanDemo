//
//  MyOptionViewController.m
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyOptionViewController.h"
#import "MyOptionCell.h"
#import "MyOptionSectionView.h"
#import "NoLoginView.h"
#import "QueryUserBtcRequest.h"
#import "ItemModel.h"
#import "BTSearchService.h"
#import "MarketRealtimeRequest.h"
#import "BTConfigureService.h"

#import "MyZiOptionView.h"
#import "BTGroupCoinListReq.h"

#import "GroupSideView.h"
#import "BTGroupListRequest.h"
#import "ExchangeRealTimeReq.h"
#import "BTGroupRealTimeReq.h"

static NSString *const identifier = @"MyOptionCell";

@interface MyOptionViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewTop;

@property (weak, nonatomic) IBOutlet UITableView *tableViewContainer;

@property (nonatomic, strong) MyZiOptionView *sectionView;

@property (weak, nonatomic) IBOutlet UIButton *btnSort;

@property (nonatomic, strong) NoLoginView *noLoginView;

@property (nonatomic, strong) BTLoadingView *loadingView;

@property (nonatomic, strong) MarketRealtimeRequest *marketRealtimeRequest;

@property (nonatomic, strong) MarketRealtimeRequest *marketRealtimeRequestCurrency;

@property (nonatomic, strong) BTGroupRealTimeReq *groupRealTimeReq;


@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *arrData;

@property (nonatomic, strong) NSMutableArray *arrKindList;

@property (nonatomic, strong) NSMutableArray *arrKindNameList;

@property (nonatomic, strong) NSMutableArray *arrChange;

@property (nonatomic, strong) NSMutableArray *arrChangeMarket;

@property (nonatomic, strong) NSMutableArray *arrChangeCurrency;

@property (nonatomic, strong) NSMutableArray *arrMarket;

@property (nonatomic, strong) NSMutableArray *arrCurrency;

@property (nonatomic, strong) NSMutableArray *sortData;

@property (nonatomic, strong) NSMutableArray *arrPriceList;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) BOOL isCNY;

@property (nonatomic, strong) BTGroupListModel *listModel;

@property (nonatomic, strong) NSMutableArray *originArr;//原始数据

@property (nonatomic, strong) BTGroupListRequest *groupListApi;

@property (nonatomic, strong) BTButton *addBtn;
@property (nonatomic, strong) BTButton *editBtn;

@property (nonatomic, assign) BOOL isFirstEnter;

@property (nonatomic, strong) dispatch_source_t sourceTimer;

@property (nonatomic, strong) UIView *footerView;

@end

@implementation MyOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.type = 1;
    if (kIsCNY) {
        self.isCNY = YES;
    }else{
        self.isCNY = NO;
    }
    //初始值
    BTGroupListModel *modelAll = [[BTGroupListModel alloc] init];
    modelAll.groupName = [APPLanguageService sjhSearchContentWith:@"quanbu"];// @"全部";
    modelAll.userGroupId = ALL_GROUP_ID;
    modelAll.isSelected =YES;
    self.listModel = modelAll;
    if(appDelegate.listModel){
        self.listModel =  appDelegate.listModel;
        if(self.listModel.userGroupId == ALL_GROUP_ID){
            self.listModel.groupName = [APPLanguageService sjhSearchContentWith:@"quanbu"];
        }
    }
    
    self.isFirstEnter = YES;
    
    [self configView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestUserBtcList) name:NSNotification_RefreshUserBtc object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestUserBtcList) name:NSNotification_loginSuccess object:nil];
    //NSNotification_loginOutSuccess
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOut) name:NSNotification_loginOutSuccess object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSelectGroup:) name:k_Notification_Refresh_Select_Group object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterDelete:) name:k_Notification_Refresh_After_Delete object:nil];
    
    
    UISwipeGestureRecognizer *swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(slide)];
    swiperight.delegate = self;
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loginOut{
    if (getUserCenter.userInfo.token.length ==  0) {
        self.noLoginView.hidden = NO;
        self.noLoginView.type = LoginOrOptionTypeNoLogin;
        self.noLoginView.loginBlock = ^{
            [AnalysisService alaysisOption_login];
            [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil];
        };
        [self.noLoginView showInWithParentView:self.view];
    }
}

- (void)configView{
    
    WS(ws);
    self.tableViewContainer.tableFooterView = self.footerView;
    self.sectionView.hiddenLine = YES;
    self.sectionView.btnCurrentPrieEnable = NO;
    
    [self.sectionView setGroupName:self.listModel.groupName];
    
    
    self.sectionView.handleBlock = ^(NSInteger type) {
        ws.type = type;
        if (type == 4) {
            //降序
            NSArray *array = ws.arrData;
            if (ws.sortData) {
                array = ws.sortData;
            }
            ws.sortData =  [NSMutableArray arrayWithArray:[array sortedArrayUsingComparator:^NSComparisonResult(CurrencyModel *obj1, CurrencyModel   *obj2) {
                return [@(obj2.rose) compare:@(obj1.rose)];
            }]];
        }else{
            //升序
            NSArray *array = ws.arrData;
            if (ws.sortData) {
                array = ws.sortData;
            }
            ws.sortData =  [NSMutableArray arrayWithArray:[array sortedArrayUsingComparator:^NSComparisonResult(CurrencyModel *obj1, CurrencyModel   *obj2) {
                return [@(obj1.rose) compare:@(obj2.rose)];
            }]];
            
        }
        [ws.tableViewContainer reloadData];
    };
    
    self.sectionView.sortBlock = ^(NSInteger type) {
        ws.type = 1;
        [ws.tableViewContainer reloadData];
    };
    
    //选择分组
    self.sectionView.selectGroupBlock = ^{
        [ws requestGroupList];
    };
    [self.sectionView showInViewWith:self.viewTop];
    ViewRadius(self.btnSort, 30);
    [_tableViewContainer registerNib:[UINib nibWithNibName:NSStringFromClass([MyOptionCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableViewContainer.backgroundColor = CViewBgColor;
    _tableViewContainer.estimatedRowHeight = 0;
    _tableViewContainer.estimatedSectionHeaderHeight = 0;
    _tableViewContainer.estimatedSectionFooterHeight = 0;
    _tableViewContainer.delegate = self;
//    _tableViewContainer.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewContainer.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    _tableViewContainer.separatorColor = SeparateColor;
    
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:self.tableViewContainer delegate:self];
    
    if (getUserCenter.userInfo.token.length ==  0) {
        [self.loadingView hiddenLoading];
        self.noLoginView.type = LoginOrOptionTypeNoLogin;
        self.noLoginView.loginBlock = ^{
            [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil];
        };
        [self.noLoginView showInWithParentView:self.view];
    }else{
        
        [self requestUserBtcList];
    }
}

//分组数据
- (void)requestGroupList{
    // stop 请求
    if(_groupListApi){
        [_groupListApi stop];
    }
    [BTShowLoading show];
    _groupListApi = [[BTGroupListRequest alloc]init];
    [_groupListApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
        if(request.data&&[request.data isKindOfClass:[NSArray class]]){
            NSMutableArray *data =@[].mutableCopy;
            
            BTGroupListModel *modelAll = [[BTGroupListModel alloc] init];
            modelAll.groupName = [APPLanguageService sjhSearchContentWith:@"quanbu"];//@"全部";
            modelAll.userGroupId = ALL_GROUP_ID;
            
            [data addObject:modelAll];
            NSMutableArray *infoArr =@[].mutableCopy;
            for (NSDictionary *dict in request.data){
                BTGroupListModel *info =[BTGroupListModel objectWithDictionary:dict];
                [infoArr addObject:info];
            }
            NSArray *reverseArr =[[infoArr reverseObjectEnumerator] allObjects];
            [data addObjectsFromArray:reverseArr];
            
            for (BTGroupListModel *info in data){
                if(info.userGroupId == self.listModel.userGroupId){
                    info.isSelected = YES;
                }
            }
            [GroupSideView showWithArr:data completion:^(BTGroupListModel *model) {
                self.listModel = model;
                [self requestList:SAFESTRING(model.groupName) state:RefreshStateNormal];
                [self.sectionView setGroupName:model.groupName];
                appDelegate.listModel = model;
                //选择完 给主页面发个通知，通知更新选择组的数据
                [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Refresh_Main_Group object:model];
            }];
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
    }];
}

- (void)startTimer{
    if(!_sourceTimer){
        NSTimeInterval period = [BTConfigureService shareInstanceService].timeSepa; //设置时间间隔
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _sourceTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_sourceTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
        WS(ws) // attention
        dispatch_source_set_event_handler(_sourceTimer, ^{
            [ws fetchList];
            
        });
        dispatch_resume(_sourceTimer);
    }
    //
    
//    if (!_timer) {
//        _timer = [NSTimer timerWithTimeInterval:[BTConfigureService shareInstanceService].timeSepa target:self selector:@selector(fetchList) userInfo:nil repeats:YES];
////        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
//        [_timer fire];
//    }
}

- (void)stopTimer{
//    if(_timer){
//        [_timer invalidate];
//        _timer = nil;
//    }
  
    if(_sourceTimer){
        dispatch_source_cancel(_sourceTimer);
        _sourceTimer = nil;
    }
}

- (void)fetchList{
    
    if(self.arrData.count ==0) return;
    
    NSArray *visibleArray =  self.arrData.copy;
    
    NSMutableArray *visibleData = @[].mutableCopy;
    for (NSInteger i = 0; i < visibleArray.count; i++) {
        //NSIndexPath *indexPath = visibleArray[i];
        CurrencyModel *model = self.arrData[i];
        [visibleData addObject:model];
    }
    if (visibleData.count == 0) {
        return;
    }
    
    NSMutableArray *coinArr = @[].mutableCopy;
    NSMutableArray *coinKindsArr = @[].mutableCopy;
    NSMutableArray *exchangeCoinArr =@[].mutableCopy;
    
    NSMutableArray *coinKindCodes =@[].mutableCopy;
    NSMutableArray *coinKindCodeDouble =@[].mutableCopy;
    NSMutableArray *exchangeCoinKindCode =@[].mutableCopy;
    for(CurrencyModel *model in visibleData){
        if([model.exchangeCode isEqualToString:k_Net_Code]||[model.exchangeCode isEqualToString:@"netWork"]){
            if ([model.kindCode containsString:@"/"]) {
                [coinKindsArr addObject:model];
                [coinKindCodeDouble addObject:SAFESTRING(model.kindCode)];
            }else{
                [coinArr addObject:model];
                [coinKindCodes addObject:SAFESTRING(model.kindCode)];
            }
        }else{
            [exchangeCoinArr addObject:model];
            [exchangeCoinKindCode addObject:SAFESTRING(model.kindCode)];
        }
    }
    //全网币种
    if(coinArr.count>0){
        self.marketRealtimeRequest = [[MarketRealtimeRequest alloc] initWithMarketType:1 kindList:coinKindCodes];
        [self.marketRealtimeRequest  requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            if(request.data&&[request.data isKindOfClass:[NSArray class]]){
                NSInteger i = -1;
                for(CurrencyModel *model in visibleData){
                    i++;
                    // NSIndexPath *indexPath = visibleArray[i];
                    for(NSDictionary *dict in request.data){
                        CurrencyModel *secondModel =[CurrencyModel modelWithJSON:dict];
                        NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
                        secondModel.icon = [NSString stringWithFormat:@"%@?%@",secondModel.icon,str];
                        if([SAFESTRING(model.kindCode) isEqualToString:SAFESTRING(secondModel.kindCode)]&&[SAFESTRING(model.exchangeCode) isEqualToString:SAFESTRING(secondModel.exchangeCode)]){
                            secondModel.type = [self comparePrice:secondModel firstModel:model type:0];
                            secondModel.kindName = model.kindName;
                            secondModel.exchangeName = model.exchangeName;
                            secondModel.exchangeCode = model.exchangeCode;
                            secondModel.icon = model.icon;
                            if(self.arrData.count > i){
                                [self.arrData replaceObjectAtIndex:i withObject:secondModel];
                            }
                        }
                    }
                    
                }
                
                if (self.type == 1) {
                    
                }else{
                    if (self.type == 4) {
                        //降序
                        self.sortData =  [NSMutableArray arrayWithArray:[self.arrData sortedArrayUsingComparator:^NSComparisonResult(CurrencyModel *obj1, CurrencyModel   *obj2) {
                            return [@(obj2.rose) compare:@(obj1.rose)];
                        }]];
                    }else{
                        //升序
                        self.sortData =  [NSMutableArray arrayWithArray:[self.arrData sortedArrayUsingComparator:^NSComparisonResult(CurrencyModel *obj1, CurrencyModel   *obj2) {
                            return [@(obj1.rose) compare:@(obj2.rose)];
                        }]];
                    }
                }
                
                
                [self.tableViewContainer reloadData];
                
            }
            
        } failure:^(__kindof BTBaseRequest *request) {
//             [self.loadingView showErrorWith:request.resultMsg];
        }];
    }
    //全网交易对
    if(coinKindsArr.count>0){
        self.marketRealtimeRequestCurrency = [[MarketRealtimeRequest alloc] initWithMarketType:2 kindList:coinKindCodeDouble];
       
        
        [self.marketRealtimeRequestCurrency requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            if(request.data&&[request.data isKindOfClass:[NSArray class]]){
                NSInteger i = -1;
                for(CurrencyModel *model in visibleData){
                    i++;
                    //NSIndexPath *indexPath = visibleArray[i];
                    for(NSDictionary *dict in request.data){
                        CurrencyModel *secondModel =[CurrencyModel modelWithJSON:dict];
                        NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
                        secondModel.icon = [NSString stringWithFormat:@"%@?%@",secondModel.icon,str];
                        if([SAFESTRING(model.kindCode) isEqualToString:SAFESTRING(secondModel.kindCode)]&&[SAFESTRING(model.exchangeCode) isEqualToString:SAFESTRING(secondModel.exchangeCode)]){
                            secondModel.type = [self comparePrice:secondModel firstModel:model type:1];
                            secondModel.exchangeName = model.exchangeName;
                            secondModel.kindName = model.kindName;
                            secondModel.exchangeCode = model.exchangeCode;
                            secondModel.icon = model.icon;
                            if(self.arrData.count > i){
                                [self.arrData replaceObjectAtIndex:i withObject:secondModel];
                            }
                        }

                    }

                }
                if (self.type == 1) {
                    
                }else{
                    if (self.type == 4) {
                        //降序
                        self.sortData =  [NSMutableArray arrayWithArray:[self.arrData sortedArrayUsingComparator:^NSComparisonResult(CurrencyModel *obj1, CurrencyModel   *obj2) {
                            return [@(obj2.rose) compare:@(obj1.rose)];
                        }]];
                    }else{
                        //升序
                        self.sortData =  [NSMutableArray arrayWithArray:[self.arrData sortedArrayUsingComparator:^NSComparisonResult(CurrencyModel *obj1, CurrencyModel   *obj2) {
                            return [@(obj1.rose) compare:@(obj2.rose)];
                        }]];
                    }
                }
                [self.tableViewContainer reloadData];
            }
        } failure:^(__kindof BTBaseRequest *request) {
//            [self.loadingView showErrorWith:request.resultMsg];
        }];
        
    }
    //交易所交易对
    if(exchangeCoinArr.count>0){
        NSMutableArray*requestArr =@[].mutableCopy;
        for(CurrencyModel *model in exchangeCoinArr){
            [requestArr addObject:[NSString stringWithFormat:@"%@_%@",SAFESTRING(model.exchangeCode),SAFESTRING(model.kindCode)]];
        }
        
        self.groupRealTimeReq = [[BTGroupRealTimeReq alloc] initWithExchangeCoinList:requestArr];
       
        
        [self.groupRealTimeReq requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            if(request.data&&[request.data isKindOfClass:[NSArray class]]){
                NSInteger i = -1;
                for(CurrencyModel *model in visibleData){
                    i++;
                    //NSIndexPath *indexPath = visibleArray[i];
                    for(NSDictionary *dict in request.data){
                        CurrencyModel *secondModel =[CurrencyModel modelWithJSON:dict];
                        NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
                        secondModel.icon = [NSString stringWithFormat:@"%@?%@",secondModel.icon,str];
                        if([SAFESTRING(model.kindCode) isEqualToString:SAFESTRING(secondModel.kindCode)]&&[SAFESTRING(model.exchangeCode) isEqualToString:SAFESTRING(secondModel.exchangeCode)]){
                            secondModel.type = [self comparePrice:secondModel firstModel:model type:1];
                            secondModel.kindName = model.kindName;
                            secondModel.exchangeName = model.exchangeName;
                            secondModel.exchangeCode = model.exchangeCode;
                            secondModel.icon = model.icon;
                            if(self.arrData.count > i){
                                [self.arrData replaceObjectAtIndex:i withObject:secondModel];
                            }
                        }

                    }

                }
            }
            if (self.type == 1) {
                
            }else{
                if (self.type == 4) {
                    //降序
                    self.sortData =  [NSMutableArray arrayWithArray:[self.arrData sortedArrayUsingComparator:^NSComparisonResult(CurrencyModel *obj1, CurrencyModel   *obj2) {
                        return [@(obj2.rose) compare:@(obj1.rose)];
                    }]];
                }else{
                    //升序
                    self.sortData =  [NSMutableArray arrayWithArray:[self.arrData sortedArrayUsingComparator:^NSComparisonResult(CurrencyModel *obj1, CurrencyModel   *obj2) {
                        return [@(obj1.rose) compare:@(obj2.rose)];
                    }]];
                }
            }
            [self.tableViewContainer reloadData];

        } failure:^(__kindof BTBaseRequest *request) {
//            [self.loadingView showErrorWith:request.resultMsg];
        }];
    }
}

- (NSInteger)comparePrice:(CurrencyModel*)model firstModel:(CurrencyModel*)firstModel type:(NSInteger)type{
    if(type == 0){
        if (kIsCNY) {
            if ([model.priceCNY doubleValue] > [firstModel.priceCNY doubleValue]) {
                return 1;
            }else if ([model.priceCNY doubleValue] == [firstModel.priceCNY doubleValue]){
                return 0;
            }else{
                return 2;
            }
        }else{
            if ([model.priceUSD doubleValue] > [firstModel.priceUSD doubleValue]) {
                return 1;
            }else if ([model.priceUSD doubleValue] == [firstModel.priceUSD doubleValue]){
                return 0;
            }else{
                return 2;
            }
        }
    }else{
        if (kIsCNY) {
            if (model.legalTendeCNY > firstModel.legalTendeCNY ) {
                return 1;
            }else if (model.legalTendeCNY  == firstModel.legalTendeCNY){
                return 0;
            }else{
                return 2;
            }
        }else{
            if (model.legalTendeUSD  > firstModel.legalTendeUSD) {
                return 1;
            }else if (model.legalTendeUSD  == model.legalTendeUSD){
                return 0;
            }else{
                return 2;
            }
        }
    }
}
#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    [self requestUserBtcList];
    //请求失败 刷新list bar
    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_Refresh_List_Bar object:nil];
}

- (void)requestList:(NSString*)groupName state:(RefreshState)state{
    
    if([groupName isEqualToString:[APPLanguageService sjhSearchContentWith:@"quanbu"]]){
        groupName =@"全部";
    }
    //查询用户自选列表前 取消定时器，很关键
    [self stopTimer];
    WS(ws)
    if(state == RefreshStateNormal){
        [self.loadingView showLoading];
    }
    BTGroupCoinListReq *api = [[BTGroupCoinListReq alloc] initWithGroupName:SAFESTRING(groupName)];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        _originArr = @[].mutableCopy;
        if ([request.data count] == 0) {
            //自选无数据时候，默认跳转到市值页面,仅仅针对第一次,点击分组列表
            if(self.isFirstEnter){
                if([groupName isEqualToString:[APPLanguageService sjhSearchContentWith:@"quanbu"]]){
                    [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Change_List_Style object:nil];
                }
            }
            
            [self.arrData removeAllObjects];
            self.noLoginView.hidden = YES;
            self.noLoginView.type = LoginOrOptionTypeNoOption;
            self.noLoginView.noOptionBlock = ^{
                ws.optionBlock();
            };
            [self.noLoginView showInWithParentView:ws.view];
            [self.tableViewContainer reloadData];
            
            [self.loadingView showAddOptioal];
            
        }else{
            [self.loadingView hiddenLoading];
            if (self.noLoginView) {
                self.noLoginView.hidden = YES;
            }
            [self.arrData removeAllObjects];
            for (NSDictionary *dic  in request.data) {
                ItemModel *item = [ItemModel modelWithJSON:dic];
                [_originArr addObject:item];
                CurrencyModel *model = [[CurrencyModel alloc] init];
                model.exchangeName = item.exchangeName;
                model.kindCode = item.currencyCode;
                model.exchangeCode = item.exchangeCode;
                model.icon = item.icon;
                if([model.exchangeCode isEqualToString:@"netWork"]){
                    model.exchangeCode = k_Net_Code;
                }
                
                if (item.currencyCodeRelation.length > 0) {
                    model.kindCode = [NSString stringWithFormat:@"%@/%@",item.currencyCode,item.currencyCodeRelation];
                }
                model.kind = model.kindCode;
                if (kIszh_hans) {
                    if (item.currencyChineseName.length > 0) {
                        model.kindName = item.currencyChineseName;
                    }
                    if (item.currencyCodeRelation.length > 0) {
                        if (item.currencyChineseName.length > 0) {
                            model.kindName = [NSString stringWithFormat:@"%@/%@",item.currencyChineseName,item.currencyChineseNameRelation];
                        }else{
                            model.kindName = item.currencyChineseNameRelation;
                        }
                    }
                }else{
                    if (item.currencyEnglishName.length > 0) {
                        model.kindName = item.currencyEnglishName;
                    }
                    if (item.currencyCodeRelation.length > 0) {
                        if (item.currencyEnglishName.length > 0) {
                            model.kindName = [NSString stringWithFormat:@"%@/%@",item.currencyEnglishName,item.currencyEnglishNameRelation];
                        }else{
                            model.kindName = item.currencyEnglishNameRelation;
                        }
                        
                    }
                }
                //筛选出交易所数据
                //if([item.exchangeCode isEqualToString:[AppHelper getExchangeCode]]){
                [self.arrData addObject:model];
                //                }
                
            }
            if (self.type == 4) {
                //降序
                ws.sortData =  [NSMutableArray arrayWithArray:[ws.arrData sortedArrayUsingComparator:^NSComparisonResult(CurrencyModel *obj1, CurrencyModel   *obj2) {
                    return [@(obj2.rose) compare:@(obj1.rose)];
                }]];
                
            }else if(self.type == 3){
                //升序
                ws.sortData =  [NSMutableArray arrayWithArray:[ws.arrData sortedArrayUsingComparator:^NSComparisonResult(CurrencyModel *obj1, CurrencyModel   *obj2) {
                    return [@(obj1.rose) compare:@(obj2.rose)];
                }]];
            }
            if (self.arrData.count > 0) {
                [self fetchList];
            }
            [self.tableViewContainer reloadData];
        }
        
        self.isFirstEnter = NO;
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
        self.isFirstEnter = NO;
        
    }];
}

- (void)requestUserBtcList{
    self.type = 1;
    [self requestList:SAFESTRING(self.listModel.groupName) state:RefreshStateNormal];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [AnalysisService alaysisOption_page];
    NSInteger index = [BTConfigureService shareInstanceService].index;
    NSArray *vcs = [[self.navigationController visibleViewController] childViewControllers];
    if (index < vcs.count) {
        if ([vcs[index] isEqual:self]) {
            [self startTimer];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(!appDelegate.listModel){
        [self.sectionView setGroupName:[APPLanguageService sjhSearchContentWith:@"quanbu"]];
        self.listModel.userGroupId = ALL_GROUP_ID;
        if (getUserCenter.userInfo.token.length > 0){
            [self requestList:[APPLanguageService sjhSearchContentWith:@"quanbu"] state:RefreshStatePull];
            appDelegate.listModel = [[BTGroupListModel alloc] init];
            appDelegate.listModel.groupName = [APPLanguageService sjhSearchContentWith:@"quanbu"];
            appDelegate.listModel.userGroupId = ALL_GROUP_ID;
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopTimer];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type == 1) {
        return self.arrData.count;
    }
    return self.sortData.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MyOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.noShowKindName = YES;
    cell.isZiXuan = YES;
    if (self.type == 1) {
        cell.model = self.arrData[indexPath.row];
    }else{
        cell.model = self.sortData[indexPath.row];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 76.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [AnalysisService alaysisOption_page_list];
    if (self.type == 1) {
        CurrencyModel *model = self.arrData[indexPath.row];
        NSData *data = [model modelToJSONData];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:dic];
    }else{
        CurrencyModel *model = self.sortData[indexPath.row];
        NSData *data = [model modelToJSONData];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:dic];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        if (self.type == 1) {
            if (self.arrData.count > 0) {
//                [self.marketRealtimeRequest start];
//                [self startTimer];
            }
        }else{
            if (self.sortData.count > 0) {
//                [self.marketRealtimeRequest start];
//                [self startTimer];
            }
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.type == 1) {
        if (self.arrData.count > 0) {
//            [self.marketRealtimeRequest start];
//            [self startTimer];
        }
    }else{
        if (self.sortData.count > 0) {
//            [self.marketRealtimeRequest start];
//            [self startTimer];
        }
    }
}

#pragma mark - Lazy

- (NSMutableArray *)arrData{
    if (!_arrData) {
        _arrData = [NSMutableArray array];
    }
    return _arrData;
}

- (NSMutableArray *)arrKindList{
    if (!_arrKindList) {
        _arrKindList = [NSMutableArray array];
    }
    return _arrKindList;
}

- (NSMutableArray *)arrKindNameList{
    if (!_arrKindNameList) {
        _arrKindNameList = [NSMutableArray array];
    }
    return _arrKindNameList;
}

- (NSMutableArray *)arrChange{
    if (!_arrChange) {
        _arrChange = [NSMutableArray array];
    }
    return _arrChange;
}

- (NSMutableArray *)arrChangeMarket{
    if (!_arrChangeMarket) {
        _arrChangeMarket = [NSMutableArray array];
    }
    return _arrChangeMarket;
}

- (NSMutableArray *)arrChangeCurrency{
    if (!_arrChangeCurrency) {
        _arrChangeCurrency = [NSMutableArray array];
    }
    return _arrChangeCurrency;
}

- (NSMutableArray *)arrMarket{
    if (!_arrMarket) {
        _arrMarket = [NSMutableArray array];
    }
    return _arrMarket;
}

- (NSMutableArray *)arrPriceList{
    if (!_arrPriceList) {
        _arrPriceList = [NSMutableArray array];
    }
    return _arrPriceList;
}

- (NSMutableArray *)arrCurrency{
    if (!_arrCurrency) {
        _arrCurrency = [NSMutableArray array];
    }
    return _arrCurrency;
}

- (MyZiOptionView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MyZiOptionView class]) owner:self options:nil][0];
    }
    return _sectionView;
}

- (NoLoginView *)noLoginView{
    if (!_noLoginView) {
        _noLoginView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NoLoginView class]) owner:self options:nil][0];
    }
    return _noLoginView;
}

- (void)refreshSelectGroup:(NSNotification*)notify{
    BTGroupListModel *listModel = (BTGroupListModel*)notify.object;
    self.listModel = listModel;
    [self requestList:SAFESTRING(listModel.groupName) state:RefreshStateNormal];
    [self.sectionView setGroupName:listModel.groupName];
}

- (void)refreshAfterDelete:(NSNotification*)notify{
    BTGroupListModel *listModel = (BTGroupListModel*)notify.object;
    if([self.listModel.groupName isEqualToString:listModel.groupName]){//如果删除的是一样的
        BTGroupListModel *modelAll = [[BTGroupListModel alloc] init];
        modelAll.groupName =[APPLanguageService sjhSearchContentWith:@"quanbu"];//@"全部";
        modelAll.userGroupId = ALL_GROUP_ID;
        modelAll.isSelected =YES;
        self.listModel = modelAll;
        [self.sectionView setGroupName:self.listModel.groupName];
        
        //
        [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Refresh_Main_Group object:self.listModel];
        [self requestUserBtcList];
    }
}

//自选侧滑
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
        
    }
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)slide{
    if (getUserCenter.userInfo.token.length == 0) {
        return;
    }
    [self requestGroupList];
}

//
- (void)searchOptional{
    [AnalysisService alaysisHome_search];
    [BTCMInstance presentViewControllerWithName:@"OptionSearch" andParams:nil animated:NO];
}


//
//新建分组
- (BTButton*)addBtn{
    if(!_addBtn){
        _addBtn = [BTButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:[UIImage imageNamed:@"add_zixuan"] forState:UIControlStateNormal];
        [_addBtn setTitleColor:SecondColor forState:UIControlStateNormal];
        _addBtn.backgroundColor = isNightMode?ViewContentBgColor:CWhiteColor;;
        _addBtn.fixTitle = @"addSelect";
        _addBtn.titleLabel.font = FONTOFSIZE(14.0f);
        [_addBtn bk_addEventHandler:^(id  _Nonnull sender) {
            
            [MobClick event:@"Add_optional"];
            [BTCMInstance presentViewControllerWithName:@"OptionSearch" andParams:nil animated:NO];
            
        } forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        _addBtn.frame = CGRectMake(ScreenWidth/2, 10, ScreenWidth/2, 52);
    }
    return _addBtn;
}

- (BTButton*)editBtn{
    if(!_editBtn){
        _editBtn = [BTButton buttonWithType:UIButtonTypeCustom];
        [_editBtn setImage:[UIImage imageNamed:@"main_edit"] forState:UIControlStateNormal];
        [_editBtn setTitleColor:SecondColor forState:UIControlStateNormal];
        _editBtn.backgroundColor = isNightMode?ViewContentBgColor:CWhiteColor;
        _editBtn.fixTitle = @"editoption";
        _editBtn.titleLabel.font = FONTOFSIZE(14.0f);
        [_editBtn bk_addEventHandler:^(id  _Nonnull sender) {
            [BTCMInstance pushViewControllerWithName:@"editoption" andParams:@{@"groupName":SAFESTRING(self.listModel.groupName)}];
            
        } forControlEvents:UIControlEventTouchUpInside];
        [_editBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        _editBtn.frame = CGRectMake(0, 10, ScreenWidth/2, 52.0f);
    }
    return _editBtn;
}
- (UIView*)footerView{
    if(!_footerView){
        _footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 62)];
        [_footerView addSubview:self.editBtn];
        [_footerView addSubview:self.addBtn];
        UIView *separateView = [[UIView alloc] initWithFrame:CGRectZero];
        separateView.backgroundColor = SeparateColor;
        [_footerView addSubview:separateView];
        [separateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_footerView.mas_centerX);
            make.width.mas_equalTo(1);
            make.height.mas_equalTo(32.0f);
            make.bottom.equalTo(_footerView).offset(-10);
        }];
    }
    return _footerView;
}
@end
