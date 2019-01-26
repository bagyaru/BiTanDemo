//
//  BTUserPraiseVC.m
//  BT
//
//  Created by apple on 2018/10/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTUserPraiseVC.h"
#import "IndomationDetailCommentListRequest.h"
#import "CommentInfomationRequest.h"
#import "FastInfomationObj.h"
#import "InputAccessoryView.h"
#import "NewDianZanAndReplayCell.h"
#import "DiscussModel.h"
#import "LikeRequest.h"
#import "BTLikeListRequest.h"
#import "BTRepliedListRequest.h"
#import "ZanAndReplayListModel.h"
#import "BTGetCommentsDetailRequest.h"
#import "ReadAllLikedRequest.h"
#import "ReadAllReplayedRequest.h"
#import "BTListLikedApi.h"
static NSString *const identifier = @"NewDianZanAndReplayCell";
@interface BTUserPraiseVC ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;

@end

@implementation BTUserPraiseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
//    if ([self.dic[@"type"] isEqualToString:@"1"]) {
//        self.title = [APPLanguageService wyhSearchContentWith:@"dianzan"];
//    }
    NSInteger userId = [self.parameters[@"userId"] integerValue];
    if(userId == [BTGetUserInfoDefalut sharedManager].userInfo.userId){
        self.title = [APPLanguageService sjhSearchContentWith:@"wodehuozan"];
    }else{
        self.title = [APPLanguageService sjhSearchContentWith:@"tadehuozan"];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //点赞或者评论 刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestZanOrReply:) name:KNotificationCommentsOperation object:nil];
}
-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationCommentsOperation object:nil];
}
- (void)requestZanOrReply:(NSNotification *)notifi {
    self.pageIndex = 1;
    [self requestList:RefreshStatePull];
}
+ (id)createWithParams:(NSDictionary *)params{
    BTUserPraiseVC *vc = [[BTUserPraiseVC alloc] init];
    vc.dic = params;
    return vc;
}
-(void)creatUI {
    
    self.pageIndex = 1;
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.mTableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
    }];
    
    self.mTableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        self.pageIndex ++;
        [self requestList:RefreshStateUp];
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:self.mTableView delegate:self];
    [self requestList:RefreshStateNormal];
}
//
- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    BTBaseRequest *api;
    BOOL isOrNo;
    NSInteger userId = [self.parameters[@"userId"] integerValue];
    api = [[BTListLikedApi alloc] initWithUserId:userId CurrentPage:self.pageIndex];
    isOrNo = YES;
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            if ([request.data count]) {
                
                [self.loadingView hiddenLoading];
            } else {
                [self.loadingView showNoDataWithMessage:[self.dic[@"type"] isEqualToString:@"1"]?@"zanwurenhedianzan":@"zanwurenhehuifuneirong" imageString:[self.dic[@"type"] isEqualToString:@"1"]?@"ic_wudianzan":@"ic_wupinglun"];
            }
            
            if ([request.data count] < BTPagesize) {
                self.mTableView.mj_footer.hidden = YES;;
            }else{
                [self.mTableView.mj_footer endRefreshing];
            }
        }else if (state == RefreshStateUp){
            if ([request.data count] < BTPagesize) {
                [self.mTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.mTableView.mj_footer endRefreshing];
            }
        }
        for (NSDictionary *dic in request.data) {
            
            ZanAndReplayListModel *model = [ZanAndReplayListModel modelWithJSON:dic];
            model.isOrNo = isOrNo;
            model.unread = NO;
            [self.dataArray addObject:model];
        }
        [self.mTableView.mj_header endRefreshing];
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
    
    ZanAndReplayListModel *model = self.dataArray[indexPath.row];
    return [self.dic[@"type"] isEqualToString:@"1"] ? 110 : [NewDianZanAndReplayCell cellHeightWithDiscussModel:model];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ZanAndReplayListModel *model = self.dataArray[indexPath.row];
    NewDianZanAndReplayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.type = self.dic[@"type"];
    
    cell.goToDetailBlock = ^(ZanAndReplayListModel *model) {
        NSDictionary *parameter = @{@"commentId":model.commentId,@"currCommentId":model.currCommentId,@"type":self.dic[@"type"],@"unread":@(model.unread),@"likeId":model.likeId};
        NSLog(@"%@",parameter);
        WS(ws);
        if ([self.dic[@"type"] isEqualToString:@"1"]) {
            
            if (model.type == 2) {//帖子
                if (ISNSStringValid(model.myContent)) {
                    [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":[NSString stringWithFormat:@"%ld",model.postId]}];
                }
            }else if (model.type == 3) {//探报
                if (ISNSStringValid(model.myContent)) {
                     [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":[NSString stringWithFormat:@"%ld",model.articleId],@"bigType":@(6)}];
                }
                
            }else {//评论
                
                [BTCMInstance pushViewControllerWithName:@"BTNewDianZanAndReplayDetail" andParams:parameter completion:^(id obj) {
                    ws.pageIndex = 1;
                    [ws requestList:RefreshStatePull];
                }];
            }
            
        }else {
            
            [BTCMInstance pushViewControllerWithName:@"BTNewDianZanAndReplayDetail" andParams:parameter completion:^(id obj) {
                 ws.pageIndex = 1;
                [ws requestList:RefreshStatePull];
            }];
        }
    };
    [cell configWithDiscussModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZanAndReplayListModel *model = self.dataArray[indexPath.row];
    NSDictionary *parameter = @{@"commentId":model.commentId,@"currCommentId":model.currCommentId,@"type":self.dic[@"type"],@"unread":@(model.unread),@"likeId":model.likeId};
    NSLog(@"%@",parameter);
    WS(ws);
    if ([self.dic[@"type"] isEqualToString:@"1"]) {
        
        if (model.type == 2) {//帖子
            if (ISNSStringValid(model.myContent)) {
                [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":[NSString stringWithFormat:@"%ld",model.postId]}];
            }
        }else if (model.type == 3) {//探报
            if (ISNSStringValid(model.myContent)) {
                [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":[NSString stringWithFormat:@"%ld",model.articleId],@"bigType":@(6)}];
            }
            
        }else {//评论
            
            [BTCMInstance pushViewControllerWithName:@"BTNewDianZanAndReplayDetail" andParams:parameter completion:^(id obj) {
                 ws.pageIndex = 1;
                [ws requestList:RefreshStatePull];
            }];
        }
        
    }else {
        
        [BTCMInstance pushViewControllerWithName:@"BTNewDianZanAndReplayDetail" andParams:parameter completion:^(id obj) {
             ws.pageIndex = 1;
            [ws requestList:RefreshStatePull];
        }];
    }
}
#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
        [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewDianZanAndReplayCell class]) bundle:nil] forCellReuseIdentifier:identifier];
        _mTableView.backgroundColor = CViewBgColor;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator = NO;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView = footView;
    }
    return _mTableView;
}

@end
