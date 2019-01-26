//
//  XianHuoDetailViewController.m
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "XianHuoDetailViewController.h"
#import "BTInfomationSameCell.h"
#import "XianHuoDetailHangQingRequest.h"
#import "XianHuoDetailRequest.h"
#import "XianHuoMainObj.h"
#import "SetionHeadView.h"
#import "XHHeadCell.h"
#import "XHMiddeCell.h"
#import "XHFootCell.h"
#import "MyOptionCell.h"
#import "QutoesDetailMarket.h"
#import "XianHuoDetailHangQingChangeRequest.h"
#import "BTConfigureService.h"
#import "XHFootView.h"
static NSString *const identifier1 = @"XHHeadCell";
static NSString *const identifier2 = @"XHMiddeCell";
static NSString *const identifier3 = @"MyOptionCell";
static NSString *const identifier4 = @"XHFootCell";
@interface XianHuoDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) NSMutableDictionary *headDict;

@property (nonatomic, strong) XianHuoMainObj *detailObj;
@property (nonatomic, strong) SetionHeadView *headView;
@property (nonatomic, strong) XHFootView *footView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) NSMutableArray *arrChange;

@property (nonatomic, strong) XianHuoDetailHangQingChangeRequest *marketRealtimeRequest;

@property (nonatomic, strong) NSMutableArray *arrKindList;

@property (nonatomic, strong) NSMutableArray *arrKindNameList;
@end

@implementation XianHuoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self stopTimer];
}

- (void)startTimer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:TimerTimeInterval_XianHuoDetail target:self selector:@selector(fetchList) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
    
}

- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}
- (void)fetchList{
    NSArray *visibleArray =  [self.tableView indexPathsForVisibleRows];
    [self.arrKindList removeAllObjects];
    [self.arrKindNameList removeAllObjects];
    for (NSInteger i = 0; i < visibleArray.count-2; i++) {
        NSIndexPath *indexPath = visibleArray[i];
        CurrencyModel *model = self.dataArray[indexPath.row];
        [self.arrKindList addObject:model.kind];
        [self.arrKindNameList addObject:model.kindName];
    }
    if (self.arrKindList.count == 0) {
        return;
    }
    self.marketRealtimeRequest = [[XianHuoDetailHangQingChangeRequest alloc] initWithMarketType:self.exchangeCode kindList:self.arrKindList];
    [self.marketRealtimeRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.arrChange removeAllObjects];
        NSInteger i = -1;
        for (NSString *strCode in self.arrKindList) {
            i++;
            for (NSDictionary *dic in request.data) {
                QutoesDetailMarket *model = [QutoesDetailMarket modelWithJSON:dic];
                if ([model.kind isEqualToString:strCode]) {
                    model.kindName = self.arrKindNameList[i];
                    [self.arrChange addObject:model];
                }
            }
        }
        for (NSInteger i = 0; i < visibleArray.count-2; i++) {
            if (i < self.arrChange.count) {
                NSIndexPath *indexPath = visibleArray[i];
                QutoesDetailMarket *model1 = self.arrChange[i];
                QutoesDetailMarket *model2 = self.dataArray[i];
                model1.icon = model2.icon;
                if ([model1.kind isEqualToString:model2.kind]) {
                    [self.dataArray insertObject:self.arrChange[i] atIndex:indexPath.row];
                    [self.dataArray removeObjectAtIndex:indexPath.row + 1];
                }
            }
        }
        
        //刷新特定section
        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:2];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
-(void)creatUI {
    self.pageIndex = 1;
    self.title = [APPLanguageService wyhSearchContentWith:@"shichangxiangqing"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XHHeadCell class]) bundle:nil] forCellReuseIdentifier:identifier1];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XHMiddeCell class]) bundle:nil] forCellReuseIdentifier:identifier2];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyOptionCell class]) bundle:nil] forCellReuseIdentifier:identifier3];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([XHFootCell class]) bundle:nil] forCellReuseIdentifier:identifier4];
    
    _tableView.backgroundColor = CViewBgColor;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
//    _tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
//        self.pageIndex = 1;
////        [self requestList:RefreshStatePull];
//    }];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    _tableView.separatorColor = SeparateColor;
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
    [self loadDetailData];
    if(!self.isExchangeIntro){
         [self requestList:RefreshStateNormal];
    }
}

