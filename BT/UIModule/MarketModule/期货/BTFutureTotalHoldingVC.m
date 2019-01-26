//
//  BTFutureTotalHoldingVC.m
//  BT
//
//  Created by apple on 2018/7/31.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTFutureTotalHoldingVC.h"
#import "BTHoldingCountApi.h"
#import "BTHoldingCountPloyApi.h"
#import "BTHoldRankTableViewCell.h"
#import "FutureLineViewCell.h"
#import "FutureHoldRankHeader.h"
@interface BTFutureTotalHoldingVC ()<UITableViewDataSource,UITableViewDelegate,BTLoadingViewDelegate,FutureLineViewCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *rankArr;
@property (nonatomic, strong)NSMutableArray *countArr;
@property (nonatomic, copy) NSArray* rankHeaderArr;
@property (nonatomic, strong) NSDictionary *holdInfo;

@property (nonatomic, strong) BTLoadingView *loadingView;

@property (nonatomic, strong)FutureHoldRankHeader *rankHeader;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) BTHoldingCountPloyApi *ployApi;

@end

static NSString *rankCellIdentifier = @"BTHoldRankTableViewCell";
static NSString *lineCellIdentifier = @"FutureLineViewCell";

@implementation BTFutureTotalHoldingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}

- (void)createUI{
    [self.view addSubview:self.tableView];
    self.tableView.separatorColor = SeparateColor;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:nil delegate:self];
}

- (void)loadData{
    self.rankArr = @[].mutableCopy;
    self.countArr = @[].mutableCopy;
    self.type = 1;
    
    [self requestPolyline];
    [self requestRankList];
}

//
- (void)refreshingData{
    [self requestPolyline];
    [self requestRankList];
}

- (void)requestPolyline{
    if(_ployApi){
        [_ployApi stop];
    }
    _ployApi = [[BTHoldingCountPloyApi alloc] initWithCode:self.code type:self.type];
    [_ployApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data &&[request.data isKindOfClass:[NSDictionary class]]){
            self.countArr = @[].mutableCopy;
            NSDictionary *dict = (NSDictionary*)request.data;
            NSArray *data = dict[@"data"];
            if(![data isKindOfClass:[NSArray class]]){
                [self.tableView reloadData];
                return;
            }
            [self.countArr addObjectsFromArray:data];
            [self.tableView reloadData];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

- (void)requestRankList{
    BTHoldingCountApi *api = [[BTHoldingCountApi alloc] initWithCode:SAFESTRING(self.code)];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        self.rankArr = @[].mutableCopy;
        if(request.data&&[request.data isKindOfClass:[NSDictionary class]]){
            NSDictionary *dict = (NSDictionary*)request.data;
            NSDictionary *dataDict = dict[@"data"];
            if(dataDict.count == 0) return ;
            NSString *key = [dataDict.allKeys firstObject];
            NSArray *arr = dataDict[key];
            
            NSArray *afterSortKeyArray = [dataDict.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString*  obj1, NSString* obj2) {
                NSComparisonResult resuest = [obj1 compare:obj2];
                return resuest;
            }];
            afterSortKeyArray = [[afterSortKeyArray reverseObjectEnumerator] allObjects];
            self.rankHeaderArr = afterSortKeyArray;
            for(NSUInteger i = 0;i < arr.count; i++){
                NSMutableArray *mutaArr = @[].mutableCopy;
                for(NSString *key in afterSortKeyArray){
                    NSArray *data = dataDict[key];
                    [mutaArr addObject:data[i]];
                }
                [self.rankArr addObject:mutaArr];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

#pragma mark- UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        if(self.type ==4) return 1;
        if(self.countArr.count ==0 ) return 0;
        return 1;
    }
    return self.rankArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        FutureLineViewCell *cell = [tableView dequeueReusableCellWithIdentifier:lineCellIdentifier];
        cell.title = @"qihuozongliangtrend";
        cell.isHoldCount = YES;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.info = self.countArr;
        
        return cell;
    }
    BTHoldRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:rankCellIdentifier];
    cell.row = indexPath.row;
    cell.arrData = self.rankArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 305.0f;
    }
    return 30.0f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 0) return nil;
    if(self.rankArr.count ==0) return nil;
    FutureHoldRankHeader *header = self.rankHeader;
    header.data = self.rankHeaderArr;
    return header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0) return 0.01;
    if(self.rankArr.count == 0) return 0.01;
    return 70.0f;
}
#pragma mark -- Customer Accessory
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tag = 1103;
        if(IOS_VERSION >=11.0f){
            _tableView.estimatedSectionHeaderHeight = 0.0;
            _tableView.estimatedSectionFooterHeight = 0.0;
        }
        [_tableView registerNib:[UINib nibWithNibName:rankCellIdentifier bundle:nil] forCellReuseIdentifier:rankCellIdentifier];
        [_tableView registerClass:[FutureLineViewCell class]  forCellReuseIdentifier:lineCellIdentifier];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (void)refreshDataWithType:(NSInteger)type{
    self.type = type;
    [self requestPolyline];
}

- (FutureHoldRankHeader*)rankHeader{
    if(!_rankHeader){
        _rankHeader = [FutureHoldRankHeader loadFromXib];
        _rankHeader.frame = CGRectMake(0, 0, ScreenWidth, 70.0f);
    }
    return _rankHeader;
}

@end
