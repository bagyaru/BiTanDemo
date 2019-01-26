//
//  BTColleageDetailVC.m
//  BT
//
//  Created by apple on 2018/11/27.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTColleageDetailVC.h"
#import "BTCandyListCell.h"
#import "FastInfomationObj.h"
#import "BTColleageDetailReq.h"
#import "BTColleageListCell.h"
#import "BTInfomationSameCell.h"

@interface BTColleageDetailVC ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) UIView *headerView;


@end

@implementation BTColleageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
}

- (void)createUI{
    self.title = SAFESTRING(self.parameters[@"name"]);
    [self.view addSubview:self.mTableView];
    self.mTableView.tableHeaderView = self.headerView;
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    WS(ws)
    _mTableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        ws.pageIndex = 1;
        [ws requestList:RefreshStatePull];
    }];
    _mTableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        ws.pageIndex ++;
        [ws requestList:RefreshStateUp];
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:self.mTableView delegate:self];
}

- (void)loadData{
    _dataArray = @[].mutableCopy;
    [self requestList:RefreshStateNormal];
}

//请求数据
- (void)requestList:(RefreshState)state{
    
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    NSInteger value = [SAFESTRING(self.parameters[@"value"]) integerValue];
    BTColleageDetailReq *_api = [[BTColleageDetailReq alloc] initWithType:@"3" pageIndex:self.pageIndex guideType:value];
    [_api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {

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
                [self.dataArray addObject:obj];

            }
            [self.mTableView.mj_header endRefreshing];
            if (!request.hasNext) {
                self.mTableView.mj_footer.hidden = YES;
            }else{
                self.mTableView.mj_footer.hidden = NO;
                [self.mTableView.mj_footer endRefreshing];
            }
        }else if (state == RefreshStateUp){
            [self.mTableView.mj_header endRefreshing];
            if ([request.data count] < BTPagesize) {
                [self.mTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.mTableView.mj_footer endRefreshing];
            }
            for (NSDictionary *dic in request.data) {


                FastInfomationObj *obj = [FastInfomationObj objectWithDictionary:dic];
                if (ISNSStringValid(obj.imgUrl)) {

                    NSString *str =  [getUserCenter getImageURLSizeWithWeight:80*2 andHeight:80*2];
                    obj.imgUrl = [NSString stringWithFormat:@"%@?%@",obj.imgUrl,str];
                }
                [self.dataArray addObject:obj];
            }
        }
        [self.mTableView reloadData];

    } failure:^(__kindof BTBaseRequest *request) {

        [self.mTableView.mj_header endRefreshing];
        [self.mTableView.mj_footer endRefreshing];
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

#pragma mark -- BTLoadingView Delegate
- (void)refreshingData{
    [self requestList:RefreshStateNormal];
}

#pragma mark --Customer Accessor
-(UITableView*)mTableView{
    if(!_mTableView){
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        if(IOS_VERSION >=11.0f){
            _mTableView.estimatedSectionHeaderHeight = 0.0;
            _mTableView.estimatedSectionFooterHeight = 0.0;
        }
        _mTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator = NO;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mTableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTInfomationSameCell class]) bundle:nil] forCellReuseIdentifier:@"BTInfomationSameCell"];
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView = footView;
    }
    return _mTableView;
}

#pragma mark- UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return 110.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTInfomationSameCell*cell = [tableView dequeueReusableCellWithIdentifier:@"BTInfomationSameCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell creatUIWith:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FastInfomationObj *model = self.dataArray[indexPath.row];
    [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":model.infoID,
                                                                              //@"whereVC":@"tg"
                                                                              }];
}

//
- (UIView*)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
        _headerView.backgroundColor = isNightMode? ViewContentBgColor :CWhiteColor;
        
        BTColleageListCell *cell = [BTColleageListCell loadFromXib];
        cell.dict = self.parameters;
        [_headerView addSubview:cell];
        cell.frame = CGRectMake(0, 0, ScreenWidth, 140);
        [cell layoutIfNeeded];
        
    }
    return _headerView;
    
}
@end
