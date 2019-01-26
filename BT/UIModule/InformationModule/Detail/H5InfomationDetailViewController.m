//
//  H5InfomationDetailViewController.m
//  BT
//
//  Created by admin on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "H5InfomationDetailViewController.h"
#import "THFInformationAndBaiKeHeadView.h"
#import "H5InfomationDetailCell.h"
#import "THFZXAndBKObj.h"
#import "InfomationDetailRequest.h"
#import "InfomationCollectionRequest.h"
#import "InfomationDetailFootView.h"
#import "IndomationDetailCommentListRequest.h"
#import "BTConfig.h"
#import "CommentDetailSetionFooterView.h"
#import "LikeRequest.h"

#import "CommentDetailFootView.h"
#import "BTNewSameCommentsCell.h"
#import "DiscussModel.h"
#import "BTNewSetionHeadView.h"
#import "CommentDetailFootView.h"
#import "CommentInfomationRequest.h"


#import "FastInfoShareView.h"
#import "UIView+saveImageWithScale.h"

#import "BTFocusUserRequest.h"
#import "BTFocusCancelReq.h"
static NSString *const identifier = @"BTNewSameCommentsCell";
@interface H5InfomationDetailViewController ()<UITableViewDelegate,UITableViewDataSource,THFZXAndBKCellDelegate,BTLoadingViewDelegate
,BTNewSameCommentsCellDelegate,UITextViewDelegate,HYShareActivityViewDelegate,UIGestureRecognizerDelegate>{

    THFZXAndBKObj                  *_detalObj;
    CGFloat                         _cellHeight;
    CGFloat                         _keyboardHeight;
    HYShareActivityView            *_shareView;
    THFInformationAndBaiKeHeadView *_headView;
    MBProgressHUD                  *_hub;
    BOOL                            _isOrNoFirst;
    BOOL                            _isOrNoTop;
    
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) InfomationDetailFootView *footView;
@property (nonatomic,strong) CommentDetailFootView *commentAlertView;
@property (nonatomic,strong) CommentDetailSetionFooterView *setionFootView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSString *refId;
@property (nonatomic, strong) CommentDetailFootView *commentsFV;
@property (nonatomic, strong) BTView *backView;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) BTNewSetionHeadView *TwoSetionView;

@property (nonatomic, strong) UIImageView *photoImageVIew;
@property (nonatomic, strong) UIImage *resultImage;
@property (nonatomic, strong) UIImage *resultShareOutImage;

@property (nonatomic, strong) FastInfoShareView *fastInfoShareV;
@property (nonatomic, strong) FastInfoShareView *fastInfoShareOutV;

@property (nonatomic,assign)BOOL firstFollowed;//第一次关注后显示取消关注按钮
@end

@implementation H5InfomationDetailViewController

