//
//  DiscoveryViewController.m
//  BT
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "DiscoveryRollImagesView.h"
#import "BTDiscovMenuView.h"
#import "BTDiscoverySelectView.h"
#import "BTDiscoveryMainCell.h"
#import "BTConceptUpDownRequest.h"
#import "BannersRequest.h"
#import "BTDiscoveryBannerReq.h"
#import "iCarousel.h"
#import "CheckMessageUnreadRequest.h"
#import "MessageModel.h"
#import "BTDiscoverySetionOneView.h"
#import "BTDiscoverySetionTwoView.h"
#import "BTDiscoveryRMBZCell.h"
#import "BTHotCurrencyListRequest.h"
#import "BTHotCurrencyModel.h"

#import "BTGroupListModel.h"
#import "ExchangeListRequest.h"
#import "BTGroupListRequest.h"
#import "GroupSideView.h"

#import "BTICOMainCell.h"
#import "BTCandyMainCell.h"

#import "BTCandyListHotApi.h"
#import "FastInfomationObj.h"
#import "BTICOListApi.h"
#import "BTICOListModel.h"
#import "BTColleageListReq.h"
#import "BTCollegeMainCell.h"
#import "BTIsSignInRequest.h"
static NSString *const identifier = @"BTDiscoveryRMBZCell";
@interface DiscoveryViewController ()<DiscoveryRollImagesViewDelegate,BTDiscovMenuContainerViewDelegate,BTLoadingViewDelegate,iCarouselDataSource,iCarouselDelegate,UITableViewDelegate,UITableViewDataSource>{
    BTConceptUpDownRequest *api;
}
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) DiscoveryRollImagesView *rollImageViews;
/**3d轮播图*/
@property (nonatomic, strong) iCarousel *myiCarousel;
@property (nonatomic, strong) BTDiscovMenuContainerView *menuContainerV;
@property (nonatomic, strong) UIView *separatorView;

@property (nonatomic, assign) NSInteger selectIndex; //1 涨幅榜 2 跌幅榜
@property (nonatomic, strong) NSMutableArray *upArr;
@property (nonatomic, strong) NSMutableArray *downArr;
@property (nonatomic, strong) BTDiscoverySelectView*selectView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *bannersArray;
@property (nonatomic, strong) NSMutableArray *HotCurrencyArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) BTDiscoverySetionOneView*setionOneView;
@property (nonatomic, strong) BTDiscoverySetionOneView*setionTwoView;
@property (nonatomic, strong) BTDiscoverySetionOneView*setionColleageView;


@property (nonatomic, strong) BTGroupListModel *listModel;
@property (nonatomic, strong) ExchangeListRequest *exchangeListApi;
@property (nonatomic, strong) BTGroupListRequest *groupListApi;

@property (nonatomic, strong) NSMutableArray *candyArr;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *icoListArr;
@property (nonatomic, strong) NSMutableArray *colleageData;

@end

@implementation DiscoveryViewController

#pragma mark --override
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
    self.title = [APPLanguageService wyhSearchContentWith:@"market"];
    [self addNavigationItemWithImageNames:@[@"main_search"] isLeft:NO target:self action:@selector(btnClick:) tags:@[@"1000"]];
    [self addNavigationItemWithImageNames:@[@"ic_zixuancelan"] isLeft:YES target:self action:@selector(btnClick:) tags:@[@"1001"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSelectGroup:) name:k_Notification_Refresh_Select_Group object:nil];
    self.listModel = [[BTGroupListModel alloc] init];
}

- (void)createUI{
    [self createTableView];
    [self createOtherViews];
}

