//
//  BTMyPostCommentVC.m
//  BT
//
//  Created by apple on 2018/9/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTMyPostCommentVC.h"
#import "BTMyPostCommentsCell.h"
#import "DiscussModel.h"
#import "LikeRequest.h"

#import "BTMyPostCommentsRequest.h"
#import "BTDeletePostAlertView.h"
#import "BTDeletPostRequest.h"
static NSString *const identifier = @"BTMyPostCommentsCell";
@interface BTMyPostCommentVC ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate,BTMyPostCommentsCellDelegate>
@property (nonatomic, strong)  UITableView *mTableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;

@end

@implementation BTMyPostCommentVC

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
    BTMyPostCommentsRequest *api = [[BTMyPostCommentsRequest alloc] initWithRefType:6 pageIndex:self.pageIndex];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            if ([request.data count]) {
                
                [self.loadingView hiddenLoading];
            } else {
                
                [self.loadingView showNoDataWith:@"zanwushuju"];
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
            
            DiscussModel *model = [DiscussModel modelWithJSON:dic];
            model.isOrNo   = NO;
            model.IsOrNoLookDetail = NO;
            [self.dataArray addObject:model];
        }
        [self.mTableView.mj_header endRefreshing];
        [self.mTableView reloadData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        
        [BTShowLoading hide];
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
    DiscussModel *model = self.dataArray[indexPath.row];
    return [BTMyPostCommentsCell cellHeightWithDiscussModel:model];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    BTMyPostCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.delegate = self;
    WS(ws);
    cell.likeBlock = ^(DiscussModel *model) {
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
        LikeRequest *request = [[LikeRequest alloc] initWithLikeRefId:model.commentId likeRefType:1 likeStatus:likeStatus likedUserId:model.userId];
        [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            model.liked = !model.liked;
            model.likeCount = model.liked ? model.likeCount + 1 : model.likeCount - 1;
            [ws.mTableView reloadData];
            [BTShowLoading hide];
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    };
    
    //删除
    cell.deletBlock = ^(DiscussModel *model) {
        if (getUserCenter.userInfo.token.length == 0) {
            [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil animated:YES];
            return ;
        }
        NSLog(@"========到时候加删除接口=============");
        
        BTDeleteMyCommentRequest *api = [[BTDeleteMyCommentRequest alloc] initWithCommentId:[model.commentId integerValue]];
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            
            [ws requestList:RefreshStatePull];
            
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    };
    
    DiscussModel *model = self.dataArray[indexPath.row];
    
    cell.lookAllBlock = ^(NSInteger index, BOOL isAddLine) {
        
        model.IsOrNoLookDetail = !model.IsOrNoLookDetail;
        model.isAddOneLine     = isAddLine;
        [ws.dataArray replaceObjectAtIndex:index withObject:model];
        [ws.mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
   
    [cell configWithDiscussModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscussModel *model = self.dataArray[indexPath.row];
    if ([model.sourceInfo isKindOfClass:[NSDictionary class]] && model.sourceInfo.count > 0) {
        [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":model.sourceInfo[@"refId"]} completion:^(id obj) {
             self.pageIndex = 1;
            [self requestList:RefreshStatePull];
        }];
    }
}
#pragma mark BTNewSameCommentsCellDelegate
-(void)BTMyPostCommentsCellCopyLableWithDiscussModel:(DiscussModel *)model {
    
    if ([model.sourceInfo isKindOfClass:[NSDictionary class]] && model.sourceInfo.count > 0) {
        
        [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":model.sourceInfo[@"refId"]} completion:^(id obj) {
             self.pageIndex = 1;
            [self requestList:RefreshStatePull];
        }];
    }
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
        [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTMyPostCommentsCell class]) bundle:nil] forCellReuseIdentifier:@"BTMyPostCommentsCell"];
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
