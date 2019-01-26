//
//  QuoteProfitLossStatVC.m
//  BT
//
//  Created by apple on 2018/3/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QuoteProfitLossStatVC.h"
#import "UILabel+Factory.h"
#import "BTProfitLossHeaderView.h"
#import "MenuHrizontal.h"
#import "BTRecordCell.h"
#import "ProfitRecordHeaderCell.h"

#import "ProfitLossDetailRequest.h"
#import "BTRecordModel.h"
#import "CurrencyModel.h"
#import "LncomeStatisticsMainObj.h"
#import "OneEntityVoObj.h"
#import "BTDeteleRecordAlert.h"
#import "BTDeleteRecordRequest.h"
#import "ProfitHeadView.h"

@interface QuoteProfitLossStatVC ()<UITableViewDelegate,UITableViewDataSource,MenuHrizontalDelegate,BTLoadingViewDelegate>{
    LncomeStatisticsMainObj *_detailObj;
}

@property (nonatomic, strong) NSDictionary *dic;
@property (nonatomic, strong) UIView *naviView;
@property (nonatomic, strong) BTProfitLossHeaderView *profitLossHeaderView;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) MenuHrizontal *menuBtn;
@property (nonatomic, strong) UIView *remindFootView;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) NSMutableArray *recordArr;//记录数据
@property (nonatomic, strong) NSMutableArray *remindArr;//提醒数据
@property (nonatomic, strong) NSMutableArray *arrKLine;
@property (nonatomic, strong) NSMutableArray *arrFenshi;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, assign) NSInteger type;//menu 类型
@property (nonatomic, assign) BOOL isShizhi;
@property (nonatomic, strong)CurrencyModel*cryModel;
@property (nonatomic, strong)UIView *guideView;
@property (nonatomic, strong) BTLoadingView *loadingView;

@property (nonatomic, strong)ProfitHeadView *headView;

@property (nonatomic, strong) UIView *topHeaderView;


@end

static NSString *const identifierAddRecord = @"ProfitRecordHeaderCell";
static NSString *const identifierRecord = @"BTRecordCell";

static NSString *const identifierRemind = @"BTRemindCell";

@implementation QuoteProfitLossStatVC

+ (id)createWithParams: (NSDictionary *)params{
    QuoteProfitLossStatVC *vc = [[QuoteProfitLossStatVC alloc] init];
    [vc updateParams:params];
    return vc;
}

- (void)updateParams:(NSDictionary *)params{
    self.dic = params;
}

#pragma mark -Life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDeleteRecord) name:@"refreshRecord" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshRecord" object:nil];
}

//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
#pragma mark -- Create UI
- (void)createUI{
//    [self.view addSubview:self.naviView];
//    [self.naviView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.top.equalTo(self.view);
//        make.height.mas_equalTo(iPhoneX?88.0f:64.0f);
//    }];
    //[self.view addSubview:self.profitLossHeaderView];
    //self.profitLossHeaderView.frame =CGRectMake(0, 0, ScreenWidth, 136);
    //[self.view addSubview:self.topHeaderView];
    
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.mTableView.tableHeaderView = self.topHeaderView;
    
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:self.mTableView delegate:self];
    if (@available(iOS 11.0, *)) {
        self.mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.addBtn];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-15);
        make.width.height.mas_equalTo(52);
    }];
}

- (UIView*)topHeaderView{
    if(!_topHeaderView){
        _topHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, (iPhoneX?215.0f:191.0f)+40)];
        [_topHeaderView addSubview:self.headView];
        
        [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_topHeaderView);
        }];
    }
    return _topHeaderView;
}

- (ProfitHeadView*)headView{
    if(!_headView){
        _headView = [ProfitHeadView loadFromXib];
        _headView.titleL.text = SAFESTRING(self.dic[@"kindCode"]);
        if(iPhoneX){
            _headView.heightLayout.constant = 88.0f;
        }
        [_headView layoutIfNeeded];
    }
    return _headView;
}

#pragma mark -- Load Data
- (void)loadData{
    _type = 1;
    _recordArr =@[].mutableCopy;
    _remindArr =@[].mutableCopy;
    _arrKLine =@[].mutableCopy;
    _arrFenshi =@[].mutableCopy;
    [self.mTableView reloadData];
    [self detailRequest];
}

