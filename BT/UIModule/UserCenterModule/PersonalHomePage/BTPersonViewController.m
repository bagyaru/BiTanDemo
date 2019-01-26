//
//  ZDPersonViewController.m
//  ZDPerson
//
//  Created by zdd. on 2017/8/26.
//  Copyright © 2017年 zdd. All rights reserved.
//

#import "BTPersonViewController.h"
#import "ZDTableViewController.h"
#import "BTPersonAllVC.h"
#import "ZDPersonHeaderView.h"
#import "BTNaviView.h"
#import "BTUserStatisticReq.h"
#import "BTFocusUserRequest.h"
#import "BTFocusCancelReq.h"
#import "BTComfirmAlertView.h"
#import "UIImage+RTTint.h"
#import "BTConfig.h"
#define IS_SafeAreaHeight (iPhoneX ? 34.0f : 0.0f)
#define IS_StatusBarHeight (iPhoneX ? 44.0f : 20.0f)
#define IS_NavigationBarHeight (iPhoneX ? 88.0f : 64.0f)

static CGFloat const HEADERVIEW_HEIGHT  =  370; //头部的高度
//static CGFloat const HEADERVIEW_MENU_HEIGHT = 44;//头部菜单的高度


@interface BTPersonViewController ()<
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    ZDTableViewDelegate,
    ZDPersonHeaderViewDelegate,
    UIScrollViewDelegate,BTLoadingViewDelegate
>
{
    BTPersonAllVC       *_vc1;
    BTPersonAllVC    *_vc2;
    NSInteger                   _selectedTag;
    UILabel                     *_titleLabel;
}

@property (nonatomic, strong)UICollectionView       *collectionView;
@property (nonatomic, strong)ZDPersonHeaderView     *headerView;
@property (nonatomic, strong)UINavigationBar       *navigationView;
@property (nonatomic, strong)UIImageView            *bgImageView;
@property (nonatomic, strong) BTNaviView *navView;
@property (nonatomic, strong) BTUserStatisticReq *stasticApi;
@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NSMutableArray *controllers;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, assign) BOOL isScrollDown;

@end

static NSString *identifer = @"CELL";

@implementation BTPersonViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self requestUserInfo:RefreshStatePull];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = isNightMode? ViewBGNightColor :CWhiteColor;
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:nil
                                                        delegate:self];
    self.isScrollDown = YES;
    [self.collectionView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
    [self requestUserInfo:RefreshStateNormal];//请求用户信息
}

- (void)configView{
    _selectedTag = 1000;
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.headerView];
    self.navView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navView];
    self.navView.userNameL.hidden = YES;
    self.navView.avatarBgView.hidden = YES;
    self.headerView.verifyBtn.hidden = YES;
}