-(void)dealloc {
    
    [self deletDeallocNotification];
}
-(void)deletDeallocNotification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSNotification_loginSuccess
                                                  object:nil];
}
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
     [self registerNsNotification];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.backView];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.commentAlertView];
    if (!ISNSStringValid([BTConfig sharedInstance].Info_h5domain)) {
        [[BTConfigureService shareInstanceService] getGlobal_HTML_configuration];
    }

}
-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [self.backView removeFromSuperview];
    [self.commentAlertView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.bigType == 6) {//探报详情打点
        [MobClick event:@"guanzhulist"];
    }else {//要闻 攻略 公告详情打点
        
        [MobClick event:@"tanbao_detail"];
    }
    [getUserCenter shareSuccseGetTanLiWithType:5 withTime:3];//阅读资讯加探力
    self.automaticallyAdjustsScrollViewInsets = NO;
    _cellHeight = 500;
    _isOrNoFirst = YES;
    _isOrNoTop   = YES;
    if (ISStringEqualToString(self.whereVC, @"攻略")) {
        
        self.title = [APPLanguageService wyhSearchContentWith:@"gongluoxiangqing"];
    }else if (ISStringEqualToString(self.whereVC, @"公告")) {
        
        self.title = [APPLanguageService wyhSearchContentWith:@"gonggaoxiangqing"];
    }else if(ISStringEqualToString(self.whereVC, @"tg")){
         self.title = [APPLanguageService sjhSearchContentWith:@"tangguoxiangqiang"];
    }else{
        self.title = [APPLanguageService wyhSearchContentWith:@"wenzhangxiangqing"];
    }
    [self createUI];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:NSNotification_loginSuccess object:nil];
    // Do any additional setup after loading the view.
    
    //
    UISwipeGestureRecognizer *swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(slide)];
    swiperight.delegate = self;
    swiperight.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat y = scrollView.contentOffset.y;
    if (y > _headView.frame.size.height) {
        self.title = _detalObj.title;
    }else {
        
        if (ISStringEqualToString(self.whereVC, @"攻略")) {
            
            self.title = [APPLanguageService wyhSearchContentWith:@"gongluoxiangqing"];
        }else if (ISStringEqualToString(self.whereVC, @"公告")) {
            
            self.title = [APPLanguageService wyhSearchContentWith:@"gonggaoxiangqing"];
        }else if(ISStringEqualToString(self.whereVC, @"tg")){
            self.title = [APPLanguageService sjhSearchContentWith:@"tangguoxiangqiang"];
        }else{
            self.title = [APPLanguageService wyhSearchContentWith:@"wenzhangxiangqing"];
        }
    }
}
-(void)notice:(NSNotification *)notifi {
    
    NSLog(@"登录成功");
    self.pageIndex = 1;
    [self loadDetailData];//详情
    [self requestList:RefreshStatePull];//评论列表
}
+ (id)createWithParams:(NSDictionary *)params{
    H5InfomationDetailViewController *vc = [[H5InfomationDetailViewController alloc] init];
    vc.urlID = [params objectForKey:@"refId"];
    vc.whereVC = [params objectForKey:@"whereVC"];
    vc.bigType = [[params objectForKey:@"bigType"] integerValue];
    vc.hidesBottomBarWhenPushed = YES;
    NSLog(@"%@",vc.urlID);
    
    return vc;
    
}
-(void)createUI {
    NSLog(@"%ld",self.bigType);
    self.pageIndex = 1;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, !ISStringEqualToString(self.whereVC, @"公告") ? ScreenHeight-kTopHeight-50-(iPhoneX?20:0) : ScreenHeight-kTopHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = CViewBgColor;
    _tableView.estimatedRowHeight = 0;
//    _tableView.estimatedSectionHeaderHeight = 0;
//    _tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableView];
    [_tableView registerNib:[UINib nibWithNibName:@"H5InfomationDetailCell" bundle:nil] forCellReuseIdentifier:@"H5InfomationDetailCell"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTNewSameCommentsCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _headView = [THFInformationAndBaiKeHeadView loadFromXib];
    _tableView.tableHeaderView = _headView;
//    _tableView.tableFooterView = !ISStringEqualToString(self.whereVC, @"公告") ? self.setionFootView : nil;
    _tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
    }];
    
    _tableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        self.pageIndex++;
        [self requestList:RefreshStateUp];
    }];
    
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
    [self.loadingView hiddenLoading];
    [self loadDetailData];//详情
    [self requestList:RefreshStateNormal];
}
//评论列表
- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    IndomationDetailCommentListRequest *api = [[IndomationDetailCommentListRequest alloc] initWithRefType:self.bigType == 6 ? 5 : 1 refId:self.urlID pageIndex:self.pageIndex];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
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
        
        NSInteger totalResults = [[request.responseObject objectForKey:@"totalResults"] integerValue];
        ViewRadius(self.footView.pingLunL, 5);
        self.footView.pingLunL.text = totalResults > 0 ? [NSString stringWithFormat:@"  %ld  ",totalResults] : @"";
        self.footView.pingLunIV.image = totalResults > 0 ? IMAGE_NAMED(@"评论") : IMAGE_NAMED(@"message");
        
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
        [self.tableView reloadData];
        //刷新特定section
//        NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:1];
//        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

