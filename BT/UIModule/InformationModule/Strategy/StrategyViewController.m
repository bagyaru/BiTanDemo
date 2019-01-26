//
//  StrategyViewController.m
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "StrategyViewController.h"
#import "BTInfomationSameCell.h"
#import "InformationModuleRequest.h"
#import "FastInfomationObj.h"
#import "BTInfoListSubTypesRequest.h"
static NSString *const identifier = @"BTInfomationSameCell";
@interface StrategyViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate> {
    
    NSInteger _subType;
    InformationModuleRequest *_api;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *topArray;
@property (nonatomic, strong) NSMutableArray *btnArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@end

@implementation StrategyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _subType = -1;
    [self creatUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRequest) name:NSNotification_SheQu_needRequest object:nil];
    //[self creatNewsHead];
    // Do any additional setup after loading the view from its nib.
}
- (void)needRequest{
    if (self.dataArray.count > 0) {
        return;
    }
    NSInteger index = [BTConfigureService shareInstanceService].sheQuIndex;
    NSArray *vcs = [[self.navigationController visibleViewController] childViewControllers];
    if (index < vcs.count) {
        if ([vcs[index] isEqual:self]) {
            [self loadTopData];
            [self requestList:RefreshStateNormal];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)loadTopData {
    
    BTInfoListSubTypesRequest *api = [[BTInfoListSubTypesRequest alloc] initWithParentType:3];
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        NSLog(@"%@",request.data);
        if ([request.data count]) {
            self.topArray = @[].mutableCopy;
            self.btnArray = @[].mutableCopy;
            [self.topArray addObjectsFromArray:request.data];
            [self creatTop];
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
-(void)creatTop {
    
    self.scrollView.scrollsToTop = NO;
    //self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = isNightMode ? TableViewCellNightColor : KWhiteColor;
    [self.scrollView removeAllSubviews];
    self.lineView.backgroundColor = SeparateColor;
    CGFloat _maxWidth = 15.0;
    for (int i = 0; i < self.topArray.count; i++) {
        NSDictionary *dict = self.topArray[i];
        UIButton *subTypeBtn = [[UIButton alloc] init];
        
        CGFloat BtnW = [getUserCenter calculateSizeWithFont:12 Text:dict[@"name"]]+35;
        NSLog(@"%.0f",BtnW);
        subTypeBtn.frame = CGRectMake(_maxWidth, 8, BtnW, 24);
        
        _maxWidth += BtnW+20;
        [subTypeBtn setTitle:dict[@"name"] forState:UIControlStateNormal];
        subTypeBtn.titleLabel.font = SYSTEMFONT(12);
        subTypeBtn.tag = i;
        [subTypeBtn addTarget:self action:@selector(subTypeBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [subTypeBtn setTitleColor:ThirdColor forState:UIControlStateNormal];
        ViewBorderRadius(subTypeBtn, 12, 1, BtnBorderColor);
        if (i == 0) {
            
            [subTypeBtn setTitleColor:MainBg_Color forState:UIControlStateNormal];
            ViewBorderRadius(subTypeBtn, 12, 1, MainBg_Color);
        }
        [self.btnArray addObject:subTypeBtn];
        [self.scrollView addSubview:subTypeBtn];
    }
    self.scrollView.contentSize = CGSizeMake(_maxWidth, 0);
}
-(void)subTypeBtnClcik:(UIButton *)btn {
    
    for (UIButton *b in self.btnArray) {
        
        if (b.tag == btn.tag) {
            
            [b setTitleColor:MainBg_Color forState:UIControlStateNormal];
            ViewBorderRadius(b, 12, 1, MainBg_Color);
        }else {
            
            [b setTitleColor:ThirdColor forState:UIControlStateNormal];
            ViewBorderRadius(b, 12, 1, BtnBorderColor);
        }
    }
    //请求在执行时，取消
    if(_api&&(_api.isExecuting)){
        [_api stop];
    }
    
    NSDictionary *dict = self.topArray[btn.tag];
    _subType = [dict[@"value"] integerValue];
    NSLog(@"%@",[NSString stringWithFormat:@"news_tactic_list_%d",abs([dict[@"value"] intValue])]);
    [MobClick event:[NSString stringWithFormat:@"news_tactic_list_%d",abs([dict[@"value"] intValue])]];
    self.pageIndex = 1;
    [self requestList:RefreshStateNormal];
    
}
-(void)creatUI {
    self.pageIndex = 1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTInfomationSameCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = CViewBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        //[self loadTopData];
        [self requestList:RefreshStatePull];
    }];
    [_tableView configToTop:^{
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
    }];
    _tableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        self.pageIndex++;
        [self requestList:RefreshStateUp];
    }];
     self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
//    [self loadTopData];
//    [self requestList:RefreshStateNormal];
}
- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    _api = [[InformationModuleRequest alloc] initWithType:@"3" keyword:@"" pageIndex:self.pageIndex subType:_subType];
    [_api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            if ([request.data count]) {
                
                [self.loadingView hiddenLoading];
            } else {
                
                [self.loadingView showNoDataWith:@"zanwushuju"];
            }
            for (NSDictionary *dic in request.data) {
                FastInfomationObj *obj = [FastInfomationObj objectWithDictionary:dic];
                
                if (ISNSStringValid(obj.imgUrl)) {
                    
                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:80*2 andHeight:80*2];
                    obj.imgUrl = [NSString stringWithFormat:@"%@?%@",obj.imgUrl,str];
                }
                [self.dataArray addObject:obj];
                
            }
            
            if (!request.hasNext) {
                self.tableView.mj_footer.hidden = YES;
            }else{
                self.tableView.mj_footer.hidden = NO;
                [self.tableView.mj_footer endRefreshing];
            }
        }else if (state == RefreshStateUp){
            if ([request.data count] < BTPagesize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            for (NSDictionary *dic in request.data) {
                
                
                FastInfomationObj *obj = [FastInfomationObj objectWithDictionary:dic];
                if (ISNSStringValid(obj.imgUrl)) {
                    
                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:80*2 andHeight:80*2];
                    obj.imgUrl = [NSString stringWithFormat:@"%@?%@",obj.imgUrl,str];
                }
                [self.dataArray addObject:obj];
            }
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    [self loadTopData];
    [self requestList:RefreshStateNormal];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FastInfomationObj *obj = self.dataArray[indexPath.row];
    BTInfomationSameCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell creatUIWith:obj];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [AnalysisService alaysisNews_tactic_list];
    FastInfomationObj *obj = self.dataArray[indexPath.row];
    [[BTSearchService sharedService] writeSheQuHistoryRead:obj];
    [self.tableView reloadData];
    [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":obj.infoID,
                                                                              @"whereVC":@"攻略"
                                                                              }];
}
#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
