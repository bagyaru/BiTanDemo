//
//  NewsViewController.m
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "NewsViewController.h"
#import "BTInfomationSameCell.h"
#import "InformationModuleRequest.h"
#import "BannersRequest.h"
#import "FastInfomationObj.h"
#import "MKRollImagesView.h"
#import "H5InfomationDetailViewController.h"
#import "NewsHeadView.h"
#import "NewRecommendedView.h"
static NSString *const identifier = @"BTInfomationSameCell";
@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource,MKRollImagesViewDelegate,BTLoadingViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *bannersArray;
@property (nonatomic, strong) NSMutableArray *topicsArray;
@property (strong, nonatomic) MKRollImagesView *rollImageView;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) NewsHeadView  *headView;
@property (nonatomic, strong) NewRecommendedView  *recommendedView;
@property (nonatomic, strong) UIView *b;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AnalysisService alaysisNews_headlines];
    [self creatUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRequest) name:NSNotification_SheQu_needRequest object:nil];
    //[self creatNewsHead];
    // Do any additional setup after loading the view from its nib.
}
- (void)needRequest{
    if (self.dataArray.count > 0) {
        return;
    }
    NSInteger index = [BTConfigureService shareInstanceService].sheQuIndex;
    NSArray *vcs = [[self.navigationController visibleViewController] childViewControllers];
    if (index < vcs.count) {
        if ([vcs[index] isEqual:self]) {
            [self requestList:RefreshStateNormal];//新闻列表
            [self loadBannerData];//banner列表
        }
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [BTThreeManager sharedInstance].typeStr = @"社区";
}

- (void)creatUI {
     self.pageIndex = 1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTInfomationSameCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = CViewBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
        [self loadBannerData];//banner列表
//        [self loadTopicData]; //话题列表
    }];
    [_tableView configToTop:^{
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
        [self loadBannerData];//banner列表
    }];
    _tableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        self.pageIndex++;
        [self requestList:RefreshStateUp];
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
//    [self requestList:RefreshStateNormal];//新闻列表
//    [self loadBannerData];//banner列表
//    [self loadTopicData]; //话题列表
}
- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    InformationModuleRequest *api = [[InformationModuleRequest alloc] initWithType:[NSString stringWithFormat:@"%ld",self.bigType] keyword:@"" pageIndex:self.pageIndex subType:-1];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            if ([request.data count]) {
                
                [self.loadingView hiddenLoading];
            } else {
                
                [self.loadingView showNoDataWith:@"zanwushuju"];
            }
            for (NSDictionary *dic in request.data) {
                FastInfomationObj *obj = [FastInfomationObj objectWithDictionary:dic];
            
                if (ISNSStringValid(obj.imgUrl)) {
                    
                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:80*2 andHeight:80*2];
                    obj.imgUrl = [NSString stringWithFormat:@"%@?%@",obj.imgUrl,str];
                }
        
                if ([dic[@"user"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *userDict = dic[@"user"];
                    obj.avatar             = SAFESTRING(userDict[@"avatar"]);
                    obj.followed           = [userDict[@"followed"] boolValue];
                    obj.introductions      = SAFESTRING(userDict[@"introductions"]);
                    obj.nickName           = SAFESTRING(userDict[@"nickName"]);
                    obj.userId             = [userDict[@"userId"] integerValue];
                    obj.authStatus         = [userDict[@"authStatus"] integerValue];
                    obj.authType           = [userDict[@"authType"] integerValue];
                }
                [self.dataArray addObject:obj];
                
            }
       
            [self.tableView.mj_header endRefreshing];
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
            for (NSDictionary *dic in request.data) {
                
                
                FastInfomationObj *obj = [FastInfomationObj objectWithDictionary:dic];
                if (ISNSStringValid(obj.imgUrl)) {
                    
                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:80*2 andHeight:80*2];
                    obj.imgUrl = [NSString stringWithFormat:@"%@?%@",obj.imgUrl,str];
                }
                if ([dic[@"user"] isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *userDict = dic[@"user"];
                    obj.avatar             = SAFESTRING(userDict[@"avatar"]);
                    obj.followed           = [userDict[@"followed"] boolValue];
                    obj.introductions      = SAFESTRING(userDict[@"introductions"]);
                    obj.nickName           = SAFESTRING(userDict[@"nickName"]);
                    obj.userId             = [userDict[@"userId"] integerValue];
                    obj.authStatus         = [userDict[@"authStatus"] integerValue];
                    obj.authType           = [userDict[@"authType"] integerValue];
                }
                [self.dataArray addObject:obj];
            }
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
    [self loadBannerData];//banner列表
//    [self loadTopicData]; //话题列表
}
-(void)loadBannerData {
    
    BannersRequest *api = [[BannersRequest alloc] initWithType:self.bigType];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        //[self.loadingView hiddenLoading];
        [self.bannersArray removeAllObjects];
        NSMutableArray *urls = @[].mutableCopy;
        NSMutableArray *titles = @[].mutableCopy;
        for (NSDictionary *dic in request.data) {
            
            FastInfomationObj *obj = [FastInfomationObj objectWithDictionary:dic];
            NSString *str =  [getUserCenter getImageURLSizeWithWeight:ScreenWidth*2 andHeight:180*2];
            obj.imgUrl = [NSString stringWithFormat:@"%@?%@",obj.imgUrl,str];
            [self.bannersArray addObject:obj];
            [urls addObject:obj.imgUrl];
            [titles addObject:obj.title];
        }
        if (self.bannersArray.count > 0) {
            self.rollImageView.bannerUrls = urls;
            self.rollImageView.titles     = titles;
            self.tableView.tableHeaderView = self.rollImageView;
            //[self creatRecommendedView];
        }else {
            
            self.tableView.tableHeaderView = nil;
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
//请求话题数据
-(void)loadTopicData {
    
    BannersRequest *api = [[BannersRequest alloc] initWithType:4];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        [self.topicsArray removeAllObjects];
        for (NSDictionary *dic in request.data) {
            
            FastInfomationObj *obj = [FastInfomationObj objectWithDictionary:dic];
            NSString *str =  [getUserCenter getImageURLSizeWithWeight:184*2 andHeight:104*2];
            obj.imgUrl = SAFESTRING(obj.imgUrl);
            obj.imgUrl = [NSString stringWithFormat:@"%@?%@",[obj.imgUrl hasPrefix:@"http"]?obj.imgUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,obj.imgUrl],str];
            
            [self.topicsArray addObject:obj];
        }
       self.headView.dataArray = self.topicsArray;

    } failure:^(__kindof BTBaseRequest *request) {
        
         [self.loadingView showErrorWith:request.resultMsg];
    }];
}
//头部（暂不用）
-(void)creatNewsHead {
    
    [self.headView.bannerView addSubview:self.rollImageView];
    self.headView.goDetailBlack = ^(NSString *detailID) {
        
        NSLog(@"%@",detailID);
        [BTCMInstance pushViewControllerWithName:@"TopicVC" andParams:@{@"refId":detailID}];
    };
    self.b.frame = CGRectMake(0, 0, ScreenWidth, 380);
    self.headView.frame = self.b.frame;
    [self.b addSubview:self.headView];
    self.tableView.tableHeaderView = self.b;
}
//头部（新的）
-(void)creatRecommendedView {
    if (self.bannersArray.count > 0) {
        
        self.recommendedView.model = self.bannersArray[0];
        self.b.frame = CGRectMake(0, 0, ScreenWidth, [self.recommendedView getHeadViewHeight]);
        self.recommendedView.frame = self.b.frame;
        [self.recommendedView.goDetailBtn addTarget:self action:@selector(goDetailBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [self.b addSubview:self.recommendedView];
        self.tableView.tableHeaderView = self.b;
    }
}
//推荐点击
-(void)goDetailBtnClick {
    
    [AnalysisService alaysisNews_headlines_rotation];
    if (self.bannersArray.count > 0) {
        FastInfomationObj *obj = self.bannersArray[0];
        [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":obj.infoID,@"bigType":@(self.bigType)}];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FastInfomationObj *obj = self.dataArray[indexPath.row];
    BTInfomationSameCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell creatUIWith:obj];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.bigType == 6) {
        [MobClick event:@"tanbao_list"];
    }else {
        [AnalysisService alaysisNews_headlines_list];
    }
     FastInfomationObj *obj = self.dataArray[indexPath.row];
    
    [[BTSearchService sharedService] writeSheQuHistoryRead:obj];
    [self.tableView reloadData];
     [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":obj.infoID,@"bigType":@(self.bigType)}];

}
#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)bannersArray{
    if (!_bannersArray) {
        _bannersArray = [NSMutableArray array];
    }
    return _bannersArray;
}
-(NSMutableArray *)topicsArray {
    
    if (!_topicsArray) {
        
        _topicsArray = [[NSMutableArray alloc] init];
    }
    return _topicsArray;
}
//点击banner图的跳转
-(void)rollImagesView:(MKRollImagesView *)rollView didClickIndex:(NSInteger)index {
    if (self.bigType == 6) {
        [MobClick event:@"tanbao_rotation"];
    }else {
        [MobClick event:@"news_rotation"];
    }
    FastInfomationObj *obj = self.bannersArray[index];
    [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":obj.infoID,@"bigType":@(self.bigType)}];
}
#pragma mark lazy
-(NewsHeadView *)headView {
    
    if (!_headView) {
        _headView = [NewsHeadView loadFromXib];
        //_headView.frame = CGRectMake(0, 0, ScreenWidth, 434);
    }
    
    return _headView;
}
-(MKRollImagesView *)rollImageView {
    
    if (!_rollImageView) {
        
        [BTThreeManager sharedInstance].typeStr = @"社区";
        _rollImageView = [[MKRollImagesView alloc] init];
        _rollImageView.frame = CGRectMake(0, 0, ScreenWidth, 180);
        _rollImageView.placeHolderImage = [UIImage imageNamed:@"Mask_list"];
        _rollImageView.delegate = self;
        [_rollImageView autoRollEnable:YES];
    }
    
    return _rollImageView;
}
-(UIView *)b {
    
    if (!_b) {
        
        _b = [[UIView alloc] init];
    }
    
    return _b;
}
-(NewRecommendedView *)recommendedView {
    
    if (!_recommendedView) {
        
        _recommendedView = [NewRecommendedView loadFromXib];
    }
    return _recommendedView;
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
