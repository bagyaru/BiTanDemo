//
//  BTJingCaiDetailViewController.m
//  BT
//
//  Created by admin on 2018/7/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTJingCaiDetailViewController.h"
#import "CommentsSameCell.h"
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
#import "BTJingCaiMainCell.h"

#import "BTJingCaiTZAlertView.h"
#import "SEFilterControl.h"
static NSString *const identifier = @"CommentsSameCell";
static NSString *const identifier1 = @"BTJingCaiMainCell";
@interface BTJingCaiDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate,CommentsSameCellDelegate,UITextViewDelegate>{
    
    BOOL  _shown;
    NSInteger _total;
    NSArray  *_titles;
    HYShareActivityView *_shareView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet BTTextField *textField;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *hotCommentsArray;
@property (nonatomic, strong) NSMutableArray *newCommentsArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) TopicDetailHeadView *headView;
@property (nonatomic, strong) InputAccessoryView *iaView;
@property (nonatomic, strong) UIView  *iaViewBack;
@property (nonatomic,strong) NSString *urlID;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSString *shareUrl;
@property (nonatomic,strong) NSString *shareImageURL;
@property (nonatomic,strong) NSString *shareTitle;
@property (nonatomic,strong) THFZXAndBKObj *detalObj;
@property (nonatomic,strong) UIView *blackBackView;

@property (nonatomic, strong) BTJingCaiTZAlertView *tzAlertView;
@property (nonatomic, strong) BTView *backView;
@property(nonatomic,strong)   SEFilterControl *sliderView;
@end

