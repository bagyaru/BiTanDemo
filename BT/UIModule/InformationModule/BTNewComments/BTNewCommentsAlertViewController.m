//
//  BTNewCommentsAlertViewController.m
//  BT
//
//  Created by admin on 2018/8/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTNewCommentsAlertViewController.h"
#import "BTNewSameCommentsCell.h"
#import "IndomationDetailCommentListRequest.h"
#import "DiscussModel.h"
#import "LikeRequest.h"
#import "BTNewSetionHeadView.h"
#import "BTGetCommentsDetailRequest.h"
#import "BTNewCommentsAlertHeadView.h"
#import "BTNewCommentsAlertFootView.h"
#import "CommentDetailFootView.h"
#import "CommentInfomationRequest.h"
#import "CommentReplyRequest.h"
static NSString *const identifier = @"BTNewSameCommentsCell";
@interface BTNewCommentsAlertViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate,BTNewSameCommentsCellDelegate,UITextViewDelegate> {
    
    CGFloat                         _keyboardHeight;
    HYShareActivityView            *_shareView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *vcBackView;
@property (weak, nonatomic) IBOutlet UIView *headBackView;
@property (weak, nonatomic) IBOutlet UIView *footBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footBackViewHeight;
@property (weak, nonatomic) IBOutlet UIView *middeView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *dataArraytwo;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) BTLoadingView *loadingFootView;
@property (nonatomic, strong) BTView *tableViewFV;
@property (nonatomic, strong) BTNewSetionHeadView *TwoSetionView;
@property (nonatomic, strong) BTNewCommentsAlertHeadView *tableViewHV;
@property (nonatomic, strong) BTNewCommentsAlertFootView *footView;

@property (nonatomic, strong) CommentDetailFootView *commentAlertView;
@property (nonatomic, strong) BTView *backView;
@property (nonatomic, strong) DiscussModel *headModel;
@property (nonatomic, strong) DiscussModel *replyModel;
@property (nonatomic, assign) BOOL isReplyComment;
@end

@implementation BTNewCommentsAlertViewController
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
     [self registerNsNotification];
    [IQKeyboardManager sharedManager].enable = NO;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.backView];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.commentAlertView];
   
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
    [IQKeyboardManager sharedManager].enable = YES;
    [self.backView removeFromSuperview];
    [self.commentAlertView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if ([self.parameters[@"isSearch"] boolValue]) {
            
            [BTCMInstance popViewController:nil];
        }else {
            
            [BTCMInstance dismissViewController];
        }
    }];
    [self.vcBackView addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"%.0f",_tableView.contentOffset.y);
    if (_tableView.contentOffset.y <= 0) {
        
        self.headBackView.frame = CGRectMake(0, 30-_tableView.contentOffset.y, ScreenWidth, 48);
    }
    if (_tableView.contentOffset.y < -100) {
        
        if ([self.parameters[@"isSearch"] boolValue]) {
            
            [BTCMInstance popViewController:nil];
        }else {
            
            [BTCMInstance dismissViewController];
        }
    }
}