- (void)loadDetailData {
    if(self.isExchangeIntro){
        [self.loadingView showLoading];
    }
    XianHuoDetailRequest *api = [[XianHuoDetailRequest alloc] initWithExchangeId:self.exchangeId];
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        self.detailObj = [XianHuoMainObj objectWithDictionary:request.data];
        [self.headDict setObject:self.detailObj.exchangeName forKey:@"title"];
        [self.headDict setObject:self.detailObj.exchangeAbstract forKey:@"content"];
        [self.headDict setObject:@(NO) forKey:@"isDetail"];
        [self.headDict setObject:SAFESTRING(self.detailObj.icon) forKey:@"icon"];
        [self.headDict setObject:@(self.detailObj.ranking) forKey:@"rank"];
        [self.headDict setObject:SAFESTRING(self.detailObj.exchangeLabel) forKey:@"label"];
        //刷新特定section
//        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:0];
//        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//        NSIndexSet *indexSet1=[[NSIndexSet alloc] initWithIndex:1];
//        [self.tableView reloadSections:indexSet1 withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView reloadData];
        
        
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    XianHuoDetailHangQingRequest *api = [[XianHuoDetailHangQingRequest alloc] initWithExchangeCode:self.exchangeCode];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
             [self.loadingView hiddenLoading];
            for (NSDictionary *dic in request.data) {
                QutoesDetailMarket *model = [QutoesDetailMarket modelWithJSON:dic];
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:18*2 andHeight:18*2];
                model.icon = [NSString stringWithFormat:@"%@?%@",model.icon,str];
                [self.dataArray addObject:model];
            }
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
            for (NSDictionary *dic in request.data) {
                QutoesDetailMarket *model = [QutoesDetailMarket modelWithJSON:dic];
                [self.dataArray addObject:model];
            }
        }
        //刷新特定section
        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:5];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        if (self.dataArray.count > 0) {
            [self startTimer];
        }
        
        
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.tableFooterView = self.footView;
    }];
}

