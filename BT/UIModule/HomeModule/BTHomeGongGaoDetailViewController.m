//
//  BTHomeGongGaoDetailViewController.m
//  BT
//
//  Created by admin on 2018/7/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTHomeGongGaoDetailViewController.h"
#import "BTHomeGongGaoCell.h"
#import "InformationModuleRequest.h"
#import "FastInfomationObj.h"
#import "BannersRequest.h"
static NSString *const identifier = @"BTHomeGongGaoCell";
@interface BTHomeGongGaoDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;

@end

@implementation BTHomeGongGaoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)creatUI {
    self.pageIndex = 1;
    self.title = [APPLanguageService wyhSearchContentWith:@"jiaoyisuogonggao"];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTHomeGongGaoCell class]) bundle:nil] forCellReuseIdentifier:identifier];
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
                FastInfomationObj *obj = [FastInfomationObj objectWithDictionary:dic];
                obj.imgUrl = SAFESTRING(obj.imgUrl);
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:(ScreenWidth-30)*2 andHeight:100*2];
                obj.imgUrl = [NSString stringWithFormat:@"%@?%@",[obj.imgUrl hasPrefix:@"http"]?obj.imgUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,obj.imgUrl],str];
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
                obj.imgUrl = SAFESTRING(obj.imgUrl);
                NSString *str =  [getUserCenter getImageURLSizeWithWeight:(ScreenWidth-30)*2 andHeight:100*2];
                obj.imgUrl = SAFESTRING(obj.imgUrl);
                obj.imgUrl = [NSString stringWithFormat:@"%@?%@",[obj.imgUrl hasPrefix:@"http"]?obj.imgUrl:[NSString stringWithFormat:@"%@%@",PhotoImageURL,obj.imgUrl],str];
                
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
    FastInfomationObj *model = self.dataArray[indexPath.row];
    CGFloat height = [getUserCenter getSpaceLabelHeight:model.title withFont:SYSTEMFONT(12) withWidth:ScreenWidth-30 withHJJ:6.0 withZJJ:0.0];
    return 70+height;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FastInfomationObj *model = self.dataArray[indexPath.row];
    BTHomeGongGaoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MobClick event:@"home_announcement_click"];
    FastInfomationObj *obj = self.dataArray[indexPath.row];
    [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":obj.infoID,@"whereVC":@"公告"}];
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