- (void)createTableView{
    [self.view addSubview:self.mTableView];
}
//搜索
- (void)btnClick:(UIButton*)btn{
    
    if (btn.tag == 1000) {
        [AnalysisService alaysisHome_search];
        [BTCMInstance presentViewControllerWithName:@"historySearch" andParams:nil animated:NO];
    }else {
        btn.ts_acceptEventInterval = 2.0f;
        [self requestList];
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [AnalysisService alaysisExchange_page];
    //    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self stopTimer];
}

- (void)createOtherViews{
    WS(weakSelf);
    [self.mTableView registerNib:[UINib nibWithNibName:@"BTICOMainCell" bundle:nil] forCellReuseIdentifier:@"BTICOMainCell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"BTCandyMainCell" bundle:nil] forCellReuseIdentifier:@"BTCandyMainCell"];
    [self.mTableView registerNib:[UINib nibWithNibName:@"BTCollegeMainCell" bundle:nil] forCellReuseIdentifier:@"BTCollegeMainCell"];
    
    self.mTableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
       
        [weakSelf loadBannerData:RefreshStatePull];
        [weakSelf loadColleageData];
        [weakSelf loadICOListData];
        [weakSelf loadCandyListData];
    }];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:nil delegate:self];
    self.mTableView.tableHeaderView = self.headerView;
    
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark --Load Data
- (void)loadData{
    _upArr =@[].mutableCopy;
    _downArr =@[].mutableCopy;
    _candyArr = @[].mutableCopy;
    _colleageData = @[].mutableCopy;
    

    NSArray *menus =@[@{@"image":@"qihuoshichang",@"title":@"qihuoshichang",@"index":@"4"},
                      
                      @{@"image":@"xinbishangxian",@"title":@"xinbishangxian",@"index":@"1"
                        
                        },
                      @{@"image":@"xianhuoshichang",@"title":@"xianhuoshichang",@"index":@"3"
                        
                        },
                      @{@"image":@"huobigainian",@"title":@"huobigainian",@"index":@"2"
                        
                        },
                     ];
    self.menuContainerV.menus = menus;
    [self loadBannerData:RefreshStateNormal];
    [self loadColleageData];
    [self loadICOListData];
    [self loadCandyListData];

}
-(void)loadBannerData:(RefreshState)state {
    if(state == RefreshStateNormal){
        [self.loadingView showLoading];
    }
    BTDiscoveryBannerReq *bannerApi = [[BTDiscoveryBannerReq alloc]initWithType:1];
    [bannerApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        _bannersArray =@[].mutableCopy;
        NSMutableArray *urls = [NSMutableArray array];
        for (NSDictionary *dic in request.data) {
            [_bannersArray addObject:dic];
            NSString *str =  [getUserCenter getImageURLSizeWithWeight:ScreenWidth*2 andHeight:150*2];
            NSString *url =[NSString stringWithFormat:@"%@?%@",SAFESTRING(dic[@"image"]),str];
            [urls addObject:[NSString stringWithFormat:@"%@",url]];
        }
        if(_bannersArray.count > 0){
            self.rollImageViews.bannerUrls = urls;
            self.rollImageViews.hidden = NO;
            
        }else{
            self.rollImageViews.hidden =YES;
            self.menuContainerV.frame =CGRectMake(0, 0, ScreenWidth, 97.0f);
            self.headerView.frame = CGRectMake(0, 0, ScreenWidth, 97.0f);
            self.mTableView.tableHeaderView = self.headerView;
        }
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
- (void)loadColleageData{
    BTColleageListReq *api = [[BTColleageListReq alloc] init];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data&& [request.data isKindOfClass:[NSArray class]]){
            self.colleageData = request.data;
        }
        
        [self.mTableView reloadData];
        
    } failure:^(__kindof BTBaseRequest *request) {

    }];
    
}
- (void)loadICOListData{
    BTICOListApi* _listApi = [[BTICOListApi alloc] initWithType:1 pageIndex:1];
    [_listApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        [self.loadingView hiddenLoading];
        if(request.data&&[request.data isKindOfClass:[NSArray class]]){
            self.icoListArr = @[].mutableCopy;
            NSMutableArray *mutaArr = @[].mutableCopy;
            for (NSDictionary *dic in request.data) {
                BTICOListModel *model = [BTICOListModel objectWithDictionary:dic];
                [mutaArr addObject:model];
            }
            
            [self.mTableView.mj_header endRefreshing];
            
            if(mutaArr.count <=6){
                self.icoListArr  = mutaArr;
            }else{
                self.icoListArr =  [mutaArr bk_select:^BOOL(id  _Nonnull obj) {
                    NSInteger index = [mutaArr indexOfObject:obj];
                    return index < 6;
                }].mutableCopy;
            }
            [self.mTableView reloadData];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        [self.mTableView.mj_header endRefreshing];
    }];
}
//
- (void)loadCandyListData{
    BTCandyListHotApi *infoApi = [[BTCandyListHotApi alloc] init];
    [infoApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        self.candyArr = @[].mutableCopy;
        [self.loadingView hiddenLoading];
        [self.mTableView.mj_header endRefreshing];
        if(request.data &&[request.data isKindOfClass:[NSArray class]]){
            
            for (NSDictionary *dic in request.data) {
                FastInfomationObj *obj = [FastInfomationObj objectWithDictionary:dic];
                if (ISNSStringValid(obj.imgUrl)) {
                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:80*2 andHeight:80*2];
                    obj.imgUrl = [NSString stringWithFormat:@"%@?%@",obj.imgUrl,str];
                }
                [self.candyArr addObject:obj];
                
            }
        }
        [self.mTableView reloadData];
    } failure:^(__kindof BTBaseRequest *request) {
        [self.mTableView.mj_header endRefreshing];
    }];
}
#pragma mark -- Customer Accessor
- (UIView*)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 197.0f)];
        [_headerView addSubview:self.rollImageViews];
        [_headerView addSubview:self.menuContainerV];
        _headerView.backgroundColor = isNightMode? ViewContentBgColor :CWhiteColor;
      }
    return _headerView;
}
//轮播图
- (DiscoveryRollImagesView*)rollImageViews{
    if(!_rollImageViews){
        _rollImageViews = [[DiscoveryRollImagesView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100.0f)];
        _rollImageViews.placeHolderImage = [UIImage imageNamed:@"Mask_list"];
        _rollImageViews.delegate = self;
//        [_rollImageViews autoRollEnable:YES];
    }
    return _rollImageViews;
}