//文章详情
-(void)loadDetailData {
    
    InfomationDetailRequest *api = [[InfomationDetailRequest alloc] initWithDetailID:self.urlID];
    api.bigType = self.bigType;
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        //[self.loadingView hiddenLoading];
        _detalObj = [THFZXAndBKObj objectWithDictionary:request.data];
        _isFavor = [request.data[@"favor"] boolValue];
        if ([request.data[@"user"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *userDict = request.data[@"user"];
            _detalObj.avatar             = SAFESTRING(userDict[@"avatar"]);
            _detalObj.followed           = [userDict[@"followed"] boolValue];
            _detalObj.introductions      = SAFESTRING(userDict[@"introductions"]);
            _detalObj.nickName           = SAFESTRING(userDict[@"nickName"]);
            _detalObj.userId             = [userDict[@"userId"] integerValue];
            _detalObj.authStatus         = [userDict[@"authStatus"] integerValue];
            _detalObj.authType           = [userDict[@"authType"] integerValue];
        }
        [self refreshUI];
        [_tableView reloadData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];

}
#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    [self loadDetailData];//详情
    [self requestList:RefreshStateNormal];
}
-(void)refreshUI {
    //当接到推送通知时 单独处理分享
    if (ISNSStringValid(_detalObj.title)) {
        
        self.shareTitle = _detalObj.title;
    }
    
    if (ISNSStringValid(_detalObj.imgUrl)) {
        
        
        if ([SAFESTRING(_detalObj.imgUrl) hasPrefix:@"http"]) {
          
            self.shareImageURL = [NSString stringWithFormat:@"%@",_detalObj.imgUrl];
        } else {
            
            self.shareImageURL = [NSString stringWithFormat:@"%@%@",PhotoImageURL,_detalObj.imgUrl];
        }
    }
    NSString *stringLanguage;
    if ([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]) {
        stringLanguage = @"lang=cn";
    }else{
        stringLanguage = @"lang=en";
    }
    NSString *stringType;
    if (self.bigType == 6) {
        stringType = @"type=6";
    }else {
        stringType = @"type=1";
    }
    self.shareUrl = [NSString stringWithFormat:@"%@%@?id=%@&%@&%@&v=%@",[BTConfig sharedInstance].Info_h5domain,InfoDetail_H5,_detalObj.infoID,stringLanguage,stringType,[getUserCenter getNowTimeTimestamp]];
    _headView.titleL.text = _detalObj.title;
    [getUserCenter setLabelSpace:_headView.titleL withValue:_detalObj.title withFont:FONT(@"PingFangSC-Medium", 24) withHJJ:4.0 withZJJ:0.0];
    CGFloat height = [getUserCenter getSpaceLabelHeight:_detalObj.title withFont:FONT(@"PingFangSC-Medium", 24) withWidth:ScreenWidth-30 withHJJ:4.0 withZJJ:0.0];
    
    _headView.nickeName.text = !ISNSStringValid(_detalObj.avatar)?_detalObj.source:_detalObj.nickName;
    
    NSString *liulan =  [NSString stringWithFormat:@"%@%@",[[DigitalHelperService transformWith:_detalObj.viewCount] hasSuffix:@".00"] ? [[DigitalHelperService transformWith:_detalObj.viewCount] stringByReplacingOccurrencesOfString:@".00" withString:@""] : [DigitalHelperService transformWith:_detalObj.viewCount],[APPLanguageService wyhSearchContentWith:@"yuedu"]];
    NSString *shijian = [NSString stringWithFormat:@"%@",[getUserCenter NewTimePresentationStringWithTimeStamp:_detalObj.issueDate]];
    
    _headView.bqL.text = [NSString stringWithFormat:@"·%@",shijian];
    //[_headView.photoIV sd_setImageWithURL:[NSURL URLWithString:[_detalObj.avatar hasPrefix:@"http"]?_detalObj.avatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,_detalObj.avatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    if (!ISNSStringValid(_detalObj.avatar)) {
        _headView.photoW.constant = 0;
        _headView.left.constant = 0;
    }
    if (self.bigType == 6) {
        _headView.photoW.constant = 34;
        _headView.left.constant = 10;
        ViewRadius(_headView.photoIV, 17);
        _headView.frame = CGRectMake(0, 0, ScreenWidth, height+72);
        _headView.photoIV.frame = CGRectMake(15, 31+height, 34, 34);
        _headView.bqL.hidden = YES;
        _headView.numberL.hidden = YES;
        _headView.nickeName.font = FONT(PF_MEDIUM, 12);
        _headView.labelTwo.text = [NSString stringWithFormat:@"%@·%@",shijian,liulan];
        [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:_detalObj.avatar andImageView:_headView.photoIV andAuthStatus:_detalObj.authStatus andAuthType:_detalObj.authType addSuperView:_headView];
        
        ViewBorderRadius(_headView.focusView, 4, 1, (isNightMode ? [UIColor colorWithHexString:@"154F78"] : [UIColor colorWithHexString:@"83BFEA"]));
        if ((_detalObj.userId == getUserCenter.userInfo.userId)) {
            _headView.focusView.hidden = YES;
        }else {
            
            if (self.firstFollowed) {
                _headView.focusView.hidden = NO;
                if (_detalObj.followed) {
                    _headView.jiaL.text = @"";
                    _headView.labelFocus.fixText = @"quxiaoguanzhu";
                    _headView.labelFocus.textColor = ThirdColor;
                    ViewBorderRadius(_headView.focusView, 4, 1, SeparateColor);
                }else {
                    
                    _headView.jiaL.text = @"+";
                    _headView.labelFocus.fixText = @"guanzhu";
                    _headView.labelFocus.textColor = MainBg_Color;
                    ViewBorderRadius(_headView.focusView, 4, 1, (isNightMode ? [UIColor colorWithHexString:@"154F78"] : [UIColor colorWithHexString:@"83BFEA"]));
                }
            }else {
                if (_detalObj.followed) {
                    _headView.focusView.hidden = YES;
                }else {
                    _headView.focusView.hidden = NO;
                }
            }
        }
        
        
    }else {
        _headView.frame = CGRectMake(0, 0, ScreenWidth, height+56);
        _headView.labelTwo.hidden  = YES;
        _headView.focusView.hidden = YES;
    }
    _headView.nickeName.userInteractionEnabled = YES;
    _headView.photoIV.userInteractionEnabled = YES;
    [_headView.nickeName addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
    [_headView.photoIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserMainVC:)]];
    [_headView.buttonFocus addTarget:self action:@selector(buttonFocusClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if(ISStringEqualToString(self.whereVC, @"tg")){
        _headView.numberL.text =@"";
    }else{
        _headView.numberL.text = liulan;
    }
    if (!ISStringEqualToString(self.whereVC, @"公告") && _detalObj.type != 1) {
        [self.view addSubview:self.footView];
    }
    if (_isFavor) {
        
        self.footView.collectionIV.image = [UIImage imageNamed:@"文章已收藏"];
    } else {
        self.footView.collectionIV.image = [UIImage imageNamed:@"文章收藏"];
    }
    ViewRadius(self.footView.PLBtn, 4);
    [self.footView.collectionBtn addTarget:self action:@selector(shouCangBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.footView.shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.footView.pingLunBtn addTarget:self action:@selector(pingLunBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.footView.PLBtn addTarget:self action:@selector(PLBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (_detalObj.type == 1) {//快讯
        
        FastInfomationObj *model = [FastInfomationObj new];
        model.content = _detalObj.content;
        model.issueDate = _detalObj.issueDate;
        [self KX_ShareWithModel:model];
    }
    
}
//关注
-(void)buttonFocusClick:(UIButton *)btn {
    if (![getUserCenter isLogined]) {
        [getUserCenter loginoutPullView];
        return;
    }
    WS(ws);
    BTBaseRequest *api;
    NSString      *message;
    if (!_detalObj.followed) {
        api = [[BTFocusUserRequest alloc] initWithRefId:_detalObj.userId];
        message = [APPLanguageService wyhSearchContentWith:@"guanzhuchenggong"];
    }else {
        message = [APPLanguageService wyhSearchContentWith:@"quxiaoguanzhuchenggong"];
        api = [[BTFocusCancelReq alloc] initWithRefId:_detalObj.userId];
    }
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [MBProgressHUD showMessageIsWait:message wait:YES];
        ws.firstFollowed = YES;
        _detalObj.followed = !_detalObj.followed;
        [ws refreshUI];
    } failure:^(__kindof BTBaseRequest *request) {
        
        [BTShowLoading hide];
    }];
}

//进个人中心
- (void)pushUserMainVC:(UITapGestureRecognizer *)sender {
    if (ISNSStringValid(SAFESTRING(_detalObj.source)) && self.bigType == 6) {
        NSLog(@"*************进入个人主页****************");
        [BTCMInstance pushViewControllerWithName:@"BTPersonViewController" andParams:@{@"userId":@(0),@"userName":SAFESTRING(_detalObj.source)}];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? 0 : ((!ISStringEqualToString(self.whereVC, @"公告")&&self.dataArray.count>0) ? 50 : 0);
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? [[UIView alloc] init] : ((!ISStringEqualToString(self.whereVC, @"公告")&&self.dataArray.count>0) ? self.TwoSetionView : [[UIView alloc] init]);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 1;
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) return _cellHeight;
    DiscussModel *model = self.dataArray[indexPath.row];    
    return [BTNewSameCommentsCell cellHeightWithDiscussModel:model];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.section == 0) {
        H5InfomationDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"H5InfomationDetailCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        WS(ws);
        cell.detailLikeBlock = ^{
           
            if (getUserCenter.userInfo.token.length == 0) {
                [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil animated:YES];
                return ;
            }
            NSInteger likeStatus;
            if (!_detalObj.likeStatus) {
                likeStatus = 1;
            }else{
                likeStatus = 2;
            }
            if (self.bigType == 6 && likeStatus == 1) {
                [getUserCenter biQuanXiangGuanCaoZuo:self.urlID.integerValue articleInfoType:5];
            }
            //[BTShowLoading show];
            LikeRequest *request = [[LikeRequest alloc] initWithLikeRefId:_detalObj.infoID likeRefType:self.bigType == 6 ? 3 : 2 likeStatus:likeStatus likedUserId:_detalObj.userId];
            [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
                [ws loadDetailData];
            } failure:^(__kindof BTBaseRequest *request) {
                
            }];
        };
        _detalObj.whereVC = self.whereVC;
        [cell creatUIWith:_detalObj.content isOrNoFirst:_isOrNoFirst model:_detalObj bigType:self.bigType];
        cell.delegate = self;
        return cell;
    }
    BTNewSameCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    WS(ws);
    //点赞
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
            //评论相关的操作的通知（回复，点赞，删除）
            //KPostNotification(KNotificationCommentsOperation, nil)
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
    
    if (indexPath.section == 1) {

//         DiscussModel *model = self.dataArray[indexPath.row];
//         [BTCMInstance presentViewControllerWithName:@"BTNewCommentsAlert" andParams:@{@"commentId":model.commentId,@"shareUrl":self.shareUrl,@"shareImageURL":self.shareImageURL,@"shareTitle":self.shareTitle} animated:YES];
    }
}
#pragma mark BTNewSameCommentsCellDelegate
-(void)BTNewSameCommentsCellCopyLableWithDiscussModel:(DiscussModel *)model {
    
    NSLog(@"===============弹出键盘=============");
    
    //[BTCMInstance presentViewControllerWithName:@"BTNewCommentsAlert" andParams:@{@"commentId":model.commentId,@"shareUrl":self.shareUrl,@"shareImageURL":self.shareImageURL,@"shareTitle":self.shareTitle} animated:YES];
    [BTCMInstance presentViewControllerWithName:@"BTNewCommentsAlert" andParams:@{@"commentId":model.commentId,@"shareUrl":self.shareUrl,@"shareImageURL":self.shareImageURL,@"shareTitle":self.shareTitle} animated:YES ompletion:^(id obj) {
        
        NSLog(@"adada");
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];//评论列表
    }];
}
#pragma mark --动态计算webview的高度
-(void)THFZXAndBKCellHeight:(CGFloat)height {
    _isOrNoFirst = NO;
    _cellHeight = height;
    [self.loadingView hiddenLoading];
    [_tableView reloadData];
}

