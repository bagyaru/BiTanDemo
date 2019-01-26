//
//  BTNewDianZanAndReplayDetailViewController.m
//  BT
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTNewDianZanAndReplayDetailViewController.h"
#import "BTNewSameCommentsCell.h"
#import "IndomationDetailCommentListRequest.h"
#import "DiscussModel.h"
#import "LikeRequest.h"
#import "BTNewSetionHeadView.h"
#import "BTCommentJumpDetailRequest.h"
#import "BTNewCommentsAlertHeadView.h"
#import "BTNewCommentsAlertFootView.h"
#import "CommentDetailFootView.h"
#import "CommentInfomationRequest.h"
#import "CommentReplyRequest.h"

#import "BTNewDianZanAndReplayDetailHeadView.h"
static NSString *const identifier = @"BTNewSameCommentsCell";
@interface BTNewDianZanAndReplayDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate,BTNewSameCommentsCellDelegate,UITextViewDelegate> {
    
    CGFloat                         _keyboardHeight;
    HYShareActivityView            *_shareView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *footBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footBackViewHeight;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataArraytwo;
@property (nonatomic, strong) NSMutableArray *localArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) BTLoadingView *loadingFootView;
@property (nonatomic, strong) BTView *tableViewFV;
@property (nonatomic, strong) BTNewSetionHeadView *TwoSetionView;
@property (nonatomic, strong) BTNewDianZanAndReplayDetailHeadView *tableViewHV;
@property (nonatomic, strong) BTNewCommentsAlertFootView *footView;

@property (nonatomic, strong) CommentDetailFootView *commentAlertView;
@property (nonatomic, strong) BTView *backView;
@property (nonatomic, strong) DiscussModel *headModel;
@property (nonatomic, strong) DiscussModel *replyModel;
@property (nonatomic, assign) BOOL isReplyComment;
@end

