//
//  BTNewMyTanLiMainViewController.m
//  BT
//
//  Created by admin on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTNewMyTanLiMainViewController.h"
#import "BTMyTanLiTPTargetCell.h"

#import "TPSignInRequest.h"
#import "QianDaoModel.h"
#import "TPAlertView.h"
#import "TPGetTPRequest.h"
#import "BTSignInDetailRequest.h"
#import "TPTargetRequest.h"
#import "TargetModel.h"

#import "BTNewMyTanLiMainHeadView.h"
#import "BTTanLiSignRewardRequest.h"
#import "BTTanLiQianLiListModel.h"
#import "BTMyTPModel.h"
#import "BTIsSignInRequest.h"
#import "BTConfig.h"
static NSString *const identifier = @"BTMyTanLiTPTargetCell";
@interface BTNewMyTanLiMainViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) BTNewMyTanLiMainHeadView *headView;
@property (nonatomic, strong) NSMutableArray *tanLiQianLiListArray;
/**签到模型*/
@property (nonatomic,strong) QianDaoModel *qianDaoModel;
/**是否由我的探力界面进来进入任务界面*/
@property (nonatomic,assign) BOOL isTargetView;
/**是否是连续签到进去的*/
@property (nonatomic,assign) BOOL isContinueQianDao;
/**任务数据数组*/
@property (nonatomic,strong) NSMutableArray *targetDataArr;
@end

@implementation BTNewMyTanLiMainViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navBar setTitleTextAttributes:@{NSForegroundColorAttributeName :CWhiteColor, NSFontAttributeName : BOLDSYSTEMFONT(16)}];
    //CNavBgColor
    [self.navBar setBackgroundImage:[UIImage imageWithColor:kHEXCOLOR(0x24272D)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navBar setShadowImage:[UIImage new]];//去掉阴影线
   [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navBar setTitleTextAttributes:@{NSForegroundColorAttributeName :FirstColor, NSFontAttributeName : [UIFont systemFontOfSize:16]}];
    //CNavBgColor
    [self.navBar setBackgroundImage:[UIImage imageWithColor:CNavBgColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navBar setShadowImage:[UIImage imageWithColor:SeparateColor size:CGSizeMake(ScreenWidth, 0.5)]];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
+ (id)createWithParams:(NSDictionary *)params{
    BTNewMyTanLiMainViewController *signInVC = [BTNewMyTanLiMainViewController new];
    if (params.count != 0) {
        signInVC.isTargetView = [[params objectForKey:@"isTarget"] boolValue];
        signInVC.isContinueQianDao = [[params objectForKey:@"isContinue"] boolValue];
    }
    
    return signInVC;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navBar = self.navigationController.navigationBar;
    self.title = [APPLanguageService wyhSearchContentWith:@"myTanli"];
    [self addNavigationItemWithImageNames:@[@"return_back"] isLeft:YES target:self action:@selector(backBtnClicked) tags:@[@(100)]];
    [self addNavigationItemWithTitles:@[[APPLanguageService wyhSearchContentWith:@"guizeshouming"]] isLeft:NO target:self action:@selector(guizeshoumingBtnClick) tags:@[@(101)] whereVC:@"我的探力"];
    [self creatUI];
    // Do any additional setup after loading the view from its nib.
}
-(void)backBtnClicked {
    
    [BTCMInstance popViewController:nil];
}
//规则说明
-(void)guizeshoumingBtnClick {
    [MobClick event:@"tanli_rule"];
//    [BTCMInstance pushViewControllerWithName:@"BTNewMyTanLiChild" andParams:@{@"currentPage":@(2)}];
    
    H5Node *node = [[H5Node alloc] init];
    node.title = [APPLanguageService wyhSearchContentWith:@"guizeshouming"];
    node.webUrl = [NSString stringWithFormat:@"%@%@",[BTConfig sharedInstance].Post_h5domain,myInviteRuleDesc];
    [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
    
}
-(void)creatUI {
    self.pageIndex = 1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTMyTanLiTPTargetCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = CViewBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    UIView *headBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 555)];
    [headBackView addSubview:self.headView];
    _tableView.tableHeaderView = headBackView;
    
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
    
    [self requestTargetData];//每日任务
    //从我的探力进入
    if (self.isTargetView) {
        if (self.isContinueQianDao) {//表示已签到
            [self requestTPAmount];
            [self getTanLiQianLiListData];
        }else {//表示不知道签不签了没 
            
            [self checkIsSignIn];
        }
    }else{
        
        //从主页中连续签到进入
        if (self.isContinueQianDao) {
            [self requestQianDaoDataWithisSignIn:YES succ:nil];
        }else{
            //从已经签到进入
            [self requestTPAmount];
            [self getTanLiQianLiListData];
        }
    }
}
#pragma mark - 网络请求

/**
 *  isSignIn 判断是否已经签到
 */
-(void)checkIsSignIn{
    [self.loadingView showLoading];
    BTIsSignInRequest *request = [BTIsSignInRequest new];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if ([request.data integerValue]) {//表示已经签到
            [self requestTPAmount];
            [self getTanLiQianLiListData];
        }else{//未签到
            
            [self requestQianDaoDataWithisSignIn:YES succ:nil];
        }
    } failure:^(__kindof BTBaseRequest *request) {
    }];
}