- (void)requestUserInfo:(RefreshState)state{
    if(state == RefreshStateNormal){
        [self.loadingView showLoading];
    }
    NSInteger userId = [self.parameters[@"userId"] integerValue];
    NSString *userName = SAFESTRING(self.parameters[@"userName"]);
    _stasticApi = [[BTUserStatisticReq alloc] initWithUserId:userId userName:userName];
    [_stasticApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        if(request.data){
            if(state == RefreshStateNormal){
                [self configView];
            }
            
            self.userInfo = request.data;
            self.headerView.postHeader.fabuCountL.text =  SAFESTRING(self.userInfo[@"articleNum"]);
            self.headerView.postHeader.guanzhuCountL.text =  SAFESTRING(self.userInfo[@"followNum"]);
            self.headerView.postHeader.fensiCountL.text =  SAFESTRING(self.userInfo[@"fansNum"]);
            self.headerView.postHeader.huozanCountL.text =  SAFESTRING(self.userInfo[@"likeNum"]);
            NSDictionary *user = self.userInfo[@"user"];
            if([user isKindOfClass:[NSDictionary class]]){
                self.navView.title = SAFESTRING(user[@"nickName"]);
                NSString *avatar = SAFESTRING(user[@"avatar"]);
                NSString *bg = SAFESTRING(user[@"homePageImg"]);
                
                
//                [self.navView.userAvatar sd_setImageWithURL:[NSURL URLWithString:[avatar hasPrefix:@"http"]?avatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,avatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
                //                [self.headerView.avatarImageV sd_setImageWithURL:[NSURL URLWithString:[avatar hasPrefix:@"http"]?avatar:[NSString stringWithFormat:@"%@%@",PhotoImageURL,avatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    
                NSInteger authStatus = [SAFESTRING(user[@"authStatus"]) integerValue];
                NSInteger authType = [SAFESTRING(user[@"authType"]) integerValue];
                
                [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:avatar andImageView:self.headerView.avatarImageV andAuthStatus:authStatus andAuthType:authType addSuperView:self.headerView];
                
                [getUserCenter imageViewPhotoAddVChuLiWithImageUrl:avatar andImageView:self.navView.userAvatar andAuthStatus:authStatus andAuthType:authType addSuperView:self.navView.avatarBgView];
                
                [self.headerView.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[bg hasPrefix:@"http"]?bg:[NSString stringWithFormat:@"%@%@",PhotoImageURL,bg]] placeholderImage:[UIImage imageNamed:@"Mask_list"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    if(image){
                        self.headerView.backgroundImageView.image = [image rt_tintedImageWithColor:kHEXCOLOR(0x000000) level:0.4];
                    }else{
                        UIImage *placeholderImage = [UIImage imageNamed:@"person_bg"];
                        self.headerView.backgroundImageView.image = [placeholderImage rt_tintedImageWithColor:kHEXCOLOR(0x000000) level:0.4];
                    }
                }];
                
                self.headerView.nameLabel.text = SAFESTRING(user[@"nickName"]);
                self.headerView.introduceL.text = SAFESTRING(user[@"introductions"]).length >0 ? SAFESTRING(user[@"introductions"]) :[APPLanguageService sjhSearchContentWith:@"zanwujianjie"];
                
                NSInteger userId = [user[@"userId"] integerValue];
                if(userId != [BTGetUserInfoDefalut sharedManager].userInfo.userId){
                    BOOL followed = [user[@"followed"] integerValue];
                    if(followed){
                        [self.navView.rightBtn setTitle:[APPLanguageService sjhSearchContentWith:@"quxiaoguanzhu"] forState:UIControlStateNormal];
                    }else{
                        [self.navView.rightBtn setTitle:[NSString stringWithFormat:@"+ %@",[APPLanguageService sjhSearchContentWith:@"guanzhu"]] forState:UIControlStateNormal];
                    }
                    self.headerView.verifyBtn.hidden = YES;
                }else{
                    [self.navView.rightBtn setTitle:[APPLanguageService sjhSearchContentWith:@"bianji"] forState:UIControlStateNormal];
                    
                    if(authStatus == 2){
                        self.headerView.verifyBtn.hidden = YES;
                    }else{
                        self.headerView.verifyBtn.hidden = NO;
                    }
                }
                [self configBtnColor:self.isScrollDown];
            }
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        [self.loadingView showBusinessErrorWith:request.resultMsg];
    }];
}

- (void)refreshingData{
    [self requestUserInfo:RefreshStateNormal];
}

- (NSMutableArray*)controllers{
    NSDictionary *user = self.userInfo[@"user"];
    NSInteger userId = [user[@"userId"] integerValue];
    
    if(!_controllers){
        _controllers = @[].mutableCopy;
        _vc1 = [[BTPersonAllVC alloc] init];
        _vc1.original = NO;
        _vc1.userId = userId;
        _vc1.scrollViewDelegate = self;
        _vc2 = [[BTPersonAllVC alloc] init];
        _vc2.original = YES;
        _vc2.scrollViewDelegate = self;
        _vc2.userId = userId;
//        _selectedTag = _vc1.tableView.tag;
        _controllers = @[].mutableCopy;
        [_controllers addObject:_vc1];
        [_controllers addObject:_vc2];
    }
    return _controllers;
}
//
#pragma mark - ZDPersonHeaderViewDelegate
- (void)personHeaderView:(ZDPersonHeaderView *)communityDetailHeaderView didSelectItemAtIndex:(NSInteger)index{
    _selectedTag = 1000 + index;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    if(index == 0){
        [MobClick event:@"mine_zhuye_all"];
    }else{
        [MobClick event:@"mine_zhuye_origin"];
    }
}