//3d轮播图
-(iCarousel *)myiCarousel{
    if (!_myiCarousel) {
        _myiCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
        _myiCarousel.delegate = self;
        _myiCarousel.dataSource = self;
        _myiCarousel.bounces = NO;
        _myiCarousel.pagingEnabled = YES;
        _myiCarousel.type = iCarouselTypeRotary;
    }
    return _myiCarousel;
}

- (BTDiscovMenuContainerView*)menuContainerV{
    if(!_menuContainerV){
        _menuContainerV = [[BTDiscovMenuContainerView alloc] initWithFrame:CGRectZero];
        _menuContainerV.frame =CGRectMake(0, 100, ScreenWidth, 97.0f);
        _menuContainerV.backgroundColor = isNightMode?ViewContentBgColor:CWhiteColor;
        _menuContainerV.deleagte = self;
    }
    return _menuContainerV;
}

//币探学院
- (BTDiscoverySetionOneView *)setionColleageView {
    if (!_setionColleageView) {
        _setionColleageView = [BTDiscoverySetionOneView loadFromXib];
        _setionColleageView.titleL.fixText = @"bitanxueyuan";
        _setionColleageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [BTCMInstance pushViewControllerWithName:@"BTColleageVC" andParams:nil];
            [MobClick event:@"school"];
        }];
        [_setionColleageView addGestureRecognizer:tap];
        
    }
    return _setionColleageView;
}

//ICO 专区
- (BTDiscoverySetionOneView *)setionOneView {
    if (!_setionOneView) {
        _setionOneView = [BTDiscoverySetionOneView loadFromXib];
        _setionOneView.titleL.fixText = @"ICOXiangmu";
        _setionOneView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [BTCMInstance pushViewControllerWithName:@"BTICOListViewController" andParams:nil];
            [MobClick event:@"ico"];
        }];
        [_setionOneView addGestureRecognizer:tap];
        
    }
    return _setionOneView;
}

//糖果专区
- (BTDiscoverySetionOneView *)setionTwoView {
    if (!_setionTwoView) {
        _setionTwoView = [BTDiscoverySetionOneView loadFromXib];
        _setionTwoView.titleL.fixText = @"tangguozhuanqu";
        _setionTwoView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [BTCMInstance pushViewControllerWithName:@"BTCandyViewController" andParams:nil];
            [MobClick event:@"candy"];
        }];
        [_setionTwoView addGestureRecognizer:tap];
    }
    return _setionTwoView;
}

