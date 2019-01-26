//
//  MyNewCollectionViewController.m
//  BT
//
//  Created by admin on 2018/4/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyNewCollectionViewController.h"
#import "BTInfomationSameCell.h"
#import "StrategyCell.h"
#import "MyCollectionRequest.h"
#import "FastInfomationObj.h"

#import "BTBatchFavorsRequest.h"
static NSString *const identifier = @"BTInfomationSameCell";
static NSString *const identifier1 = @"StrategyCell";
@interface MyNewCollectionViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (strong, nonatomic) UIView *editingView;
@property (strong, nonatomic) UIButton *buttonAllSeleted;
@property (strong, nonatomic) UIButton *buttonDelete;
@property (strong, nonatomic) UIButton *rightBarButton;
@end

@implementation MyNewCollectionViewController

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CollectionChange
                                                  object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self creatUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:CollectionChange object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)notice:(NSNotification *)notifi {
    
    NSLog(@"收藏状态改变通知");
    [self requestList:RefreshStateNormal];
}
#pragma mark -- UI
- (void)initUI{
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:[APPLanguageService sjhSearchContentWith:@"bianji"] style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick:)];
//    self.navigationItem.rightBarButtonItem = item;
    
    _rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBarButton.frame = CGRectMake(0, 0, 80, 30);
    [_rightBarButton setTitle:[APPLanguageService sjhSearchContentWith:@"bianji"] forState:UIControlStateNormal];
    [_rightBarButton addTarget:self action:@selector(rightBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
    _rightBarButton.titleLabel.font = SYSTEMFONT(14);
    [_rightBarButton setTitleColor:ThirdColor forState:UIControlStateNormal];
    //[_rightBarButton sizeToFit];
    
    
    [_rightBarButton setContentEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:_rightBarButton];
    self.navigationItem.rightBarButtonItem = item;
    
    
}

- (void)rightBarItemClick:(UIButton *)item{
    [MobClick event:@"mine_collect_edit"];
    item.selected = !item.selected;
    if (item.selected) {
        if (self.dataArray.count == 0) {
            return;
        }
        [_rightBarButton setTitleColor:MainBg_Color forState:UIControlStateNormal];
        [_rightBarButton setTitle:[APPLanguageService wyhSearchContentWith:@"wangcheng_password"] forState:UIControlStateNormal];
        [self.tableView setEditing:YES animated:YES];
        [self showEitingView:YES];
    }else{
        [_rightBarButton setTitleColor:ThirdColor forState:UIControlStateNormal];
        [_rightBarButton setTitle:[APPLanguageService sjhSearchContentWith:@"bianji"] forState:UIControlStateNormal];
        [self.tableView setEditing:NO animated:YES];
        _buttonAllSeleted.selected = NO;
        [_buttonAllSeleted setTitle:[APPLanguageService sjhSearchContentWith:@"allSelect"] forState:UIControlStateNormal];
        [self showEitingView:NO];
    }
    
}
#pragma mark -- event response

- (void)allSelect:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }];
        
        [_buttonAllSeleted setTitle:[APPLanguageService wyhSearchContentWith:@"cancelallSelect"] forState:UIControlStateNormal];
    }else {
        
        [self.tableView reloadData];
        /** 遍历反选
         [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [self.tableView deselectRowAtIndexPath:obj animated:NO];
         }];
         */
        
        [_buttonAllSeleted setTitle:[APPLanguageService sjhSearchContentWith:@"allSelect"] forState:UIControlStateNormal];
    }

}
- (void)delete:(UIButton *)sender {
    NSMutableIndexSet *insets = [[NSMutableIndexSet alloc] init];
    NSMutableArray    *deletArray = @[].mutableCopy;
    [[self.tableView indexPathsForSelectedRows] enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"%ld",obj.row);
        FastInfomationObj *model = self.dataArray[obj.row];
        NSDictionary *oneDict = @{@"refId":model.infoID,
                                  @"refType":model.type == 6 ? @(20) : @(10),
                                  @"favor":@(NO)
                                  };
        [insets addIndex:obj.row];
        [deletArray addObject:oneDict];
    }];
    if (deletArray.count > 0) {
        BTBatchFavorsRequest *request = [[BTBatchFavorsRequest alloc] initWithDict:deletArray];
        [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            [self.dataArray removeObjectsAtIndexes:insets];
            [self.tableView deleteRowsAtIndexPaths:[self.tableView indexPathsForSelectedRows] withRowAnimation:UITableViewRowAnimationFade];
            _buttonAllSeleted.selected = NO;
            [_buttonAllSeleted setTitle:[APPLanguageService sjhSearchContentWith:@"allSelect"] forState:UIControlStateNormal];
            /** 数据清空情况下取消编辑状态*/
            if (self.dataArray.count == 0) {
                [_rightBarButton setTitleColor:ThirdColor forState:UIControlStateNormal];
                [_rightBarButton setTitle:[APPLanguageService sjhSearchContentWith:@"bianji"] forState:UIControlStateNormal];
                [self.tableView setEditing:NO animated:YES];
                [self showEitingView:NO];
                [self.loadingView showNoDataWithMessage:@"zanwushuju" imageString:@"ic_wushuju"];
            }
            
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    }
}