//点击评论
-(void)PLBtnClick {
    
    if (![getUserCenter isLogined]) {
        
        [getUserCenter loginoutPullView];
        return;
    }
    
    [self.footView.textField becomeFirstResponder];
    self.backView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
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

//点击消息
-(void)pingLunBtnClick {
    //滚动指定位置
    if (self.dataArray.count > 0) {
        _isOrNoTop = !_isOrNoTop;
        if (!_isOrNoTop) {
            NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:1];
            [self.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }else {
            
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
    }else {
        
        [self PLBtnClick];
    }
}
//收藏(必须在登录的情况下才可以收藏)
-(void)shouCangBtnClick {
    
    if ([getUserCenter isLogined]) {
   
        InfomationCollectionRequest *api = [[InfomationCollectionRequest alloc] initWithRefType:self.bigType == 6 ? 20 : 10 refId:self.urlID favor:!_isFavor];
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            if (self.bigType == 6) {
            [getUserCenter biQuanXiangGuanCaoZuo:self.urlID.integerValue articleInfoType:3];
            }
            if (_isFavor) {
            
                
                [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"quxiaoshoucangchenggong"] wait:YES];

                
                self.footView.collectionIV.image = [UIImage imageNamed:@"文章收藏"];
            
                
            } else {
            
                
                [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"shoucangchenggong"] wait:YES];

                
                self.footView.collectionIV.image = [UIImage imageNamed:@"文章已收藏"];
                
            }
            
            
            _isFavor = !_isFavor;
            
            KPostNotification(CollectionChange, nil);
       
       } failure:^(__kindof BTBaseRequest *request) {
            
        }];
        
    }else {
        
        
        [getUserCenter loginoutPullView];
    }
    
}
//分享
-(void)shareBtnClick {
    
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
   
    NSLog(@"%ld",(unsigned long)type);
//    if (type == 2) {//微博
//        if ([WeiboSDK isWeiboAppInstalled] )
//        {
//           [getUserCenter shareSuccseGetTanLiWithType:3 withTime:2];
//            if (self.bigType == 6) {
//                [getUserCenter biQuanXiangGuanCaoZuo:self.urlID.integerValue articleInfoType:2];
//            }
//        }
//    }else {//微信
//
//        if ([WXApi isWXAppInstalled] )
//        {
//            [getUserCenter shareSuccseGetTanLiWithType:3 withTime:2];
//            if (self.bigType == 6) {
//                [getUserCenter biQuanXiangGuanCaoZuo:self.urlID.integerValue articleInfoType:2];
//            }
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
             if (self.bigType == 6) {
                 [getUserCenter biQuanXiangGuanCaoZuo:self.urlID.integerValue articleInfoType:2];
             }
         }
         [_shareView hide];
     }];
    
    
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
#pragma mark lazy

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(InfomationDetailFootView *)footView {
    
    if (!_footView) {
        
        _footView = [InfomationDetailFootView loadFromXib];
        _footView.frame = CGRectMake(0, ScreenHeight-kTopHeight-50-(iPhoneX?20:0), ScreenWidth, 50);
    }
    return _footView;
}
-(CommentDetailSetionFooterView *)setionFootView {
    
    if (!_setionFootView) {
        
        _setionFootView = [CommentDetailSetionFooterView loadFromXib];
        _setionFootView.frame = CGRectMake(0, 0, ScreenWidth, 200);
        ViewBorderRadius(_setionFootView.viewDS, 18, 1, BtnBorderColor);
        ViewBorderRadius(_setionFootView.viewZan, 18, 1, BtnBorderColor);
    }
    return _setionFootView;
}
-(BTNewSetionHeadView *)TwoSetionView {
    
    if (!_TwoSetionView) {
        _TwoSetionView = [BTNewSetionHeadView loadFromXib];
        _TwoSetionView.frame = CGRectMake(0, 0, ScreenWidth, 50);
    }
    return _TwoSetionView;
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
//发表评论
-(void)fasongBtnClick {
    
    if (!ISNSStringValid(self.commentAlertView.textV.text)) {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"shurupinglunneirong"] wait:YES];
        return;
    }

    self.commentAlertView.fasongBtn.enabled = NO;
    CommentInfomationRequest *api = [[CommentInfomationRequest alloc] initWithRefType:self.bigType == 6 ? 5 : 1 refId:self.urlID content:self.commentAlertView.textV.text refUserId:self.bigType == 6 ? _detalObj.userId : -1];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        _isOrNoTop = YES;
        [self pingLunBtnClick];
        self.commentAlertView.textV.text = nil;
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
        self.commentAlertView.fasongBtn.enabled = YES;
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"pinglunchenggong"] wait:YES];
        [getUserCenter shareSuccseGetTanLiWithType:6 withTime:2];
        if (self.bigType == 6) {
           [getUserCenter biQuanXiangGuanCaoZuo:self.urlID.integerValue articleInfoType:4];
        }
         [self.commentAlertView.textV resignFirstResponder];
    } failure:^(__kindof BTBaseRequest *request) {
        self.commentAlertView.fasongBtn.enabled = YES;
    }];
}

