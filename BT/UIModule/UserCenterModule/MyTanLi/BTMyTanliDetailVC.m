//
//  BTMyTanliDetailVC.m
//  BT
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTMyTanliDetailVC.h"
#import "MyCoinDetailCell.h"
#import "MyCoinDetailHeader.h"
#import "BTMyCoinDetailRequest.h"
#import "BTMyCoinRequest.h"
@interface BTMyTanliDetailVC ()<BTLoadingViewDelegate>
@property (nonatomic, strong) MyCoinDetailHeader *detailHeader;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) BTLoadingView *loadingView;
@end

@implementation BTMyTanliDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [APPLanguageService wyhSearchContentWith:@"tanlixiangqing"];
}

- (NSString*)nibNameOfCell{
    return @"MyCoinDetailCell";
}

- (NSString*)cellIdentifier{
    return [self nibNameOfCell];
}

- (void)createOtherViews{
    UIImageView *imageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"coinDetailBg"]];
    [self.view insertSubview:imageView belowSubview:self.mTableView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(self.view);
    }];
    self.mTableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    WS(weakSelf)
    self.mTableView.mj_footer =[BTRefreshFooter footerWithRefreshingBlock:^{
        weakSelf.currentPage++;
        [weakSelf requestList:RefreshStateUp];
    }];
  
//    self.mTableView.mj_header =[BTRefreshHeader headerWithRefreshingBlock:^{
//        weakSelf.currentPage = 1;
//        [weakSelf requestList:RefreshStatePull];
//    }];
    
    self.mTableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.detailHeader];
    [self.detailHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(94.0f);
    }];
    [self.mTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailHeader.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:nil delegate:self];
}

- (void)loadData{
    [self requestMyCoinDetail];
    self.dataArray =@[].mutableCopy;
    self.currentPage = 1;
    [self.mTableView reloadData];
    [self requestList:RefreshStateNormal];
}

- (void)requestList:(RefreshState)state{
    if(state == RefreshStateNormal){
        [self.loadingView showLoading];
    }
    BTMyCoinDetailRequest *api =[[BTMyCoinDetailRequest alloc] initWithCurrentPage:self.currentPage pageSize:20];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        if(state == RefreshStateNormal ||state ==RefreshStatePull){
            
            self.dataArray =@[].mutableCopy;
            if(request.data&&[request.data isKindOfClass:[NSArray class]]){
                [self.dataArray addObjectsFromArray:request.data];
            }
            [self.mTableView reloadData];
            //[self.mTableView.mj_header endRefreshing];
            BOOL hasNext =[[request.responseObject objectForKey:@"hasNext"] boolValue];
            if (!hasNext) {
                self.mTableView.mj_footer.hidden = YES;
            }
        }else{//加载更多
            NSInteger totalPage = [[request.responseObject objectForKey:@"totalPage"] integerValue];
            if(self.currentPage>totalPage){
                [self.mTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.dataArray addObjectsFromArray:request.data];
                [self.mTableView reloadData];
                [self.mTableView.mj_footer endRefreshing];
            }
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
- (void)requestMyCoinDetail{
    BTMyCoinRequest *api = [[BTMyCoinRequest alloc]init];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if(request.data&&[request.data isKindOfClass:[NSDictionary class]]){
            
            self.detailHeader.valueL.text =[NSString stringWithFormat:@"%@", SAFESTRING(request.data[@"totalCoin"])];
            
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
    
    }];
}

#pragma mark -- Custom Accessor
- (MyCoinDetailHeader*)detailHeader{
    if(!_detailHeader){
        _detailHeader = [MyCoinDetailHeader loadFromXib];
    }
    return _detailHeader;
}
#pragma mark --UITableView Delegate Datasoure
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCoinDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.data =self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 69.f;
}

//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return self.detailHeader;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 94.0f;
//}

- (void)refreshingData{
    [self requestList:RefreshStateNormal];
}
@end