- (void)detailRequest{
    [self.loadingView showLoading];
    ProfitLossDetailRequest *detailRequest = [[ProfitLossDetailRequest alloc] initWithKind:SAFESTRING(self.dic[@"kindCode"])];
    [detailRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        _recordArr = @[].mutableCopy;
        if([request.data isKindOfClass:[NSDictionary class]]){
            NSDictionary *data =request.data;
            LncomeStatisticsMainObj *detailObj = [LncomeStatisticsMainObj objectWithDictionary:request.data];
            self.headView.obj = detailObj;
            _detailObj = detailObj;
            for(NSDictionary *subDict in data[@"detailVOList"]){
                BTRecordModel *model =[BTRecordModel objectWithDictionary:subDict];
                [_recordArr addObject:model];
            }
            [self.mTableView reloadData];
            
            if(_recordArr.count == 0){//删除完之后通知刷新列表
                [BTCMInstance popViewController:nil];
            }
           
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    [self detailRequest];
}

#pragma mark --Custom Accessor
- (BTProfitLossHeaderView*)profitLossHeaderView{
    if(!_profitLossHeaderView){
        _profitLossHeaderView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BTProfitLossHeaderView class]) owner:self options:nil][0];
    }
    return _profitLossHeaderView;
}

- (MenuHrizontal*)menuBtn{
    if(!_menuBtn){
        _menuBtn =[[MenuHrizontal alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 34.0f)];
        _menuBtn.delegate = self;
        _menuBtn.backgroundColor = kHEXCOLOR(0x2C3744);
        _menuBtn.lineBtnArr =@[@{@"name":@"行情"},@{@"name":@"记录"},@{@"name":@"提醒"}];
        [_menuBtn clickButtonAtIndex:0];
    }
    return _menuBtn;
}

- (UIButton*)addBtn{
    if(!_addBtn){
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:[UIImage imageNamed:@"ic_wodezichan-tianjia"] forState:UIControlStateNormal];
        WS(weakSelf)
        [_addBtn bk_addEventHandler:^(id  _Nonnull sender) {
            [BTCMInstance pushViewControllerWithName:@"BTNewAddRecord" andParams:@{@"kind":SAFESTRING(self.dic[@"kindCode"]),@"isDetail":@"YES"} completion:^(id obj) {
                [weakSelf detailRequest];
                
            }];
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

-(UITableView*)mTableView{
    if(!_mTableView){
        _mTableView =[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate=self;
        _mTableView.dataSource=self;
        if(IOS_VERSION >= 11.0f){
            _mTableView.estimatedSectionHeaderHeight=0.0;
            _mTableView.estimatedSectionFooterHeight=0.0;
        }
        _mTableView.separatorColor = kHEXCOLOR(0xdddddd);
        _mTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _mTableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator =NO;
        [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTRecordCell class]) bundle:nil] forCellReuseIdentifier:identifierRecord];
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView =footView;
    }
    return _mTableView;
}
#pragma mark- UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recordArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    BTRecordModel *model =self.recordArr[indexPath.row];
    NSString *str = SAFESTRING(model.note).length>0?[NSString stringWithFormat:@"%@:%@",[APPLanguageService wyhSearchContentWith:@"beizhu_New"],model.note]:[NSString stringWithFormat:@"%@:%@",[APPLanguageService wyhSearchContentWith:@"beizhu_New"],[APPLanguageService wyhSearchContentWith:@"wu"]];
    CGFloat H = [self getSpaceLabelHeight:str withFont:SYSTEMFONT(12) withWidth:ScreenWidth - 30 withHJJ:0.0 withZJJ:0.0];
    if(H < 17){
        H = 17;
    }
    return 128.0f + 15 + H;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BTRecordModel *model = self.recordArr[indexPath.row];
    model.kind = [NSString stringWithFormat:@"%@/%@",_detailObj.kind,model.relevantKind];
    [AnalysisService alaysisIncome_add_button];
    [BTCMInstance pushViewControllerWithName:@"BTNewAddRecord" andParams:@{@"kind":@"",@"model":model} completion:^(id obj) {
        [self detailRequest];
        
    }];
}

-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width withHJJ:(CGFloat)HJJ withZJJ:(CGFloat)ZJJ{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = HJJ;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle, NSKernAttributeName:@(ZJJ)
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 1000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTRecordModel *model = self.recordArr[indexPath.row];
    model.totalCount = self.recordArr.count-1;
    BTRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierRecord forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.kind = _detailObj.kind;
    cell.model = model;
    return cell;
}

#pragma mark -- Event Response
- (void)refreshRecord{
    [self detailRequest];
}

- (void)refreshDeleteRecord{
    [self detailRequest];
}

- (void)pop{
    [BTCMInstance popViewController:nil];
}


@end
