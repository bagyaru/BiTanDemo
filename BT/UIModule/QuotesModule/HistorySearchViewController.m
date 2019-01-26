//
//  HistorySearchViewController.m
//  BT
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HistorySearchViewController.h"
#import "HistorySectionView.h"
#import "HistorySearchCell.h"
#import "BTSearchService.h"
#import "HistoryResultCell.h"
#import "BTTitleView.h"
#import "HistoryResultXianhuoCell.h"
#import "XianHuoSearchObj+CoreDataClass.h"
#import "XianHuoSearchObj+CoreDataProperties.h"
#import "QiHuoSearchObj+CoreDataClass.h"
#import "QiHuoSearchObj+CoreDataProperties.h"
#import "BYListBar.h"

#import "ExchangeSelectCell.h"
#import "BTOnlineExchangeReq.h"

static NSString *const identifierExchange = @"ExchangeSelectCell";
static NSString *const identifierSection = @"HistorySectionView";

static NSString *const identifier = @"HistorySearchCell";

static NSString *const identifierResult = @"HistoryResultCell";

static NSString *const identifierResultXianhuo = @"HistoryResultXianhuoCell";

@interface HistorySearchViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableViewContainer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintBottom;

@property (nonatomic, strong) NSArray *arrData;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIView *viewNoData;

@property (nonatomic, strong) NSMutableArray *arrResult;

@property (nonatomic, strong) NSDictionary *param;

@property (nonatomic, assign) BOOL isHans;

@property (nonatomic, assign) NSInteger type; //1 币，2 现货，3 期货

@property (weak, nonatomic) IBOutlet BTLabel *labelNoData;
@property (weak, nonatomic) IBOutlet UIButton *findAssistantBtn;
@property (nonatomic, assign) NSInteger pageIndex;

@property (nonatomic, strong) BYListBar *listBar;
@property (nonatomic, strong) UIView *resultHeaderView;

@property (nonatomic, assign) NSInteger resultType;
@property (nonatomic, strong) NSMutableArray *exchangeResultArr;
@property (nonatomic, strong) BTOnlineExchangeReq *onlineExchangeApi;
@property (nonatomic, assign) NSInteger exchangePageIndex;
@property (nonatomic, assign) BOOL isFirst;
@property (weak, nonatomic) IBOutlet UIImageView *searchNoDataImageV;


@end

@implementation HistorySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.isResult) {
        
    }else{
        if ([self.param.allKeys containsObject:@"title"]) {
            if ([self.param[@"title"] isEqualToString:@"xianhuo"]) {
                self.type = 1;
            }else if ([self.param[@"title"] isEqualToString:@"添加收益"]) {
                self.type = 3;
            }else{
                self.type = 2;
            }
        }
    }
    if (kIszh_hans) {
        self.isHans = YES;
    }
    [self configView];
    self.resultType = 0;//默认搜索币种
    self.exchangePageIndex = 1;
    _exchangeResultArr = @[].mutableCopy;
    self.isFirst = YES;
    self.findAssistantBtn.layer.cornerRadius = 4.0f;
    self.findAssistantBtn.layer.masksToBounds = YES;
    self.findAssistantBtn.layer.borderWidth = 1.0f;
    self.searchNoDataImageV.image = [UIImage imageNamed:@"ic_searchNoData"];
    if(isNightMode){
        self.findAssistantBtn.layer.borderColor = ViewContentBgColor.CGColor;
        self.findAssistantBtn.backgroundColor = ViewBGNightColor;
    }else{
        self.findAssistantBtn.layer.borderColor = kHEXCOLOR(0x83BFEA).CGColor;
        self.findAssistantBtn.backgroundColor = CWhiteColor;
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if(self.isFirst){
         [self.searchBar becomeFirstResponder];
    }
   
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.isFirst = NO;
}

- (void)update{
    [self.tableViewContainer  reloadData];
}

