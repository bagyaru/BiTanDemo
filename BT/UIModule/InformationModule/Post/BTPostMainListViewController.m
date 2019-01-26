//
//  BTPostMainListViewController.m
//  BT
//
//  Created by admin on 2018/9/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPostMainListViewController.h"
#import "BTPostMainListCell.h"
#import "BTPostMainListRequest.h"
#import "BTPostMainListHeadRequest.h"
#import "BTPostMainListModel.h"
#import "LikeRequest.h"
#import "BTTransmitPostVCViewController.h"//转发
#import "BTAddPostRequest.h"
#import "BTFocusUserRequest.h"
#import "BTFocusCancelReq.h"

#import "BTDeletePostAlertView.h"
#import "BTDeletPostRequest.h"
static NSString *const identifier = @"BTPostMainListCell";
@interface BTPostMainListViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UIView *viewTop;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhoto;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelNumBer;
@property (weak, nonatomic) IBOutlet UIView *viewMyPost;

@end

@implementation BTPostMainListViewController
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //[self requestList:RefreshStatePull];
    if ([getUserCenter isLogined]) {
        
        self.viewTop.hidden     = NO;
        self.topHeight.constant = 76;
    }else {
        
        self.viewTop.hidden     = YES;
        self.topHeight.constant = 0;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    ViewRadius(self.viewMyPost, 14);
    ViewRadius(self.imageViewPhoto, 20);
    [self creatUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessRequest) name:NSNotification_loginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMainListNotification) name:k_Notification_Refresh_Post_List object:nil];
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
            [self loadMyPostsInfoData];
            [self requestList:RefreshStateNormal];
        }
    }
}
- (void)refreshMainListNotification {
     self.pageIndex = 1;
    [self requestList:RefreshStatePull];
}
- (void)loginSuccessRequest {
    
    [self loadMyPostsInfoData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)creatUI {
    self.pageIndex = 1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTPostMainListCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = CViewBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self loadMyPostsInfoData];
        [self requestList:RefreshStatePull];
    }];
    [_tableView configToTop:^{
        self.pageIndex = 1;
        [self loadMyPostsInfoData];
        [self requestList:RefreshStatePull];
    }];
    _tableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        self.pageIndex++;
        [self requestList:RefreshStateUp];
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
//    [self loadMyPostsInfoData];
//    [self requestList:RefreshStateNormal];
}
- (void)loadMyPostsInfoData {
    
    if ([getUserCenter isLogined]) {
        BTPostMainListHeadRequest *api = [BTPostMainListHeadRequest new];
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            BTPostMainListModel *model = [BTPostMainListModel objectWithDictionary:request.data];
            if ([request.data[@"user"] isKindOfClass:[NSDictionary class]] && request.data[@"user"] != NULL) {//用户信息
                NSDictionary *userDict = request.data[@"user"];
                model.avatar           = SAFESTRING(userDict[@"avatar"]);
                model.nickName         = SAFESTRING(userDict[@"nickName"]);
                model.userId           = [SAFESTRING(userDict[@"userId"]) integerValue];
                model.authStatus       = [SAFESTRING(userDict[@"authStatus"]) integerValue];
                model.authType         = [SAFESTRING(userDict[@"authType"]) integerValue];
            }
            //[self.imageViewPhoto sd_setImageWithURL:[NSURL URLWithString:[SAFESTRING(model.avatar) hasPrefix:@"http"]?model.avatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,model.avatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
            
            [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:model.avatar andImageView:self.imageViewPhoto andAuthStatus:model.authStatus andAuthType:model.authType addSuperView:self.viewTop];
            
            self.labelName.text = model.nickName;
            self.labelNumBer.text = [NSString stringWithFormat:@"%@:%ld",[APPLanguageService wyhSearchContentWith:@"yueduliang"],(long)model.viewCount];
            
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    }
}
- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    BTPostMainListRequest *api = [[BTPostMainListRequest alloc] initWithIndex:self.pageIndex];
    api.type = 1;
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            NSMutableArray *sendErrerArray = [BTGetUserInfoDefalut sharedManager].posts;
            //代表有发送失败的帖子
            if (sendErrerArray.count > 0) {
                
                [self.dataArray addObjectsFromArray:sendErrerArray];
            }
            if ([request.data count]) {
                
                [self.loadingView hiddenLoading];
            } else {
                
                [self.loadingView showNoDataWith:@"zanwushuju"];
            }
            for (NSDictionary *dic in request.data) {
                BTPostMainListModel *model = [BTPostMainListModel objectWithDictionary:dic];
                model.whereVC = @"帖子主列表";
                model.postId = [dic[@"id"] integerValue];
                model.hotRecommend = [dic[@"hotRecommend"] boolValue];
                if ([dic[@"sourcePost"] isKindOfClass:[NSDictionary class]] && dic[@"sourcePost"] != NULL) {//被转发的来源信息
                    NSDictionary *sourcePostDict = dic[@"sourcePost"];
                    model.sourcePostModel = [BTPostMainListModel objectWithDictionary:sourcePostDict];
                    model.sourcePostModel.postId = [sourcePostDict[@"id"] integerValue];
                    if ([sourcePostDict[@"user"] isKindOfClass:[NSDictionary class]] && sourcePostDict[@"user"] != NULL) {//用户信息
                        NSDictionary *sourcePostUserDict = sourcePostDict[@"user"];
                        model.sourcePostModel.avatar           = SAFESTRING(sourcePostUserDict[@"avatar"]);
                        model.sourcePostModel.nickName         = SAFESTRING(sourcePostUserDict[@"nickName"]);
                        model.sourcePostModel.userId           = [sourcePostUserDict[@"userId"] integerValue];
                        model.sourcePostModel.authStatus       = [sourcePostUserDict[@"authStatus"] integerValue];
                        model.sourcePostModel.authType         = [sourcePostUserDict[@"authType"] integerValue];
                    }
                }
                if ([dic[@"user"] isKindOfClass:[NSDictionary class]] && dic[@"user"] != NULL) {//用户信息
                    NSDictionary *userDict = dic[@"user"];
                    model.avatar           = SAFESTRING(userDict[@"avatar"]);
                    model.nickName         = SAFESTRING(userDict[@"nickName"]);
                    model.userId           = [userDict[@"userId"] integerValue];
                    model.authStatus       = [userDict[@"authStatus"] integerValue];
                    model.authType         = [userDict[@"authType"] integerValue];
                }
                [self.dataArray addObject:model];
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
                BTPostMainListModel *model = [BTPostMainListModel objectWithDictionary:dic];
                model.whereVC = @"帖子主列表";
                model.postId = [dic[@"id"] integerValue];
                model.hotRecommend = [dic[@"hotRecommend"] boolValue];
                if ([dic[@"sourcePost"] isKindOfClass:[NSDictionary class]] && dic[@"sourcePost"] != NULL) {//被转发的来源信息
                    NSDictionary *sourcePostDict = dic[@"sourcePost"];
                    model.sourcePostModel = [BTPostMainListModel objectWithDictionary:sourcePostDict];
                    model.sourcePostModel.postId = [sourcePostDict[@"id"] integerValue];
                    if ([sourcePostDict[@"user"] isKindOfClass:[NSDictionary class]] && sourcePostDict[@"user"] != NULL) {//用户信息
                        NSDictionary *sourcePostUserDict = sourcePostDict[@"user"];
                        model.sourcePostModel.avatar           = SAFESTRING(sourcePostUserDict[@"avatar"]);
                        model.sourcePostModel.nickName         = SAFESTRING(sourcePostUserDict[@"nickName"]);
                        model.sourcePostModel.userId           = [sourcePostUserDict[@"userId"] integerValue];
                        model.sourcePostModel.authStatus       = [sourcePostUserDict[@"authStatus"] integerValue];
                        model.sourcePostModel.authType         = [sourcePostUserDict[@"authType"] integerValue];
                    }
                }
                if ([dic[@"user"] isKindOfClass:[NSDictionary class]] && dic[@"user"] != NULL) {//用户信息
                    NSDictionary *userDict = dic[@"user"];
                    model.avatar           = SAFESTRING(userDict[@"avatar"]);
                    model.nickName         = SAFESTRING(userDict[@"nickName"]);
                    model.userId           = [userDict[@"userId"] integerValue];
                    model.authStatus       = [userDict[@"authStatus"] integerValue];
                    model.authType         = [userDict[@"authType"] integerValue];
                }
                [self.dataArray addObject:model];
            }
        }
        [self.tableView reloadData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    [self loadMyPostsInfoData];
    [self requestList:RefreshStateNormal];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTPostMainListModel *model = self.dataArray[indexPath.row];
    return [BTPostMainListCell cellHeightWithDiscussModel:model];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    BTPostMainListModel *model = self.dataArray[indexPath.row];
    BTPostMainListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.IsShowDeletBtn = YES;
    //点赞
    WS(ws);
    
    cell.focusPostUserBlock = ^(BTPostMainListModel *model) {
        [ws foucesPostWith:model];
    };
    
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
        //[BTShowLoading show];
        LikeRequest *request = [[LikeRequest alloc] initWithLikeRefId:[NSString stringWithFormat:@"%ld",model.postId] likeRefType:4 likeStatus:likeStatus likedUserId:model.userId];
        [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            model.liked = !model.liked;
            model.likeNum = model.liked ? model.likeNum + 1 : model.likeNum - 1;
            [ws.tableView reloadData];
            //[BTShowLoading hide];
        } failure:^(__kindof BTBaseRequest *request) {
            
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
    
    /************************从新发送失败的帖子*************************/
    cell.deletPostBlock = ^(BTPostMainListModel *model) {
        
        if (model.errorType != 0 && ISNSStringValid(model.uuid)) {//从内存中删除失败的帖子
            
            [ws.dataArray removeObject:model];
            [[BTGetUserInfoDefalut sharedManager] removePostWithId:model.uuid];
            [ws.tableView reloadData];
        }else {//删除自己发的帖子
            
            [BTDeletePostAlertView showWithRecordModel:model completion:^(BTPostMainListModel *model) {
                
                BTDeletPostRequest *api = [[BTDeletPostRequest alloc] initWithCommentId:model.postId];
                [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
                    
                    [MBProgressHUD showMessageIsWait:[APPLanguageService sjhSearchContentWith:@"deleteSuccess"] wait:YES];
                    [ws.dataArray removeObject:model];
                    [ws.tableView reloadData];
                    
                } failure:^(__kindof BTBaseRequest *request) {
                    
                }];
            }];
        }
    };
    //从新发送失败的帖子
    cell.sendPostAgainBlock = ^(BTPostMainListModel *model) {
        [ws sendPostAgainWithModel:model];
    };
    [cell configWithDiscussModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    BTPostMainListModel *model = self.dataArray[indexPath.row];
    if (model.status == 99 || (model.errorType != 0 && ISNSStringValid(model.uuid)) || model.status == 4) return;
    [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":[NSString stringWithFormat:@"%ld",model.postId]} completion:^(id obj) {
         self.pageIndex = 1;
        [self requestList:RefreshStatePull];
    }];
}
//我的帖子
- (IBAction)myPostMainBtnClcik:(UIButton *)sender {
    [MobClick event:@"post_mypost"];
    [BTCMInstance pushViewControllerWithName:@"BTMyPostViewController" andParams:nil];
    
}
//关注帖子
-(void)foucesPostWith:(BTPostMainListModel *)model {
    if (![getUserCenter isLogined]) {
        [getUserCenter loginoutPullView];
        return;
    }
    [MobClick event:@"post_detail_guanzhuuser"];
    //[BTShowLoading show];
    WS(ws);
    BTBaseRequest *api;
    NSString      *message;
    if (!model.followed) {
        api = [[BTFocusUserRequest alloc] initWithRefId:model.userId];
        message = [APPLanguageService wyhSearchContentWith:@"guanzhuchenggong"];
    }else {
        message = [APPLanguageService wyhSearchContentWith:@"quxiaoguanzhuchenggong"];
        api = [[BTFocusCancelReq alloc] initWithRefId:model.userId];
    }
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [MBProgressHUD showMessageIsWait:message wait:YES];
        //操作成功 改变列表相同用户的关注状态
        model.followed = !model.followed;
        for (BTPostMainListModel *currentModel in self.dataArray) {
            if (currentModel.userId == model.userId) {
                currentModel.followed = model.followed;
            }
        }
        [ws.tableView reloadData];
    } failure:^(__kindof BTBaseRequest *request) {
        

    }];
}
-(void)sendPostAgainWithModel:(BTPostMainListModel *)model {
    
    [BTShowLoading show];
    NSString *imagesKey = @"";
    NSInteger sourcePostId;
    NSInteger sharePostId;
    if(model.images.count >0){
        imagesKey = [model.images componentsJoinedByString:@","];
    }
    if(model.type == 3){//转发
        
        if (model.errorType == 2) {//代表第一次转发
            sourcePostId = model.postId;
            sharePostId  = 0;
        }else {
            sourcePostId = model.sourcePostModel.postId;
            sharePostId  = model.postId;
        }
    }else{
        sourcePostId = 0;
        sharePostId  = 0;
    }
    NSDictionary *params = @{
                             @"content": SAFESTRING(model.content),
                             @"images": SAFESTRING(imagesKey),
                             @"shareId": @(sharePostId),
                             @"sourceId": @(sourcePostId),
                             @"type": @(model.type),//转发
                             @"userId": @([BTGetUserInfoDefalut sharedManager].userInfo.userId),
                             };
    
    
    BTAddPostRequest *addPostApi = [[BTAddPostRequest alloc] initWithDict:params];
    [addPostApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
        //通知帖子列表刷新
        if(request.data){
            //[[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Refresh_Post_List object:nil];
            
            [self.dataArray removeObject:model];
            [[BTGetUserInfoDefalut sharedManager] removePostWithId:model.uuid];
            [self requestList:RefreshStatePull];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
        [MBProgressHUD showMessage:request.resultMsg wait:YES];
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

@end