@implementation BTJingCaiDetailViewController

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:KNotificationCommentsOperation object:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.blackBackView];
    [self.iaViewBack addSubview:self.iaView];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.iaViewBack];
    [self.iaView.textView resignFirstResponder];
    [self.textField resignFirstResponder];
    [self registerNsNotification];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [self.blackBackView removeFromSuperview];
    [self.iaViewBack removeFromSuperview];
    [self.iaView.textView resignFirstResponder];
    [self.textField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self addNavigationItemViewWithImageNames:@"commentsshare" isLeft:NO target:self action:@selector(naviBtnClick:) tag:3000];
    //点赞或者评论 刷新列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestZanOrReply:) name:KNotificationCommentsOperation object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)creatUI {
    
    if (iPhoneX) {
        
        self.bottomConstraint.constant = 34;
    }
    _shown = NO;
    ViewRadius(self.textField, 35/2);
    self.urlID = self.parameters[@"refId"];
    self.title = [APPLanguageService wyhSearchContentWith:@"jingcaixiangqing"];
    self.pageIndex = 1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommentsSameCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTJingCaiMainCell class]) bundle:nil] forCellReuseIdentifier:identifier1];
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
- (void)requestZanOrReply:(NSNotification *)notifi {
    self.pageIndex = 1;
    [self loadDetailData];
    [self requestList:RefreshStatePull];
}
//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSLog(@"竞猜详情=====当键盘出现");
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    
    if (!_shown) {
        [self.iaView.textView becomeFirstResponder];
        self.blackBackView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.iaViewBack.frame = CGRectMake(0, ScreenHeight-height-167, ScreenWidth, 167);
    }else {
        
        [self.tzAlertView.textField becomeFirstResponder];
        self.tzAlertView.frame = CGRectMake(0, ScreenHeight-height-240, ScreenWidth, 240);
    }
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    
    NSLog(@"竞猜详情=====当键退出");
    if (!_shown) {
        self.blackBackView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
        self.iaViewBack.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 167);
    }else {
        
        self.tzAlertView.frame = CGRectMake(0, ScreenHeight-240, ScreenWidth, 240);
    }
}
#pragma mark UITextViewDelegeta
//将要开始编辑是
-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.iaView.titleL.hidden = self.iaView.textView.text.length > 0;
}
//正在编辑中
-(void)textViewDidChange:(UITextView *)textView {
    
    
    self.iaView.titleL.hidden = self.iaView.textView.text.length > 0;
    (self.iaView.textView.text.length > 0) ? (self.iaView.submitBtn.titleLabel.textColor = CGreenColor) : (self.iaView.submitBtn.titleLabel.textColor = CTbarColor);
    
    if ([self.iaView.textView.text length] > contentTVMaxLenth) {
        self.iaView.textView.text = [self.iaView.textView.text substringWithRange:NSMakeRange(0, contentTVMaxLenth)];
        [self.iaView.textView.undoManager removeAllActions];
        [self.iaView.textView becomeFirstResponder];
        return;
    }
}
-(void)loadDetailData {
    
    InfomationDetailRequest *api = [[InfomationDetailRequest alloc] initWithDetailID:self.urlID];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        self.detalObj = [THFZXAndBKObj objectWithDictionary:request.data];
        NSString *str =  [getUserCenter getImageURLSizeWithWeight:ScreenWidth*2 andHeight:196*2];
        self.detalObj.imgUrl = [NSString stringWithFormat:@"%@?%@",[self.detalObj.imgUrl hasPrefix:@"http"]?self.detalObj.imgUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,self.detalObj.imgUrl],str];
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
    
}
-(void)loadHotCommentsData {
    
    HotCommentRequest *api = [[HotCommentRequest alloc] initWithRefType:1 refId:self.urlID];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.hotCommentsArray removeAllObjects];
        [self.loadingView hiddenLoading];
        if ([request.data count]) {
            
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
                [self.hotCommentsArray addObject:model];
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(__kindof BTBaseRequest *request) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
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
        
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.newCommentsArray removeAllObjects];
            
            if ([request.data count] < BTPagesize) {
                self.tableView.mj_footer.hidden = YES;;
            }else{
                [self.tableView.mj_footer endRefreshing];
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
                
                [self.newCommentsArray addObject:model];
            }
            [self loadHotCommentsData];
        }else if (state == RefreshStateUp){
            if ([request.data count] < BTPagesize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
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
                
                [self.newCommentsArray addObject:model];
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    [self loadDetailData];
    [self requestList:RefreshStateNormal];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0 ? 1 : (section == 1 ? self.hotCommentsArray.count : self.newCommentsArray.count);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
        return [self.parameters[@"selectIndex"] integerValue] == 1 ? 194.5+15 : 156.5+15;
    }
    
    if (indexPath.section == 1) {
        
        DiscussModel *model1 = self.hotCommentsArray[indexPath.row];
        return [CommentsSameCell cellHeightWithDiscussModel:model1];
    }
    DiscussModel *model = self.newCommentsArray[indexPath.row];
    return [CommentsSameCell cellHeightWithDiscussModel:model];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        BTJingCaiMainCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1 forIndexPath:indexPath];
        cell.selectionStyle     = UITableViewCellSelectionStyleNone;
        cell.selectIndex        = [self.parameters[@"selectIndex"] integerValue];
        cell.model              = [BTjingcaiMainModel new];
        WS(ws);
        cell.JCBlock = ^(NSInteger type, BTjingcaiMainModel *model) {
            
            NSLog(@"========%@=========",type == 11 ? @"支持" : @"反对");
            _total = 99;
            _titles = @[@"",[NSString stringWithFormat:@"%ld",_total/4],[NSString stringWithFormat:@"%ld",_total/4*2],[NSString stringWithFormat:@"%ld",_total/4*3],[NSString stringWithFormat:@"%ld",_total]];
            
            [ws show_tzAlertView];
        };
        return cell;
    }
    
    CommentsSameCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
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
            model.liked = !model.liked;
            model.likeCount = model.liked ? model.likeCount + 1 : model.likeCount - 1;
            [self.tableView reloadData];
            [BTShowLoading hide];
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    };
    if (indexPath.section == 1) {
        
        DiscussModel *model1 = self.hotCommentsArray[indexPath.row];
        [cell configWithDiscussModel:model1];
        return cell;
    }
    DiscussModel *model2 = self.newCommentsArray[indexPath.row];
    [cell configWithDiscussModel:model2];
    return cell;
}
#pragma mark CommentsSameCellDelegate
-(void)CommentsSameCellWith:(NSIndexPath *)indexPath withCellHeight:(CGFloat)height{
    
    //NSLog(@"%ld组%ld行%.2f",indexPath.section,indexPath.row,height);
    
    if (indexPath.section == 1) {
        
        DiscussModel *model = self.hotCommentsArray[indexPath.row];
        model.isOrNo = YES;
        model.cellHeight = height;
        [self.hotCommentsArray replaceObjectAtIndex:indexPath.row withObject:model];
        
    }
    if (indexPath.section == 2) {
        
        DiscussModel *model = self.newCommentsArray[indexPath.row];
        model.isOrNo = YES;
        model.cellHeight = height;
        [self.newCommentsArray replaceObjectAtIndex:indexPath.row withObject:model];
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 38)];
    view.backgroundColor = CWhiteColor;
    BTLabel *label = [[BTLabel alloc] initWithFrame:CGRectMake(12, 15, 100, 22)];
    
    if (section == 1) {
        
        label.localText = @"remenpinglun";
    }
    if (section == 2) {
        
        label.localText = @"zuixinpinglun";
    }
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    label.textColor = CFontColor8;
    [view addSubview:label];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? 0 : 38;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        return;
    }
    DiscussModel *model = indexPath.section == 1 ? self.hotCommentsArray[indexPath.row] :self.newCommentsArray[indexPath.row];
    [BTCMInstance pushViewControllerWithName:@"CommentsDetailVC" andParams:@{@"commentId":model.commentId}];
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
#pragma mark --弹出投注View
-(void)show_tzAlertView {
    
    if (_shown)
    {
        return;
    }
    _shown = YES;
    
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.backView];
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissView)];
    [self.backView addGestureRecognizer:g];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.tzAlertView];
    [self.tzAlertView.sliderView addSubview:self.sliderView];
    [UIView animateWithDuration:0.5f animations:^
     {
         //self.backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
         self.tzAlertView.frame = CGRectMake(0, ScreenHeight-240, ScreenWidth, 240);
         self.backView.alpha = 1;
         
     } completion:^(BOOL finished) {
         self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
     }];
}
-(void)dissView {
    if (!_shown)
    {
        return;
    }
    [UIView animateWithDuration:0.5f animations:^
     {
         
         self.tzAlertView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 240);
         
     } completion:^(BOOL finished) {
         self.backView.alpha = 0;
         self.tzAlertView.alpha = 0;
         [self.backView removeFromSuperview];
         [self.tzAlertView removeFromSuperview];
         [self.sliderView removeFromSuperview];
         self.backView = nil;
         self.tzAlertView = nil;
         self.sliderView  = nil;
         _shown = NO;
     }];
}
#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)hotCommentsArray{
    if (!_hotCommentsArray) {
        _hotCommentsArray = [NSMutableArray array];
    }
    return _hotCommentsArray;
}
- (NSMutableArray *)newCommentsArray {
    
    if (!_newCommentsArray) {
        
        _newCommentsArray = [NSMutableArray array];
    }
    return _newCommentsArray;
}
-(UIView *)iaViewBack {
    
    if (!_iaViewBack) {
        
        _iaViewBack = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 167)];
        _iaViewBack.backgroundColor = [UIColor blackColor];
    }
    return _iaViewBack;
}
-(UIView *)blackBackView {
    
    if (!_blackBackView) {
        
        _blackBackView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
        _blackBackView.backgroundColor = [UIColor blackColor];
        _blackBackView.alpha = 0.5;
    }
    return _blackBackView;
}
-(InputAccessoryView *)iaView {
    
    if (!_iaView) {
        
        _iaView = [InputAccessoryView loadFromXib];
        _iaView.frame = CGRectMake(0, 0, ScreenWidth, 167);
        _iaView.textView.delegate = self;
        //_iaView.textView.inputAccessoryView = [[UIView alloc] init];
        [_iaView.cancellBtn addTarget:self action:@selector(cancellBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_iaView.submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _iaView;
}
-(void)cancellBtnClick {
    
    [self.iaView.textView resignFirstResponder];
}
-(void)submitBtnClick {
    if (getUserCenter.userInfo.token.length == 0) {
        [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil animated:YES];
        return ;
    }
    if (!ISNSStringValid(self.iaView.textView.text)) {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"shurupinglunneirong"] wait:YES];
        return;
    }
    self.iaView.submitBtn.enabled = NO;
    CommentInfomationRequest *api = [[CommentInfomationRequest alloc] initWithRefType:1 refId:self.urlID content:self.iaView.textView.text refUserId:-1];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"pinglunchenggong"] wait:YES];
        self.iaView.textView.text = nil;
        [self.iaView.textView resignFirstResponder];
        self.iaView.submitBtn.enabled = YES;
        [self loadDetailData];
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
    } failure:^(__kindof BTBaseRequest *request) {
        self.iaView.submitBtn.enabled = YES;
    }];
    
}