//交易所搜索
- (void)requestExchangeApi:(RefreshState)state str:(NSString*)str{
    
    NSString *searchStr = [self searchDeletewhitespaceWithString:str];
    _onlineExchangeApi = [[BTOnlineExchangeReq alloc] initWithIndex:self.exchangePageIndex category:@"-1" keywords:SAFESTRING(searchStr)];
    WS(ws)
    [_onlineExchangeApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
       
        if(request.data&&[request.data isKindOfClass:[NSArray class]]){
            self.isResult = YES;
            if(state == RefreshStateNormal || state == RefreshStatePull){
                [ws.exchangeResultArr removeAllObjects];
                for(NSDictionary *dict in request.data){
                    BTExchangeListModel *model = [BTExchangeListModel objectWithDictionary:dict];
                    model.isSearch = YES;
                    [ws.exchangeResultArr addObject:model];
                }
                NSString *hasNext = SAFESTRING(request.responseObject[@"hasNext"]);
                [self.tableViewContainer reloadData];
                [ws.tableViewContainer.mj_header endRefreshing];
                if([hasNext isEqualToString:@"0"]){
                    ws.tableViewContainer.mj_footer.hidden = YES;
                }else{
                    ws.tableViewContainer.mj_footer.hidden = NO;
                    [ws.tableViewContainer.mj_footer endRefreshing];
                }
            }else if(state == RefreshStateUp){
                for(NSDictionary *dict in request.data){
                    BTExchangeListModel *model = [BTExchangeListModel objectWithDictionary:dict];
                    [ws.exchangeResultArr addObject:model];
                }
                NSString *hasNext = SAFESTRING(request.responseObject[@"hasNext"]);
                [self.tableViewContainer reloadData];
                if([hasNext isEqualToString:@"1"]){
                    [self.tableViewContainer.mj_footer endRefreshing];
                    
                }else{
                    [self.tableViewContainer.mj_footer endRefreshingWithNoMoreData];
                }
                
            }
        }
        if (ws.exchangeResultArr.count > 0) {
            self.viewNoData.hidden = YES;
        }else {
            self.viewNoData.hidden = NO;
        }
       
       
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

- (void)setIsResult:(BOOL)isResult{
    _isResult = isResult;
    if (isResult) {
        //搜索
        if (self.type >= 1) {
            self.viewNoData.hidden = YES;
            if (self.arrResult.count == 0) {
                return;
            }
            //[self.tableViewContainer reloadData];
        }else {
            WS(ws)
//            _tableViewContainer.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
//                if(ws.resultType == 0){
//                      ws.pageIndex = 1;
//                     [ws requestList:RefreshStatePull with:self.searchBar.text];
//                }else{
//                    ws.exchangePageIndex = 1;
//                    [ws requestExchangeApi:RefreshStateNormal str:self.searchBar.text];
//                }
//            }];
            
            _tableViewContainer.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
                if(ws.resultType == 0){
                    ws.pageIndex++;
                    [ws requestList:RefreshStateUp with:self.searchBar.text];
                }else{
                    ws.exchangePageIndex ++;
                    [ws requestExchangeApi:RefreshStateUp str:self.searchBar.text];
                }
               
            }];
        }
    }else {
        
        _tableViewContainer.mj_header = nil;
        _tableViewContainer.mj_footer = nil;
    }
}

