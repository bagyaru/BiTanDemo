//
//  BTAitMeListViewController.m
//  BT
//
//  Created by admin on 2018/10/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTAitMeListViewController.h"
#import "BTAitMeListCell.h"
#import "BTMentionMeListRequest.h"
#import "BannersRequest.h"
#import "BTAitMeListModel.h"

#import "BTAitMeCommentModel.h"
#import "BTPostMainListCell.h"
#import "LikeRequest.h"
#import "BTTransmitPostVCViewController.h"//转发
static NSString *const identifier = @"BTPostMainListCell";
static NSString *const identifier1 = @"BTAitMeListCell";
@interface BTAitMeListViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate,BTAitMeListCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;

@end

@implementation BTAitMeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)creatUI {
    self.pageIndex = 1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTPostMainListCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTAitMeListCell class]) bundle:nil] forCellReuseIdentifier:identifier1];
    _tableView.backgroundColor = CViewBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
    }];
    
    _tableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        self.pageIndex++;
        [self requestList:RefreshStateUp];
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
    [self requestList:RefreshStateNormal];
}

- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    BTMentionMeListRequest *api = [[BTMentionMeListRequest alloc] initWithCurrentPage:self.pageIndex];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            if ([request.data count]) {
                
                [self.loadingView hiddenLoading];
            } else {
                
                [self.loadingView showNoDataWithMessage:@"zanwuaitewode" imageString:@"ic_wuaite"];
            }
            for (NSDictionary *dic in request.data) {
                BTAitMeListModel *mianModel = [BTAitMeListModel objectWithDictionary:dic];
                mianModel.unread = [dic[@"unread"] boolValue];
                if ([dic[@"comment"] isKindOfClass:[NSDictionary class]] && dic[@"comment"] != NULL) {
                    
                    mianModel.commentModel = [BTAitMeCommentModel objectWithDictionary:dic[@"comment"]];
                    if ([dic[@"comment"][@"sourceInfo"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *commentSourceInfo = dic[@"comment"][@"sourceInfo"];
                        mianModel.commentModel.images = commentSourceInfo[@"images"];
                        mianModel.commentModel.imgUrl = commentSourceInfo[@"imgUrl"];
                        mianModel.commentModel.refId = commentSourceInfo[@"refId"];
                        mianModel.commentModel.title = commentSourceInfo[@"title"];
                        mianModel.commentModel.sourceInfoUserName = commentSourceInfo[@"userName"];
                        mianModel.commentModel.jumpType = [commentSourceInfo[@"jumpType"] intValue];
                    }else {
                        
                        mianModel.commentModel.imgUrl = @"";
                        mianModel.commentModel.title = @"";
                    }
                    mianModel.commentModel.unread = mianModel.unread;
                    [self.dataArray addObject:mianModel];
                }
                if ([dic[@"post"] isKindOfClass:[NSDictionary class]] && dic[@"post"] != NULL) {
                    
                    mianModel.postModel = [BTPostMainListModel objectWithDictionary:dic[@"post"]];
                    mianModel.postModel.whereVC = @"艾特我的列表";
                    mianModel.postModel.postId = [dic[@"post"][@"id"] integerValue];
                    mianModel.postModel.unread = mianModel.unread;
                    if ([dic[@"post"][@"sourcePost"] isKindOfClass:[NSDictionary class]] && dic[@"post"][@"sourcePost"] != NULL) {//被转发的来源信息
                        NSDictionary *sourcePostDict = dic[@"post"][@"sourcePost"];
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
                    if ([dic[@"post"][@"user"] isKindOfClass:[NSDictionary class]] && dic[@"post"][@"user"] != NULL) {//用户信息
                        NSDictionary *userDict = dic[@"post"][@"user"];
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
                BTAitMeListModel *mianModel = [BTAitMeListModel objectWithDictionary:dic];
                mianModel.unread = [dic[@"unread"] boolValue];
                if ([dic[@"comment"] isKindOfClass:[NSDictionary class]] && dic[@"comment"] != NULL) {
                    
                    mianModel.commentModel = [BTAitMeCommentModel objectWithDictionary:dic[@"comment"]];
                    if ([dic[@"comment"][@"sourceInfo"] isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *commentSourceInfo = dic[@"comment"][@"sourceInfo"];
                        mianModel.commentModel.images = commentSourceInfo[@"images"];
                        mianModel.commentModel.imgUrl = commentSourceInfo[@"imgUrl"];
                        mianModel.commentModel.refId = commentSourceInfo[@"refId"];
                        mianModel.commentModel.title = commentSourceInfo[@"title"];
                        mianModel.commentModel.jumpType = [commentSourceInfo[@"jumpType"] intValue];
                        mianModel.commentModel.sourceInfoUserName = commentSourceInfo[@"userName"];
                    }else {
                        
                        mianModel.commentModel.imgUrl = @"";
                        mianModel.commentModel.title = @"";
                    }
                    mianModel.commentModel.unread = mianModel.unread;
                    [self.dataArray addObject:mianModel];
                }
                if ([dic[@"post"] isKindOfClass:[NSDictionary class]] && dic[@"post"] != NULL) {
                    
                    mianModel.postModel = [BTPostMainListModel objectWithDictionary:dic[@"post"]];
                    mianModel.postModel.whereVC = @"艾特我的列表";
                    mianModel.postModel.postId = [dic[@"postVO"][@"id"] integerValue];
                    mianModel.postModel.unread = mianModel.unread;
                    if ([dic[@"post"][@"sourcePost"] isKindOfClass:[NSDictionary class]] && dic[@"post"][@"sourcePost"] != NULL) {//被转发的来源信息
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
                    if ([dic[@"post"][@"user"] isKindOfClass:[NSDictionary class]] && dic[@"post"][@"user"] != NULL) {//用户信息
                        NSDictionary *userDict = dic[@"post"][@"user"];
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
    
    
    BTAitMeListModel *model = self.dataArray[indexPath.row];
    BTPostMainListModel *postModel = model.postModel;
    BTAitMeCommentModel *commentModel = model.commentModel;
    if (postModel && postModel.postId > 0) {
        return [BTPostMainListCell cellHeightWithDiscussModel:postModel];
    }
    return [BTAitMeListCell cellHeightWithDiscussModel:commentModel];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BTAitMeListModel *model = self.dataArray[indexPath.row];
    BTPostMainListModel *postModel = model.postModel;
    BTAitMeCommentModel *commentModel = model.commentModel;
    if (postModel && postModel.postId > 0) {
    
        
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
            LikeRequest *request = [[LikeRequest alloc] initWithLikeRefId:[NSString stringWithFormat:@"%ld",(long)model.postId] likeRefType:4 likeStatus:likeStatus likedUserId:model.userId];
            [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
                model.liked = !model.liked;
                model.likeNum = model.liked ? model.likeNum + 1 : model.likeNum - 1;
                [ws.tableView reloadData];
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
            
            [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":[NSString stringWithFormat:@"%ld",(long)model.postId],@"whereVC":@"评论"} completion:^(id obj) {
                 ws.pageIndex = 1;
                [ws requestList:RefreshStatePull];
            }];
        };
        //进详情
        cell.lookAllBlock = ^(BTPostMainListModel *model) {
            
            [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":[NSString stringWithFormat:@"%ld",(long)model.postId]} completion:^(id obj) {
                 ws.pageIndex = 1;
                [ws requestList:RefreshStatePull];
            }];
        };
        
        [cell configWithDiscussModel:postModel];
        return cell;
        
    }
    
    BTAitMeListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1 forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.delegate = self;
    WS(ws);
    cell.lookAllBlock = ^(NSInteger index, BOOL isAddLine) {
        
        commentModel.IsOrNoLookDetail = !commentModel.IsOrNoLookDetail;
        commentModel.isAddOneLine     = isAddLine;
        [ws.dataArray replaceObjectAtIndex:index withObject:model];
        [ws.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    cell.sourceLookAllBlock = ^(NSInteger index) {
       
        [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":commentModel.refId} completion:^(id obj) {
            ws.pageIndex = 1;
            [ws requestList:RefreshStatePull];
        }];
    };
    [cell configWithDiscussModel:commentModel];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    BTAitMeListModel *model = self.dataArray[indexPath.row];
    BTPostMainListModel *postModel = model.postModel;
    BTAitMeCommentModel *commentModel = model.commentModel;
    WS(ws);
    if (postModel && postModel.postId > 0) {
        [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":[NSString stringWithFormat:@"%ld",postModel.postId]} completion:^(id obj) {
             ws.pageIndex = 1;
            [ws requestList:RefreshStatePull];
        }];
    }else {
        
        if (commentModel.jumpType == 6) {//帖子
            
            [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":commentModel.refId} completion:^(id obj) {
                 ws.pageIndex = 1;
                [ws requestList:RefreshStatePull];
            }];
        }
        
        if (commentModel.jumpType == 12 || commentModel.jumpType == 15) {//要闻 攻略
            
            [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":commentModel.refId}];
        }
        if (commentModel.jumpType == 5) {//币圈
            
            [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":commentModel.refId,@"bigType":@(6)}];
        }
        if (commentModel.jumpType == 16) {//话题
            
            [BTCMInstance pushViewControllerWithName:@"TopicVC" andParams:@{@"refId":commentModel.refId}];
        }
        if (commentModel.jumpType == 2) {//论币
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            if ([commentModel.refId containsString:@"/"]) {//交易对
                [dict setObject:[commentModel.refId componentsSeparatedByString:@"/"][0] forKey:@"currencyCode"];
                [dict setObject:[commentModel.refId componentsSeparatedByString:@"/"][1] forKey:@"currencyCodeRelation"];
            }else {//币种
                
                [dict setObject:commentModel.refId forKey:@"kindCode"];
            }
            if (dict.count > 0) {
                [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:dict];
            }
        }
        
        if (commentModel.jumpType == 4) {//期货
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            NSArray *arr = [commentModel.refId componentsSeparatedByString:@"@"];
            [dict setObject:arr[0] forKey:@"exchangeCode"];
            [dict setObject:arr[1] forKey:@"kindCode"];
            [dict setObject:commentModel.title forKey:@"kindName"];
            [BTCMInstance pushViewControllerWithName:@"QiHuoDetailVC" andParams:dict];
        }
    }
    
    [getUserCenter ReadSingleMessageWithMessageId:model.messageId andType:4 andUnread:model.unread completion:^{
        KPostNotification(@"ReadSingleMessage", nil);
        ws.pageIndex = 1;
        [ws requestList:RefreshStatePull];
    }];
}
-(void)BTAitMeListCellCopyLableWithDiscussModel:(BTAitMeCommentModel *)model indexRow:(NSInteger)index{
    
    BTAitMeListModel *mainModel = self.dataArray[index];
    WS(ws);
    if (model.jumpType == 6) {//帖子
        
        [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":model.refId} completion:^(id obj) {
             ws.pageIndex = 1;
            [ws requestList:RefreshStatePull];
        }];
    }
    if (model.jumpType == 12 || model.jumpType == 15) {//要闻 攻略
        
        [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":model.refId}];
    }
    if (model.jumpType == 5) {//币圈
        
        [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":model.refId,@"bigType":@(6)}];
    }
    if (model.jumpType == 16) {//话题
        
        [BTCMInstance pushViewControllerWithName:@"TopicVC" andParams:@{@"refId":model.refId}];
    }
    if (model.jumpType == 2) {//论币
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if ([model.refId containsString:@"/"]) {//交易对
            [dict setObject:[model.refId componentsSeparatedByString:@"/"][0] forKey:@"currencyCode"];
            [dict setObject:[model.refId componentsSeparatedByString:@"/"][1] forKey:@"currencyCodeRelation"];
        }else {//币种
            
            [dict setObject:model.refId forKey:@"kindCode"];
        }
        if (dict.count > 0) {
            [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:dict];
        }
    }
    
    if (model.jumpType == 4) {//期货
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        NSArray *arr = [model.refId componentsSeparatedByString:@"@"];
        [dict setObject:arr[0] forKey:@"exchangeCode"];
        [dict setObject:arr[1] forKey:@"kindCode"];
        [dict setObject:model.title forKey:@"kindName"];
        [BTCMInstance pushViewControllerWithName:@"QiHuoDetailVC" andParams:dict];
    }
    
    [getUserCenter ReadSingleMessageWithMessageId:mainModel.messageId andType:4 andUnread:mainModel.unread completion:^{
        KPostNotification(@"ReadSingleMessage", nil);
        [ws requestList:RefreshStatePull];
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