- (void)showEitingView:(BOOL)isShow{
    [self.editingView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(isShow?0:45);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)creatUI {
    self.title = [APPLanguageService wyhSearchContentWith:@"myCollection"];
    self.pageIndex = 1;
    [self.view addSubview:self.editingView];
    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.editingView.mas_top);
//    }];
    [self.editingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.view).offset(50);
    }];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTInfomationSameCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([StrategyCell class]) bundle:nil] forCellReuseIdentifier:identifier1];
    _tableView.backgroundColor = CViewBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
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
    MyCollectionRequest *api = [[MyCollectionRequest alloc] initWithPageIndex:self.pageIndex];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            
            if ([request.data count]) {
                
                [self.loadingView hiddenLoading];
            } else {
                
                [self.loadingView showNoDataWithMessage:@"zanwushuju" imageString:@"ic_wushuju"];
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
    cell.whereVC = @"我的收藏";
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell creatUIWith:obj];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.isEditing) {
    
        return;
    }
    FastInfomationObj *obj = self.dataArray[indexPath.row];
    
    if (obj.type == 6) {
        
        [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":obj.infoID,@"bigType":@(6)}];
    }else {
        
        [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":obj.infoID}];
    }
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}
#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (UIView *)editingView{
    if (!_editingView) {
        _editingView = [[UIView alloc] init];
        _editingView.backgroundColor = isNightMode ? TableViewCellNightColor : KWhiteColor;
        _buttonDelete= [UIButton buttonWithType:UIButtonTypeCustom];
        //button.backgroundColor = [UIColor redColor];
        _buttonDelete.titleLabel.font = FONTOFSIZE(14);
        [_buttonDelete setTitle:[APPLanguageService sjhSearchContentWith:@"delete"] forState:UIControlStateNormal];
        [_buttonDelete setTitleColor:UIColorHex(E63A1A) forState:UIControlStateNormal];
        [_buttonDelete addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        [_editingView addSubview:_buttonDelete];
        [_buttonDelete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.bottom.equalTo(_editingView);
            make.width.equalTo(_editingView).multipliedBy(0.5);
        }];
        
        _buttonAllSeleted = [UIButton buttonWithType:UIButtonTypeCustom];
        //button.backgroundColor = [UIColor darkGrayColor];
        [_buttonAllSeleted setTitle:[APPLanguageService sjhSearchContentWith:@"allSelect"] forState:UIControlStateNormal];
        [_buttonAllSeleted setTitle:[APPLanguageService sjhSearchContentWith:@"cancelallSelect"] forState:UIControlStateSelected];
        [_buttonAllSeleted setTitleColor:UIColorHex(E63A1A) forState:UIControlStateNormal];
        _buttonAllSeleted.titleLabel.font = FONTOFSIZE(14);
        [_buttonAllSeleted addTarget:self action:@selector(allSelect:) forControlEvents:UIControlEventTouchUpInside];
        [_editingView addSubview:_buttonAllSeleted];
        [_buttonAllSeleted mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.equalTo(_editingView);
            make.width.equalTo(_editingView).multipliedBy(0.5);
        }];
    }
    return _editingView;
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
