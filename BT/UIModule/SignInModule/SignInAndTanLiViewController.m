//
//  SignInAndTanLiViewController.m
//  BT
//
//  Created by apple on 2018/5/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SignInAndTanLiViewController.h"
#import "QianDaoTableViewCell.h"
#import "TargetTableViewCell.h"
#import "TargetModel.h"
#import "DescribeTableViewCell.h"
#import "DescModel.h"
#import "HistoryTableViewCell.h"
#import "HistoryModel.h"
#import "TPSignInRequest.h"
#import "QianDaoModel.h"
#import "TPAlertView.h"
#import "TPHistoryTPRequest.h"
#import "TPTargetRequest.h"
#import "TPGetTPRequest.h"
#import "BTSignInDetailRequest.h"

@interface SignInAndTanLiViewController ()<UITableViewDataSource,UITableViewDelegate,BTLoadingViewDelegate>

/**选择标签视图*/
@property (nonatomic,strong) UIView *selectTipView;
/**记录上次选中的按钮*/
@property (nonatomic,strong) UIButton *preBtn;
/**获取当前滚动页*/
@property (nonatomic,assign) NSInteger currentPage;
/**记录之前的页数*/
@property (nonatomic,assign) NSInteger prePage;

@property (nonatomic,strong) UITableView *tableView;
/**探力label*/
@property (nonatomic, strong) UILabel *tpLabel;
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
/**签到模型*/
@property (nonatomic,strong) QianDaoModel *qianDaoModel;

@property (nonatomic, strong) BTLoadingView *loadingView;

/**刷新索引*/
@property (nonatomic,assign) NSInteger refreshIndex;
/**是否由我的探力界面进来进入任务界面*/
@property (nonatomic,assign) BOOL isTargetView;
/**是否是连续签到进去的*/
@property (nonatomic,assign) BOOL isContinueQianDao;

/**是否加载过viewDidLoad用来判断是否是从上个界面通过左上角的返回按钮进入到这个界面*/
@property (nonatomic,assign) BOOL isViewDidLoad;

@end

@implementation SignInAndTanLiViewController

#pragma mark --  Life Cycle


#pragma mark -- Create UI


#pragma mark -- Load Data


#pragma mark -- Custom Accessor


#pragma mark -- Event Response


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

-(NSMutableArray *)descDataArr{
    if (!_descDataArr) {
        _descDataArr = [NSMutableArray array];
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
                                 [APPLanguageService wyhSearchContentWith:@"shuoMingSubTitle4"]];
        for (int i = 0; i < 4; i++) {
            DescModel *model = [DescModel new];
            model.imgStr = imgStrArr[i];
            model.mainTitle = mainTitleArr[i];
            model.descTitle = subTitleArr[i];
            [_descDataArr addObject:model];
        }
    }
    return _descDataArr;
}


