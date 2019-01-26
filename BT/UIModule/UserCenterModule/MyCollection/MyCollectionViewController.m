//
//  MyCollectionViewController.m
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "BTInfomationSameCell.h"
#import "StrategyCell.h"
#import "MyCollectionRequest.h"
#import "FastInfomationObj.h"
static NSString *const identifier = @"BTInfomationSameCell";
static NSString *const identifier1 = @"StrategyCell";
@interface MyCollectionViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@end

@implementation MyCollectionViewController
-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:CollectionChange
                                                  object:nil];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
    [center addObserver:self selector:@selector(notice:) name:CollectionChange object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)notice:(NSNotification *)notifi {
    
    NSLog(@"收藏状态改变通知");
    [self requestList:RefreshStateNormal];
}
-(void)creatUI {
    self.title = [APPLanguageService wyhSearchContentWith:@"myCollection"];
    self.pageIndex = 1;
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
                
                [self.loadingView showNoDataWith:@"zanwushuju"];
            }
            for (NSDictionary *dic in request.data) {
                FastInfomationObj *obj = [FastInfomationObj objectWithDictionary:dic];
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
    
    FastInfomationObj *obj = self.dataArray[indexPath.row];
    if (obj.type == 3) {
        
        return 60;
    }
    return 108;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FastInfomationObj *obj = self.dataArray[indexPath.row];
    
    if (obj.type == 3) {
        
        StrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1 forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell creatUIWith:obj];
        return cell;
    }
    BTInfomationSameCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell creatUIWith:obj];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FastInfomationObj *obj = self.dataArray[indexPath.row];
    if (obj.type == 6) {
        
        [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":obj.infoID,@"bigType":@(6)}];
    }else {
        
       [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":obj.infoID}];
    }
}
#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
