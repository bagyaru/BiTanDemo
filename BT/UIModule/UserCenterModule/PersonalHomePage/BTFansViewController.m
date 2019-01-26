//
//  BTFansViewController.m
//  BT
//
//  Created by apple on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTFansViewController.h"
#import "ConatctModel.h"
#import "BTUserFansListReq.h"
#import "BTPersonFocusCell.h"
#import "BTFocusCancelReq.h"
#import "BTFocusUserRequest.h"
#import "BTFocusCancelReq.h"
@interface BTFansViewController ()<UITableViewDelegate,UITableViewDataSource,MGSwipeTableCellDelegate,BTLoadingViewDelegate>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, assign) NSInteger userListPage;
@property (nonatomic, strong) BTUserFansListReq *fansListApi;

@end

@implementation BTFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSInteger userId = [self.parameters[@"userId"] integerValue];
    if(userId == [BTGetUserInfoDefalut sharedManager].userInfo.userId){
        self.title = [APPLanguageService sjhSearchContentWith:@"wodefensi"];
    }else{
        self.title = [APPLanguageService sjhSearchContentWith:@"tadefensi"];
    }
    [self createUI];
    [self loadData];
    
    [_mTableView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(request) name:NSNotification_loginSuccess object:nil];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)request{
    self.userListPage = 1;
    [self requestUserFollowList:RefreshStatePull];
}
- (void)loadData{
    _userListPage = 1;
    _dataArr = @[].mutableCopy;
    [self requestUserFollowList:RefreshStateNormal];
}

- (void)createUI{
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.right.bottom.equalTo(self.view);
    }];
    WS(ws)
    self.mTableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        ws.userListPage++;
        [ws requestUserFollowList:RefreshStateUp];
    }];
    self.mTableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        ws.userListPage = 1;
        [ws requestUserFollowList:RefreshStatePull];
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.mTableView aboveSubView:self.view delegate:self];
}

- (void)refreshingData{
    [self requestUserFollowList:RefreshStateNormal];
}
- (void)requestUserFollowList:(RefreshState)state{
    if(state == RefreshStateNormal){
        [self.loadingView showLoading];
    }
    NSInteger userId = [self.parameters[@"userId"] integerValue];
    _fansListApi = [[BTUserFansListReq alloc] initWithUserId:userId CurrentPage:_userListPage];
    [_fansListApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.mTableView.mj_header endRefreshing];
            [self.dataArr removeAllObjects];
            if(![request.data isKindOfClass:[NSArray class]]){
                [self.loadingView showNoDataWithMessage:@"nofensi" imageString:@"empty_unperson"];
                [self.mTableView reloadData];
                return;
            }else{
                NSArray *arr = request.data;
                if(arr.count == 0){
                    [self.mTableView reloadData];
                    [self.loadingView showNoDataWithMessage:@"nofensi" imageString:@"empty_unperson"];
                    return;
                }
            }
            [self.loadingView hiddenLoading];
            NSString *hasNext = SAFESTRING(request.responseObject[@"hasNext"]);
            if ([hasNext isEqualToString:@"0"]) {
                self.mTableView.mj_footer.hidden = YES;
            }else{
                self.mTableView.mj_footer.hidden = NO;
                [self.mTableView.mj_footer endRefreshing];
            }
        }else if (state == RefreshStateUp){
            
            NSString *hasNext = SAFESTRING(request.responseObject[@"hasNext"]);
            if([hasNext isEqualToString:@"1"]){
                [self.mTableView.mj_footer endRefreshing];
            }else{
                [self.mTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        for(NSDictionary *dict in request.data){
            ConatctModel *model = [ConatctModel objectWithDictionary:dict];
            [self.dataArr addObject:model];
        }
        [self.mTableView reloadData];
        
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

- (UITableView*)mTableView{
    if(!_mTableView){
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        if(IOS_VERSION >=11.0f){
            _mTableView.estimatedSectionHeaderHeight = 0.0;
            _mTableView.estimatedSectionFooterHeight = 0.0;
        }
        _mTableView.separatorColor = SeparateColor;
        [_mTableView registerNib:[UINib nibWithNibName:@"BTPersonFocusCell" bundle:nil] forCellReuseIdentifier:@"BTPersonFocusCell"];
        _mTableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator =NO;
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView =footView;
    }
    return _mTableView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)r44tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTPersonFocusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTPersonFocusCell"];
    ConatctModel *model =  self.dataArr[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ConatctModel *model =  self.dataArr[indexPath.row];
    if(SAFESTRING(model.nickName).length == 0) return;
    [BTCMInstance pushViewControllerWithName:@"BTPersonViewController" andParams:@{@"userId":@(model.userId),@"userName":SAFESTRING(model.nickName)}];
}
////// 定义编辑样式
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}
//
////// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        ConatctModel *model = self.dataArr[indexPath.row];
//        [self focus:model];
//    }
//}
////
//- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
//    //添加一个删除按钮
//    ConatctModel *model =  self.dataArr[indexPath.row];
//    if(model.followed){
//        return nil;
//    }
//    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"关注TA" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [self focus:model];
//
//    }];
//    deleteAction.backgroundColor = MainBg_Color;
//    return @[deleteAction];
//}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    //添加一个删除按钮
    ConatctModel *model = self.dataArr[indexPath.row];
    NSString *name;
    if(model.followed){
        name = [APPLanguageService sjhSearchContentWith:@"quxiaoguanzhu"];
    }else{
        name = [APPLanguageService sjhSearchContentWith:@"guanzhuta"];
    }
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:name handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (![getUserCenter isLogined]) {
            [AnalysisService alaysisMine_login];
            [getUserCenter loginoutPullView];
            return;
        }
        if(model.followed){
            [self cancelFocus:model];
        }else{
            [self focus:model];
        }
    }];
    if(!model.followed){
        deleteAction.backgroundColor = MainBg_Color;
    }
    return @[deleteAction];
}

- (void)focus:(ConatctModel*)model {
    BTFocusUserRequest *req = [[BTFocusUserRequest alloc] initWithRefId:model.userId];
    [req requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"guanzhuchenggong"] wait:YES];
        [self requestUserFollowList:RefreshStatePull];
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
- (void)cancelFocus:(ConatctModel*)model {
    BTFocusCancelReq *req = [[BTFocusCancelReq alloc] initWithRefId:model.userId];
    [req requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"quxiaoguanzhuchenggong"] wait:YES];
        [self requestUserFollowList:RefreshStatePull];
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

@end