@implementation BTNewDianZanAndReplayDetailViewController

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [self readUnreadMessage];
    [self registerNsNotification];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.backView];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.commentAlertView];
   
}
-(void)readUnreadMessage {
    NSLog(@"%@%@",self.parameters[@"type"],self.parameters[@"bigType"]);
    WS(ws);
    if ([self.parameters[@"type"] isEqualToString:@"1"]) {//点赞
        [getUserCenter ReadSingleMessageWithMessageId:[self.parameters[@"likeId"] integerValue] andType:3 andUnread:[self.parameters[@"unread"] boolValue] completion:^{
            KPostNotification(@"ReadSingleMessage", nil);
            if(ws.returnParamsBlock){
                ws.returnParamsBlock(nil);
            }
        }];
    }else {//评论
    
        [getUserCenter ReadSingleMessageWithMessageId:[[self.parameters[@"bigType"] integerValue] == 1 ? self.parameters[@"currCommentId"] : self.parameters[@"commentId"] integerValue] andType:2 andUnread:[self.parameters[@"unread"] boolValue] completion:^{
            KPostNotification(@"ReadSingleMessage", nil);
            if(ws.returnParamsBlock){
                ws.returnParamsBlock(nil);
            }
        }];
    }
}
-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [self.backView removeFromSuperview];
    [self.commentAlertView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    self.title = [APPLanguageService sjhSearchContentWith:@"xiangqing"];
    // Do any additional setup after loading the view from its nib.
}
-(void)creatUI {
    self.pageIndex = 1;
    self.isReplyComment = NO;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTNewSameCommentsCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.tag = 8754159;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    //    _tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
    //        self.pageIndex = 1;
    //        [self requestList:RefreshStatePull];
    //    }];
    
    _tableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        self.pageIndex++;
        [self requestList:RefreshStateUp];
    }];
    _tableView.tableHeaderView = self.tableViewHV;
    _tableView.tableFooterView = self.tableViewFV;
    self.footBackViewHeight.constant = iPhoneX?70:50;
    self.footView.frame = CGRectMake(0, 0, self.footBackView.frame.size.width, 50);
    [self.footBackView addSubview:self.footView];
    
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
    self.loadingFootView = [[BTLoadingView alloc] initWithParentView:self.tableViewFV aboveSubView:nil delegate:nil];
    [self loadDatailData];
    [self requestList:RefreshStateNormal];
}
-(void)loadDatailData {
    
    BTCommentJumpDetailRequest *api = [[BTCommentJumpDetailRequest alloc] initWithCommentId:[self.parameters[@"commentId"] integerValue] currCommentId:[self.parameters[@"currCommentId"] integerValue]];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        NSLog(@"%@",request.data);
        [self.dataArraytwo removeAllObjects];
        if ([request.data[@"replyList"] isKindOfClass:[NSArray class]]) {
            NSDictionary *replyListDict = request.data[@"replyList"][0];
            [self.dataArraytwo addObject:[DiscussModel modelWithJSON:replyListDict]];
        }
        self.headModel            = [DiscussModel modelWithJSON:request.data];
        self.footView.model       = self.headModel;
        self.footView.isHaveShare = YES;
        self.footView.shareUrl    = self.parameters[@"shareUrl"];
        self.footView.shareTitle  = self.parameters[@"shareTitle"];
        self.footView.shareImageURL = self.parameters[@"shareImageURL"];
        self.tableViewHV.model    = self.headModel;
        [self refreshHeadView];
        [self.tableView reloadData];
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
-(void)refreshHeadView {
    
    CGFloat height = [getUserCenter getSpaceLabelHeight:self.headModel.content withFont:SYSTEMFONT(16) withWidth:ScreenWidth-15-61 withHJJ:7.0 withZJJ:0.0]+1;
    self.tableViewHV.frame = CGRectMake(0, 0, ScreenWidth, 160+height);
    WS(ws);
    self.tableViewHV.likeBlock = ^(DiscussModel *model) {
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
            
            ws.headModel.liked = !ws.headModel.liked;
            ws.headModel.likeCount = ws.headModel.liked ? ws.headModel.likeCount + 1 : ws.headModel.likeCount - 1;
            ws.footView.model = ws.headModel;
            ws.tableViewHV.model = ws.headModel;
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    };
}
- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    IndomationDetailCommentListRequest *api = [[IndomationDetailCommentListRequest alloc] initWithRefType:3 refId:self.parameters[@"commentId"] pageIndex:self.pageIndex];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            if ([request.data count] <= 0) {
                
                [self.loadingFootView showNoDataWithMessage:@"postDetailNoMessage" imageString:@"我的帖子-评论为空"];
            }else {
                
                [self.loadingFootView hiddenLoading];
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
            model.IsOrNoLookDetail = NO;
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
        
        if (self.dataArray.count > 0) {
            NSInteger juli = ScreenHeight-114*(self.dataArray.count+1)-50-kTopHeight;
            self.tableViewFV.frame = CGRectMake(0, 0, ScreenWidth, juli > 0 ? juli : 0);
            
        }else {
            self.tableViewFV.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-114-kTopHeight-50);
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? self.dataArraytwo.count : self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? 0 : 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? [[UIView alloc] init] : self.TwoSetionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [BTNewSameCommentsCell cellHeightWithDiscussModel:indexPath.section == 0 ? self.dataArraytwo[indexPath.row] : self.dataArray[indexPath.row]];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BTNewSameCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
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
            [BTShowLoading hide];
            [self refreshLocalData:model changeType:indexPath.section];
            
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
            
            if (indexPath.section == 0) {
                
                [self.dataArraytwo removeObject:model];
            }else {
                [self.dataArray removeObject:model];
            }
            [self deletLocalData:model changeType:indexPath.section];
            
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    };
    
    DiscussModel *model = indexPath.section == 0 ? self.dataArraytwo[indexPath.row] : self.dataArray[indexPath.row];
    
    cell.lookAllBlock = ^(NSInteger index, BOOL isAddLine) {
        model.isAddOneLine     = isAddLine;
        model.IsOrNoLookDetail = !model.IsOrNoLookDetail;
        [indexPath.section == 0 ? self.dataArraytwo : self.dataArray replaceObjectAtIndex:index withObject:model];
        [ws.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    [cell configWithDiscussModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//        if (![getUserCenter isLogined]) {
//            
//            [getUserCenter loginoutPullView];
//            return;
//        }
//    
//    self.replyModel    = indexPath.section == 0 ? self.dataArraytwo[indexPath.row] : self.dataArray[indexPath.row];
//    self.commentAlertView.placeL.hidden = self.commentAlertView.textV.text.length > 0;
//    self.commentAlertView.placeL.text = [NSString stringWithFormat:@"  %@ %@：",[APPLanguageService wyhSearchContentWith:@"huifu"],self.replyModel.userName];
//    [self.footView.textField becomeFirstResponder];
//    self.backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//    self.isReplyComment = YES;
}
#pragma mark BTNewSameCommentsCellDelegate
-(void)BTNewSameCommentsCellCopyLableWithDiscussModel:(DiscussModel *)model {
    
    NSLog(@"===============弹出键盘=============");
    if (![getUserCenter isLogined]) {
        
        [getUserCenter loginoutPullView];
        return;
    }
    self.replyModel             = model;
    self.commentAlertView.placeL.hidden = self.commentAlertView.textV.text.length > 0;
    self.commentAlertView.placeL.text = [NSString stringWithFormat:@"  %@ %@：",[APPLanguageService wyhSearchContentWith:@"huifu"],self.replyModel.userName];
    [self.footView.textField becomeFirstResponder];
    self.backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.isReplyComment = YES;
}


-(void)textViewDidChange:(UITextView *)textView {
    
    self.commentAlertView.placeL.hidden = self.commentAlertView.textV.text.length > 0;
    [self.commentAlertView.fasongBtn setTitleColor:self.commentAlertView.textV.text.length > 0 ? MainBg_Color : CFontColor11 forState:UIControlStateNormal];
    static CGFloat maxHeight = 73.0f;
    
    CGRect frame = textView.frame;
    
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    
    CGSize size = [textView sizeThatFits:constraintSize];
    
    NSLog(@"前======%.0f %.0f",size.height,frame.size.height);
    if (size.height >= maxHeight) {
        
        size.height = maxHeight;
        textView.scrollEnabled = YES;  // 允许滚动
        
    }else{
        
        textView.scrollEnabled = YES;    // 不允许滚动
    }
    NSLog(@"后======%.0f %.0f",size.height,frame.size.height);
    self.commentAlertView.textV.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
    self.commentAlertView.frame = CGRectMake(0, ScreenHeight-_keyboardHeight-50-(size.height-35), ScreenWidth, 15+size.height);
    
    if (textView == self.commentAlertView.textV) {
        
        if ([self.commentAlertView.textV.text length] > CommentsMaxLength) {
            self.commentAlertView.textV.text = [self.commentAlertView.textV.text substringWithRange:NSMakeRange(0, CommentsMaxLength)];
            [self.commentAlertView.textV.undoManager removeAllActions];
            [self.commentAlertView.textV becomeFirstResponder];
            return;
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
-(NSMutableArray *)dataArraytwo {
    
    if (!_dataArraytwo) {
        _dataArraytwo = [NSMutableArray array];
    }
    return _dataArraytwo;
}
-(NSMutableArray *)localArray {
    
    if (!_localArray) {
        _localArray = [NSMutableArray array];
    }
    return _localArray;
}
-(BTNewSetionHeadView *)TwoSetionView {
    
    if (!_TwoSetionView) {
        _TwoSetionView = [BTNewSetionHeadView loadFromXib];
        _TwoSetionView.frame = CGRectMake(0, 0, ScreenWidth, 50);
    }
    return _TwoSetionView;
}
-(BTView *)tableViewFV {
    
    if (!_tableViewFV) {
        _tableViewFV = [[BTView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 500)];
        _tableViewFV.backgroundColor = KWhiteColor;
    }
    return _tableViewFV;
}
-(BTNewDianZanAndReplayDetailHeadView *)tableViewHV {
    
    if (!_tableViewHV) {
        
        _tableViewHV = [BTNewDianZanAndReplayDetailHeadView loadFromXib];
        
    }
    return _tableViewHV;
}
-(BTNewCommentsAlertFootView *)footView {
    
    if (!_footView) {
        
        _footView = [BTNewCommentsAlertFootView loadFromXib];
        [_footView.PLBtn addTarget:self action:@selector(PLBtnClick) forControlEvents:UIControlEventTouchUpInside];
        WS(ws)
        _footView.likeBlock = ^(DiscussModel *model) {
            
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
                
                ws.headModel.liked = !ws.headModel.liked;
                ws.headModel.likeCount = ws.headModel.liked ? ws.headModel.likeCount + 1 : ws.headModel.likeCount - 1;
                ws.footView.model = ws.headModel;
                ws.tableViewHV.model = ws.headModel;
            } failure:^(__kindof BTBaseRequest *request) {
                
            }];
        };
    }
    return _footView;
}
-(BTView *)backView {
    
    if (!_backView) {
        _backView = [[BTView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
        _backView.backgroundColor = [UIColor blackColor];
        _backView.alpha = 0.5;
        _backView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}
- (void)tapAction{
    [self.commentAlertView.textV resignFirstResponder];
}
-(CommentDetailFootView *)commentAlertView {
    
    if (!_commentAlertView) {
        
        _commentAlertView = [CommentDetailFootView loadFromXib];
        _commentAlertView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 50);
//        _commentAlertView.textV.delegate = self;
        [_commentAlertView.fasongBtn addTarget:self action:@selector(fasongBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentAlertView;
}


//点击评论
-(void)PLBtnClick {
    
    if (![getUserCenter isLogined]) {
        
        [getUserCenter loginoutPullView];
        return;
    }
    self.commentAlertView.placeL.localText = @"youhegaojian";
    [self.footView.textField becomeFirstResponder];
    self.backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.isReplyComment = NO;
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
    [self.commentAlertView.textV becomeFirstResponder];
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    _keyboardHeight = height;
    self.backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.commentAlertView.frame = CGRectMake(0, ScreenHeight-height-50, ScreenWidth, 50);
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    self.backView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    self.commentAlertView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 50);
}


//发表评论
-(void)fasongBtnClick {
    
    if (!ISNSStringValid(self.commentAlertView.textV.text)) {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"shurupinglunneirong"] wait:YES];
        return;
    }
    self.commentAlertView.fasongBtn.enabled = NO;
    //refType 关联类型 1新闻攻略 2论币 3回复 4期货
    BTBaseRequest *commentsApi;
    if (self.isReplyComment) {//回复 评论的回复
        commentsApi = [[CommentReplyRequest alloc] initWithRefType:3 refId:self.headModel.commentId content:self.commentAlertView.textV.text refUserId:self.headModel.userId replyId:self.replyModel.commentId replyUserId:self.replyModel.userId];
        
    }else {//回复评论
        commentsApi = [[CommentInfomationRequest alloc] initWithRefType:3 refId:self.parameters[@"commentId"] content:self.commentAlertView.textV.text refUserId:self.headModel.userId];
       
    }
    [commentsApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        self.commentAlertView.textV.text = nil;
        self.commentAlertView.fasongBtn.enabled = YES;
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"pinglunchenggong"] wait:YES];
        [getUserCenter shareSuccseGetTanLiWithType:6 withTime:2];
        [self getCommentsListFirstData];
         [self.commentAlertView.textV resignFirstResponder];
    } failure:^(__kindof BTBaseRequest *request) {
        self.commentAlertView.fasongBtn.enabled = YES;
    }];
}
-(void)getCommentsListFirstData {
    
    IndomationDetailCommentListRequest *api = [[IndomationDetailCommentListRequest alloc] initWithRefType:3 refId:self.parameters[@"commentId"] pageIndex:1];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
    
        NSDictionary *dic = request.data[0];
        DiscussModel *model = [DiscussModel modelWithJSON:dic];
        model.isOrNo   = NO;
        model.IsOrNoLookDetail = NO;
        model.isLocalModel = YES;
        [self.dataArraytwo insertObject:model atIndex:0];
        [self.tableView reloadData];
        [self SlidingToTop];
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
//滚动指定位置
-(void)SlidingToTop {
    //滚动指定位置
    if (self.dataArray.count > 0) {
        NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}
//点赞刷新本地数据
-(void)refreshLocalData:(DiscussModel *)model changeType:(NSInteger)type {
    
    for (int i = 0; i < self.dataArraytwo.count; i++) {
        
        DiscussModel *changeModel = self.dataArraytwo[i];
        if (ISStringEqualToString(model.commentId, changeModel.commentId)) {
            changeModel.liked = !changeModel.liked;
            changeModel.likeCount = changeModel.liked ? changeModel.likeCount + 1 : changeModel.likeCount - 1;
            [self.dataArraytwo replaceObjectAtIndex:i withObject:changeModel];
        }
    }
    
    for (int i = 0; i < self.dataArray.count; i++) {
        
        DiscussModel *changeModel = self.dataArray[i];
        if (ISStringEqualToString(model.commentId, changeModel.commentId)) {
            changeModel.liked = !changeModel.liked;
            changeModel.likeCount = changeModel.liked ? changeModel.likeCount + 1 : changeModel.likeCount - 1;
            [self.dataArray replaceObjectAtIndex:i withObject:changeModel];
        }
    }
    [self.tableView reloadData];
}
//点赞删除本地数据
-(void)deletLocalData:(DiscussModel *)model changeType:(NSInteger)type {
    
    if (type == 0) {
        
        for (int i = 0; i < self.dataArray.count; i++) {
            
            DiscussModel *changeModel = self.dataArray[i];
            if (ISStringEqualToString(model.commentId, changeModel.commentId)) {
                changeModel.liked = !changeModel.liked;
                changeModel.likeCount = changeModel.liked ? changeModel.likeCount + 1 : changeModel.likeCount - 1;
                [self.dataArray removeObject:changeModel];
            }
        }
        
    }else {
        
        for (int i = 0; i < self.dataArraytwo.count; i++) {
            
            DiscussModel *changeModel = self.dataArraytwo[i];
            if (ISStringEqualToString(model.commentId, changeModel.commentId)) {
                changeModel.liked = !changeModel.liked;
                changeModel.likeCount = changeModel.liked ? changeModel.likeCount + 1 : changeModel.likeCount - 1;
                [self.dataArraytwo removeObject:changeModel];
            }
        }
        
    }
    
    [self.tableView reloadData];
    
    if (self.dataArraytwo.count <= 0) {
        //评论相关的操作的通知（回复，点赞，删除）
        KPostNotification(KNotificationCommentsOperation, nil)
        [BTCMInstance popViewController:nil];
    }
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
