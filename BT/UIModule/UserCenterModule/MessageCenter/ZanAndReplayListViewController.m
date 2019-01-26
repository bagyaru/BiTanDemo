//
//  ZanAndReplayListViewController.m
//  BT
//
//  Created by admin on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ZanAndReplayListViewController.h"
#import "IndomationDetailCommentListRequest.h"
#import "CommentInfomationRequest.h"
#import "FastInfomationObj.h"
#import "InputAccessoryView.h"
#import "NewDianZanAndReplayCell.h"
#import "DiscussModel.h"
#import "LikeRequest.h"
#import "BTListLikedApi.h"
#import "BTRepliedListRequest.h"
#import "ZanAndReplayListModel.h"
#import "BTGetCommentsDetailRequest.h"
#import "ReadAllLikedRequest.h"
#import "ReadAllReplayedRequest.h"

static NSString *const identifier = @"NewDianZanAndReplayCell";
@interface ZanAndReplayListViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;

@end

@implementation ZanAndReplayListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    if ([self.dic[@"type"] isEqualToString:@"1"]) {
        //[self readAllLiked];
        self.title = [APPLanguageService wyhSearchContentWith:@"xindedianzan"];
    }else {
        //[self readAllReplayed];
        self.title = [APPLanguageService wyhSearchContentWith:@"xindepinglun"];
    }
    // Do any additional setup after loading the view from its nib.
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
    ZanAndReplayListViewController *vc = [[ZanAndReplayListViewController alloc] init];
    vc.dic = params;
    return vc;
}
-(void)creatUI {
    
    self.pageIndex = 1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([NewDianZanAndReplayCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = CWhiteColor;
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
-(void)readAllLiked {
    
    ReadAllLikedRequest *api = [[ReadAllLikedRequest alloc] initWithReadAllLiked];
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
-(void)readAllReplayed {
    
    ReadAllReplayedRequest *api = [[ReadAllReplayedRequest alloc] initWithReadReplayed];
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    BTBaseRequest *api;
    BOOL isOrNo;
    if ([self.dic[@"type"] isEqualToString:@"1"]) {
        
        api = [[BTListLikedApi alloc] initWithUserId:getUserCenter.userInfo.userId CurrentPage:self.pageIndex];
        isOrNo = YES;
    }else {
        
        api = [[BTRepliedListRequest alloc] initWithPageIndex:self.pageIndex];
        isOrNo = NO;
    }
   
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            if ([request.data count]) {
                
                [self.loadingView hiddenLoading];
            } else {
                
                [self.loadingView showNoDataWithMessage:[self.dic[@"type"] isEqualToString:@"1"]?@"zanwurenhedianzan":@"zanwurenhehuifuneirong" imageString:[self.dic[@"type"] isEqualToString:@"1"]?@"ic_wudianzan":@"ic_wupinglun"];
            }
            
            if ([request.data count] < BTPagesize) {
                self.tableView.mj_footer.hidden = YES;;
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else if (state == RefreshStateUp){
            if ([request.data count] < BTPagesize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
        for (NSDictionary *dic in request.data) {
            
            ZanAndReplayListModel *model = [ZanAndReplayListModel modelWithJSON:dic];
            model.isOrNo = isOrNo;
            model.unread = [[dic objectForKey:@"unread"] boolValue];
            [self.dataArray addObject:model];
        }
        [self.tableView.mj_header endRefreshing];
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
    
    ZanAndReplayListModel *model = self.dataArray[indexPath.row];
    return [self.dic[@"type"] isEqualToString:@"1"] ? 110 : [NewDianZanAndReplayCell cellHeightWithDiscussModel:model];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ZanAndReplayListModel *model = self.dataArray[indexPath.row];
    NewDianZanAndReplayCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.type = self.dic[@"type"];
    WS(ws);
    cell.goToDetailBlock = ^(ZanAndReplayListModel *model) {
//        NSDictionary *parameter = @{@"commentId":model.commentId,@"currCommentId":model.currCommentId,@"type":ws.dic[@"type"],@"unread":@(model.unread),@"likeId":model.likeId};
        NSMutableDictionary *parameter = @{}.mutableCopy;
        [parameter setObject:self.dic[@"type"] forKey:@"type"];
        [parameter setObject:@(model.unread) forKey:@"unread"];
        [parameter setObject:model.likeId forKey:@"likeId"];
        [parameter setObject:model.commentId forKey:@"commentId"];
        [parameter setObject:model.currCommentId forKey:@"currCommentId"];
        [parameter setObject:@(model.type) forKey:@"bigType"];
        NSLog(@"%@",parameter);
        if ([self.dic[@"type"] isEqualToString:@"1"]) {
            
            if (model.type == 2) {//帖子
                if (ISNSStringValid(model.myContent)) {
                    [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":[NSString stringWithFormat:@"%ld",model.postId]}];
                }
                [getUserCenter ReadSingleMessageWithMessageId:[model.likeId integerValue] andType:3 andUnread:model.unread completion:^{
                    KPostNotification(@"ReadSingleMessage", nil);
                    ws.pageIndex = 1;
                    [ws requestList:RefreshStatePull];
                }];
            }else if (model.type == 3) {//探报
                
                if (ISNSStringValid(model.myContent)) {
                    [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":[NSString stringWithFormat:@"%ld",model.articleId],@"bigType":@(6)}];
                }
                [getUserCenter ReadSingleMessageWithMessageId:[model.likeId integerValue] andType:3 andUnread:model.unread completion:^{
                    KPostNotification(@"ReadSingleMessage", nil);
                    ws.pageIndex = 1;
                    [ws requestList:RefreshStatePull];
                }];
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
    //NSDictionary *parameter = @{@"type":self.dic[@"type"],@"unread":@(model.unread),@"likeId":model.likeId,@"commentId":model.commentId,@"currCommentId":model.commentId};
    NSMutableDictionary *parameter = @{}.mutableCopy;
    [parameter setObject:self.dic[@"type"] forKey:@"type"];
    [parameter setObject:@(model.unread) forKey:@"unread"];
    [parameter setObject:model.likeId forKey:@"likeId"];
    [parameter setObject:model.commentId forKey:@"commentId"];
    [parameter setObject:model.currCommentId forKey:@"currCommentId"];
    [parameter setObject:@(model.type) forKey:@"bigType"];
    NSLog(@"%@",parameter);
    WS(ws);
    if ([self.dic[@"type"] isEqualToString:@"1"]) {
        
        if (model.type == 2) {//帖子
            
            if (ISNSStringValid(model.myContent)) {
                [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":[NSString stringWithFormat:@"%ld",model.postId]}];
            }
            [getUserCenter ReadSingleMessageWithMessageId:[model.likeId integerValue] andType:3 andUnread:model.unread completion:^{
                KPostNotification(@"ReadSingleMessage", nil);
                 ws.pageIndex = 1;
                [ws requestList:RefreshStatePull];
            }];
        }else if (model.type == 3) {//探报
            if (ISNSStringValid(model.myContent)) {
            
                [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":[NSString stringWithFormat:@"%ld",model.articleId],@"bigType":@(6)}];
            }
            [getUserCenter ReadSingleMessageWithMessageId:[model.likeId integerValue] andType:3 andUnread:model.unread completion:^{
                KPostNotification(@"ReadSingleMessage", nil);
                 ws.pageIndex = 1;
                [ws requestList:RefreshStatePull];
            }];
            
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
