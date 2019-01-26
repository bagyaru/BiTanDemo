//
//  CurrencyConceptsVC.m
//  BT
//
//  Created by apple on 2018/4/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CurrencyConceptsVC.h"
#import "ConceptAllTableViewCell.h"
#import "CurrencyConceptGridView.h"
#import "BTConceptMainRequest.h"
#import "CurrencyConceptModel.h"
@interface CurrencyConceptsVC ()<BTLoadingViewDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray*headerMenus;
@property (nonatomic, strong) NSMutableArray *headerDataArr;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) BTLoadingView *loadingView;

@end

@implementation CurrencyConceptsVC

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self stopTimer];
}

- (void)createOtherViews{
    self.title = [APPLanguageService wyhSearchContentWith:@"huobigainian"];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:nil delegate:self];
//    self.mTableView.separatorColor = kHEXCOLOR(0xE1E1E1);
    self.mTableView.separatorStyle = UITableViewCellSelectionStyleNone;
}

- (NSString*)nibNameOfCell{
    return @"ConceptAllTableViewCell";
}
- (NSString*)cellIdentifier{
    return [self nibNameOfCell];
}

- (void)startTimer{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:[BTConfigureService shareInstanceService].timeSepa target:self selector:@selector(refreshListData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        [_timer fire];
    }
}

- (void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}
- (void)loadData{
    self.mTableView.tableHeaderView = self.headerView;
    [self requestData:RefreshStateNormal];
}
//定时器刷新数据
- (void)refreshListData{
    [self requestData:RefreshStatePull];
}
//请求数据
- (void)requestData:(RefreshState)state{
    if(state == RefreshStateNormal){
        [self.loadingView showLoading];
    }
    BTConceptMainRequest *api =[[BTConceptMainRequest alloc] initWithFirstRequest:true];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [self.loadingView hiddenLoading];
        self.dataArray =@[].mutableCopy;
        if(request.data&&[request.data isKindOfClass:[NSArray class]]){
            for(NSDictionary *dict in request.data){
                CurrencyConceptModel *model =[CurrencyConceptModel objectWithDictionary:dict];
                [self.dataArray addObject:model];
            }
            NSInteger count =self.dataArray.count;
            WS(weakSelf)
            if(count>=6){
                _headerDataArr =  [self.dataArray bk_select:^BOOL(id  _Nonnull obj) {
                    NSInteger index = [weakSelf.dataArray indexOfObject:obj];
                    return index < 6;
                }].mutableCopy;
                //            _headerDataArr = [self.dataArray bk_select:^BOOL(id  _Nonnull obj) {
                //                CurrencyConceptModel *info =(CurrencyConceptModel*)obj;
                //                return info.hot == 1;
                //
                //            }].mutableCopy;
                self.dataArray =[self.dataArray bk_select:^BOOL(id  _Nonnull obj) {
                    NSInteger index = [weakSelf.dataArray indexOfObject:obj];
                    return index >= 6;
                    //                CurrencyConceptModel *info =(CurrencyConceptModel*)obj;
                    //                return info.hot == 0;
                    
                }].mutableCopy;
                [self setHeaderViewContent];
                [self.mTableView reloadData];
            }
        }
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}
#pragma mark -- Custom Accessor
- (UIView*)headerView{
    if(!_headerView){
        _headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,44.0f)];
        UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44.0f)];
        view.backgroundColor = ViewBGColor;
        UILabel *label =[UILabel labelWithFrame:CGRectZero title:[APPLanguageService wyhSearchContentWith:@"remengainian"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] textColor: FirstColor];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view).offset(15);
            make.centerY.equalTo(view.mas_centerY);
        }];
        [_headerView addSubview:view];
        
    }
    return _headerView;
}

- (void)setHeaderViewContent{
    _headerMenus = @[].mutableCopy;
    CGFloat width = ScreenWidth/3.0;
    CGFloat height = 112.0f;
    NSUInteger count = _headerDataArr.count;
    
    CGFloat line = (count%3 ==0)? count/3 :(count/3+1);
    for(NSUInteger i =0;i<count;i++){
        CurrencyConceptGridView *gridView = [CurrencyConceptGridView loadFromXib];
        gridView.frame =CGRectMake(i%3*width, 44+i/3*112, width, height);
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [gridView addGestureRecognizer:tap];
        [self.headerView addSubview:gridView];
        [_headerMenus addObject:gridView];
    }
    for(NSInteger i =0 ;i<line-1;i++){
        UILabel *xlabel =[[UILabel alloc]initWithFrame:CGRectMake(0, 44+112.0f*(i+1), ScreenWidth, 0.5)];
        [self.headerView addSubview:xlabel];
        xlabel.backgroundColor  = SeparateColor;
    }
    
    UILabel *yLabel1 =[[UILabel alloc]initWithFrame:CGRectMake(width, 44, 0.5, line*112.0f)];
    UILabel *yLabel2 =[[UILabel alloc]initWithFrame:CGRectMake(width*2, 44, 0.5, line*112.0f)];
    
    [_headerView addSubview:yLabel1];
    [_headerView addSubview:yLabel2];
    
    yLabel1.backgroundColor = SeparateColor;
    yLabel2.backgroundColor = SeparateColor;
    _headerView.frame =CGRectMake(0, 0, ScreenWidth, 112.0*line+44.0f);
    NSInteger i=0;
    for(CurrencyConceptGridView *gridview in _headerMenus){
        gridview.model =_headerDataArr [i];
        i++;
    }
}
#pragma mark -- UITableView Delegate DataSource
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ConceptAllTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model =self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view =[[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44.0f)];
    view.backgroundColor = ViewBGColor;
    UILabel *label =[UILabel labelWithFrame:CGRectZero title:[APPLanguageService wyhSearchContentWith:@"quanbugainian"] font:[UIFont fontWithName:@"PingFangSC-Regular" size:14] textColor: FirstColor];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view).offset(15);
        make.centerY.equalTo(view.mas_centerY);
    }];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CurrencyConceptModel *model =self.dataArray[indexPath.row];
    [BTCMInstance pushViewControllerWithName:@"PayConceptVC" andParams:@{@"conceptId":@(model.conceptId),@"conceptClassifyName":SAFESTRING(model.conceptClassifyName)}];
}

#pragma mark --Event Response
- (void)tap:(UIGestureRecognizer*)gesture{
    CurrencyConceptGridView *view =(CurrencyConceptGridView*)gesture.view;
    [BTCMInstance pushViewControllerWithName:@"PayConceptVC" andParams:@{@"conceptId":@(view.model.conceptId)}];
    
}

- (void)refreshingData{
   [self requestData:RefreshStateNormal];
}
@end