#pragma mark -------快讯进来直接跳分享界面---------
- (UIImageView *)photoImageVIew{
    if (!_photoImageVIew) {
        
        _photoImageVIew = [[UIImageView alloc] init];
        _photoImageVIew.userInteractionEnabled = YES;
    }
    return _photoImageVIew;
}
- (FastInfoShareView*)fastInfoShareV{
    if(!_fastInfoShareV){
        _fastInfoShareV = [FastInfoShareView loadFromXib];
        _fastInfoShareV.frame = CGRectMake(0, 0, ScreenWidth, 600);
    }
    return _fastInfoShareV;
}
-(FastInfoShareView *)fastInfoShareOutV {
    
    if (!_fastInfoShareOutV) {
        _fastInfoShareOutV = [FastInfoShareView loadFromXib];
        _fastInfoShareOutV.frame = CGRectMake(0, 0, ScreenWidth, 600);
    }
    return _fastInfoShareOutV;
}
//分享
-(void)KX_ShareWithModel:(FastInfomationObj *)obj {
    
    [AnalysisService alaysisNews_newsflash_share];
    
    self.fastInfoShareV.obj = obj;
    self.fastInfoShareOutV.obj = obj;
    
    CGFloat height    = 0.0;
    CGFloat heightOut = 0.0;
    if ([obj.content containsString:@"【"] && [obj.content containsString:@"】"]) {
        NSRange startRange = [obj.content rangeOfString:@"【"];
        NSRange endRange = [obj.content rangeOfString:@"】"];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *titleResult = [obj.content substringWithRange:range];
        NSString *contentResult = [[obj.content substringFromIndex:endRange.location] stringByReplacingOccurrencesOfString:@"】" withString:@""];
        NSLog(@"%@ %@",titleResult,contentResult);
        
        CGFloat titleHeight = [getUserCenter getSpaceLabelHeight:titleResult withFont:FONT(@"PingFangSC-Medium", 20) withWidth:235 withHJJ:4.0 withZJJ:0.0];
        CGFloat contentHeight = [getUserCenter getSpaceLabelHeight:contentResult withFont:FONTOFSIZE(14) withWidth:235 withHJJ:8.0 withZJJ:0.0];;
        NSLog(@"%.0f  %.0f",titleHeight,contentHeight);
        height = 86.0 + 124.0 + 107.0 + contentHeight +titleHeight;
        
        CGFloat titleOutHeight = [getUserCenter getSpaceLabelHeight:titleResult withFont:FONT(@"PingFangSC-Medium", 20) withWidth:ScreenWidth-70 withHJJ:4.0 withZJJ:0.0];
        CGFloat contentOutHeight = [getUserCenter getSpaceLabelHeight:contentResult withFont:FONTOFSIZE(14) withWidth:ScreenWidth-70 withHJJ:8.0 withZJJ:0.0];;
        NSLog(@"%.0f  %.0f",titleHeight,contentHeight);
        heightOut = 86.0 + 124.0 + 107.0 + contentOutHeight +titleOutHeight;
        
    }else {
        
        CGFloat titleHeight = 0.0;
        CGFloat contentHeight = [getUserCenter getSpaceLabelHeight:obj.content withFont:FONTOFSIZE(14) withWidth:235 withHJJ:8.0 withZJJ:0.0];;
        NSLog(@"%.0f  %.0f",titleHeight,contentHeight);
        height = 86.0 + 124.0 + 107.0 + contentHeight +titleHeight;
        
        CGFloat titleOutHeight = 0.0;
        CGFloat contentOutHeight = [getUserCenter getSpaceLabelHeight:obj.content withFont:FONTOFSIZE(14) withWidth:ScreenWidth-70 withHJJ:8.0 withZJJ:0.0];;
        NSLog(@"%.0f  %.0f",titleHeight,contentHeight);
        heightOut = 86.0 + 124.0 + 107.0 + contentOutHeight +titleOutHeight;
    }
    
    self.fastInfoShareOutV.frame = CGRectMake(0, 0, ScreenWidth, heightOut);
    [self.fastInfoShareOutV layoutIfNeeded];
    self.resultShareOutImage = [self.fastInfoShareOutV saveImageWithScale:[UIScreen mainScreen].scale];
    
    self.fastInfoShareV.frame = CGRectMake(0, 0, 305, height);
    [self.fastInfoShareV layoutIfNeeded];
    self.resultImage = [self.fastInfoShareV saveImageWithScale:[UIScreen mainScreen].scale];
    [self alertShareView];
    self.fastInfoShareV = nil;
    self.fastInfoShareOutV = nil;
}