//点击item 点击别人的关注和粉丝之前必须先登录
- (void)clickButton:(NSInteger)index{
    NSDictionary *user = self.userInfo[@"user"];
    NSInteger userId = [user[@"userId"] integerValue];
    NSString *userName = SAFESTRING(user[@"nickName"]);
    if(index == 100){//发布
        [MobClick event:@"mine_zhuye_fabu"];
        [BTCMInstance pushViewControllerWithName:@"BTFabuViewController" andParams:@{@"userName":userName,@"userId":@(userId)}];
    }else if(index == 101){//关注
        
//        if (![getUserCenter isLogined]) {
//            [AnalysisService alaysisMine_login];
//            [getUserCenter loginoutPullView];
//            return;
//        }
        [MobClick event:@"mine_zhuye_guanzhulist"];
        [BTCMInstance pushViewControllerWithName:@"BTFocusViewController" andParams:@{@"userName":@"",@"userId":@(userId)}];
        
    }else if(index == 102){//粉丝
//        if (![getUserCenter isLogined]) {
//            [AnalysisService alaysisMine_login];
//            [getUserCenter loginoutPullView];
//            return;
//        }
         [MobClick event:@"mine_zhuye_fensi"];
        [BTCMInstance pushViewControllerWithName:@"BTFansViewController" andParams:@{@"userName":@"",@"userId":@(userId)}];
        
    }else if(index == 103){//获赞
//        if (![getUserCenter isLogined]) {
//            [AnalysisService alaysisMine_login];
//            [getUserCenter loginoutPullView];
//            return;
//        }
//        if(userId ==[BTGetUserInfoDefalut sharedManager].userInfo.userId){
         [MobClick event:@"mine_zhuye_zan"];
        [BTCMInstance pushViewControllerWithName:@"BTUserPraiseVC" andParams:@{@"type":@"1",@"userId":@(userId)}];
//        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offetX = scrollView.contentOffset.x;
    if (scrollView == self.collectionView) {
        if (offetX == 0) {
            self.headerView.selectIndex = 0;
        }else if(offetX == ScreenWidth){
            self.headerView.selectIndex = 1;
        }
        _selectedTag = self.headerView.selectIndex + 1000;
    }
}

#pragma mark - ZDTableViewDelegate
- (void)tableViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag != _selectedTag) {
        return;
    }
    CGFloat offetY = scrollView.contentOffset.y;
    [_vc1 setContentOffset:offetY withTag:scrollView.tag];
    [_vc2 setContentOffset:offetY withTag:scrollView.tag];
    CGFloat tempHeight = HEADERVIEW_HEIGHT  - NaviBarHeight - 44;
    //上移
    if(offetY <= tempHeight){
        CGRect frame = self.headerView.frame;
        CGFloat y = -scrollView.contentOffset.y;
        frame.origin.y = y;
        self.headerView.frame = frame;
        UIColor * color = isNightMode ?ViewContentBgColor :CWhiteColor;
        if (offetY > HEADERVIEW_HEIGHT - NaviBarHeight - 180) {
            self.navView.backgroundColor = color;
            self.navView.userNameL.hidden = NO;
            self.navView.avatarBgView.hidden = NO;
            self.isScrollDown = NO;
            [self configBtnColor:NO];
        }else if(offetY >0){
            CGFloat alpha = MIN(1, 1 - ((tempHeight - offetY) / NaviBarHeight));
            self.bgImageView.backgroundColor = [color colorWithAlphaComponent:alpha];
            self.navView.backgroundColor = [color colorWithAlphaComponent:alpha];
            _titleLabel.backgroundColor = color;
            if(alpha == 1){
                self.navView.userNameL.hidden = NO;
                self.navView.avatarBgView.hidden = NO;
                self.isScrollDown = NO;
                [self configBtnColor:NO];
                
            }else{
                self.navView.userNameL.hidden = YES;
                self.navView.avatarBgView.hidden = YES;
                self.isScrollDown = YES;
                [self configBtnColor:YES];
                
            }
        }else{
            self.bgImageView.backgroundColor = [color colorWithAlphaComponent:0];
            self.navigationView.backgroundColor = [color colorWithAlphaComponent:0];
            _titleLabel.alpha = 0;
            self.navView.userNameL.hidden = YES;
            self.navView.avatarBgView.hidden = YES;
            self.navView.backgroundColor = [UIColor clearColor];
            self.isScrollDown = YES;
            [self configBtnColor:YES];
            
        }
    }else{
        CGRect frame = self.headerView.frame;
        CGFloat y = -tempHeight;
        frame.origin.y = y;
        self.headerView.frame = frame;
    }
    //小于0时下拉放大
    if (offetY < 0) {
        //刷新头部
        CGRect rect = self.headerView.backgroundImageView.frame;;
        rect.origin.y = offetY;
        rect.size.height = -offetY + HEADERVIEW_HEIGHT;
        self.headerView.backgroundImageView.frame = rect;
    }
}