-(void)creatUI {
    self.pageIndex = 1;
    self.isReplyComment = NO;
    self.middeView.backgroundColor = isNightMode ? TableViewCellNightColor : KWhiteColor;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, ScreenWidth, 48) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, ScreenWidth, 48);
    maskLayer.path = maskPath.CGPath;
    self.headBackView.layer.mask = maskLayer;
    
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
        _tableView.mj_footer.backgroundColor = KWhiteColor;
        [self requestList:RefreshStateUp];
    }];
    _tableView.tableFooterView = self.tableViewFV;
    self.tableViewHV.frame = CGRectMake(0, 0, self.headBackView.frame.size.width, 48);
    self.tableViewHV.isSearch = [self.parameters[@"isSearch"] boolValue];
    [self.headBackView addSubview:self.tableViewHV];
    self.footBackViewHeight.constant = iPhoneX?70:50;
    self.footView.frame = CGRectMake(0, 0, self.footBackView.frame.size.width, 50);
    [self.footBackView addSubview:self.footView];
    
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
    self.loadingFootView = [[BTLoadingView alloc] initWithParentView:self.tableViewFV aboveSubView:nil delegate:nil];
    [self loadDatailData];
    [self requestList:RefreshStateNormal];
}
-(void)loadDatailData {
    
    BTGetCommentsDetailRequest *api = [[BTGetCommentsDetailRequest alloc] initWithCommentId:self.parameters[@"commentId"]];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.dataArraytwo removeAllObjects];
        [self.dataArraytwo addObject:[DiscussModel modelWithJSON:request.data]];
        self.headModel = [DiscussModel modelWithJSON:request.data];
        self.footView.model = self.headModel;
        self.footView.isHaveShare = [self.parameters[@"isHaveShare"] boolValue];
        self.footView.shareUrl = self.parameters[@"shareUrl"];
        self.footView.shareTitle = self.parameters[@"shareTitle"];
        self.footView.shareImageURL = self.parameters[@"shareImageURL"];
        [self.tableView reloadData];
        [BTShowLoading hide];
    } failure:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
    }];
}
- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    IndomationDetailCommentListRequest *api = [[IndomationDetailCommentListRequest alloc] initWithRefType:3 refId:self.parameters[@"commentId"] pageIndex:self.pageIndex];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        [BTShowLoading hide];
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
            NSInteger juli = ScreenHeight-114*(self.dataArray.count+1)-30-50-48;
            self.tableViewFV.frame = CGRectMake(0, 0, ScreenWidth, juli > 0 ? juli : 0);
            
        }else {
            self.tableViewFV.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-114-30-48-50);
        }
    
        self.tableViewHV.number = [[request.responseJSONObject objectForKey:@"totalResults"] integerValue];
        [self.tableView reloadData];
    
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [BTShowLoading hide];
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
    
    return section == 0 ? 0 : (self.dataArray.count > 0 ? 50 : 0);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? [[UIView alloc] init] : (self.dataArray.count > 0 ? self.TwoSetionView : [[UIView alloc] init]);
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
            
            //评论相关的操作的通知（回复，点赞，删除）
            //KPostNotification(KNotificationCommentsOperation, nil)
            if (ws.returnParamsBlock) {
                ws.returnParamsBlock(nil);
            }
            if (indexPath.section == 0) {
                
                [ws loadDatailData];
            }else {
                model.liked = !model.liked;
                model.likeCount = model.liked ? model.likeCount + 1 : model.likeCount - 1;
                [ws.tableView reloadData];
                [BTShowLoading hide];
            }
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
            //评论相关的操作的通知（回复，点赞，删除）
            //KPostNotification(KNotificationCommentsOperation, nil)
            if (ws.returnParamsBlock) {
                ws.returnParamsBlock(nil);
            }
            if (indexPath.section == 0) {
                
                [BTCMInstance dismissViewController];
            }else {
                [ws requestList:RefreshStatePull];
            }
            
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    };
    
    DiscussModel *model = indexPath.section == 0 ? self.dataArraytwo[indexPath.row] : self.dataArray[indexPath.row];
    cell.lookAllBlock = ^(NSInteger index,BOOL isAddLine) {
        model.isAddOneLine     = isAddLine;
        model.IsOrNoLookDetail = !model.IsOrNoLookDetail;
        [indexPath.section == 0 ? self.dataArraytwo : self.dataArray replaceObjectAtIndex:index withObject:model];
        [ws.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    cell.isCommentsNumber = (indexPath.section == 0);
    [cell configWithDiscussModel:model];
    return cell;
}
#pragma mark BTNewSameCommentsCellDelegate
-(void)BTNewSameCommentsCellCopyLableWithDiscussModel:(DiscussModel *)model {
    
    NSLog(@"===============弹出键盘=============");
    if (![getUserCenter isLogined]) {
        
        [getUserCenter loginoutPullView];
        return;
    }
    self.replyModel     = model;
    if (!ISStringEqualToString(self.replyModel.commentId, self.headModel.commentId)) {
        self.commentAlertView.placeL.hidden = self.commentAlertView.textV.text.length > 0;
        self.commentAlertView.placeL.text = [NSString stringWithFormat:@"  %@ %@：",[APPLanguageService wyhSearchContentWith:@"huifu"],self.replyModel.userName];
        self.commentAlertView.replayContent = [NSString stringWithFormat:@"  %@ %@：",[APPLanguageService wyhSearchContentWith:@"huifu"],self.replyModel.userName];
        [self.footView.textField becomeFirstResponder];
        self.backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.isReplyComment = YES;
    }
}


//-(void)textViewDidChange:(UITextView *)textView {
//    
//    self.commentAlertView.placeL.hidden = self.commentAlertView.textV.text.length > 0;
//    [self.commentAlertView.fasongBtn setTitleColor:self.commentAlertView.textV.text.length > 0 ? MainBg_Color : CFontColor11 forState:UIControlStateNormal];
//    static CGFloat maxHeight = 73.0f;
//    
//    CGRect frame = textView.frame;
//    
//    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
//    
//    CGSize size = [textView sizeThatFits:constraintSize];
//    
//    NSLog(@"前======%.0f %.0f",size.height,frame.size.height);
//    if (size.height >= maxHeight) {
//        
//        size.height = maxHeight;
//        textView.scrollEnabled = YES;  // 允许滚动
//        
//    }else{
//        
//        textView.scrollEnabled = YES;    // 不允许滚动
//    }
//    NSLog(@"后======%.0f %.0f",size.height,frame.size.height);
//    self.commentAlertView.textV.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
//    self.commentAlertView.frame = CGRectMake(0, ScreenHeight-_keyboardHeight-50-(size.height-35), ScreenWidth, 15+size.height);
//    
//    if (textView == self.commentAlertView.textV) {
//        
//        if ([self.commentAlertView.textV.text length] > CommentsMaxLength) {
//            self.commentAlertView.textV.text = [self.commentAlertView.textV.text substringWithRange:NSMakeRange(0, CommentsMaxLength)];
//            [self.commentAlertView.textV.undoManager removeAllActions];
//            [self.commentAlertView.textV becomeFirstResponder];
//            return;
//        }
//    }
//}

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
-(BTNewCommentsAlertHeadView *)tableViewHV {
    
    if (!_tableViewHV) {
        
        _tableViewHV = [BTNewCommentsAlertHeadView loadFromXib];
        _tableViewHV.frame = CGRectMake(0, 0, ScreenWidth, 48);
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
            [BTShowLoading show];
            LikeRequest *request = [[LikeRequest alloc] initWithLikeRefId:model.commentId likeRefType:1 likeStatus:likeStatus likedUserId:model.userId];
            [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
                
                //评论相关的操作的通知（回复，点赞，删除）
                //KPostNotification(KNotificationCommentsOperation, nil)
                if (ws.returnParamsBlock) {
                    ws.returnParamsBlock(nil);
                }
                [ws loadDatailData];
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
    self.commentAlertView.replayContent = [APPLanguageService sjhSearchContentWith:@"fatieplaceholder"];
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
        
        //评论相关的操作的通知（回复，点赞，删除）
        //KPostNotification(KNotificationCommentsOperation, nil)
        if (self.returnParamsBlock) {
            self.returnParamsBlock(nil);
        }
        self.commentAlertView.textV.text = nil;
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
        self.commentAlertView.fasongBtn.enabled = YES;
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"huifuchenggong"] wait:YES];
        [getUserCenter shareSuccseGetTanLiWithType:6 withTime:2];
        [self SlidingToTop];
        [self.commentAlertView.textV resignFirstResponder];
    } failure:^(__kindof BTBaseRequest *request) {
        self.commentAlertView.fasongBtn.enabled = YES;
    }];
}
//滚动指定位置
-(void)SlidingToTop {
    //滚动指定位置
    if (self.dataArray.count > 0) {
        NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:1];
        [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
