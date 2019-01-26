//
//  BTMyPostCollectVC.m
//  BT
//
//  Created by apple on 2018/9/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTMyPostCollectVC.h"
#import "BTPostMainListCell.h"
#import "BTPostMainListRequest.h"
#import "BTMyPostCollectReq.h"
#import "BTPostMainListModel.h"
#import "LikeRequest.h"
#import "BTTransmitPostVCViewController.h"//转发

#import "BTMyPostRequest.h"
#import "BTDeletePostAlertView.h"
#import "BTDeletPostRequest.h"
#import "BTDeletePostCollectAlertView.h"
#import "InfomationCollectionRequest.h"

static NSString *const identifier = @"BTPostMainListCell";
@interface BTMyPostCollectVC ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>
@property (nonatomic, strong)  UITableView *mTableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;

@end

@implementation BTMyPostCollectVC

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshMainListNotification) name:k_Notification_Refresh_Post_List object:nil];
    // Do any additional setup after loading the view.
}
- (void)refreshMainListNotification {
     self.pageIndex = 1;
    [self requestList:RefreshStatePull];
}
- (void)creatUI {
    self.pageIndex = 1;
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    WS(ws)
    _mTableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        ws.pageIndex = 1;
        [ws requestList:RefreshStatePull];
    }];
    
    _mTableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        ws.pageIndex++;
        [ws requestList:RefreshStateUp];
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_mTableView delegate:self];
    
    [self requestList:RefreshStateNormal];
}
- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    BTMyPostCollectReq *api = [[BTMyPostCollectReq alloc] initWithCurrentPage:self.pageIndex];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            if ([request.data count]) {
                
                [self.loadingView hiddenLoading];
            } else {
                
                [self.loadingView showNoDataWith:@"zanwushuju"];
            }
            for (NSDictionary *dic in request.data) {
                BTPostMainListModel *model = [BTPostMainListModel objectWithDictionary:dic];
                model.whereVC = @"我的帖子-收藏";
                model.postId = [dic[@"id"] integerValue];
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
            if ([request.data count] < BTPagesize) {
                self.mTableView.mj_footer.hidden = YES;;
            }else{
                [self.mTableView.mj_footer endRefreshing];
            }
            [self.mTableView.mj_header endRefreshing];
        }else if (state == RefreshStateUp){
            if ([request.data count] < BTPagesize) {
                [self.mTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.mTableView.mj_footer endRefreshing];
            }
            
            for (NSDictionary *dic in request.data) {
                BTPostMainListModel *model = [BTPostMainListModel objectWithDictionary:dic];
                model.whereVC = @"我的帖子-收藏";
                model.postId = [dic[@"id"] integerValue];
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
        [self.mTableView reloadData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.mTableView.mj_header endRefreshing];
        [self.mTableView.mj_footer endRefreshing];
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
    BTPostMainListModel *model = self.dataArray[indexPath.row];
    return [BTPostMainListCell cellHeightWithDiscussModel:model];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    BTPostMainListModel *model = self.dataArray[indexPath.row];
    BTPostMainListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isCollcetDelete = YES;
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
            [ws.mTableView reloadData];
            [BTShowLoading hide];
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
    //删除
    cell.deletPostBlock = ^(BTPostMainListModel *model) {
        
        [BTDeletePostCollectAlertView showWithRecordModel:model completion:^(BTPostMainListModel *model) {
            InfomationCollectionRequest *api = [[InfomationCollectionRequest alloc] initWithRefType:30 refId: SAFESTRING(@(model.postId))  favor:NO];
            [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
                [ws requestList:RefreshStatePull];
                [MBProgressHUD showMessageIsWait:[APPLanguageService sjhSearchContentWith: @"shanchushoucangcg"] wait:YES];
            } failure:^(__kindof BTBaseRequest *request) {
                
            }];
        }];
    };
    [cell configWithDiscussModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BTPostMainListModel *model = self.dataArray[indexPath.row];
    
    if (model.status == 99 || model.status == 4) return;
    [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":[NSString stringWithFormat:@"%ld",model.postId]} completion:^(id obj) {
         self.pageIndex = 1;
        [self requestList:RefreshStatePull];
    }];
}
#pragma mark --Customer Accessor
-(UITableView*)mTableView{
    if(!_mTableView){
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        if(IOS_VERSION >=11.0f){
            _mTableView.estimatedSectionHeaderHeight = 0.0;
            _mTableView.estimatedSectionFooterHeight = 0.0;
        }
        _mTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator =NO;
        _mTableView.separatorColor = SeparateColor;
        [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTPostMainListCell class]) bundle:nil] forCellReuseIdentifier:@"BTPostMainListCell"];
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView = footView;
    }
    return _mTableView;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