- (void)configBtnColor:(BOOL)isDown{
    NSDictionary *user = self.userInfo[@"user"];
    BOOL followed = [user[@"followed"] integerValue];
    NSInteger userId = [user[@"userId"] integerValue];
    if(userId != [BTGetUserInfoDefalut sharedManager].userInfo.userId){
        self.navView.rightWidthCons.constant = 56.0f;
        if(followed){
            if(isDown){
                self.navView.rightBtn.layer.borderColor = [UIColor whiteColor].CGColor;
                self.navView.rightBtn.layer.borderWidth = 1;
                [self.navView.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                  [self.navView.leftBtn setImage:[UIImage imageNamed:@"return_back"] forState:UIControlStateNormal];
            }else{
                self.navView.rightBtn.layer.borderColor = kHEXCOLOR(0xCACACA).CGColor;
                self.navView.rightBtn.layer.borderWidth = 1;
                [self.navView.rightBtn setTitleColor:ThirdColor forState:UIControlStateNormal];
                [self.navView.leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            }
            
        }else{
            if(isDown){
                self.navView.rightBtn.layer.borderColor = [UIColor whiteColor].CGColor;
                self.navView.rightBtn.layer.borderWidth = 1;
                [self.navView.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.navView.leftBtn setImage:[UIImage imageNamed:@"return_back"] forState:UIControlStateNormal];
            }else{
                self.navView.rightBtn.layer.borderColor = MainBg_Color.CGColor;
                self.navView.rightBtn.layer.borderWidth = 1;
                [self.navView.rightBtn setTitleColor:MainBg_Color forState:UIControlStateNormal];
                [self.navView.leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
            }
        }
    }else{
        self.navView.rightWidthCons.constant = 30.0f;
        self.navView.rightBtn.layer.borderColor = [UIColor clearColor].CGColor;
        if(isDown){
             [self.navView.leftBtn setImage:[UIImage imageNamed:@"return_back"] forState:UIControlStateNormal];
            [self.navView.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [self.navView.rightBtn setTitleColor:MainBg_Color forState:UIControlStateNormal];
            [self.navView.leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        }
    }
    if(self.isScrollDown){
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.navView.leftBtn setImage:[UIImage imageNamed:@"return_back"] forState:UIControlStateNormal];
    }else{
        if (isNightMode) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }else {
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        }
        [self.navView.leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.controllers.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
    if (!cell) {
        cell = [[UICollectionViewCell alloc] init];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    ZDTableViewController *vc = self.controllers[indexPath.row];
    vc.view.frame = CGRectMake(0, 0, ScreenWidth, iPhoneX?(self.view.height - 34) : self.view.height);
    [cell.contentView addSubview:vc.view];
    
    return cell;
}
#pragma mark -懒加载
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, ScreenWidth, ScreenHeight - IS_SafeAreaHeight) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        layout.itemSize = CGSizeMake(ScreenWidth, ScreenHeight - IS_SafeAreaHeight);
        
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource =self;
        _collectionView.bounces = NO;
        _collectionView.allowsSelection = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifer];
    }
    return _collectionView;
}
- (ZDPersonHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ZDPersonHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HEADERVIEW_HEIGHT)];
        _headerView.delegate = self;
        //获取穿透view的数量
        _headerView.passthroughViews = @[self.collectionView];
        
        //申请认证
        [_headerView.verifyBtn bk_addEventHandler:^(id  _Nonnull sender) {
            [MobClick event:@"mine_zhuye_renzheng"];
            H5Node *node = [[H5Node alloc] init];
            node.title = [APPLanguageService sjhSearchContentWith:@"bitanrenzheng"];
            node.webUrl = [NSString stringWithFormat:@"%@%@",[BTConfig sharedInstance].Post_h5domain,Verify_URL];
            [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerView;
}

- (UINavigationBar *)navigationView{
    if (!_navigationView) {
        _navigationView = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,IS_NavigationBarHeight)];
        
        [_navigationView addSubview:self.bgImageView];
        [_navigationView setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        _navigationView.shadowImage = [UIImage new];
        
        UINavigationItem *item = [[UINavigationItem alloc] init];
        item.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        item.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
        _navigationView.tintColor = [UIColor whiteColor];
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, IS_StatusBarHeight, ScreenWidth - 40 * 2, 44)];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.text = @"麦卡特尼";
        _titleLabel = titleLabel;
        [_navigationView addSubview:titleLabel];
        _navigationView.items = @[item];
    }
    return _navigationView;
}
- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, IS_NavigationBarHeight)];
    }
    return _bgImageView;
}
- (BTNaviView*)navView{
    if(!_navView){
        _navView = [BTNaviView loadFromXib];
        _navView.frame = CGRectMake(0, 0, ScreenWidth, NaviBarHeight);
        _navView.userInteractionEnabled = YES;
        WS(ws)
        _navView.addHandleBlock = ^{
            if (![getUserCenter isLogined]) {
                [AnalysisService alaysisMine_login];
                [getUserCenter loginoutPullView];
                return;
            }
            NSDictionary *user = ws.userInfo[@"user"];
            if([user isKindOfClass:[NSDictionary class]]){
                BOOL followed = [user[@"followed"] integerValue];
                NSInteger userId = [user[@"userId"] integerValue];
                if(userId != [BTGetUserInfoDefalut sharedManager].userInfo.userId){
                    if(followed){
                        [BTComfirmAlertView showWithRecordModel:nil completion:^(BTPostMainListModel *model) {
                             [ws cancelFocus:userId];
                        }];
                      
                    }else{
                        [MobClick event:@"mine_zhuye_guanzhuuser"];
                        [ws focus:userId];
                    }
                }else{
                    [MobClick event:@"mine_zhuye_edit"];
                    [BTCMInstance pushViewControllerWithName:@"personSetting" andParams:@{@"data":user}];
                }
            }
        };
        
    }
    return _navView;
}

//
- (void)focus:(NSInteger)userId {
    BTFocusUserRequest *req = [[BTFocusUserRequest alloc] initWithRefId:userId];
    [req requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"guanzhuchenggong"] wait:YES];
        [self requestUserInfo:RefreshStatePull];
        [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Refresh_Post_List object:nil];
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

- (void)cancelFocus:(NSInteger)userId {
    BTFocusCancelReq *req = [[BTFocusCancelReq alloc] initWithRefId:userId];
    [req requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self requestUserInfo:RefreshStatePull];
        [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Refresh_Post_List object:nil];
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

@end
