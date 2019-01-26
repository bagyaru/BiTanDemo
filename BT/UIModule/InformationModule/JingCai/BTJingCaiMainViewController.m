//
//  BTJingCaiMainViewController.m
//  BT
//
//  Created by admin on 2018/7/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTJingCaiMainViewController.h"
#import "BTJingCaiMainCell.h"
#import "InformationModuleRequest.h"
#import "BTjingcaiMainModel.h"
#import "BannersRequest.h"
#import "BTJingCaiMainView.h"
#import "BTJingCaiTZAlertView.h"
#import "SEFilterControl.h"
static NSString *const identifier = @"BTJingCaiMainCell";
@interface BTJingCaiMainViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate> {
    
    BOOL  _shown;
    NSInteger _total;
    NSArray  *_titles;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) BTJingCaiMainView *seletView;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) BTJingCaiTZAlertView *tzAlertView;
@property (nonatomic, strong) BTView *backView;
@property(nonatomic,strong) SEFilterControl *sliderView;
@end

@implementation BTJingCaiMainViewController
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationItemWithTitles:@[@"我的竞猜"] isLeft:NO target:self action:@selector(myjcBtnClcik) tags:@[@(100)] whereVC:@"我的竞猜"];
    [self creatUI];
    // Do any additional setup after loading the view from its nib.
}
-(void)myjcBtnClcik {
    
    [BTCMInstance pushViewControllerWithName:@"BTMyJingCai" andParams:nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [self registerNsNotification];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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
-(void)creatUI {
    _shown = NO;
    self.pageIndex   = 1;
    self.selectIndex = 1;
    self.title = [APPLanguageService wyhSearchContentWith:@"jingcai"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTJingCaiMainCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = CViewBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    self.seletView.frame = self.topView.frame;
    [self.topView addSubview:self.seletView];
    _tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
    }];
    
    _tableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        self.pageIndex++;
        [self requestList:RefreshStateUp];
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
    [self requestList:RefreshStateNormal];
}

- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    InformationModuleRequest *api = [[InformationModuleRequest alloc] initWithType:@"5" keyword:@"" pageIndex:self.pageIndex subType:-1];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            if ([request.data count]) {
                
                [self.loadingView hiddenLoading];
            } else {
                
                [self.loadingView showNoDataWith:@"zanwushuju"];
            }
            for (NSDictionary *dic in request.data) {
                BTjingcaiMainModel *obj = [BTjingcaiMainModel objectWithDictionary:dic];
                
                [self.dataArray addObject:obj];
                
            }
            if ([request.data count] < BTPagesize) {
                self.tableView.mj_footer.hidden = YES;;
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView.mj_header endRefreshing];
        }else if (state == RefreshStateUp){
            if ([request.data count] < BTPagesize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            for (NSDictionary *dic in request.data) {
                
                
                BTjingcaiMainModel *obj = [BTjingcaiMainModel objectWithDictionary:dic];
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
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.selectIndex == 1 ? 194.5 : 156.5;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BTJingCaiMainCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle     = UITableViewCellSelectionStyleNone;
    cell.selectIndex        = self.selectIndex;
    cell.model              = self.dataArray[indexPath.row];
    WS(ws);
    cell.JCBlock = ^(NSInteger type, BTjingcaiMainModel *model) {
        
        NSLog(@"========%@=========",type == 11 ? @"支持" : @"反对");
        _total = 99;
        _titles = @[@"",[NSString stringWithFormat:@"%ld",_total/4],[NSString stringWithFormat:@"%ld",_total/4*2],[NSString stringWithFormat:@"%ld",_total/4*3],[NSString stringWithFormat:@"%ld",_total]];
        
        [ws show_tzAlertView];
    };
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    [BTCMInstance pushViewControllerWithName:@"BTJingCaiDetail" andParams:@{@"refId":@"53131",@"selectIndex":[NSString stringWithFormat:@"%ld",self.selectIndex]}];
}

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
//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
    //获取键盘的高度
    NSLog(@"竞猜主页面=====当键盘出现%@",notification.userInfo);
    [self.tzAlertView.textField becomeFirstResponder];
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    self.tzAlertView.frame = CGRectMake(0, ScreenHeight-height-240, ScreenWidth, 240);
    
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    
    NSLog(@"竞猜主页面=====当键退出");
    self.tzAlertView.frame = CGRectMake(0, ScreenHeight-240, ScreenWidth, 240);
    
}
#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(BTJingCaiMainView *)seletView {
    
    if (!_seletView) {
        _seletView = [BTJingCaiMainView loadFromXib];
        [_seletView.zfBtn bk_addEventHandler:^(id  _Nonnull sender) {
            //[AnalysisService alaysisfind_page_zfb];
            if(self.selectIndex == 1) return;
            [self.seletView setZfColor];
            self.selectIndex = 1;
            [self.tableView reloadData];
//          [self requestUpAndDownList:RefreshStatePull];
        } forControlEvents:UIControlEventTouchUpInside];
        
        [_seletView.dfBtn bk_addEventHandler:^(id  _Nonnull sender) {
            if(self.selectIndex == 2) return;
            [self.seletView setDfColor];
            self.selectIndex = 2;
            [self.tableView reloadData];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _seletView;
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
