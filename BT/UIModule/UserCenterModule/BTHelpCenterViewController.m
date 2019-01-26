//
//  BTHelpCenterViewController.m
//  BT
//
//  Created by apple on 2018/10/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTHelpCenterViewController.h"
#import "BTHelpCenterCell.h"
#import "BTHelpCenterListApi.h"
@interface BTHelpCenterViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UILabel *nameL;
@property (nonatomic, strong) UIButton *contactBtn;
@property (nonatomic, assign) NSInteger pageIndex;

@end

@implementation BTHelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [APPLanguageService sjhSearchContentWith:@"bangzhuzhongxin"];
    [self createUI];
    [self loadData];
}

- (void)createUI{
    self.view.backgroundColor = ViewBGColor;
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, iPhoneX?102:68, 0));
    }];
    [self.view addSubview:self.contactBtn];
    [self.contactBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(iPhoneX?(-34):(-10));
        make.height.mas_equalTo(48);
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:nil delegate:self];
}

- (void)refreshingData{
    [self requestList:RefreshStateNormal];
}
- (void)loadData{
    [self requestList:RefreshStateNormal];
}
- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    BTHelpCenterListApi *api = [[BTHelpCenterListApi alloc] initWithCurrentPage:self.pageIndex];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            if ([request.data count]) {
                
                [self.loadingView hiddenLoading];
            } else {
                [self.loadingView showNoDataWith:@"zanwushuju"];
            }
            
            if ([request.data count] < BTPagesize) {
                self.mTableView.mj_footer.hidden = YES;;
            }else{
                [self.mTableView.mj_footer endRefreshing];
            }
        }else if (state == RefreshStateUp){
            if ([request.data count] < BTPagesize) {
                [self.mTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.mTableView.mj_footer endRefreshing];
            }
        }
        for (NSDictionary *dic in request.data) {
            BTHelpCenterModel *model = [BTHelpCenterModel modelWithJSON:dic];;
            [self.dataArray addObject:model];
        }
        [self.mTableView.mj_header endRefreshing];
        [self.mTableView reloadData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.mTableView.mj_header endRefreshing];
        [self.mTableView.mj_footer endRefreshing];
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
#pragma mark --Customer Accessor
- (UITableView*)mTableView{
    if(!_mTableView){
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        if(IOS_VERSION >=11.0f){
            _mTableView.estimatedSectionHeaderHeight = 0.0;
            _mTableView.estimatedSectionFooterHeight = 0.0;
        }
        [_mTableView registerNib:[UINib nibWithNibName:@"BTHelpCenterCell" bundle:nil] forCellReuseIdentifier:@"BTHelpCenterCell"];
        _mTableView.backgroundColor = CViewBgColor;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator = NO;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView = footView;
        _mTableView.tableHeaderView = self.headerView;
        _mTableView.tag = 100000;
    }
    return _mTableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTHelpCenterModel *currentModel = self.dataArray[indexPath.row];
    if(!currentModel.isExpand){
        return 52.0f;
    }else{
        NSString *content;
        if([[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]){
            content = SAFESTRING(currentModel.answer);
        }else{
            content = SAFESTRING(currentModel.answerEn);
        }
        NSMutableParagraphStyle *wordStyle = [[NSMutableParagraphStyle alloc] init];
        wordStyle.lineSpacing = 6.0f;
        CGFloat height = [content boundingRectWithSize:CGSizeMake(ScreenWidth - 45, 10000) options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSParagraphStyleAttributeName:wordStyle} context:nil].size.height;
        return 52.0f + height + 25 +6;;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BTHelpCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BTHelpCenterCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BTHelpCenterModel *currentModel = self.dataArray[indexPath.row];
    for(BTHelpCenterModel *model in self.dataArray){
        if(model !=currentModel){
            model.isExpand = NO;
        }
    }
    currentModel.isExpand = !currentModel.isExpand;
    [self.mTableView reloadData];
}

#pragma mark --
- (UIView*)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
        _headerView.backgroundColor = isNightMode? ViewContentBgColor: CWhiteColor;
        UIImageView *bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"problem_bg"]];
        [_headerView addSubview:bg];
        [bg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(15);
            make.right.equalTo(_headerView).offset(-15);
            make.top.equalTo(_headerView).offset(20);
            make.height.mas_equalTo(120);
        }];
        bg.layer.cornerRadius = 6.0f;
        bg.layer.masksToBounds = YES;
        _nameL = [UILabel labelWithFrame:CGRectZero title:@"" font:[UIFont systemFontOfSize:24] textColor:[UIColor whiteColor]];
        [_headerView addSubview:_nameL];
        [_nameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(44);
            make.top.equalTo(_headerView).offset(46.0f);
        }];
        if(SAFESTRING([BTGetUserInfoDefalut sharedManager].userInfo.token).length == 0){
               _nameL.text = SAFESTRING([APPLanguageService wyhSearchContentWith:@"noLogin"]);
        }else{
            _nameL.text = [NSString stringWithFormat:@"Hi，%@",SAFESTRING(getUserCenter.detailMyInfo.username)];
        }
      
        BTLabel *desL = [[BTLabel alloc] initWithFrame:CGRectZero];
        desL.font = FONTOFSIZE(14);
        desL.textColor = kHEXCOLOR(0x78C6FF);
        desL.fixText = @"bitanzushouyiwen";
        [_headerView addSubview:desL];
        [desL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(44);
            make.top.equalTo(_nameL.mas_bottom).offset(9);
        }];
        
    }
    return _headerView;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UIButton*)contactBtn{
    if(!_contactBtn){
        _contactBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        _contactBtn.backgroundColor = MainBg_Color;
        [_contactBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _contactBtn.titleLabel.font = FONTOFSIZE(16.0f);
        _contactBtn.layer.cornerRadius = 4.0f;
        _contactBtn.layer.masksToBounds = YES;
        [_contactBtn setTitle:[APPLanguageService wyhSearchContentWith:@"lianxiwomen"] forState:UIControlStateNormal];
        [_contactBtn bk_addEventHandler:^(id  _Nonnull sender) {
             [BTCMInstance pushViewControllerWithName:@"BTContactUsViewController" andParams:nil];
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _contactBtn;
}
@end
