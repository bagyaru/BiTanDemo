//
//  BTPersonAllVC.m
//  BT
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPersonAllVC.h"
#import "BTHomePageArticleApi.h"
#import "BTInfomationSameCell.h"
#import "BTPostMainListCell.h"
#import "BTSheQuFocusListRequest.h"
#import "FastInfomationObj.h"
#import "BTPostMainListModel.h"
#import "BTFocusListModel.h"

#import "LikeRequest.h"
static NSString *const identifier = @"BTPostMainListCell";
static NSString *const identifier1 = @"BTInfomationSameCell";
@interface BTPersonAllVC ()<BTLoadingViewDelegate>

@property (nonatomic, strong) BTHomePageArticleApi *homeArticleApi;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, assign) BOOL isFirstEnter;
@end

@implementation BTPersonAllVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMainListNotification) name:k_Notification_Refresh_Post_List object:nil];
    [self requestList:RefreshStateNormal];
    // Do any additional setup after loading the view.
}
- (void)refreshMainListNotification {
    self.pageIndex = 1;
    [self requestList:RefreshStatePull];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    if(!self.isFirstEnter){
//        [self requestList:RefreshStateNormal];
//    }
//    self.isFirstEnter = YES;
}

- (void)creatUI {
    self.view.backgroundColor = [UIColor whiteColor];
    if(!self.original){
        self.tableView.tag = 1000;
    }else{
        self.tableView.tag = 1001;
    }
    self.pageIndex = 1;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTPostMainListCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTInfomationSameCell class]) bundle:nil] forCellReuseIdentifier:identifier1];
    self.tableView.backgroundColor = CViewBgColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
    }];
    
    self.loadingView = [[BTLoadingView alloc] initWithParentView:nil aboveSubView:nil delegate:self];
    UIView *view = [[UIView alloc] initWithFrame:self.tableView.frame];
    [view addSubview:self.loadingView];
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    self.tableView.tableFooterView = view;
}
//
- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    BTHomePageArticleApi *api = [[BTHomePageArticleApi alloc] initWithUserId:self.userId currentPage:self.pageIndex original:self.original];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            if ([request.data count]) {
                
                self.tableView.tableFooterView = nil;
            } else {
                [self.loadingView showNoDataWithMessage:@"haimeiyourenheneirong" imageString:@"ic_gerenzhuyezanwushuju"];
                
            }
            for (NSDictionary *dic in request.data) {
                BTFocusListModel *mianModel = [BTFocusListModel objectWithDictionary:dic];
                if ([dic[@"articleVO"] isKindOfClass:[NSDictionary class]] && dic[@"articleVO"] != NULL) {
                    
                    mianModel.articleModel = [FastInfomationObj objectWithDictionary:dic[@"articleVO"]];
                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:(ScreenWidth-30)*2 andHeight:100*2];
                    mianModel.articleModel.imgUrl = [NSString stringWithFormat:@"%@?%@",[SAFESTRING(mianModel.articleModel.imgUrl) hasPrefix:@"http"]?SAFESTRING(mianModel.articleModel.imgUrl):[NSString stringWithFormat:@"%@%@",PhotoImageURL,SAFESTRING(mianModel.articleModel.imgUrl)],str];
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
            if ([request.data count] < BTPagesize) {
                self.tableView.mj_footer.hidden = YES;;
            }else{
                self.tableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
                    self.pageIndex++;
                    [self requestList:RefreshStateUp];
                }];
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
                BTFocusListModel *mianModel = [BTFocusListModel objectWithDictionary:dic];
                if ([dic[@"articleVO"] isKindOfClass:[NSDictionary class]] && dic[@"articleVO"] != NULL) {
                    
                    mianModel.articleModel = [FastInfomationObj objectWithDictionary:dic[@"articleVO"]];
                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:(ScreenWidth-30)*2 andHeight:100*2];
                    mianModel.articleModel.imgUrl = [NSString stringWithFormat:@"%@?%@",[SAFESTRING(mianModel.articleModel.imgUrl) hasPrefix:@"http"]?SAFESTRING(mianModel.articleModel.imgUrl):[NSString stringWithFormat:@"%@%@",PhotoImageURL,SAFESTRING(mianModel.articleModel.imgUrl)],str];
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
                        mianModel.postModel.followed         = [userDict[@"followed"] boolValue];
                        mianModel.postModel.authStatus       = [userDict[@"authStatus"] integerValue];
                        mianModel.postModel.authType         = [userDict[@"authType"] integerValue];
                    }
                    
                    [self.dataArray addObject:mianModel];
                }
            }
        }
        [self.tableView reloadData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    [self requestList:RefreshStateNormal];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTFocusListModel *model = self.dataArray[indexPath.row];
    if (model.type == 1) {
        return [BTPostMainListCell cellHeightWithDiscussModel:model.postModel];
    }
    return 108;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BTFocusListModel *model = self.dataArray[indexPath.row];
    if (model.type == 1) {
        BTPostMainListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //点赞
        WS(ws);
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BTFocusListModel *model = self.dataArray[indexPath.row];
    if(model.type == 1){
        [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":[NSString stringWithFormat:@"%@",@(model.postModel.postId)]} completion:^(id obj) {
             self.pageIndex = 1;
            [self requestList:RefreshStatePull];
        }];
        
    }else{
        [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":SAFESTRING(model.articleModel.infoID),@"bigType":@(6)}];
    }
}
#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}



@end