/**
 *  isSignIn 是否是由签到按钮进入的界面
 */
-(void)requestQianDaoDataWithisSignIn:(BOOL)isSignIn succ:(void(^)(NSString* str))succ{
    //签到请求
    TPSignInRequest *request = [[TPSignInRequest alloc] init];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if (request.isSuccess) {
            
            self.qianDaoModel = [QianDaoModel modelWithJSON:request.data];
            [self requestTPAmount];
            [self getTanLiQianLiListData];
            [TPAlertView showTPAlertView:(self.qianDaoModel.day == 7 || self.qianDaoModel.day == 14 || self.qianDaoModel.day == 21)?AlertTypeSignAward:AlertTypeSignSucc day:self.qianDaoModel.signNum award:self.qianDaoModel.num btnClick:^{
                NSLog(@"按钮的block回调");
            }];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}


//获取探力详情 (获取连续签到几天了)
-(void)requestTPDetail{
    BTSignInDetailRequest *request = [BTSignInDetailRequest new];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if (request.isSuccess) {
            self.qianDaoModel = [QianDaoModel new];
            self.qianDaoModel.day = [request.data integerValue];
            self.headView.model = self.qianDaoModel;
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

//获取探力数额-（总的探力和今天所得探力）
-(void)requestTPAmount{
    [self.loadingView showLoading];
    TPGetTPRequest *request = [[TPGetTPRequest alloc] init];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if (request.isSuccess) {
            BTMyTPModel *model = [BTMyTPModel modelWithJSON:request.data];
            self.headView.myTPModel = model;
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

//探力奖励周期列表
-(void)getTanLiQianLiListData {
    BTTanLiSignRewardRequest *api = [BTTanLiSignRewardRequest new];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        self.tanLiQianLiListArray = @[].mutableCopy;
        if ([request.data isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dict in request.data) {
                BTTanLiQianLiListModel *model = [BTTanLiQianLiListModel modelWithJSON:dict];
                [self.tanLiQianLiListArray addObject:model];
            }
            self.headView.TPJiangLiListArray = self.tanLiQianLiListArray;
        }
        [self requestTPDetail];
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
#pragma mark - 任务
-(void)requestTargetData{
    
    TPTargetRequest *request = [[TPTargetRequest alloc] init];
    request.type = 1;
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if (request.isSuccess) {
            [self.targetDataArr removeAllObjects];
            for (NSDictionary *dic in request.data) {
                TargetModel *model = [TargetModel modelWithJSON:dic];
                [self.targetDataArr addObject:model];
            }
            
            [self.tableView reloadData];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    BTMyTanLiTPTargetCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.array = self.targetDataArr;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark layz
- (NSMutableArray *)tanLiQianLiListArray{
    if (!_tanLiQianLiListArray) {
        _tanLiQianLiListArray = [NSMutableArray array];
    }
    return _tanLiQianLiListArray;
}

-(BTNewMyTanLiMainHeadView *)headView {
    
    if (!_headView) {
        _headView = [BTNewMyTanLiMainHeadView loadFromXib];
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 555);
    }
    return _headView;
}
- (NSMutableArray *)targetDataArr{
    if (!_targetDataArr) {
        _targetDataArr = [NSMutableArray array];
        
    }
    return _targetDataArr;
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
