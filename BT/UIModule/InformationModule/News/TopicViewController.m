//
//  TopicViewController.m
//  BT
//
//  Created by admin on 2018/4/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TopicViewController.h"
#import "BTNewSameCommentsCell.h"
#import "FastInfomationObj.h"
#import "TopicDetailHeadView.h"
#import "DiscussModel.h"
#import "InputAccessoryView.h"
#import "BTConfig.h"
#import "THFZXAndBKObj.h"
#import "InformationModuleRequest.h"
#import "InfomationDetailRequest.h"
#import "HotCommentRequest.h"
#import "IndomationDetailCommentListRequest.h"
#import "CommentInfomationRequest.h"
#import "LikeRequest.h"

#import "BTNewSetionHeadView.h"
#import "CommentDetailFootView.h"
static NSString *const identifier = @"BTNewSameCommentsCell";
@interface TopicViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate,BTNewSameCommentsCellDelegate,UITextViewDelegate,UIGestureRecognizerDelegate>{
    
     HYShareActivityView *_shareView;
     CGFloat              _keyboardHeight;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


@property (weak, nonatomic) IBOutlet BTTextField *textField;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) TopicDetailHeadView *headView;
@property (nonatomic,strong) NSString *urlID;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *shareUrl;
@property (nonatomic,strong) NSString *shareImageURL;
@property (nonatomic,strong) NSString *shareTitle;
@property (nonatomic,strong) THFZXAndBKObj *detalObj;
@property (nonatomic,strong) UIView *blackBackView;

@property (nonatomic, strong) BTNewSetionHeadView *TwoSetionView;
@property (nonatomic, strong) CommentDetailFootView *commentAlertView;
@end

@implementation TopicViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [self registerNsNotification];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.blackBackView];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.commentAlertView];
    if (!ISNSStringValid([BTConfig sharedInstance].h5domain)) {
        [[BTConfigureService shareInstanceService] getGlobal_HTML_configuration];
    }
    
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [self.blackBackView removeFromSuperview];
    [self.commentAlertView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self addNavigationItemViewWithImageNames:@"commentsshare" isLeft:NO target:self action:@selector(naviBtnClick:) tag:3000];
    // Do any additional setup after loading the view from its nib.
    UISwipeGestureRecognizer *swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(slide)];
    swiperight.delegate = self;
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
}
+ (id)createWithParams:(NSDictionary *)params{
    TopicViewController *vc = [[TopicViewController alloc] init];
    vc.urlID = [params objectForKey:@"refId"];
    NSLog(@"%@",vc.urlID);
    return vc;
}
- (void)creatUI {
    
    if (iPhoneX) {
        
        self.bottomConstraint.constant = 34;
    }
    ViewRadius(self.textField, 35/2);
    self.title = [APPLanguageService wyhSearchContentWith:@"huatixiangqing"];
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
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
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
    
    InfomationDetailRequest *api = [[InfomationDetailRequest alloc] initWithDetailID:self.urlID];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        self.detalObj = [THFZXAndBKObj objectWithDictionary:request.data];
        self.detalObj.hotRecommend = [request.data[@"hotRecommend"] boolValue];
        NSString *str =  [getUserCenter getImageURLSizeWithWeight:ScreenWidth*2 andHeight:196*2];
        self.detalObj.imgUrl = SAFESTRING(self.detalObj.imgUrl);
        self.detalObj.imgUrl = [NSString stringWithFormat:@"%@?%@",[self.detalObj.imgUrl hasPrefix:@"http"]?self.detalObj.imgUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,self.detalObj.imgUrl],str];
        [self creatHeadView];
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
    
}

- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    IndomationDetailCommentListRequest *api = [[IndomationDetailCommentListRequest alloc] initWithRefType:1 refId:self.urlID pageIndex:self.pageIndex];
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
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
-(void)creatHeadView {
    
    if (ISNSStringValid(_detalObj.title)) {
        
        self.shareTitle = _detalObj.title;
    }
    
    if (ISNSStringValid(_detalObj.imgUrl)) {
        
        
        if ([_detalObj.imgUrl hasPrefix:@"http"]) {
            
            self.shareImageURL = [NSString stringWithFormat:@"%@",_detalObj.imgUrl];
        } else {
            
            self.shareImageURL = [NSString stringWithFormat:@"%@%@",PhotoImageURL,_detalObj.imgUrl];
        }
    }
    self.shareUrl = [NSString stringWithFormat:@"%@%@/%@",[BTConfig sharedInstance].h5domain,TOPICURL_H5,self.urlID];
    NSData *data = [self.detalObj modelToJSONData];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    self.headView.dict = dic;
    self.headView.frame = CGRectMake(0, 0, ScreenWidth, 291+[self.headView getHeadViewHeight]);
    WS(ws);
    self.headView.dOuBlack = ^{
        
        ws.headView.frame = CGRectMake(0, 0, ScreenWidth, 291+[ws.headView getHeadViewHeight]);
        ws.tableView.tableHeaderView = ws.headView;
        [ws scrollToTop:YES];
    };
    self.tableView.tableHeaderView = self.headView;
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
    
    return self.dataArray.count > 0 ? 50 : 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return self.dataArray.count > 0 ? self.TwoSetionView : [UIView new];
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
        [BTShowLoading show];
        LikeRequest *request = [[LikeRequest alloc] initWithLikeRefId:model.commentId likeRefType:1 likeStatus:likeStatus likedUserId:model.userId];
        [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            model.liked = !model.liked;
            model.likeCount = model.liked ? model.likeCount + 1 : model.likeCount - 1;
            [ws.tableView reloadData];
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
//    DiscussModel *model = self.dataArray[indexPath.row];
//    [BTCMInstance presentViewControllerWithName:@"BTNewCommentsAlert" andParams:@{@"commentId":model.commentId,@"shareUrl":self.shareUrl,@"shareImageURL":self.shareImageURL,@"shareTitle":self.shareTitle} animated:YES];
}
#pragma mark BTNewSameCommentsCellDelegate
-(void)BTNewSameCommentsCellCopyLableWithDiscussModel:(DiscussModel *)model {
    
    NSLog(@"===============弹出键盘=============");
    [BTCMInstance presentViewControllerWithName:@"BTNewCommentsAlert" andParams:@{@"commentId":model.commentId,@"shareUrl":self.shareUrl,@"shareImageURL":self.shareImageURL,@"shareTitle":self.shareTitle} animated:YES ompletion:^(id obj) {
        
        NSLog(@"adada");
        self.pageIndex = 1;
        [self loadDetailData];
        [self requestList:RefreshStatePull];
    }];
}
#pragma mark 分享
- (void)naviBtnClick:(UIButton *)btn{
    [AnalysisService alaysisfind_page_huati_01_share];
    //分享
    if ( _shareView == nil ){
        
        _shareView = [[HYShareActivityView alloc] initWithButtons:@[@(HYSharePlatformTypeWechatSession),@(HYSharePlatformTypeWechatTimeline),@(HYSharePlatformTypeSinaWeibo)]
                                                   shareTypeBlock:^(HYSharePlatformType type)
                      {
                          
                          [self shareActiveType:type];
                      }];
        [_shareView show];
    }else
    {
        [_shareView show];
    }
}
-(void)shareActiveType:(NSUInteger)type {
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
    shareInfo.content = [APPLanguageService wyhSearchContentWith:@"fenxiangfubiaoti"];
    shareInfo.title = self.shareTitle;
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

-(TopicDetailHeadView *)headView {
    
    if (!_headView) {
        
        _headView = [TopicDetailHeadView loadFromXib];
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
    CommentInfomationRequest *api = [[CommentInfomationRequest alloc] initWithRefType:1 refId:self.urlID content:self.commentAlertView.textV.text refUserId:-1];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
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

//侧滑
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
        
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
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
