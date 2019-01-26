//
//  BTPostDetailViewController.m
//  BT
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPostDetailViewController.h"
#import "BTNewSameCommentsCell.h"

#import "DiscussModel.h"
#import "InputAccessoryView.h"
#import "BTConfig.h"
#import "InformationModuleRequest.h"
#import "IndomationDetailCommentListRequest.h"
#import "CommentInfomationRequest.h"
#import "LikeRequest.h"

#import "BTNewSetionHeadView.h"
#import "CommentDetailFootView.h"

#import "BTPostDetailRequest.h"
#import "BTPostMainListModel.h"
#import "BTPostDetailHeadView.h"
#import "InfomationCollectionRequest.h"
#import "BTDeletePostAlertView.h"
#import "BTDeletPostRequest.h"
#import "BTPostDetailNoCommentsView.h"
#import "BTFocusUserRequest.h"
#import "BTFocusCancelReq.h"
static NSString *const identifier = @"BTNewSameCommentsCell";
@interface BTPostDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate,BTNewSameCommentsCellDelegate,UITextViewDelegate,BTPostDetailHeadViewDelegate,UIGestureRecognizerDelegate>{
    
    HYShareActivityView *_shareView;
    CGFloat              _keyboardHeight;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet BTTextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewFootZan;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewFootShare;

@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) BTPostDetailHeadView *headView;
@property (nonatomic,strong) NSString *postId;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *shareUrl;
@property (nonatomic,strong) NSString *shareImageURL;
@property (nonatomic,strong) NSString *shareTitle;
@property (nonatomic,strong) BTPostMainListModel *detalObj;
@property (nonatomic,strong) UIView *blackBackView;

@property (nonatomic, strong) BTNewSetionHeadView *TwoSetionView;
@property (nonatomic, strong) CommentDetailFootView *commentAlertView;
@property (nonatomic, strong) BTPostDetailNoCommentsView *noCommentsView;
@property (nonatomic, assign) BOOL isFirstEnter;
@property (nonatomic,assign)BOOL firstFollowed;//第一次关注后显示取消关注按钮
@property (nonatomic, strong) LikeRequest *likeApi;
@end

@implementation BTPostDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
     [self registerNsNotification];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.blackBackView];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.commentAlertView];
    
    if (!ISNSStringValid([BTConfig sharedInstance].Post_h5domain)) {
        [[BTConfigureService shareInstanceService] getGlobal_HTML_configuration];
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    self.isFirstEnter = NO;
    [IQKeyboardManager sharedManager].enable = YES;
    [self.blackBackView removeFromSuperview];
    [self.commentAlertView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageViewFootShare.image = IMAGE_NAMED(@"文章分享");
    self.isFirstEnter = YES;
    [self creatUI];
    // Do any additional setup after loading the view from its nib.
    
    //
    UISwipeGestureRecognizer *swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(slide)];
    swiperight.delegate = self;
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
}

- (void)creatUI {
    
    if (iPhoneX) {
        
        self.bottomConstraint.constant = 34;
    }
    self.postId  = self.parameters[@"postId"];
    ViewRadius(self.textField, 35/2);
    //self.title = [APPLanguageService wyhSearchContentWith:@"tieziquanwen"];
    self.pageIndex = 1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTNewSameCommentsCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = CViewBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self loadDetailData];
        [self requestList:RefreshStatePull];
    }];
    
    _tableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        self.pageIndex++;
        [self requestList:RefreshStateUp];
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:self.tableView delegate:self];
    [self loadDetailData];
    [self requestList:RefreshStateNormal];
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
    [MobClick event:@"post_detail_comment"];
    //获取键盘的高度
    NSLog(@"当键盘出现");
    [self.commentAlertView.textV becomeFirstResponder];
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    _keyboardHeight = height;
    self.blackBackView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.commentAlertView.frame = CGRectMake(0, ScreenHeight-height-50, ScreenWidth, 50);
    
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    
    NSLog(@"当键退出");
    self.blackBackView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    self.commentAlertView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 50);
    
}
#pragma mark UITextViewDelegeta
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