-(NSMutableArray *)historyDataArr{
    if (!_historyDataArr) {
        _historyDataArr = [NSMutableArray array];
//        for (int i = 0; i<5; i++) {
//            HistoryModel *model = [HistoryModel new];
//            model.mainTitle = @"邀请好友";
//            model.timeStr = @"2018-05-30 10:00";
//            model.tpStr = @"+20";
//            [_historyDataArr addObject:model];
//        }
    }
    return _historyDataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    
    self.isViewDidLoad = YES;
    self.view.backgroundColor = KWhiteColor;
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //如果没有经过viewDidLoad说明从上个界面返回的 这时候刷新请求
    if (!self.isViewDidLoad) {
        if (self.currentPage == 1) {
            [self requestTPAmount];
            [self requestTargetData];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.isViewDidLoad = NO;
}


+ (id)createWithParams:(NSDictionary *)params{
    SignInAndTanLiViewController *signInVC = [SignInAndTanLiViewController new];
    if (params.count!=0) {
        signInVC.isTargetView = [[params objectForKey:@"isTarget"] boolValue];
        signInVC.isContinueQianDao = [[params objectForKey:@"isContinue"] boolValue];
    }
    
    return signInVC;
}


-(void)initUI{
    
    //背景图
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, RELATIVE_WIDTH(202))];
//    [self.view addSubview:headView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, headView.width, RELATIVE_WIDTH(188))];
    [headView addSubview:imgView];
    imgView.image = [UIImage imageNamed:@"bg_01"];
//    imgView.backgroundColor = [UIColor redColor];
    
    
    //探力label初始化
    self.tpLabel = [UILabel new];
    [headView addSubview:self.tpLabel];
    UILabel *tpTipLabel = [UILabel new];
    [headView addSubview:tpTipLabel];
    
    self.tpLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(36)];
    self.tpLabel.textColor = kHEXCOLOR(0x111210);
    self.tpLabel.text = @"0";
    tpTipLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(16)];
    tpTipLabel.textColor = self.tpLabel.textColor;
    tpTipLabel.text = @"TP";
    
    [self.tpLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headView).offset(RELATIVE_WIDTH(60));
        make.right.equalTo(tpTipLabel.mas_left).offset(RELATIVE_WIDTH(-5));
        make.height.mas_equalTo(RELATIVE_WIDTH(50));
    }];
    
    [tpTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headView).offset(RELATIVE_WIDTH(-152));
        make.height.mas_equalTo(RELATIVE_WIDTH(22));
        make.top.equalTo(headView).offset(RELATIVE_WIDTH(81));
    }];
    
    
    UIView *bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame), headView.width, RELATIVE_WIDTH(14))];
    [headView addSubview:bottomBgView];
    bottomBgView.backgroundColor = kHEXCOLOR(0xf5f5f5);
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    headView.backgroundColor = KWhiteColor;
    self.tableView.tableHeaderView = headView;
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
    
    
    //从我的探力进入
    if (self.isTargetView) {
        self.currentPage = 1;
        [self requestTPAmount];
        [self requestTargetData];
    }else{
        
        //从主页中连续签到进入
        if (self.isContinueQianDao) {
            [self requestQianDaoDataWithisSignIn:YES succ:nil];
        }else{
            //从已经签到进入
            [self requestTPDetail];
            [self requestTPAmount];
        }
    }
    
    
    WS(ws)
    self.tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        ws.refreshIndex = 1;
        [ws requestHistoryTPData:RefreshStateNormal];
    }];
    
    self.tableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        ws.refreshIndex++;
        [ws requestHistoryTPData:RefreshStateUp];
        
    }];
    
    
    //开始是第一个视图是隐藏头尾
    self.tableView.mj_header.hidden = YES;
    self.tableView.mj_footer.hidden = YES;
    
  
}

#pragma mark - 网络请求
/**
 *  isSignIn 是否是由签到按钮进入的界面
 */
-(void)requestQianDaoDataWithisSignIn:(BOOL)isSignIn succ:(void(^)(NSString* str))succ{
    if (isSignIn) {
        [self.loadingView showLoading];
    }
    
    //签到请求
    TPSignInRequest *request = [[TPSignInRequest alloc] init];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if (request.isSuccess) {
            
            self.qianDaoModel = [QianDaoModel modelWithJSON:request.data];
//            self.qianDaoModel.day = 7;
            WS(ws)
            [TPAlertView showTPAlertView:self.qianDaoModel.day == 7?AlertTypeSignAward:AlertTypeSignSucc day:self.qianDaoModel.day award:self.qianDaoModel.num btnClick:^{
                NSLog(@"按钮的block回调");
                if (isSignIn) {
                    [ws.tableView reloadData];
                }else{
                    succ(@"点击按钮");
                }
                [ws requestTPAmount];
            }];
        }
    } failure:^(__kindof BTBaseRequest *request) {

        [self.loadingView showErrorWith:request.resultMsg];
    }];
}


