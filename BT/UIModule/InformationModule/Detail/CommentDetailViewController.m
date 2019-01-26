//
//  CommentDetailViewController.m
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CommentDetailViewController.h"
#import "IndomationDetailCommentListRequest.h"
#import "CommentDetailFootView.h"
#import "CommentInfomationRequest.h"
#import "CommentsSameCell.h"
#import "DiscussModel.h"
#import "LikeRequest.h"
static NSString *const identifier = @"CommentsSameCell";
@interface CommentDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *refId;
@property (nonatomic, strong) CommentDetailFootView *footView;
@property (nonatomic, strong) BTView *backView;
@property (nonatomic, strong) BTLoadingView *loadingView;
@end

@implementation CommentDetailViewController
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationCommentsOperation object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [self registerNsNotification];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self creatFootView];
    // Do any additional setup after loading the view from its nib.
}
+ (id)createWithParams:(NSDictionary *)params{
    CommentDetailViewController *vc = [[CommentDetailViewController alloc] init];
    vc.refId = [params objectForKey:@"refId"];
//    vc.detailMyInfo = [params objectForKey:@"data"];
    NSLog(@"%@",vc.refId);
    
    return vc;
    
}
-(void)creatUI {
    self.pageIndex = 1;
    self.title = @"评论列表";
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommentsSameCell class]) bundle:nil] forCellReuseIdentifier:identifier];
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
    //点赞或者评论 刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestZanOrReply:) name:KNotificationCommentsOperation object:nil];
}
- (void)requestZanOrReply:(NSNotification *)notifi {
    self.pageIndex = 1;
    [self requestList:RefreshStatePull];
}
-(void)creatFootView {
    if (iPhoneX) {
        
     self.backView.frame = CGRectMake(0, ScreenHeight-44-88-20, ScreenWidth, 44);
    }else {
        
    self.backView.frame = CGRectMake(0, ScreenHeight-64-44, ScreenWidth, 44);
    }
    [self.view addSubview:self.backView];
    self.footView.frame = CGRectMake(0, 0, ScreenWidth, 44);
    [self.backView addSubview:self.footView];
    
    [self.footView.fasongBtn addTarget:self action:@selector(fasongBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)registerNsNotification {
    
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    
    if (iPhoneX) {
        
        self.backView.frame = CGRectMake(0, ScreenHeight-height-44-88-20, ScreenWidth, 44);
    }else {
        
        self.backView.frame = CGRectMake(0, ScreenHeight-height-44-64, ScreenWidth, 44);
        
    }
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    
    
    if (iPhoneX) {
        
        self.backView.frame = CGRectMake(0, ScreenHeight-44-88-20, ScreenWidth, 44);
    }else {
        
        self.backView.frame = CGRectMake(0, ScreenHeight-44-64, ScreenWidth, 44);
        
    }
    
}
//发送评论
-(void)fasongBtnClick {
    
   
    if (!ISNSStringValid(self.footView.textField.text)) {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"shurupinglunneirong"] wait:YES];
        return;
    }
    self.footView.fasongBtn.enabled = NO;
    CommentInfomationRequest *api = [[CommentInfomationRequest alloc] initWithRefType:1 refId:self.refId content:self.footView.textField.text refUserId:-1];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
      
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"pinglunchenggong"] wait:YES];
        [getUserCenter shareSuccseGetTanLiWithType:6 withTime:2];
        self.footView.textField.text = nil;
        [self.footView.textField resignFirstResponder];
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
        self.footView.fasongBtn.enabled = YES;
    } failure:^(__kindof BTBaseRequest *request) {
        self.footView.fasongBtn.enabled = YES;
    }];
}
- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
   IndomationDetailCommentListRequest *api = [[IndomationDetailCommentListRequest alloc] initWithRefType:1 refId:self.refId pageIndex:self.pageIndex];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            if ([request.data count]) {
                
                [self.loadingView hiddenLoading];
            } else {
                
                [self.loadingView showNoDataWith:@"zanwushuju"];
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
            
            DiscussModel *model = [DiscussModel modelWithJSON:dic];
            model.isOrNo   = NO;
            if (![[dic objectForKey:@"replyList"] isKindOfClass:[NSNull class]]) {
                
                NSArray *replyList = [dic objectForKey:@"replyList"];
                model.commentsArray = [[NSMutableArray alloc] init];
                for (NSDictionary *replyDic in replyList) {
                    
                    DiscussModel *replyModel = [DiscussModel modelWithJSON:replyDic];
                    [model.commentsArray addObject:replyModel];
                }
            }
            
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
    
    DiscussModel *model = self.dataArray[indexPath.row];
    return [CommentsSameCell cellHeightWithDiscussModel:model];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CommentsSameCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    //cell.delegate = self;
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
        LikeRequest *request = [[LikeRequest alloc] initWithLikeRefId:model.commentId likeRefType:1 likeStatus:likeStatus likedUserId:model.userId];
        [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            [self requestList:RefreshStatePull];
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    };
    
    DiscussModel *model = self.dataArray[indexPath.row];
    [cell configWithDiscussModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscussModel *model = self.dataArray[indexPath.row];
    [BTCMInstance pushViewControllerWithName:@"CommentsDetailVC" andParams:@{@"commentId":model.commentId}];
}
#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(CommentDetailFootView *)footView {
    
    if (!_footView) {
       
        _footView = [CommentDetailFootView loadFromXib];
        
    }
     return _footView;
}
-(BTView *)backView {
    
    if (!_backView) {
        
        _backView = [[BTView alloc] init];
    }
    return _backView;
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