-(void)loadDetailData {
    
    BTPostDetailRequest *api = [[BTPostDetailRequest alloc] initWithDetailID:self.postId];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
//        [BTShowLoading hide];
        self.detalObj = [BTPostMainListModel objectWithDictionary:request.data];
        self.detalObj.whereVC = @"帖子详情";
        self.detalObj.postId = [request.data[@"id"] integerValue];
        
        self.detalObj.firstFollowed = self.firstFollowed;
        
        if ([request.data[@"user"] isKindOfClass:[NSDictionary class]] && request.data[@"user"] != NULL) {//用户信息
            NSDictionary *userDict = request.data[@"user"];
            self.detalObj.avatar           = SAFESTRING(userDict[@"avatar"]);
            self.detalObj.nickName         = SAFESTRING(userDict[@"nickName"]);
            self.detalObj.userId           = [userDict[@"userId"] integerValue];
            self.detalObj.authStatus       = [userDict[@"authStatus"] integerValue];
            self.detalObj.authType         = [userDict[@"authType"] integerValue];
        }
        if ([request.data[@"sourcePost"] isKindOfClass:[NSDictionary class]] && request.data[@"sourcePost"] != NULL) {//被转发的来源信息
            NSDictionary *sourcePostDict = request.data[@"sourcePost"];
            self.detalObj.sourcePostModel = [BTPostMainListModel objectWithDictionary:sourcePostDict];
            self.detalObj.sourcePostModel.postId = [sourcePostDict[@"id"] integerValue];
            if ([sourcePostDict[@"user"] isKindOfClass:[NSDictionary class]] && sourcePostDict[@"user"] != NULL) {//用户信息
                NSDictionary *sourcePostUserDict = sourcePostDict[@"user"];
                self.detalObj.sourcePostModel.avatar           = SAFESTRING(sourcePostUserDict[@"avatar"]);
                self.detalObj.sourcePostModel.nickName         = SAFESTRING(sourcePostUserDict[@"nickName"]);
                self.detalObj.sourcePostModel.userId           = [sourcePostUserDict[@"userId"] integerValue];
                self.detalObj.sourcePostModel.followed         = [sourcePostUserDict[@"followed"] boolValue];
                self.detalObj.sourcePostModel.authStatus       = [sourcePostUserDict[@"authStatus"] integerValue];
                self.detalObj.sourcePostModel.authType         = [sourcePostUserDict[@"authType"] integerValue];
            }
        }
        [self scrollViewDidEndDecelerating:self.tableView];
        [self creatHeadView];
    } failure:^(__kindof BTBaseRequest *request) {
//        [BTShowLoading hide];
        [self.loadingView hiddenLoading];
        self.noCommentsView.label.text = request.resultMsg;
        self.noCommentsView.imageView.image = IMAGE_NAMED(@"空白-帖子／文章已删除");
    }];
    
}

- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    IndomationDetailCommentListRequest *api = [[IndomationDetailCommentListRequest alloc] initWithRefType:6 refId:self.postId pageIndex:self.pageIndex];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        [BTShowLoading hide];
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            
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
            [self.dataArray addObject:model];
        }
        NSInteger totalResults = [[request.responseObject objectForKey:@"totalResults"] integerValue];

        self.TwoSetionView.labelNumber.text = totalResults > 0 ? [NSString stringWithFormat:@"(%ld)  ",totalResults] : @"";
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        //第一次进入无评论 自动弹出评论框
        if ([self.parameters[@"whereVC"] isEqualToString:@"评论"] && self.dataArray.count <= 0) {
            if (self.isFirstEnter) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                    
                    [self.textField becomeFirstResponder];
                    self.isFirstEnter = NO;
                });
            }
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.loadingView hiddenLoading];
        self.noCommentsView.label.text = request.resultMsg;
        self.noCommentsView.imageView.image = IMAGE_NAMED(@"空白-帖子／文章已删除");
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
   
    //self.photoV = @"头像加v";
    self.authStatus = _detalObj.authStatus;
    self.authType   = _detalObj.authType;
    CGFloat y = scrollView.contentOffset.y;
    _detalObj.avatar = SAFESTRING(_detalObj.avatar);
    if (y > 64) {
        
        if (!_detalObj.followed && (_detalObj.userId != getUserCenter.userInfo.userId)) {//没关注 自己的帖子不能关注
            [self addNavigationItemWithImageNames:@[@"back",ISNSStringValid(_detalObj.avatar) ? [_detalObj.avatar hasPrefix:@"http"]?_detalObj.avatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,_detalObj.avatar] : @"morentouxiang",(kIszh_hans?@"ic_guanzhutou":@"ic_guanzhutou_en")] isLeft:YES target:self action:@selector(rightNaviBtnSClick:) tags:@[@"2000",@"2001",@"2002"]];
            
        }else {
            if (self.firstFollowed) {
              
                [self addNavigationItemWithImageNames:@[@"back",ISNSStringValid(_detalObj.avatar) ? [_detalObj.avatar hasPrefix:@"http"]?_detalObj.avatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,_detalObj.avatar] : @"morentouxiang",(kIszh_hans?@"ic_quxiaoguanzhutou":@"ic_quxiaoguanzhutou_en")] isLeft:YES target:self action:@selector(rightNaviBtnSClick:) tags:@[@"2000",@"2001",@"2002"]];
                
            }else {
                [self addNavigationItemWithImageNames:@[@"back",ISNSStringValid(_detalObj.avatar) ? [_detalObj.avatar hasPrefix:@"http"]?_detalObj.avatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,_detalObj.avatar] : @"morentouxiang"] isLeft:YES target:self action:@selector(rightNaviBtnSClick:) tags:@[@"2000",@"2001"]];
            }
        }
    }else {
        
        [self addNavigationItemWithImageNames:@[@"back"] isLeft:YES target:self action:@selector(rightNaviBtnSClick:) tags:@[@"2000"]];
    }
}
//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//
//    CGFloat y = scrollView.contentOffset.y;
//
//    if (y > 64) {
//
//        if (!_detalObj.followed && (_detalObj.userId != getUserCenter.userInfo.userId)) {//没关注 自己的帖子不能关注
//            [self addNavigationItemWithImageNames:@[@"back",ISNSStringValid(_detalObj.avatar) ? [_detalObj.avatar hasPrefix:@"http"]?_detalObj.avatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,_detalObj.avatar] : @"morentouxiang",@"ic_guanzhutou"] isLeft:YES target:self action:@selector(rightNaviBtnSClick:) tags:@[@"2000",@"2001",@"2002"]];
//        }else {
//
//            [self addNavigationItemWithImageNames:@[@"back",ISNSStringValid(_detalObj.avatar) ? [_detalObj.avatar hasPrefix:@"http"]?_detalObj.avatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,_detalObj.avatar] : @"morentouxiang"] isLeft:YES target:self action:@selector(rightNaviBtnSClick:) tags:@[@"2000",@"2001"]];
//        }
//    }else {
//
//        [self addNavigationItemWithImageNames:@[@"back"] isLeft:YES target:self action:@selector(rightNaviBtnSClick:) tags:@[@"2000"]];
//    }
//}
-(void)creatHeadView {
    
    NSString *collectionStr;
    if (_detalObj.favor) {
        collectionStr = @"文章已收藏";
    }else {
        
        collectionStr = @"文章收藏";
    }
    if (_detalObj.userId == getUserCenter.userInfo.userId) {
        
        [self addNavigationItemWithImageNames:@[collectionStr ,@"我的帖子-帖子删除"] isLeft:NO target:self action:@selector(leftNaviBtnSClick:) tags:@[@"1000",@"1001"]];
    }else {
        
        [self addNavigationItemWithImageNames:@[collectionStr] isLeft:NO target:self action:@selector(leftNaviBtnSClick:) tags:@[@"1000"]];
    }
    if (_detalObj.liked) {
        self.imageViewFootZan.image = IMAGE_NAMED(@"我的帖子-评论点赞-2");
    }else {
        
        self.imageViewFootZan.image = IMAGE_NAMED(@"我的帖子-评论点赞-1");
    }
    if (ISNSStringValid(_detalObj.content)) {

        [getUserCenter sharePostContentWithTitle:_detalObj.content completion:^(NSString *content) {
            
            self.shareTitle = content;
        }];
    }
    
    if ([_detalObj.images isKindOfClass:[NSArray class]]) {
        
        NSString *imageUrl = _detalObj.images[0];
        if ([imageUrl hasPrefix:@"http"]) {
            
            self.shareImageURL = [NSString stringWithFormat:@"%@",imageUrl];
        } else {
            
            self.shareImageURL = [NSString stringWithFormat:@"%@%@",PhotoImageURL,imageUrl];
        }
    }
    self.shareUrl = [NSString stringWithFormat:@"%@%@?id=%@",[BTConfig sharedInstance].Post_h5domain,POSTSHARE_H5,self.postId];
   
    [self.headView configWithDiscussModel:self.detalObj];
    self.headView.model = self.detalObj;
    self.headView.frame = CGRectMake(0, 0, ScreenWidth, [self.headView getHeadViewHeight]);
    WS(ws);
    //点赞
    self.headView.likeBlock = ^(BTPostMainListModel *model) {
        
        [MobClick event:@"post_detail_zan"];
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
//        [BTShowLoading show];
        if(ws.likeApi.isExecuting){
            [ws.likeApi stop];
        }
        ws.likeApi = [[LikeRequest alloc] initWithLikeRefId:[NSString stringWithFormat:@"%ld",model.postId] likeRefType:4 likeStatus:likeStatus likedUserId:model.userId];
        [ws.likeApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            if (ws.returnParamsBlock) {
                ws.returnParamsBlock(nil);
            }
            ws.detalObj.liked = !ws.detalObj.liked;
            ws.detalObj.likeNum = ws.detalObj.liked ? ws.detalObj.likeNum + 1 : ws.detalObj.likeNum - 1;
            [ws creatHeadView];
        } failure:^(__kindof BTBaseRequest *request) {
//            [BTShowLoading hide];
        }];
    };
    //转发
    self.headView.forwardingBlock = ^(BTPostMainListModel *model) {
        [ws sharePost];
    };
    //关注
    self.headView.focusBlock = ^(BTPostMainListModel *model) {
        
        [ws foucesPost];
    };
    self.tableView.tableHeaderView = self.headView;
}

