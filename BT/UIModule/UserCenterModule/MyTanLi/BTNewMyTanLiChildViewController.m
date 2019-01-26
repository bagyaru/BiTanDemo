//
//  BTNewMyTanLiChildViewController.m
//  BT
//
//  Created by admin on 2018/8/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTNewMyTanLiChildViewController.h"
#import "TargetTableViewCell.h"
#import "TargetModel.h"
#import "DescribeTableViewCell.h"
#import "DescModel.h"
#import "HistoryTableViewCell.h"
#import "HistoryModel.h"
#import "TPHistoryTPRequest.h"
#import "TPTargetRequest.h"
#import "BTGetTPDoc.h"
@interface BTNewMyTanLiChildViewController ()<UITableViewDataSource,UITableViewDelegate,BTLoadingViewDelegate>

@property (nonatomic,strong) UITableView *tableView;
/**刷新索引*/
@property (nonatomic,assign) NSInteger refreshIndex;
/**任务数据数组*/
@property (nonatomic,strong) NSMutableArray *targetDataArr;
/**任务模型*/
@property (nonatomic,strong) TargetModel *targetModel;
/**说明数据数组*/
@property (nonatomic,strong) NSMutableArray *descDataArr;
/**说明模型*/
@property (nonatomic,strong) DescModel *descModel;
/**历史数据数组*/
@property (nonatomic,strong) NSMutableArray *historyDataArr;
/**历史模型*/
@property (nonatomic,strong) HistoryModel *historyModel;
/**是否加载过viewDidLoad用来判断是否是从上个界面通过左上角的返回按钮进入到这个界面*/
@property (nonatomic,assign) BOOL isViewDidLoad;

@property (nonatomic,assign) NSInteger currentPage;

@property (nonatomic, strong) BTLoadingView *loadingView;
@end