-(BTJingCaiTZAlertView *)tzAlertView {
    
    if (!_tzAlertView) {
        _tzAlertView = [BTJingCaiTZAlertView loadFromXib];
        _tzAlertView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 240);
        ViewRadius(_tzAlertView.tzBtn, 4);
        [_tzAlertView.allInBtn addTarget:self action:@selector(allInBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_tzAlertView.tzBtn addTarget:self action:@selector(tzBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tzAlertView;
}
-(BTView *)backView {
    
    if (!_backView) {
        _backView = [[BTView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        //_backView.backgroundColor = [UIColor blackColor];
        //_backView.alpha = 0.5;
    }
    return _backView;
}
-(SEFilterControl *)sliderView {
    
    if (!_sliderView) {
        
        _sliderView = [[SEFilterControl alloc] initWithFrame:CGRectMake(25, 5, self.view.frame.size.width-50, 15) Titles:_titles];
        [_sliderView addTarget:self action:@selector(filterValueChanged:) forControlEvents:UIControlEventTouchUpInside];
        [_sliderView setProgressColor:[UIColor groupTableViewBackgroundColor]];//设置滑杆的颜色
        [_sliderView setTopTitlesColor:[UIColor orangeColor]];//设置滑块上方字体颜色
        [_sliderView setSelectedIndex:0];//设置当前选中
    }
    return _sliderView;
}
#pragma mark -- 点击底部按钮响应事件
-(void)filterValueChanged:(SEFilterControl *)sender
{
    NSLog(@"当前滑块位置%d",sender.SelectedIndex);
    self.tzAlertView.textField.text = _titles[sender.SelectedIndex];
    
}
#pragma mark -- 全押
-(void)allInBtnClick {
    
    [self.sliderView setSelectedIndex:4];
    self.tzAlertView.textField.text = _titles[4];
    
}
#pragma mark -- 投注
-(void)tzBtnBtnClick {
    if (!ISNSStringValid(self.tzAlertView.textField.text)) {
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"touzhushuliangbunengweikong"] wait:YES];
        return;
    }
    if ([self.tzAlertView.textField.text integerValue] > _total) {
        
        [UIAlertView showWithTitle:nil
                           message:[APPLanguageService wyhSearchContentWith:@"tanlibuzu"] cancelButtonTitle:[APPLanguageService wyhSearchContentWith:@"quxiao"] otherButtonTitles:@[[APPLanguageService wyhSearchContentWith:@"zuorenwu"]]
                          tapBlock:^(UIAlertView * __nonnull alertView, NSInteger buttonIndex)
         {
             
             NSLog(@"%ld",(long)buttonIndex);
             if (buttonIndex == 1) {
                 [self dissView];
                 if (![getUserCenter isLogined]) {
                     [AnalysisService alaysisMine_login];
                     [getUserCenter loginoutPullView];
                     return;
                 }
                 [AnalysisService alaysismine_page_tanli];
                 [BTCMInstance pushViewControllerWithName:@"BTNewMyTanLiMain" andParams:@{@"isTarget":@(1)}];
             }
             
         }];
        return;
    }
    [self dissView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