-(void)alertShareView {
    
    self.photoImageVIew.image = self.resultImage;
    self.photoImageVIew.frame = CGRectMake((ScreenWidth-305)/2, self.resultImage.size.height > ScreenHeight-160-kTopHeight ? kTopHeight : (ScreenHeight-160-self.resultImage.size.height)/2, 305, self.resultImage.size.height);
    //分享
    _shareView = [[HYShareActivityView alloc] initWithButtons:@[@(HYSharePlatformTypeWechatSession),@(HYSharePlatformTypeWechatTimeline),@(HYSharePlatformTypeSinaWeibo),@(HYSharePlatformTypeCopy)] title:@"快讯" image:self.photoImageVIew shareTypeBlock:^(HYSharePlatformType type) {
        
        [self KX_ShareActiveType:type];
    }];
    
    _shareView.delegate = self;
    [_shareView show];
}
-(void)KX_ShareActiveType:(NSUInteger)type {
    
    if (self.resultImage)
    {
        if (type == 4) {//保存图片
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImageWriteToSavedPhotosAlbum(self.resultShareOutImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            });
            
            return;
        }
        
//        if (type == 2) {//微博
//            if ([WeiboSDK isWeiboAppInstalled] )
//            {
//                [getUserCenter shareSuccseGetTanLiWithType:3 withTime:2];
//            }
//        }else {//微信
//
//            if ([WXApi isWXAppInstalled] )
//            {
//                [getUserCenter shareSuccseGetTanLiWithType:3 withTime:2];
//            }
//        }
        [getUserCenter shareBuriedPointWithType:type withWhereVc:10];
        HYShareInfo *info = [[HYShareInfo alloc] init];
        info.content = [APPLanguageService wyhSearchContentWith:@"fenxiangfubiaoti"];
        info.images = self.resultShareOutImage;
        info.type = (HYPlatformType)type;
        info.shareType    = HYShareDKContentTypeImage;
        [HYShareKit shareImageWeChat:info  completion:^(NSString *errorMsg)
         {
             if ( ISNSStringValid(errorMsg) )
             {
                 
                 [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
                 [getUserCenter shareSuccseGetTanLiWithType:3 withTime:2];
                 [self.photoImageVIew removeFromSuperview];
                 self.photoImageVIew = nil;
                 [_shareView hide];
                 [BTCMInstance popViewController:nil];
             }
         }];
    }else
    {
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"fenxiangshibai"] wait:YES];
    }
}
-(void)closeView {
    
    [self.photoImageVIew removeFromSuperview];
    self.photoImageVIew = nil;
    [BTCMInstance popViewController:nil];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"baocunshibai"] wait:YES];
    } else {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"chenggongbaocundaoxiangce"] wait:YES];
    }
}

//侧滑
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
