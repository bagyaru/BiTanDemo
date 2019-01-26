//
//  BTFocusListViewController.m
//  BT
//
//  Created by admin on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTFocusListViewController.h"
#import "BTInfomationSameCell.h"
#import "BTPostMainListCell.h"
#import "BTSheQuFocusListRequest.h"
#import "FastInfomationObj.h"
#import "BTPostMainListModel.h"
#import "BTFocusListModel.h"

#import "LikeRequest.h"
#import "NoLoginView.h"

#import "BTFocusRecommendCell.h"
#import "BTFocusRecommendFootView.h"
#import "BTFocusRecommendModel.h"
#import "BTFocusUserRequest.h"
#import "BTFocusCancelReq.h"

#import "BTRecommendFollowListRequest.h"
static NSString *const identifier = @"BTPostMainListCell";
static NSString *const identifier1 = @"BTInfomationSameCell";

static NSString *const identifier2 = @"BTFocusRecommendCell";
@interface BTFocusListViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger focusRecommendPageIndex;
@property (nonatomic, assign) NSInteger focusRecommendTotalPage;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *focusRecommendArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, assign) BOOL isFirstEnter;
@property (nonatomic, strong) NoLoginView *noLoginView;
@property (nonatomic, strong) BTFocusRecommendFootView *footView;
@end

@implementation BTFocusListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFirstEnter = YES;
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
            if ([getUserCenter isLogined]) {
                [self requestList:RefreshStateNormal];
            }else {
                [self.loadingView showNoDataWith:@"lijidenglu"];
            }
        }
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.isFirstEnter = NO;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.isFirstEnter) {
        if ([getUserCenter isLogined]) {
            self.noLoginView.hidden = YES;
            self.pageIndex = 1;
            [self requestList:RefreshStatePull];
        }else {
            self.noLoginView.hidden = NO;
            self.noLoginView.type = FocusListVC;
            self.noLoginView.loginBlock = ^{
                [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil];
            };
            [self.noLoginView showInWithParentView:self.view];
        }
    }else {
        
        if (![getUserCenter isLogined]) {
            
            self.noLoginView.hidden = NO;
            self.noLoginView.type = FocusListVC;
            self.noLoginView.loginBlock = ^{
                [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil];
            };
            [self.noLoginView showInWithParentView:self.view];
        }
    }
}

-(void)creatUI {
    self.pageIndex = 1;
    self.focusRecommendPageIndex = 1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTPostMainListCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTInfomationSameCell class]) bundle:nil] forCellReuseIdentifier:identifier1];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTFocusRecommendCell class]) bundle:nil] forCellReuseIdentifier:identifier2];
    _tableView.backgroundColor = CViewBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        self.focusRecommendPageIndex++;
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
//    if ([getUserCenter isLogined]) {
//       [self requestList:RefreshStateNormal];
//    }else {
//       [self.loadingView showNoDataWith:@"lijidenglu"];
//    }
}

- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    BTSheQuFocusListRequest *api = [[BTSheQuFocusListRequest alloc] initWithCurrentPage:self.pageIndex];
    //api.pageSize = self.pageIndex*10;
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        [BTShowLoading hide];
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            [self.loadingView hiddenLoading];
//            if ([request.data count]) {
//
//                [self.loadingView hiddenLoading];
//            } else {
//
//                [self.loadingView showNoDataWithMessage:@"zanwudongtai" imageString:@"空白-暂无动态"];
//            }
            for (NSDictionary *dic in request.data) {
                BTFocusListModel *mianModel = [BTFocusListModel objectWithDictionary:dic];
                if ([dic[@"articleVO"] isKindOfClass:[NSDictionary class]] && dic[@"articleVO"] != NULL) {
                    
                    mianModel.articleModel = [FastInfomationObj objectWithDictionary:dic[@"articleVO"]];
                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:(ScreenWidth-30)*2 andHeight:100*2];
                    mianModel.articleModel.imgUrl = [NSString stringWithFormat:@"%@?%@",[SAFESTRING(mianModel.articleModel.imgUrl) hasPrefix:@"http"]?mianModel.articleModel.imgUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,mianModel.articleModel.imgUrl],str];
                    if ([dic[@"articleVO"][@"user"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *userDict = dic[@"articleVO"][@"user"];
                        mianModel.articleModel.avatar             = SAFESTRING(userDict[@"avatar"]);
                        mianModel.articleModel.followed           = [userDict[@"followed"] boolValue];
                        mianModel.articleModel.introductions      = SAFESTRING(userDict[@"introductions"]);
                        mianModel.articleModel.nickName           = SAFESTRING(userDict[@"nickName"]);
                        mianModel.articleModel.userId             = [userDict[@"userId"] integerValue];
                        mianModel.articleModel.userId             = [userDict[@"userId"] integerValue];
                        mianModel.articleModel.authStatus         = [userDict[@"authStatus"] integerValue];
                        mianModel.articleModel.authType           = [userDict[@"authType"] integerValue];
                    }
                    [self.dataArray addObject:mianModel];
                }
                if ([dic[@"postVO"] isKindOfClass:[NSDictionary class]] && dic[@"postVO"] != NULL) {
                    
                    mianModel.postModel = [BTPostMainListModel objectWithDictionary:dic[@"postVO"]];
                    mianModel.postModel.whereVC = @"社区关注列表";
                    mianModel.postModel.postId = [dic[@"postVO"][@"id"] integerValue];
                    if ([dic[@"postVO"][@"sourcePost"] isKindOfClass:[NSDictionary class]] && dic[@"postVO"][@"sourcePost"] != NULL) {//被转发的来源信息
                        NSDictionary *sourcePostDict = dic[@"postVO"][@"sourcePost"];
                        mianModel.postModel.sourcePostModel = [BTPostMainListModel objectWithDictionary:sourcePostDict];
                        mianModel.postModel.sourcePostModel.postId = [sourcePostDict[@"id"] integerValue];
                        if ([sourcePostDict[@"user"] isKindOfClass:[NSDictionary class]] && sourcePostDict[@"user"] != NULL) {//用户信息
                            NSDictionary *sourcePostUserDict = sourcePostDict[@"user"];
                            mianModel.postModel.sourcePostModel.avatar           = SAFESTRING(sourcePostUserDict[@"avatar"]);
                            mianModel.postModel.sourcePostModel.nickName         = SAFESTRING(sourcePostUserDict[@"nickName"]);
                            mianModel.postModel.sourcePostModel.userId           = [sourcePostUserDict[@"userId"] integerValue];
                            mianModel.postModel.sourcePostModel.followed         = [sourcePostUserDict[@"followed"] boolValue];
                            mianModel.postModel.sourcePostModel.authStatus       = [sourcePostUserDict[@"authStatus"] integerValue];
                            mianModel.postModel.sourcePostModel.authType         = [sourcePostUserDict[@"authType"] integerValue];
                        }
                    }
                    if ([dic[@"postVO"][@"user"] isKindOfClass:[NSDictionary class]] && dic[@"postVO"][@"user"] != NULL) {//用户信息
                        NSDictionary *userDict = dic[@"postVO"][@"user"];
                        mianModel.postModel.avatar           = SAFESTRING(userDict[@"avatar"]);
                        mianModel.postModel.nickName         = SAFESTRING(userDict[@"nickName"]);
                        mianModel.postModel.userId           = [userDict[@"userId"] integerValue];
                        mianModel.postModel.authStatus       = [userDict[@"authStatus"] integerValue];
                        mianModel.postModel.authType         = [userDict[@"authType"] integerValue];
                    }
                   
                    [self.dataArray addObject:mianModel];
                }
            }
            if ([request.data count] < BTSmallPagesize) {
                self.tableView.mj_footer.hidden = YES;;
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView.mj_header endRefreshing];
        }else if (state == RefreshStateUp){
            if ([request.data count] < BTSmallPagesize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            for (NSDictionary *dic in request.data) {
                BTFocusListModel *mianModel = [BTFocusListModel objectWithDictionary:dic];
                if ([dic[@"articleVO"] isKindOfClass:[NSDictionary class]] && dic[@"articleVO"] != NULL) {
                    
                    mianModel.articleModel = [FastInfomationObj objectWithDictionary:dic[@"articleVO"]];
                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:(ScreenWidth-30)*2 andHeight:100*2];
                    mianModel.articleModel.imgUrl = [NSString stringWithFormat:@"%@?%@",[mianModel.articleModel.imgUrl hasPrefix:@"http"]?mianModel.articleModel.imgUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,mianModel.articleModel.imgUrl],str];
                    if ([dic[@"articleVO"][@"user"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *userDict = dic[@"articleVO"][@"user"];
                        mianModel.articleModel.avatar             = SAFESTRING(userDict[@"avatar"]);
                        mianModel.articleModel.followed           = [userDict[@"followed"] boolValue];
                        mianModel.articleModel.introductions      = SAFESTRING(userDict[@"introductions"]);
                        mianModel.articleModel.nickName           = SAFESTRING(userDict[@"nickName"]);
                        mianModel.articleModel.userId             = [userDict[@"userId"] integerValue];
                        mianModel.articleModel.authStatus         = [userDict[@"authStatus"] integerValue];
                        mianModel.articleModel.authType           = [userDict[@"authType"] integerValue];
                    }
                    [self.dataArray addObject:mianModel];
                }
                if ([dic[@"postVO"] isKindOfClass:[NSDictionary class]] && dic[@"postVO"] != NULL) {
                    
                    mianModel.postModel = [BTPostMainListModel objectWithDictionary:dic[@"postVO"]];
                    mianModel.postModel.whereVC = @"社区关注列表";
                    mianModel.postModel.postId = [dic[@"postVO"][@"id"] integerValue];
                    if ([dic[@"postVO"][@"sourcePost"] isKindOfClass:[NSDictionary class]] && dic[@"postVO"][@"sourcePost"] != NULL) {//被转发的来源信息
                        NSDictionary *sourcePostDict = dic[@"postVO"][@"sourcePost"];
                        mianModel.postModel.sourcePostModel = [BTPostMainListModel objectWithDictionary:sourcePostDict];
                        mianModel.postModel.sourcePostModel.postId = [sourcePostDict[@"id"] integerValue];
                        if ([sourcePostDict[@"user"] isKindOfClass:[NSDictionary class]] && sourcePostDict[@"user"] != NULL) {//用户信息
                            NSDictionary *sourcePostUserDict = sourcePostDict[@"user"];
                            mianModel.postModel.sourcePostModel.avatar           = SAFESTRING(sourcePostUserDict[@"avatar"]);
                            mianModel.postModel.sourcePostModel.nickName         = SAFESTRING(sourcePostUserDict[@"nickName"]);
                            mianModel.postModel.sourcePostModel.userId           = [sourcePostUserDict[@"userId"] integerValue];
                            mianModel.postModel.sourcePostModel.followed         = [sourcePostUserDict[@"followed"] boolValue];
                            mianModel.postModel.sourcePostModel.authStatus       = [sourcePostUserDict[@"authStatus"] integerValue];
                            mianModel.postModel.sourcePostModel.authType         = [sourcePostUserDict[@"authType"] integerValue];
                        }
                    }
                    if ([dic[@"postVO"][@"user"] isKindOfClass:[NSDictionary class]] && dic[@"postVO"][@"user"] != NULL) {//用户信息
                        NSDictionary *userDict = dic[@"postVO"][@"user"];
                        mianModel.postModel.avatar           = SAFESTRING(userDict[@"avatar"]);
                        mianModel.postModel.nickName         = SAFESTRING(userDict[@"nickName"]);
                        mianModel.postModel.userId           = [userDict[@"userId"] integerValue];
                        mianModel.postModel.followed         = [userDict[@"followed"] boolValue];
                        mianModel.postModel.authStatus       = [userDict[@"authStatus"] integerValue];
                        mianModel.postModel.authType         = [userDict[@"authType"] integerValue];
                    }
                    
                    [self.dataArray addObject:mianModel];
                }
            }
        }
        if (self.dataArray.count > 0) {
            self.focusRecommendPageIndex = 1;
            [self.tableView reloadData];
        }else {
            [self reloadFocusRecommendData];
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
//推荐关注列表或者换一批
-(void)reloadFocusRecommendData {
    
    if (self.focusRecommendPageIndex > self.focusRecommendTotalPage) {
        self.focusRecommendPageIndex = 1;
    }
    BTRecommendFollowListRequest *API = [[BTRecommendFollowListRequest alloc] initWithCurrentPage:self.focusRecommendPageIndex];
    [API requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.focusRecommendArray removeAllObjects];
        self.focusRecommendTotalPage = request.totalPage;
        self.footView.recommendIds = @[].mutableCopy;
        for (NSDictionary *dic in request.data) {
            BTFocusRecommendModel *model = [BTFocusRecommendModel objectWithDictionary:dic];
            [self.focusRecommendArray addObject:model];
            [self.footView.recommendIds addObject:@(model.userId)];
        }
        self.footView.isFocusAll = NO;
        [self.tableView reloadData];
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
//关注或取消关注
-(void)focusOrCancellFocusWithModel:(BTFocusRecommendModel *)model {
    BTBaseRequest *api;
    NSString      *message;
    if (!model.followed) {
        api = [[BTFocusUserRequest alloc] initWithRefId:model.userId];
        message = [APPLanguageService wyhSearchContentWith:@"guanzhuchenggong"];
    }else {
        message = @"";
        api = [[BTFocusCancelReq alloc] initWithRefId:model.userId];
    }
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        //[MBProgressHUD showMessageIsWait:message wait:YES];
        model.followed = !model.followed;
        [self checkIsAllFocus];
        [self.tableView reloadData];
    } failure:^(__kindof BTBaseRequest *request) {
        

    }];
}
//检查这一批是否都关注了
-(void)checkIsAllFocus {
    NSInteger j = 0;
    for (int i = 0; i < self.focusRecommendArray.count; i++) {
        BTFocusRecommendModel *model = self.focusRecommendArray[i];
        if (model.followed) {
            j++;
        }
    }
    NSLog(@"================%ld",j);
    if (j == self.focusRecommendArray.count) {
        self.footView.isFocusAll = YES;
    }else {
        self.footView.isFocusAll = NO;
    }
}
#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    [self requestList:RefreshStateNormal];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count > 0 ? self.dataArray.count : self.focusRecommendArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataArray.count > 0) {
        BTFocusListModel *model = self.dataArray[indexPath.row];
        if (model.type == 1) {
            return [BTPostMainListCell cellHeightWithDiscussModel:model.postModel];
        }
        return 114;
    }
    return 90;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    WS(ws);
    if (self.dataArray.count > 0) {
        BTFocusListModel *model = self.dataArray[indexPath.row];
        if (model.type == 1) {
            BTPostMainListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //点赞
            cell.likeBlock = ^(BTPostMainListModel *model) {
                if (getUserCenter.userInfo.token.length == 0) {
                    [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil animated:YES];
                    return ;
                }
                NSInteger likeStatus;
                if (!model.liked) {
                    likeStatus = 1;
                }else{
                    likeStatus = 2;
                }
                [BTShowLoading show];
                LikeRequest *request = [[LikeRequest alloc] initWithLikeRefId:[NSString stringWithFormat:@"%ld",model.postId] likeRefType:4 likeStatus:likeStatus likedUserId:model.userId];
                [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
                    model.liked = !model.liked;
                    model.likeNum = model.liked ? model.likeNum + 1 : model.likeNum - 1;
                    [ws.tableView reloadData];
                    [BTShowLoading hide];
                } failure:^(__kindof BTBaseRequest *request) {
                    [BTShowLoading hide];
                }];
            };
            //转发
            cell.forwardingBlock = ^(BTPostMainListModel *model) {
                
                if ([getUserCenter isLogined]) {
                    
                    [BTCMInstance presentViewControllerWithName:@"BTTransmitPostVCViewController" andParams:@{@"model":model} animated:YES ompletion:nil];
                }else {
                    
                    [getUserCenter loginoutPullView];
                }
            };
            //评论
            cell.commentsBlock = ^(BTPostMainListModel *model) {
                
                if (![getUserCenter isLogined]) {
                    [getUserCenter loginoutPullView];
                    return;
                }
                
                [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":[NSString stringWithFormat:@"%ld",model.postId],@"whereVC":@"评论"} completion:^(id obj) {
                    ws.pageIndex = 1;
                    [ws requestList:RefreshStatePull];
                }];
            };
            //进详情
            cell.lookAllBlock = ^(BTPostMainListModel *model) {
                
                [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":[NSString stringWithFormat:@"%ld",model.postId]} completion:^(id obj) {
                    ws.pageIndex = 1;
                    [ws requestList:RefreshStatePull];
                }];
            };
            
            [cell configWithDiscussModel:model.postModel];
            
            return cell;
        }
        
        BTInfomationSameCell *cell1 = [tableView dequeueReusableCellWithIdentifier:identifier1 forIndexPath:indexPath];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        cell1.whereVC = @"关注";
        [cell1 creatUIWith:model.articleModel];
        return cell1;
    }
    BTFocusRecommendModel *model = self.focusRecommendArray[indexPath.row];
    BTFocusRecommendCell *cell2 = [tableView dequeueReusableCellWithIdentifier:identifier2 forIndexPath:indexPath];
    cell2.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell2.focusBlock = ^(BTFocusRecommendModel * _Nonnull model) {
        
        [ws focusOrCancellFocusWithModel:model];
    };
    cell2.model = model;
    
    return cell2;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headV = [[UIView alloc] init];
    headV.backgroundColor = ViewBGColor;
    headV.frame = CGRectMake(0, 0, ScreenWidth, 34);
    
    UILabel *labelHead = [[UILabel alloc] init];
    labelHead.frame    = CGRectMake(15, 10, ScreenWidth-30, 14);
    labelHead.text     = [APPLanguageService wyhSearchContentWith:@"cainiganxinquderen"];
    labelHead.textColor= ThirdColor;
    labelHead.font     = SYSTEMFONT(14);
    [headV addSubview:labelHead];
    return self.dataArray.count > 0 ? [[UIView alloc] init] : headV;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return self.dataArray.count > 0 ? [[UIView alloc] init] : self.footView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return self.dataArray.count > 0 ? 0.01 : 34;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return self.dataArray.count > 0 ? 0.01 : 58;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataArray.count > 0) {
      
        BTFocusListModel *model = self.dataArray[indexPath.row];
        WS(ws);
        if (model.type == 1) {
            
            [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":[NSString stringWithFormat:@"%ld",model.postModel.postId]} completion:^(id obj) {
                ws.pageIndex = 1;
                [ws requestList:RefreshStatePull];
            }];
        }else {
            
            [MobClick event:@"tanbao_list"];
            [[BTSearchService sharedService] writeSheQuHistoryRead:model.articleModel];
            [self.tableView reloadData];
            [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":model.articleModel.infoID,@"bigType":@(6)}];
        }
        
    }else {
        BTFocusRecommendModel *model = self.focusRecommendArray[indexPath.row];
        if (ISNSStringValid(SAFESTRING(model.nickName))) {
            [BTCMInstance pushViewControllerWithName:@"BTPersonViewController" andParams:@{@"userId":@(0),@"userName":SAFESTRING(model.nickName)}];
        }
    }
}
#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(NSMutableArray *)focusRecommendArray {
    if (!_focusRecommendArray) {
        _focusRecommendArray = [NSMutableArray array];
    }
    return _focusRecommendArray;
}
- (NoLoginView *)noLoginView{
    if (!_noLoginView) {
        _noLoginView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NoLoginView class]) owner:self options:nil][0];
    }
    return _noLoginView;
}
-(BTFocusRecommendFootView *)footView {
    
    if (!_footView) {
        _footView = [BTFocusRecommendFootView loadFromXib];
        WS(ws);
        _footView.focusAllBlock = ^(BOOL isFocusAll) {
           
            if (isFocusAll) {
                for (int i = 0; i < ws.focusRecommendArray.count; i++) {
                    BTFocusRecommendModel *model = ws.focusRecommendArray[i];
                    model.followed = YES;
                    [ws.focusRecommendArray replaceObjectAtIndex:i withObject:model];
                }
            }else {
                
                for (int i = 0; i < ws.focusRecommendArray.count; i++) {
                    BTFocusRecommendModel *model = ws.focusRecommendArray[i];
                    model.followed = NO;
                    [ws.focusRecommendArray replaceObjectAtIndex:i withObject:model];
                }
            }
            [ws.tableView reloadData];
        };
        
        _footView.inABatchBlock = ^{//换一批
            ws.focusRecommendPageIndex++;
            [ws reloadFocusRecommendData];
        };
    }
    return _footView;
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