//获取探力详情
-(void)requestTPDetail{
    BTSignInDetailRequest *request = [BTSignInDetailRequest new];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if (request.isSuccess) {
            self.qianDaoModel = [QianDaoModel new];
            self.qianDaoModel.day = [request.data integerValue];
            [self.tableView reloadData];
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

//获取探力数额
-(void)requestTPAmount{
    TPGetTPRequest *request = [[TPGetTPRequest alloc] init];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if (request.isSuccess) {
            self.tpLabel.text = [NSString stringWithFormat:@"%@",[request.data objectForKey:@"totalCoin"]];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}


#pragma mark - 任务
-(void)requestTargetData{

    TPTargetRequest *request = [[TPTargetRequest alloc] init];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if (request.isSuccess) {
            [self.targetDataArr removeAllObjects];
            TargetModel *firstModel = [TargetModel new];
            firstModel.isFirstRow = YES;
            [self.targetDataArr addObject:firstModel];
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
//        [self.loadingView showLoading];
    }
    TPHistoryTPRequest *request = [[TPHistoryTPRequest alloc] initWithIndex:self.refreshIndex];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
       
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.currentPage) {
        case 0:
            return 1;
            break;
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
        case 0:
            cellID = @"qianDaoCellID";
            cellClass = [QianDaoTableViewCell class];
            break;
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
    
    
    if ([cell isKindOfClass:[QianDaoTableViewCell class]]) {
//        self.qianDaoModel.day = 5;
        if (indexPath.row == 0) {
            [(QianDaoTableViewCell*)cell parseData:self.qianDaoModel];
        }
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
                        [ws requestQianDaoDataWithisSignIn:NO succ:^(NSString *str) {
                            btn.selected = YES;
                            btn.backgroundColor = kHEXCOLOR(0x108EE9);
                            btn.titleEdgeInsets = UIEdgeInsetsMake(0, RELATIVE_WIDTH(5), 0, 0);
                            ViewBorderRadius(btn, RELATIVE_WIDTH(2), 0, kHEXCOLOR(0x666666));
                        }];
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
                        [ws.tabBarController setSelectedIndex:2];
                        NSMutableArray *controllersArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                        [controllersArr removeLastObject];
                        self.navigationController.viewControllers = controllersArr;
                    }
                        break;
                        
                    case 7:
                    {
                        [AnalysisService alaysisIncome_add_button];
                        [BTCMInstance pushViewControllerWithName:@"BTNewAddRecord" andParams:@{@"kind":@""}];
                    }
                        break;
                    case 9:
                    {
                        [AnalysisService alaysisIncome_add_button];
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
        case 0:
            return RELATIVE_WIDTH(400);
            break;
        case 1:
            if (indexPath.row == 0) {
                return RELATIVE_WIDTH(48);
            }
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return RELATIVE_WIDTH(40);
}


- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //选择类型头部视图
    if (!self.selectTipView) {
        self.selectTipView = [[UIView alloc] init];
        //    [headView addSubview:self.selectTipView];
        self.selectTipView.backgroundColor = [UIColor whiteColor];
        self.selectTipView.frame = CGRectMake(0, 0, self.tableView.width, RELATIVE_WIDTH(40));
        
        
        NSArray *titleArr = @[[APPLanguageService wyhSearchContentWith:@"qiandao"],
                              [APPLanguageService wyhSearchContentWith:@"renwu"],
                              [APPLanguageService wyhSearchContentWith:@"shuoming"],
                              [APPLanguageService wyhSearchContentWith:@"lishi"]];
        NSMutableArray *btnArr = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.selectTipView addSubview:btn];
            [btn setTitle:titleArr[i] forState:UIControlStateNormal];
            [btn setTitleColor:kHEXCOLOR(0x999999) forState:UIControlStateNormal];
            [btn setTitleColor:kHEXCOLOR(0x108ee9) forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:RELATIVE_WIDTH(14)];
            [btn addTarget:self action:@selector(slectTipBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btn addTarget:self action:@selector(cancelHighLight:) forControlEvents:UIControlEventAllEvents];
            btn.tag = 1000+i;
            [btnArr addObject:btn];
            
            btn.selected = NO;
            
            
            //分割线
            UIView *lineView = [UIView new];
            [self.selectTipView addSubview:lineView];
            lineView.backgroundColor = kHEXCOLOR(0x108ee9);
            lineView.tag = 2000+i;
            lineView.hidden = YES;
            
            [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.equalTo(btn);
                make.bottom.equalTo(self.selectTipView).offset(RELATIVE_WIDTH(-1));
                make.height.mas_equalTo(RELATIVE_WIDTH(2));
            }];
            
            if(i == 0 && !self.isTargetView){
                btn.selected = YES;
                lineView.hidden = NO;
                self.preBtn = btn;
            }
            
            if (self.isTargetView) {
                if (i==1) {
                    btn.selected = YES;
                    lineView.hidden = NO;
                    self.preBtn = btn;
                }
            }
            
        }
        
        CGFloat btnW = 0;
        CGFloat leftMargin = 0;
        if ([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
            btnW = RELATIVE_WIDTH(48);
            leftMargin = RELATIVE_WIDTH(50);
        }else{
            btnW = RELATIVE_WIDTH(80);
            leftMargin = RELATIVE_WIDTH(20);
        }
        //距离最左和最右边的距离相同
        [btnArr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:btnW leadSpacing:leftMargin tailSpacing:leftMargin];
        
        [btnArr mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectTipView);
            make.bottom.equalTo(self.selectTipView).offset(RELATIVE_WIDTH(-2));
        }];
        
        
        ///添加底部分割线
        UIView *bottomLineView = [UIView new];
        [self.selectTipView insertSubview:bottomLineView atIndex:1];
        bottomLineView.backgroundColor = kHEXCOLOR(0xdddddd);
        [bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.selectTipView);
            make.bottom.equalTo(self.selectTipView).offset(RELATIVE_WIDTH(-0.5));
            make.height.mas_equalTo(RELATIVE_WIDTH(0.5));
        }];
    }
    
    return self.selectTipView;
}