- (void)configView{
    self.pageIndex = 1;
    ViewRadius(self.findAssistantBtn, 3);
    self.labelNoData.textColor = CGrayColor;
    [self addNavigationItemWithImageNames:@[] isLeft:YES target:self action:@selector(hh:) tags:@[]];
    [self configSearchBar];
    [_tableViewContainer registerNib:[UINib nibWithNibName:NSStringFromClass([HistorySearchCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    [_tableViewContainer registerNib:[UINib nibWithNibName:NSStringFromClass([ExchangeSelectCell class]) bundle:nil] forCellReuseIdentifier:identifierExchange];
    [_tableViewContainer registerNib:[UINib nibWithNibName:NSStringFromClass([HistoryResultCell class]) bundle:nil] forCellReuseIdentifier:identifierResult];
    [_tableViewContainer registerNib:[UINib nibWithNibName:NSStringFromClass([HistoryResultXianhuoCell class]) bundle:nil] forCellReuseIdentifier:identifierResultXianhuo];
    [_tableViewContainer registerNib:[UINib nibWithNibName:NSStringFromClass([HistorySectionView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:identifierSection];
    _tableViewContainer.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCollectionView:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
- (void)requestList:(RefreshState)state with:(NSString *)str{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
    }
    WS(ws);
    [[BTSearchService sharedService] realTimeWithInput:str pageIndex:self.pageIndex result:^(NSArray *resultArray) {
        self.isResult = YES;
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [ws.arrResult removeAllObjects];
            
            if ([resultArray count] < BTPagesize) {
                ws.tableViewContainer.mj_footer.hidden = YES;;
            }else{
                [ws.tableViewContainer.mj_footer endRefreshing];
            }
            
            [ws.arrResult addObjectsFromArray:resultArray];
            [ws.tableViewContainer.mj_header endRefreshing];
        }else if (state == RefreshStateUp){
            if ([resultArray count] < BTPagesize) {
                [ws.tableViewContainer.mj_footer endRefreshingWithNoMoreData];
            }else{
                [ws.tableViewContainer.mj_footer endRefreshing];
            }
            
            [ws.arrResult addObjectsFromArray:resultArray];
        }
        
        if (ws.arrResult.count > 0) {
            
            self.viewNoData.hidden = YES;
        }else {
            
            self.viewNoData.hidden = NO;
        }
       
        [ws.tableViewContainer reloadData];
    }];
    
}
- (void)hh:(UIButton *)btn{
    [self.searchBar becomeFirstResponder];
}

- (void)configSearchBar{
    [self addNavigationItemWithTitles:@[[APPLanguageService sjhSearchContentWith:@"quxiao"]] isLeft:NO target:self action:@selector(btnClick:) tags:@[@(8888)] whereVC:@"取消"];
     //self.navigationItem.leftBarButtonItem = nil;
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-65, 44)];
    
    self.searchBar.delegate = self;
    if (self.type >= 1) {
        if (self.type == 1) {
             self.searchBar.placeholder = [APPLanguageService sjhSearchContentWith:@"searchxianhuoplacehodler"];
        }else if (self.type == 3) {
            
            self.searchBar.placeholder = [APPLanguageService wyhSearchContentWith:@"searchsytjplacehodler"];
        }else{
            self.searchBar.placeholder = [APPLanguageService sjhSearchContentWith:@"searchqihuoplacehodler"];
        }
    }else{
         self.searchBar.placeholder = [APPLanguageService sjhSearchContentWith:@"searchhomeplacehodler"];
    }
    

    self.searchBar.showsCancelButton = NO;
    self.searchBar.tintColor = [UIColor blueColor];
    for (UIView *view in self.searchBar.subviews) {
        for (id v in view.subviews) {
            if ([v isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [v removeFromSuperview];
            }else if ([v isKindOfClass:NSClassFromString(@"UISearchBarTextField")]){
                UITextField *textField = (UITextField *)v;
                textField.font = MediumFont;
                [textField setValue:ThirdColor forKeyPath:@"_placeholderLabel.textColor"];
                textField.backgroundColor = isNightMode?ViewBGNightColor:CSearchBarColor;
                textField.textColor = FirstColor;
                textField.layer.masksToBounds = YES;
                textField.layer.cornerRadius  = 18;
            }else if ([v isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)v;
                [btn setTitle:[APPLanguageService sjhSearchContentWith:@"quxiao"] forState:UIControlStateNormal];
                btn.titleLabel.font = FONTOFSIZE(14.0f);
                [btn setTitleColor:CBlackColor forState:UIControlStateNormal];
            }
        }
    }
    
    //5. 设置搜索Icon
    [self.searchBar setImage:[UIImage imageNamed:@"search"]
                  forSearchBarIcon:UISearchBarIconSearch
                             state:UIControlStateNormal];
    [self.searchBar setImage:[UIImage imageNamed:@"search_clear"]
            forSearchBarIcon:UISearchBarIconClear
                       state:UIControlStateNormal];
   
    BTTitleView *ivTitle = [[BTTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-65, 44)];
    [ivTitle addSubview:self.searchBar];
    self.navigationItem.titleView = ivTitle;
}
- (void)btnClick:(UIButton*)btn{
    
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [BTCMInstance dismissViewController];
}

- (void)changeCollectionView:(NSNotification *)noti{
    CGRect endFrame = [[noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (endFrame.origin.y == ScreenHeight) {
        self.constraintBottom.constant = 0;
    }else{
        self.constraintBottom.constant = endFrame.size.height;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (self.isResult) {
        return 1;
    }
    if (self.type < 1 && [BTConfigureService shareInstanceService].hotSearchArray.count > 0) {
        
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isResult) {
        if(self.resultType == 0)
            return self.arrResult.count;
        
        return self.exchangeResultArr.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isResult) {
        if (self.type >=  1 && self.type != 3) {
            HistoryResultXianhuoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierResultXianhuo forIndexPath:indexPath];
            if (self.type == 2) {
                QiHuoSearchObj *search = self.arrResult[indexPath.row];
                cell.name = search.contractName;
            }else{
                XianHuoSearchObj *search = self.arrResult[indexPath.row];
                cell.name = search.exchangeName;
            }
            return cell;
        }else{
            if(self.type == 3){
                HistoryResultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierResult forIndexPath:indexPath];
                cell.model = self.arrResult[indexPath.row];
                return cell;
            }else{
                if(self.resultType == 0){//币种
                    HistoryResultCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierResult forIndexPath:indexPath];
                    cell.model = self.arrResult[indexPath.row];
                    return cell;
                }else{ //交易所
                    ExchangeSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierExchange forIndexPath:indexPath];
                    cell.model = self.exchangeResultArr[indexPath.row];
                    return cell;
                }
            }
            
        }
        
    }
    HistorySearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    WS(ws);
    cell.searchBlock = ^(NSString *str) {
        ws.searchBar.text = str;
        ws.isResult = YES;
        if (self.type >= 1) {
            [ws.arrResult removeAllObjects];
            if (self.type == 1) {
                [[BTSearchService sharedService] fecthStocksXianhuoWithInput:str  result:^(NSArray *resultArray) {
                    if (resultArray == nil) {
                        [ws.tableViewContainer reloadData];
                        return ;
                    }
                    [ws.arrResult addObjectsFromArray:resultArray];
                    [ws.tableViewContainer reloadData];
                }];
               
            }else if (self.type == 3) {
                [[BTSearchService sharedService] BZ_RealTimeWithInput:str result:^(NSArray *resultArray) {
                    if (resultArray == nil) {
                        [ws.tableViewContainer reloadData];
                        return ;
                    }
                    [ws.arrResult addObjectsFromArray:resultArray];
                    [ws.tableViewContainer reloadData];
                }];
            }else{
                [[BTSearchService sharedService] fecthStocksQihuoWithInput:str result:^(NSArray *resultArray) {
                    if (resultArray == nil) {
                        [ws.tableViewContainer reloadData];
                        return ;
                    }
                    [ws.arrResult addObjectsFromArray:resultArray];
                    [ws.tableViewContainer reloadData];
                }];
            }
                
        }else{
            if(self.resultType == 0){
                [self requestList:RefreshStateNormal with:str];
            }else{
                [self requestExchangeApi:RefreshStateNormal str:str];
            }
            
        }
        
    };
    cell.type = self.type;
    cell.section = indexPath.section;
    [cell createView];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HistorySectionView *sectionView= [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifierSection];
    WS(ws);
    sectionView.clearBlock = ^{
        
        [ws AlertWithTitle:[APPLanguageService sjhSearchContentWith:@"tishi"] message:[APPLanguageService sjhSearchContentWith:@"quedingqingkongjilu"] andOthers:@[[APPLanguageService sjhSearchContentWith:@"quxiao"],[APPLanguageService sjhSearchContentWith:@"queding"]] animated:YES action:^(NSInteger index) {
            if (index == 1) {
                switch (ws.type) {
                    case 0:
                        [[BTSearchService sharedService] clearSearchHistory];
                        break;
                    case 1:
                        [[BTSearchService sharedService] clearSearchXianhuoHistory];
                        break;
                    case 2:
                        [[BTSearchService sharedService] clearSearchQihuoHistory];
                        break;
                    case 3:
                        [[BTSearchService sharedService] clearSearchSYTJHistory];
                        break;
                        
                    default:
                        break;
                }
                [ws update];
            }
            
        }];
    };
    if(!self.param){
        if (self.isResult) {
            return self.resultHeaderView;
        }
    }
    if (self.isResult) {//搜索结果
        sectionView.type = SectionViewTypeResult;
        return sectionView;
    }else{
        if (self.type < 1 && [BTConfigureService shareInstanceService].hotSearchArray.count > 0) {
            if (section == 0) {
                
                sectionView.type = SectionViewTypeHistory;
            } else {
                sectionView.type = SectionViewTypeHot;
            }
        } else {
            
            sectionView.type = SectionViewTypeHistory;
        }
        return sectionView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if(!self.param){
        if (self.isResult) {
            return 44.0f;
        }
    }
    
    if (self.type < 1 && [[BTSearchService sharedService] readHistorySearch].count <= 0) {
        if (section == 0) {
            
             return 0;
        }
    }
    return 42;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isResult) {
        if (self.type >= 1 && self.type != 3) {
            return 44;
        }
        return 57;
    }else{
        NSArray *arr;
        
        if (self.type < 1 && [BTConfigureService shareInstanceService].hotSearchArray.count > 0) {
            if (indexPath.section == 1) {//热门搜索
                
                arr = [BTConfigureService shareInstanceService].hotSearchArray;
                
            } else {//历史搜索
                switch (self.type) {
                    case 0:
                        arr = [[BTSearchService sharedService] readHistorySearch];
                        break;
                    case 1:
                        arr = [[BTSearchService sharedService] readHistoryXianhuoSearch];
                        break;
                    case 2:
                        arr = [[BTSearchService sharedService] readHistoryQihuoSearch];
                        break;
                    case 3:
                        
                        arr = [[BTSearchService sharedService] readHistorySYTJSearch];
                        break;
                    default:
                        break;
                }
            }
        }else {
            
            switch (self.type) {
                case 0:
                    arr = [[BTSearchService sharedService] readHistorySearch];
                    break;
                case 1:
                    arr = [[BTSearchService sharedService] readHistoryXianhuoSearch];
                    break;
                case 2:
                    arr = [[BTSearchService sharedService] readHistoryQihuoSearch];
                    break;
                case 3:
                    
                    arr = [[BTSearchService sharedService] readHistorySYTJSearch];
                    break;
                default:
                    break;
            }
        }
        if (arr.count == 0) {
            
            return 0.0f;
        }

        return [self getHeight:arr];
        
//       return  20 +(20 + 30) * (((arr.count > HotSearchAndHistoryMax ? HotSearchAndHistoryMax :arr.count) - 1) / 4) + 50;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.isResult) {
        if(self.resultType == 0){//币种
            if (self.type >= 1 && self.type != 3) {
                if (self.type == 1) {
                    XianHuoSearchObj *model = self.arrResult[indexPath.row];
                    [[BTSearchService sharedService] writeHistoryXianhuoSearch:model.exchangeName];
                    NSDictionary *dict = @{@"exchangeId":@(model.exchangeId),@"exchangeCode":model.exchangeCode,@"exchangeName":model.exchangeName};
                    //跳转
                    //[BTCMInstance pushViewControllerWithName:@"xianhuoxiangqing" andParams:dic];
                    //发送通知 回到上一个页面的时候刷新数据 保持数据准确
                    [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_ChooseJYS object:nil userInfo:@{@"dict":dict}];
                    [BTCMInstance dismissViewController];
                    return;
                }else{
                    QiHuoSearchObj *model = self.arrResult[indexPath.row];
                    [[BTSearchService sharedService] writeHistoryQihuoSearch:model.contractName];
                    NSDictionary *dic = @{@"FuturesId":@(model.futuresId)};
                    [BTCMInstance pushViewControllerWithName:@"qihuoxiangqing" andParams:dic];
                    return;
                }
                
            }
            CurrentcyModel *model = self.arrResult[indexPath.row];
            
            if (self.type == 3) {
                
                [[BTSearchService sharedService] writeHistorySYTJSearch:model.currencySimpleName];
                
                NSLog(@"==============添加收益统计=============");
                
                //[BTCMInstance pushViewControllerWithName:@"AddRecord" andParams:@{@"resultArray":@[],@"kind":model.currencySimpleName}];
                
                //发送通知 回到上一个页面的时候刷新数据 保持数据准确
                [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_chooseJYDSuccess object:nil userInfo:@{@"model":model}];
                [BTCMInstance dismissViewController];
                return;
            }
            
            if (ISNSStringValid(model.currencySimpleNameRelation)) {
                
                [[BTSearchService sharedService] writeHistorySearch:[NSString stringWithFormat:@"%@/%@",model.currencySimpleName,model.currencySimpleNameRelation]];
            }else {
                [[BTSearchService sharedService] writeHistorySearch:model.currencySimpleName];
            }
            NSDictionary *dic = @{@"currencyCode":model.currencyCode,@"isSearch":@(YES),@"currencyCodeRelation":model.currencyCodeRelation};
            //跳转
            [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:dic];
        }else{//交易所 1
            
            BTExchangeListModel *model = self.exchangeResultArr[indexPath.row];
            if([model.category isEqualToString:@"5"]){//期货
                [BTCMInstance pushViewControllerWithName:@"FutureList" andParams:@{@"model":model}];
            }else{
                [BTCMInstance pushViewControllerWithName:@"BTExchangeContainerVC" andParams:@{@"model":model}];
            }
        }
    }
}

+ (id)createWithParams:(NSDictionary *)params{
    HistorySearchViewController *vc = [[HistorySearchViewController alloc] init];
    [vc updateParams:params];
    return vc;
}

- (void)updateParams:(NSDictionary *)params{
    self.param = params;
}

#pragma mark - UISearchBar

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [BTCMInstance dismissViewController];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar.text.length == 0) {
        self.isResult = NO;
        self.viewNoData.hidden = YES;
        [self.tableViewContainer reloadData];
       // self.tableViewContainer.userInteractionEnabled = YES;
    }
    NSString *searchString = [self searchDeletewhitespaceWithString:searchBar.text];
    if (searchString.length > 0) {
        WS(ws)
        if (self.type >= 1) {
            [self.arrResult removeAllObjects];
            if (self.type == 1) {
                [[BTSearchService sharedService] fecthStocksXianhuoWithInput:searchString result:^(NSArray *resultArray) {
                    if (resultArray == nil) {
                        self.viewNoData.hidden = NO;
                        [ws.tableViewContainer reloadData];
                       // ws.tableViewContainer.userInteractionEnabled = YES;
                        return ;
                    }
                    self.isResult = YES;
                    self.viewNoData.hidden = YES;
                    [ws.arrResult addObjectsFromArray:resultArray];
                    [ws.tableViewContainer reloadData];
                    //ws.tableViewContainer.userInteractionEnabled = YES;
                }];
            }else if (self.type == 3) {
                
                [[BTSearchService sharedService] BZ_RealTimeWithInput:searchString result:^(NSArray *resultArray) {
                    if (resultArray == nil) {
                        self.viewNoData.hidden = NO;
                        [ws.tableViewContainer reloadData];
                        return ;
                    }
                    self.isResult = YES;
                    self.viewNoData.hidden = YES;
                    [ws.arrResult addObjectsFromArray:resultArray];
                    [ws.tableViewContainer reloadData];
                }];
                
            }else{
                [[BTSearchService sharedService] fecthStocksQihuoWithInput:searchString result:^(NSArray *resultArray) {
                    if (resultArray == nil) {
                        self.viewNoData.hidden = NO;
                        [ws.tableViewContainer reloadData];
                        //ws.tableViewContainer.userInteractionEnabled = YES;
                        return ;
                    }
                    self.isResult = YES;
                    self.viewNoData.hidden = YES;
                    [ws.arrResult addObjectsFromArray:resultArray];
                    [ws.tableViewContainer reloadData];
                    //ws.tableViewContainer.userInteractionEnabled = YES;
                }];
            }
            
        }else{

            if(self.resultType == 0){
                [self requestList:RefreshStateNormal with:searchString];
            }else{
                [self requestExchangeApi:RefreshStateNormal str:searchString];
            }
            
        }
        
      
    }
    
   
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder]; //searchBar失去焦点
    UIButton *cancelBtn = [searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    cancelBtn.enabled = YES; //把enabled设置为yes
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    
    //[self.searchBar resignFirstResponder]; //searchBar失去焦点
    UIButton *cancelBtn = [searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    cancelBtn.enabled = YES; //把enabled设置为yes
    
}
- (NSString *)searchDeletewhitespaceWithString:(NSString *)text{
    if (text.length == 0) {
        return text;
    }
    NSString *searchText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@" "];
    return searchText;
}
//我要找币探小助手
- (IBAction)findAssistantBtnClick:(UIButton *)sender {
    
    H5Node *node = [[H5Node alloc] init];
    node.title = [APPLanguageService wyhSearchContentWith:@"tianjiaweixinquan"];
    node.webUrl = BTXZS_H5;
    
    [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
}
#pragma mark - Lazy

- (NSMutableArray *)arrResult{
    if (!_arrResult) {
        _arrResult = [NSMutableArray array];
    }
    return _arrResult;
}

- (BYListBar*)listBar{
    if(!_listBar){
        _listBar = [[BYListBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 43.0f)];
        _listBar.isFuture = YES;
        _listBar.visibleItemList = [[NSMutableArray alloc] initWithArray:@[[APPLanguageService sjhSearchContentWith:@"bi"],[APPLanguageService sjhSearchContentWith:@"jiaoyisuo"]]];
        WS(ws)
        _listBar.listBarItemClickBlock = ^(NSString *itemName, NSInteger itemIndex) {
//            ws.viewNoData.hidden = YES;
            ws.resultType = itemIndex;
            NSString *searchString = [ws searchDeletewhitespaceWithString:ws.searchBar.text];
            if(searchString.length >0){
                ws.tableViewContainer.mj_footer = nil;
                [ws.tableViewContainer reloadData];
                if(ws.resultType == 0){
                    [ws requestList:RefreshStateNormal with:searchString];
                }else{
                    [ws requestExchangeApi:RefreshStateNormal str:searchString];
                }
                
                
            }
        };
//        [_listBar itemClickByScrollerWithIndex:0];
        
    }
    return _listBar;
}

- (UIView*)resultHeaderView{
    if(!_resultHeaderView){
        _resultHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44.0f)];
        [_resultHeaderView addSubview:self.listBar];
        [AppHelper addBottomLineWithParentView:_resultHeaderView];
    }
    return _resultHeaderView;
}

- (CGSize)labelAutoCalculateRectWith:(NSString *)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize {
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize], NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    labelSize.height = ceil(labelSize.height);
    labelSize.width = ceil(labelSize.width);
    return labelSize;
}

- (CGFloat)getHeight:(NSArray*)arr{
    float buttonRight = 0;
    CGFloat count = 0;
    for (int i = 0; i < (arr.count > HotSearchAndHistoryMax ? HotSearchAndHistoryMax :arr.count); i++) {
        NSString *title = arr[i];
        CGFloat titleW = [self labelAutoCalculateRectWith:title FontSize:14 MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)].width + 20;
        if (i > 0) {
            //当前按钮右侧坐标
            buttonRight = buttonRight + 10 + titleW;
            if (buttonRight > ScreenWidth) {
                count++;
                buttonRight = 15 + titleW;
            }
        }else{
            buttonRight = 15 + titleW;
        }
    }
    
    return 22 + (count+1)*28 + count *10;
}
@end
