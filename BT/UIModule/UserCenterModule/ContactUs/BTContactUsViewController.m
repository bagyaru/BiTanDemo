//
//  BTContactUsViewController.m
//  BT
//
//  Created by admin on 2018/9/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTContactUsViewController.h"
#import "BTContactUsRequest.h"
#import "BTContactUsCell.h"
#import "InformationModuleRequest.h"
#import "BTContactUsModel.h"
static NSString *const identifier = @"BTContactUsCell";
@interface BTContactUsViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;

@property (weak, nonatomic) IBOutlet BTLabel *banBenHaoL;
@property (weak, nonatomic) IBOutlet UIImageView *logoIV;

@end

@implementation BTContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [APPLanguageService wyhSearchContentWith:@"lianxiwomen"];
    self.banBenHaoL.text = [NSString stringWithFormat:@"%@ v%@",[APPLanguageService wyhSearchContentWith:@"banbenhao"],IosAppVersion];
    self.logoIV.image = IMAGE_NAMED(@"ic_lianxiwomenlogo");
    [self creatUI];
}
- (void)creatUI {
    self.pageIndex = 1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BTContactUsCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = CViewBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
   
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
    [self requestList:RefreshStateNormal];
}

- (void)requestList:(RefreshState)state{
    
    [self.loadingView showLoading];
    BTContactUsRequest *api = [BTContactUsRequest new];
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        [self.loadingView hiddenLoading];
        
        if ([request.data isKindOfClass:[NSArray class]]) {
            
            for (NSDictionary *dic in request.data) {
                
                BTContactUsModel *model = [BTContactUsModel objectWithDictionary:dic];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        
        [self.loadingView hiddenLoading];
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
    return 48;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BTContactUsModel *model = self.dataArray[indexPath.row];
    BTContactUsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    BTContactUsModel *model = self.dataArray[indexPath.row];
    
    if (model.opType == 2) {
        
        H5Node *node =[[H5Node alloc] init];
        node.webUrl  = [NSString stringWithFormat:@"%@%@",model.urlHead,model.value];
        [BTCMInstance pushViewControllerWithName:@"webView" andParams:@{@"node":node}];
    }
}
#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
@end