@implementation BTNewMyTanLiChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isViewDidLoad = YES;
    self.currentPage = [self.parameters[@"currentPage"] integerValue];
    [self initUI];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //如果没有经过viewDidLoad说明从上个界面返回的 这时候刷新请求
    if (!self.isViewDidLoad) {
        if (self.currentPage == 1) {
            [self requestTargetData];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isViewDidLoad = NO;
}
-(void)initUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
    
    
    WS(ws)
    self.tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        ws.refreshIndex = 1;
        [ws requestHistoryTPData:RefreshStatePull];
    }];
    
    self.tableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        ws.refreshIndex++;
        [ws requestHistoryTPData:RefreshStateUp];
        
    }];
    
    //开始是第一个视图是隐藏头尾
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
    
    if (self.currentPage == 1) {//任务
        self.title = [APPLanguageService wyhSearchContentWith:@"meirirenwu"];
        [self requestTargetData];
        
    }else if (self.currentPage == 2) {//说明
        self.title = [APPLanguageService wyhSearchContentWith:@"guizeshouming"];
        [self.loadingView hiddenLoading];
        [self requestTPDoc];
    }else {
        self.title = [APPLanguageService wyhSearchContentWith:@"lishijilu"];
        self.tableView.mj_header.hidden = NO;
        self.tableView.mj_footer.hidden = NO;
        [self requestHistoryTPData:RefreshStateNormal];
    }

    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.currentPage) {
        case 1:
            return self.targetDataArr.count;
            break;
        case 2:
            return self.descDataArr.count;
            break;
        case 3:
            return self.historyDataArr.count;
            break;
            
        default:
            break;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID;
    UITableViewCell *cell;
    Class cellClass;
    switch (self.currentPage) {
        case 1:
            cellID = @"targetCellID";
            cellClass = [TargetTableViewCell class];
            break;
        case 2:
            cellID = @"descCellID";
            cellClass = [DescribeTableViewCell class];
            break;
        case 3:
            cellID = @"histpryCellID";
            cellClass = [HistoryTableViewCell class];
            break;
            
        default:
            break;
    }
    
    cell  = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if ([cell isKindOfClass:[TargetTableViewCell class]]) {
        if (indexPath.row < self.targetDataArr.count) {
            WS(ws)
            [(TargetTableViewCell*)cell parseData:self.targetDataArr[indexPath.row] row:indexPath.row btnClick:^(UIButton *btn) {
                TargetModel *model = self.targetDataArr[indexPath.row];
                DLog(@"block回调");
                switch (model.type) {
                    case 1:
                        
                        break;
                    case 2:
                    {
                        
                        break;
                    }
                        
                    case 4:
                    {
                        [AnalysisService alaysisMine_invite];
                        H5Node *node =[[H5Node alloc] init];
                        node.title = [APPLanguageService wyhSearchContentWith:@"yaoqinghaoyou"];
                        [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
                    }
                        break;
                    case 3:
                    case 5:
                    case 6:
                    {
                        if (model.type == 3) [MobClick event:@"tanli_task_shareinfo"];
                        if (model.type == 5) [MobClick event:@"tanli_task_reading"];
                        if (model.type == 6) [MobClick event:@"tanli_task_comment"];
                        [ws.tabBarController setSelectedIndex:2];
                        NSMutableArray *controllersArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                        [controllersArr removeLastObject];
                        self.navigationController.viewControllers = controllersArr;
                    }
                        break;
                        
                    case 7:
                    {
                        [MobClick event:@"tanli_task_recording"];
                        [BTCMInstance pushViewControllerWithName:@"BTNewAddRecord" andParams:@{@"kind":@""}];
                    }
                        break;
                    case 9:
                    {
                        [MobClick event:@"tanli_task_authorization"];
                        [BTCMInstance pushViewControllerWithName:@"BTNewAddRecord" andParams:@{@"kind":@"",@"isShouquandaoru":@(YES)}];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }];
        }
    }
    
    if ([cell isKindOfClass:[DescribeTableViewCell class]]) {
        if (indexPath.row < self.descDataArr.count) {
            [(DescribeTableViewCell*)cell parseData:self.descDataArr[indexPath.row] row:indexPath.row];
        }
    }
    
    if ([cell isKindOfClass:[HistoryTableViewCell class]]) {
        if (indexPath.row < self.historyDataArr.count) {
            [(HistoryTableViewCell*)cell parseData:self.historyDataArr[indexPath.row]];
        }
        
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.currentPage) {
        case 1:
            return RELATIVE_WIDTH(68);
            break;
        case 2:
            return UITableViewAutomaticDimension;
            break;
        case 3:
            return RELATIVE_WIDTH(68);
            break;
        default:
            break;
    }
    return RELATIVE_WIDTH(68);
}
#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    
    switch (self.currentPage) {
        
        case 1:
            [self requestTargetData];
            break;
        case 2:
            [self requestTPDoc];
            break;
        case 3:
            [self requestHistoryTPData:RefreshStateNormal];
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 任务
-(void)requestTargetData{
    if (self.isViewDidLoad) {
        [self.loadingView showLoading];
    }
    TPTargetRequest *request = [[TPTargetRequest alloc] init];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if (request.isSuccess) {
            [self.targetDataArr removeAllObjects];
            for (NSDictionary *dic in request.data) {
                TargetModel *model = [TargetModel modelWithJSON:dic];
                if (model.type<=9 && model.type != 8) {
                    [self.targetDataArr addObject:model];
                }
                
            }
            
            [self.tableView reloadData];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

-(void)requestHistoryTPData:(RefreshState)state{
    
    if (state == RefreshStateNormal) {
        self.refreshIndex = 1;
        [self.loadingView showLoading];
    }
    TPHistoryTPRequest *request = [[TPHistoryTPRequest alloc] initWithIndex:self.refreshIndex];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            if ([request.data count] > 0) {
                
                [self.loadingView hiddenLoading];
                [self.historyDataArr removeAllObjects];
                for (NSDictionary *dic in request.data) {
                    HistoryModel *model = [HistoryModel modelWithJSON:dic];
                    [self.historyDataArr addObject:model];
                }
                if ([request.data count] < BTPagesize) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            }else{
                [self.loadingView showNoDataWith:@"zanwushuju"];
            }
        }else if (state == RefreshStateUp){
            if ([request.data count] < BTPagesize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            for (NSDictionary *dic in request.data) {
                HistoryModel *model = [HistoryModel modelWithJSON:dic];
                [self.historyDataArr addObject:model];
            }
        }
        
        [self.tableView reloadData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
    
}
// tp desc
- (void)requestTPDoc{
    [self.loadingView showLoading];
    BTGetTPDoc *api = [[BTGetTPDoc alloc] init];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data&&[request.data isKindOfClass:[NSArray class]]){
            NSMutableArray *mutaArr = @[].mutableCopy;
            NSInteger i = 0;
            for(NSDictionary *dict in request.data){
                if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
                    [mutaArr addObject:[NSString stringWithFormat:@"(%@)%@",@(i+1),SAFESTRING(dict[@"desc"])]];
                }else{
                    [mutaArr addObject:[NSString stringWithFormat:@"(%@)%@",@(i+1),SAFESTRING(dict[@"descEn"])]];
                }
                i++;
                
            }
            NSString *mutaStr = [mutaArr componentsJoinedByString:@"\n"];
            [self.loadingView hiddenLoading];
            NSArray *imgStrArr = @[@"ic_shuoming01",@"ic_shuoming02",@"ic_shuoming03",@"ic_shuoming04"];
            NSArray *mainTitleArr = @[
                                      [APPLanguageService wyhSearchContentWith:@"shuoMingMainTitle1"],
                                      [APPLanguageService wyhSearchContentWith:@"shuoMingMainTitle2"],
                                      [APPLanguageService wyhSearchContentWith:@"shuoMingMainTitle3"],
                                      [APPLanguageService wyhSearchContentWith:@"shuoMingMainTitle4"]];
            NSArray *subTitleArr = @[
                                     [APPLanguageService wyhSearchContentWith:@"shuoMingSubTitle1"],
                                     [APPLanguageService wyhSearchContentWith:@"shuoMingSubTitle2"],
                                     [APPLanguageService wyhSearchContentWith:@"shuoMingSubTitle3"],
                                     [NSString stringWithFormat:@"%@%@",[APPLanguageService wyhSearchContentWith:@"shuoMingSubTitle4"],mutaStr]];
            for (int i = 0; i < 4; i++) {
                DescModel *model = [DescModel new];
                model.imgStr = imgStrArr[i];
                model.mainTitle = mainTitleArr[i];
                model.descTitle = subTitleArr[i];
                [_descDataArr addObject:model];
            }
            [self.tableView reloadData];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
#pragma mark --  lazy
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        if(IOS_VERSION >=11.0f){
            _tableView.estimatedSectionHeaderHeight=0.0;
            _tableView.estimatedSectionFooterHeight=0.0;
        }
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 44;
    }
    return _tableView;
}

- (NSMutableArray *)targetDataArr{
    if (!_targetDataArr) {
        _targetDataArr = [NSMutableArray array];
    }
    return _targetDataArr;
}
- (NSMutableArray *)descDataArr{
    if (!_descDataArr) {
        _descDataArr = [NSMutableArray array];
    }
    return _descDataArr;
}

- (NSMutableArray *)historyDataArr{
    if (!_historyDataArr) {
        _historyDataArr = [NSMutableArray array];
    }
    return _historyDataArr;
}
@end