#pragma mark -- UITableView Delegate DataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        BTCollegeMainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTCollegeMainCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setItemView:self.colleageData];
        return cell;
        
    }else if(indexPath.section == 1){
        BTICOMainCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BTICOMainCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setItemView:self.icoListArr];
        return cell;
    }
    BTCandyMainCell *cell =[tableView dequeueReusableCellWithIdentifier:@"BTCandyMainCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setItemView:self.candyArr];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) return 115.0f;
    if(indexPath.section == 1) return 108.0f;
    return 188.0f +40.0f;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) return self.setionOneView;
    if(section == 2) return self.setionTwoView;
    return self.setionColleageView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    QutoesDetailMarket *model = self.dataArray[indexPath.row];
//    NSData *data = [model modelToJSONData];
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    [BTCMInstance pushViewControllerWithName:@"quotesdetail" andParams:dic];
}

#pragma mark -- BTMenuContainer Delegate
- (void)menuView:(BTDiscovMenuContainerView *)containerView didClickIndex:(NSInteger)index{
    switch (index) {
        case 1:
            [BTCMInstance pushViewControllerWithName:@"NewCurrencyOnSaleVC" andParams:nil];
            [AnalysisService alaysisfind_page_xinbi];
            break;
        case 2:
            [BTCMInstance pushViewControllerWithName:@"CurrencyConceptsVC" andParams:nil];
            [AnalysisService alaysisfind_page_gainian];
            break;
        case 3:{
            [BTCMInstance pushViewControllerWithName:@"xianhuoVC" andParams:nil];
            [AnalysisService alaysisfind_page_xianhuo];
            
            break;
        }
        case 4:{
            [BTCMInstance pushViewControllerWithName:@"FutureList" andParams:nil];
            [AnalysisService alaysisfind_page_qihuo];
            break;
        }
        default:
            break;
    }
}
#pragma mark --DiscoveryRollImagesViewDelegate
//点击轮播  可配置页面
- (void)rollImagesView:(DiscoveryRollImagesView *)rollView didClickIndex:(NSInteger)index{
    NSDictionary *dict = self.bannersArray[index];
    NSInteger urlType = [SAFESTRING(dict[@"urlType"]) integerValue];
    NSString *url = SAFESTRING(dict[@"url"]);
    NSString *refId = SAFESTRING(dict[@"refId"]);
   
    switch (urlType) {
        case 1://内部网页
        {
            if(url.length > 0){
                H5Node *node =[[H5Node alloc] init];
                node.webUrl = url;
                node.title = SAFESTRING(dict[@"title"]);
                [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
            }
        }
            
            break;
        case 2:// 外部网页
        {
            if(url.length > 0){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            }
        }
            
            break;
            
        case 3://要闻
        {
            if(refId.length >0){
                [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":refId}];
            }
        }
            
            break;
        case 4://探报
        {
            if(refId.length >0){
                [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":refId,@"bigType":@(6)}];
            }
        }
            
            break;
        case 5://帖子
        {
            if(refId.length >0){
                [BTCMInstance pushViewControllerWithName:@"BTPostDetailViewController" andParams:@{@"postId":refId}];
            }
        }
            
            break;
        case 6: //攻略
        {
            if(refId.length >0){
                [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":refId,
                                                                                          @"whereVC":@"攻略"
                                                                                          }];
            }
        }
            break;
        case 7://讨论
        {
            if(refId.length >0){
                [BTCMInstance pushViewControllerWithName:@"TopicVC" andParams:@{@"refId":refId}];
            }
        }
            
            break;
            
        case 8:{// 我的探力
            if (![getUserCenter isLogined]) {
                [AnalysisService alaysisMine_login];
                [getUserCenter loginoutPullView];
                return;
            }
            BTIsSignInRequest *request = [BTIsSignInRequest new];
            [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
                if ([request.data integerValue]) {//表示已经签到
                    [BTCMInstance pushViewControllerWithName:@"BTNewMyTanLiMain" andParams:nil];
                }else{//未签到
                    [BTCMInstance pushViewControllerWithName:@"BTNewMyTanLiMain" andParams:@{@"isContinue":@(YES)}];
                }
            } failure:^(__kindof BTBaseRequest *request) {
            }];
        }
            break;
            
            
        default:
            break;
    }
   
}

#pragma mark - iCarousel代理
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return self.bannersArray.count;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view{
    
    UIImageView *imgView = (UIImageView*)view;
    if (imgView == nil) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 280, 112)];
        ViewRadius(imgView, 6);
    }
  
    NSString *str =  [getUserCenter getImageURLSizeWithWeight:ScreenWidth*2 andHeight:150*2];
    NSString *url =[NSString stringWithFormat:@"%@?%@",SAFESTRING(self.bannersArray[index][@"image"]),str];
    [url hasPrefix:@"http"]?[imgView sd_setImageWithURL:[NSURL URLWithString:url]]:[imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoImageURL,url]]];
    
    return imgView;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    switch (option) {
            
        case iCarouselOptionVisibleItems:
            return 3;
        
        case iCarouselOptionArc:
            return value*carousel.numberOfItems/10;
            
            //设置没个界面直接的间隙
        case iCarouselOptionSpacing:
            return value*1.28;
        default:
            return value;
            break;
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    DLog(@"---点击了%ld--",index);
    
    [AnalysisService alaysisfind_page_lunbo_01];
    [AnalysisService alaysisfind_page_lunbo_01_index:index];
    NSDictionary *dict = self.bannersArray[index];
    NSString *url = SAFESTRING(dict[@"url"]);
    H5Node *node =[[H5Node alloc] init];
    node.webUrl = url;
    node.title = SAFESTRING(dict[@"title"]);
    if(url.length > 0){
        [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
    }
}


- (void)refreshingData{
    [self loadData];
}

- (void)messageNaviBtnClick:(UIButton *)btn{
    
    if ([getUserCenter isLogined]) {
        [AnalysisService alaysisHome_message];
        [BTCMInstance pushViewControllerWithName:@"MessageCenter" andParams:nil];
    } else {
        [getUserCenter loginoutPullView];
    }
}
//自选
- (void)requestList{
    if (getUserCenter.userInfo.token.length == 0) {
        [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil animated:YES];
        return;
    }
    if(_groupListApi.isExecuting){
        [_groupListApi stop];
    }
    if(_exchangeListApi.isExecuting){
        [_exchangeListApi stop];
    }
//    [BTShowLoading show];
    _groupListApi = [[BTGroupListRequest alloc]init];
    [_groupListApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
        if(request.data&&[request.data isKindOfClass:[NSArray class]]){
            NSMutableArray *data =@[].mutableCopy;
            
            BTGroupListModel *modelAll = [[BTGroupListModel alloc] init];
            modelAll.groupName = [APPLanguageService sjhSearchContentWith:@"quanbu"]; //@"全部";
            modelAll.userGroupId = ALL_GROUP_ID;
            [data addObject:modelAll];
            
            NSMutableArray *infoArr =@[].mutableCopy;
            for (NSDictionary *dict in request.data){
                BTGroupListModel *info =[BTGroupListModel objectWithDictionary:dict];
                [infoArr addObject:info];
            }
            if(!appDelegate.listModel){
                self.listModel.userGroupId = ALL_GROUP_ID;
            }else{
                self.listModel = appDelegate.listModel;
            }
            NSArray *reverseArr =[[infoArr reverseObjectEnumerator] allObjects];
            [data addObjectsFromArray:reverseArr];
            for (BTGroupListModel *info in data){
                if(info.userGroupId == self.listModel.userGroupId){
                    info.isSelected = YES;
                }
            }
            [GroupSideView showWithArr:data completion:^(BTGroupListModel *model) {
                self.listModel = model;
                //选择完 给自选页面发个通知，通知刷新数据
                [[NSNotificationCenter defaultCenter] postNotificationName:k_Notification_Refresh_Select_Group object:model];
                appDelegate.listModel = model;
                [self.tabBarController setSelectedIndex:1];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_Switch_List_Bar object:model];
            }];
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
    }];
}

- (void)refreshSelectGroup:(NSNotification*)notify{
    BTGroupListModel *listModel = (BTGroupListModel*)notify.object;
    self.listModel = listModel;
}

#pragma mark --Customer Accessor
-(UITableView*)mTableView{
    if(!_mTableView){
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        if(IOS_VERSION >=11.0f){
            _mTableView.estimatedSectionHeaderHeight=0.0;
            _mTableView.estimatedSectionFooterHeight=0.0;
        }
        _mTableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator =NO;
        _mTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView =footView;
    }
    return _mTableView;
}

@end