#pragma mark 头部高度 （解决imageview未加载完成高度计算不准确问题）
-(void)BTPostDetailHeadViewHeight:(CGFloat)height {
    
    self.headView.frame = CGRectMake(0, 0, ScreenWidth, height);
    self.tableView.tableHeaderView = self.headView;
}

-(void)leftNaviBtnSClick:(UIButton *)btn {
    
    if (btn.tag == 1000) {//收藏
        [MobClick event:@"post_detail_collection"];
        [self shouCangBtnClick];
        
    }else {//删除
        [MobClick event:@"post_detail_del"];
        [self deletPostBtn];
    }
}
-(void)rightNaviBtnSClick:(UIButton *)btn {
    
    if (btn.tag == 2000) {//返回
        [BTCMInstance popViewController:nil];
    }
    if (btn.tag == 2001) {//进个人主页
        [BTCMInstance pushViewControllerWithName:@"BTPersonViewController" andParams:@{@"userId":@(_detalObj.userId),@"userName":SAFESTRING(_detalObj.nickName)}];
    }
    if (btn.tag == 2002) {//关注
        [self foucesPost];
    }
}
//底部视图点赞
- (IBAction)footViewZanBtnClick:(UIButton *)sender {
    [MobClick event:@"post_detail_zan"];
    if (getUserCenter.userInfo.token.length == 0) {
        [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil animated:YES];
        return ;
    }
    NSInteger likeStatus;
    if (!_detalObj.liked) {
        likeStatus = 1;
    }else{
        likeStatus = 2;
    }
    //[BTShowLoading show];
    LikeRequest *request = [[LikeRequest alloc] initWithLikeRefId:[NSString stringWithFormat:@"%ld",_detalObj.postId] likeRefType:4 likeStatus:likeStatus likedUserId:_detalObj.userId];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (self.returnParamsBlock) {
            self.returnParamsBlock(nil);
        }
        self.detalObj.liked = !self.detalObj.liked;
        self.detalObj.likeNum = self.detalObj.liked ? self.detalObj.likeNum + 1 : self.detalObj.likeNum - 1;
        [self creatHeadView];
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
//底部视图转发
- (IBAction)footViewZFBtnClick:(UIButton *)sender {
    
    [self sharePost];
}
//打赏
- (IBAction)dashangBtnClick:(UIButton *)sender {
    [MobClick event:@"post_detail_dashang"];
    [getUserCenter ExceptionalAuthorsWithID:self.detalObj.postId andType:2];
}

- (void)scrollToTop:(BOOL)animated {
    [self.tableView setContentOffset:CGPointMake(0,0) animated:animated];
}
#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    [self loadDetailData];
    [self requestList:RefreshStateNormal];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return self.dataArray.count > 0 ? 50 : VIEW_H(self.tableView);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.dataArray.count > 0 ? self.TwoSetionView : self.noCommentsView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DiscussModel *model = self.dataArray[indexPath.row];
    return [BTNewSameCommentsCell cellHeightWithDiscussModel:model];
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
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
        //[BTShowLoading show];
        if(ws.likeApi.isExecuting){
            [ws.likeApi stop];
        }
        ws.likeApi = [[LikeRequest alloc] initWithLikeRefId:model.commentId likeRefType:1 likeStatus:likeStatus likedUserId:model.userId];
        [ws.likeApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
//            if (ws.returnParamsBlock) {
//                ws.returnParamsBlock(nil);
//            }
            model.liked = !model.liked;
            model.likeCount = model.liked ? model.likeCount + 1 : model.likeCount - 1;
            [ws.tableView reloadData];
            //[BTShowLoading hide];
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
            
            if (ws.returnParamsBlock) {
                ws.returnParamsBlock(nil);
            }
            [ws loadDetailData];
            [ws requestList:RefreshStatePull];
            
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    };
    
    DiscussModel *model = self.dataArray[indexPath.row];
    
    cell.lookAllBlock = ^(NSInteger index, BOOL isAddLine) {
        
        model.IsOrNoLookDetail = !model.IsOrNoLookDetail;
        model.isAddOneLine     = isAddLine;
        [ws.dataArray replaceObjectAtIndex:index withObject:model];
        [ws.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    
    [cell configWithDiscussModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DiscussModel *model = self.dataArray[indexPath.row];
    [BTCMInstance presentViewControllerWithName:@"BTNewCommentsAlert" andParams:@{@"commentId":model.commentId,@"shareUrl":self.shareUrl,@"shareImageURL":self.shareImageURL,@"shareTitle":self.shareTitle} animated:YES ompletion:^(id obj) {
        
        NSLog(@"adada");
        self.pageIndex = 1;
        [self loadDetailData];
        [self requestList:RefreshStatePull];
    }];
}
#pragma mark BTNewSameCommentsCellDelegate
-(void)BTNewSameCommentsCellCopyLableWithDiscussModel:(DiscussModel *)model {
    
    [BTCMInstance presentViewControllerWithName:@"BTNewCommentsAlert" andParams:@{@"commentId":model.commentId,@"shareUrl":self.shareUrl,@"shareImageURL":self.shareImageURL,@"shareTitle":self.shareTitle} animated:YES ompletion:^(id obj) {
        
        NSLog(@"adada");
        self.pageIndex = 1;
        [self loadDetailData];
        [self requestList:RefreshStatePull];
    }];
}
//收藏(必须在登录的情况下才可以收藏)
-(void)shouCangBtnClick {
    
    if ([getUserCenter isLogined]) {
        
        InfomationCollectionRequest *api = [[InfomationCollectionRequest alloc] initWithRefType:30 refId:self.postId favor:!_detalObj.favor];
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            if (self.returnParamsBlock) {
                self.returnParamsBlock(nil);
            }
            [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:_detalObj.favor ? @"quxiaoshoucangchenggong" : @"shoucangchenggong"] wait:YES];
            [self loadDetailData];
            
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
        
    }else {
        
        
        [getUserCenter loginoutPullView];
    }
    
}
- (void)deletPostBtn {
    WS(ws);
    [BTDeletePostAlertView showWithRecordModel:self.detalObj completion:^(BTPostMainListModel *model) {
        
        NSLog(@"========到时候加删除帖子接口=============");
        BTDeletPostRequest *api = [[BTDeletPostRequest alloc] initWithCommentId:model.postId];
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            [MBProgressHUD showMessageIsWait:[APPLanguageService sjhSearchContentWith:@"deleteSuccess"] wait:YES];
            
            if (ws.returnParamsBlock) {
                ws.returnParamsBlock(nil);
            }
            [BTCMInstance popViewController:nil];
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    }];
}
#pragma mark 分享
- (void)sharePost{
    [MobClick event:@"post_detail_zhuanfa"];
    //分享
    if ( _shareView == nil ){
        
        _shareView = [[HYShareActivityView alloc] initWithButtons:@[@(HYSharePlatformTypeToMain),@(HYSharePlatformTypeWechatSession),@(HYSharePlatformTypeWechatTimeline),@(HYSharePlatformTypeSinaWeibo)] title:@"帖子" shareTypeBlock:^(HYSharePlatformType type) {
            [self shareActiveType:type];
        }];
        [_shareView show];
    }else
    {
        [_shareView show];
    }
}
-(void)shareActiveType:(NSUInteger)type {
    
    if (type == 6) {//转发
        [_shareView hide];
        if ([getUserCenter isLogined]) {
            
            if (_detalObj.type != 3) {//原创
                
              [BTCMInstance presentViewControllerWithName:@"BTTransmitPostVCViewController" andParams:@{@"model":_detalObj} animated:YES ompletion:nil];
            }else {
                
                if (_detalObj.sourcePostModel == nil) {
                    
                    [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"bunengzhuanfa"] wait:YES];
                }else {
                    
                    [BTCMInstance presentViewControllerWithName:@"BTTransmitPostVCViewController" andParams:@{@"model":_detalObj} animated:YES ompletion:nil];
                }
                
            }
            
        }else {
            
            [getUserCenter loginoutPullView];
        }
        return;
    }
//    if (type == 2) {//微博
//        if ([WeiboSDK isWeiboAppInstalled] )
//        {
//            [getUserCenter shareSuccseGetTanLiWithType:3 withTime:2];
//        }
//    }else {//微信
//
//        if ([WXApi isWXAppInstalled] )
//        {
//            [getUserCenter shareSuccseGetTanLiWithType:3 withTime:2];
//        }
//    }
    [getUserCenter shareBuriedPointWithType:type withWhereVc:10];
    HYShareInfo *shareInfo = [[HYShareInfo alloc] init];
    shareInfo.title = self.shareTitle;
    shareInfo.content = self.shareTitle;
    shareInfo.url = self.shareUrl;
    shareInfo.image = self.shareImageURL;
    shareInfo.type = (HYPlatformType)type;
    shareInfo.shareType = HYShareDKContentTypeWebPage;
    [HYShareKit shareInfoWith:shareInfo completion:^(NSString *errorMsg)
     {
         if ( ISNSStringValid(errorMsg) )
         {
             
             [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
             [getUserCenter shareSuccseGetTanLiWithType:3 withTime:2];
         }
         [_shareView hide];
     }];
    
    
}
//关注帖子
-(void)foucesPost {
    if (![getUserCenter isLogined]) {
        [getUserCenter loginoutPullView];
        return;
    }
    [MobClick event:@"post_detail_guanzhuuser"];
    //[BTShowLoading show];
    WS(ws);
    BTBaseRequest *api;
    NSString      *message;
    if (!self.detalObj.followed) {
        api = [[BTFocusUserRequest alloc] initWithRefId:self.detalObj.userId];
        message = [APPLanguageService wyhSearchContentWith:@"guanzhuchenggong"];
    }else {
        message = [APPLanguageService wyhSearchContentWith:@"quxiaoguanzhuchenggong"];
        api = [[BTFocusCancelReq alloc] initWithRefId:self.detalObj.userId];
    }
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [MBProgressHUD showMessageIsWait:message wait:YES];
        ws.firstFollowed = YES;
        //[ws loadDetailData];
        ws.detalObj.firstFollowed = ws.firstFollowed;
        ws.detalObj.followed = !ws.detalObj.followed;
        [ws scrollViewDidEndDecelerating:ws.tableView];
        [ws creatHeadView];
    } failure:^(__kindof BTBaseRequest *request) {
        
        [BTShowLoading hide];
    }];
}
#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(BTNewSetionHeadView *)TwoSetionView {
    
    if (!_TwoSetionView) {
        _TwoSetionView = [BTNewSetionHeadView loadFromXib];
        _TwoSetionView.frame = CGRectMake(0, 0, ScreenWidth, 50);
    }
    return _TwoSetionView;
}
-(BTPostDetailNoCommentsView *)noCommentsView {
    
    if (!_noCommentsView) {
        _noCommentsView = [BTPostDetailNoCommentsView loadFromXib];
        _noCommentsView.frame = CGRectMake(0, 0, ScreenWidth, 500);
    }
    return _noCommentsView;
}
-(BTPostDetailHeadView *)headView {
    
    if (!_headView) {
        
        _headView = [BTPostDetailHeadView loadFromXib];
        _headView.delegate = self;
    }
    return _headView;
}
- (UIView *)blackBackView {
    if (!_blackBackView) {
        _blackBackView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
        _blackBackView.backgroundColor = [UIColor blackColor];
        _blackBackView.alpha = 0.5;
        _blackBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_blackBackView addGestureRecognizer:tap];
    }
    return _blackBackView;
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
//发表评论
-(void)fasongBtnClick {
    
    if (!ISNSStringValid(self.commentAlertView.textV.text)) {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"shurupinglunneirong"] wait:YES];
        return;
    }
    if (![getUserCenter isLogined]) {
        [getUserCenter loginoutPullView];
        return;
    }
    self.commentAlertView.fasongBtn.enabled = NO;
    CommentInfomationRequest *api = [[CommentInfomationRequest alloc] initWithRefType:6 refId:self.postId content:self.commentAlertView.textV.text refUserId:self.detalObj.userId];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if (self.returnParamsBlock) {
            self.returnParamsBlock(nil);
        }
        [self SlidingToTop];
      
        self.commentAlertView.textV.text = nil;
        self.pageIndex = 1;
        [self loadDetailData];
        [self requestList:RefreshStatePull];
        self.commentAlertView.fasongBtn.enabled = YES;
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"pinglunchenggong"] wait:YES];
        [getUserCenter shareSuccseGetTanLiWithType:6 withTime:2];
        [self.commentAlertView.textV resignFirstResponder];
    } failure:^(__kindof BTBaseRequest *request) {
        self.commentAlertView.fasongBtn.enabled = YES;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//自选侧滑
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
        
    }
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)slide{
    [BTCMInstance popViewController:nil];
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