#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    //    [self requestList:RefreshStateNormal];
    [self loadDetailData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.isExchangeIntro){
        return 5;
    }
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 5){
        return self.dataArray.count;
    }
    if(section > 1 &&section < 5){
        NSString *content = @"";
        if(section == 2){
            content = self.detailObj.exchangeDownloads;
        }else if(section == 3){
            content = self.detailObj.exchangeContact;
        }else if(section == 4){
            content = self.detailObj.exchangePoundage;
        }
        if(content.length == 0) return 0;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        if (ISNSStringValid(self.headDict[@"content"])) {
            
            CGFloat height = [getUserCenter customGetContactHeight:self.headDict[@"content"] FontOfSize:14 LabelMaxWidth:ScreenWidth-26 jianju:6.0];
            if ([self.headDict[@"isDetail"] boolValue]) {
                return height+90 + 54;
            } else {
                
                if (height > 65) {
                    
                    return 140 +54.0f;
                }else {
                    
                    return height+90-20 +54.0f;
                }
            }
        }
        
        return 140 +54.0f;
    }
    //详情
    if (indexPath.section == 1) {
        return 178 - 5.0f;
    }
    if(indexPath.section == 5){
        return 76.0f;
    }
    
    NSString *content = @"";
    if(indexPath.section == 2){
        content = self.detailObj.exchangeDownloads;
    }else if(indexPath.section == 3){
        content = self.detailObj.exchangeContact;
    }else if(indexPath.section == 4){
        content = self.detailObj.exchangePoundage;
    }
    NSMutableAttributedString *oneString = [[NSMutableAttributedString alloc]initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:FONTOFSIZE(14.0f)} documentAttributes:nil error:nil];
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(ScreenWidth - 15 * 2, CGFLOAT_MAX) text:oneString];
    
    return   layout.textBoundingSize.height + 20.0f;
    return 60.0f;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        XHHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell creatUIWithDict:self.headDict];
        [cell.detailBtn addTarget:self action:@selector(detailBtnClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if (indexPath.section == 1) {
        XHMiddeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell creatUIWith:self.detailObj];
        [cell.goGuanWangBtn addTarget:self action:@selector(goGuanWangBtnClick) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    if(indexPath.section == 5){
        MyOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier3 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isShiChang = YES;
        cell.marketModel = self.dataArray[indexPath.row];
        return cell;
    }
   
    XHFootCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier4];
    if(indexPath.section == 2){
        cell.content = self.detailObj.exchangeDownloads;
    }else if(indexPath.section == 3){
        cell.content = self.detailObj.exchangeContact;
    }else if(indexPath.section == 4){
        cell.content = self.detailObj.exchangePoundage;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//查看详情
-(void)detailBtnClick {
    
    if ([self.headDict[@"isDetail"] boolValue]) {
        
        [self.headDict setObject:@(NO) forKey:@"isDetail"];
    }else {
        
         [self.headDict setObject:@(YES) forKey:@"isDetail"];
    }
    // 某个cell刷新
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
}
//去官网
-(void)goGuanWangBtnClick {
    
    H5Node *node = [[H5Node alloc] init];
    node.title = [APPLanguageService wyhSearchContentWith:@"guanwangdizhi"];
    node.webUrl = self.detailObj.exchangeWebsiteAddress;
    
    [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(!self.isExchangeIntro){
        if (section == 5) {
            return 60;
        }
    }
    if(section > 1 &&section < 5){
        NSString *content = @"";
        if(section == 2){
            content = self.detailObj.exchangeDownloads;
        }else if(section == 3){
            content = self.detailObj.exchangeContact;
        }else if(section == 4){
            content = self.detailObj.exchangePoundage;
        }
        if(content.length == 0) return 0.01;
        return 38.0f;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(!self.isExchangeIntro){
        if (section == 5) {
            return self.headView;
        }
    }
    //新增简介信息
    if(section > 1 &&section < 5){
        NSString *content = @"";
        if(section == 2){
            content = self.detailObj.exchangeDownloads;
        }else if(section == 3){
            content = self.detailObj.exchangeContact;
        }else if(section == 4){
            content = self.detailObj.exchangePoundage;
        }
        if(content.length == 0) return nil;
        NSArray *arr = @[[APPLanguageService sjhSearchContentWith:@"appxiazai"],[APPLanguageService sjhSearchContentWith:@"lianxifangshi"],[APPLanguageService sjhSearchContentWith:@"shouxufei"]];
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 28.0f)];
        headerView.backgroundColor =isNightMode?ViewBGNightColor:ViewBGDayColor;
        UILabel *titleLabel = [UILabel labelWithFrame:CGRectZero title:@"" font:FONTOFSIZE(12) textColor:isNightMode?FirstNightColor:FirstDayColor];
        titleLabel.text = arr[section - 2];
        [headerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView).offset(15);
            make.centerY.equalTo(headerView.mas_centerY);
        }];
        return headerView;
    }
    
    return nil;
}
#pragma mark - UIScrollDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    [self.marketRealtimeRequest stop];
//    [self stopTimer];
//}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
//    if (!decelerate) {
//
//        if (self.dataArray.count > 0) {
//
//            [self startTimer];
//        }
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//
//    if (self.dataArray.count > 0) {
//
//        [self startTimer];
//    }
//}

+ (id)createWithParams:(NSDictionary *)params{
    XianHuoDetailViewController *vc = [[XianHuoDetailViewController alloc] init];
    vc.exchangeId = [[params objectForKey:@"exchangeId"] integerValue];
    vc.exchangeCode = [params objectForKey:@"exchangeCode"];
    vc.hidesBottomBarWhenPushed = YES;
    NSLog(@"%ld%@",vc.exchangeId,vc.exchangeCode);
    
    return vc;
    
}
#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableDictionary *)headDict {
    
    if (!_headDict) {
        
        _headDict = [[NSMutableDictionary alloc] init];
    }
    return _headDict;
}
-(SetionHeadView *)headView {
    
    if (!_headView) {
        
        _headView = [SetionHeadView loadFromXib];
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 60);
        [AppHelper addLeftLineWithParentView:_headView];
    }
    return _headView;
}
-(XHFootView *)footView {
    
    if (!_footView) {
        
        _footView = [XHFootView loadFromXib];
        _footView.frame = CGRectMake(0, 0, ScreenWidth, 300);
    }
    return _footView;
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

@end