//取消高亮
-(void)cancelHighLight:(UIButton *)btn{
    btn.highlighted = NO;
}

#pragma mark - 选择tip按钮点击方法
-(void)slectTipBtnClick:(UIButton*)btn{
    DLog(@"+++按钮点击+");
    
    if(self.preBtn == btn) return;
    
    self.preBtn.selected = NO;
    [self.selectTipView viewWithTag:self.preBtn.tag + 1000].hidden = YES;
    btn.selected = YES;
    [self.selectTipView viewWithTag:btn.tag + 1000].hidden = NO;
    self.preBtn = btn;
    
    self.currentPage = btn.tag - 1000;
    
    if (self.currentPage == 0) {
        
        //这个主要作用于由我的探力进入界面  开始处于任务界面
        if (!self.qianDaoModel) {
            //这时候请求签到

            self.targetModel = self.targetDataArr[2];
            //表示已经签到了
            if (self.targetModel.useNum == 1) {
                [self requestTPDetail];
            }else{
                [self requestQianDaoDataWithisSignIn:YES succ:nil];
            }
            
        }
        NSLog(@"=====%lf======",self.tableView.contentOffset.y);
        if (self.tableView.contentOffset.y > RELATIVE_WIDTH(400)) {
            [self.tableView reloadData];
            [self.tableView scrollToRow:0 inSection:0 atScrollPosition:UITableViewScrollPositionNone animated:NO];
            return;
        }
    }
    
    
    self.tableView.mj_header.hidden = self.currentPage != 3 ?YES:NO;
    self.tableView.mj_footer.hidden = self.currentPage != 3 ?YES:NO;
    
    
    if (self.currentPage == 1) {
        [self requestTargetData];
        return;
    }
    
    
    if (self.currentPage == 3) {
        [self requestHistoryTPData:RefreshStateNormal];
        return;
    }
    
    
    [self.tableView reloadData];

}


#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    
    switch (self.currentPage) {
        case 0:
            [self requestQianDaoDataWithisSignIn:YES succ:nil];
            break;
        case 1:
            [self requestTargetData];
            break;
        case 2:
            
            break;
        case 3:
            [self requestHistoryTPData:RefreshStateNormal];
            break;
            
        default:
            break;
    }
    
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
