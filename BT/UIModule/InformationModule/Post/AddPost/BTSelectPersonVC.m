//
//  BTSelectPersonVC.m
//  BT
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTSelectPersonVC.h"
#import "SelectMemberWithSearchView.h"
#import "SelectContactCell.h"
#import "BTUserFollowListReq.h"
#import "BTSearchUserReq.h"
#import "ConatctModel.h"

@interface BTSelectPersonVC ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,SelectMemberWithSearchViewDelegate>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) NSMutableArray *arrResult;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) SelectMemberWithSearchView *selectView;

@property (nonatomic, assign) NSInteger userListPage;
@property (nonatomic, assign) NSInteger searchListPage;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) BTSearchUserReq *searchApi;
@property (nonatomic, strong)BTUserFollowListReq *followListApi;
@property (nonatomic, assign) BOOL isResult;


@end

@implementation BTSelectPersonVC

//
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"@TA";
    [self createUI];
    [self loadData];
    _dataArr = @[].mutableCopy;
    _arrResult = @[].mutableCopy;
}

- (void)createUI{
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:[APPLanguageService sjhSearchContentWith:@"confirm"] style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    [rightBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                           NSForegroundColorAttributeName : ThirdColor} forState:UIControlStateDisabled];
    [rightBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                           NSForegroundColorAttributeName : MainBg_Color} forState:UIControlStateNormal];
    [rightBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                           NSForegroundColorAttributeName : MainBg_Color} forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.view addSubview:self.mTableView];
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(46);
        make.left.right.bottom.equalTo(self.view);
    }];
    self.mTableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        if(self.isResult){
            _searchListPage++;
            NSString *searchString = [self searchDeletewhitespaceWithString:self.searchBar.text];
            [self requestList:RefreshStateUp with:searchString];
        }else{
            _userListPage++;
            [self requestUserFollowList:RefreshStateUp];
        }
    }];
    [self configSearchBar];
    self.view.backgroundColor = [UIColor whiteColor];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.mTableView aboveSubView:self.view delegate:nil];
}

- (void)configSearchBar{
    UIView *ivTitle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 46)];
    ivTitle.backgroundColor = isNightMode ? ViewContentBgColor :CWhiteColor;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(7, 5, ScreenWidth - 14, 36)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = [APPLanguageService sjhSearchContentWith:@"searchnicheng"];
    self.searchBar.showsCancelButton = NO;
    self.searchBar.tintColor = [UIColor blueColor];
    for (UIView *view in self.searchBar.subviews) {
        for (id v in view.subviews) {
            if ([v isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [v removeFromSuperview];
            }else if ([v isKindOfClass:NSClassFromString(@"UISearchBarTextField")]){
                UITextField *textField = (UITextField *)v;
                textField.font = MediumFont;
                [textField setValue:ThirdColor forKeyPath:@"_placeholderLabel.textColor"];
                textField.backgroundColor = isNightMode?ViewBGNightColor:CSearchBarColor;;
                textField.layer.masksToBounds = YES;
                textField.layer.cornerRadius  = 18;
                textField.textColor = FirstColor;
            }else if ([v isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)v;
                [btn setTitle:[APPLanguageService sjhSearchContentWith:@"quxiao"] forState:UIControlStateNormal];
                btn.titleLabel.font = FONTOFSIZE(14.0f);
                [btn setTitleColor:CBlackColor forState:UIControlStateNormal];
            }
        }
    }
    //5. 设置搜索Icon
    [self.searchBar setImage:[UIImage imageNamed:@"search"]
            forSearchBarIcon:UISearchBarIconSearch
                       state:UIControlStateNormal];
    [self.searchBar setImage:[UIImage imageNamed:@"search_clear"]
            forSearchBarIcon:UISearchBarIconClear
                       state:UIControlStateNormal];
    [ivTitle addSubview:self.searchBar];
    [self.view addSubview:ivTitle];
}

- (void)loadData{
    _userListPage = 1;
    _searchListPage = 1;
    [self requestUserFollowList:RefreshStateNormal];
}

- (void)requestUserFollowList:(RefreshState)state{
    if(state == RefreshStateNormal){
        [self.loadingView showLoading];
    }
    if(_searchApi.executing){
        [_searchApi stop];
    }
    _followListApi = [[BTUserFollowListReq alloc] initWithUserId:[BTGetUserInfoDefalut sharedManager].userInfo.userId CurrentPage:_userListPage];
    [_followListApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.mTableView.mj_header endRefreshing];
            [self.dataArr removeAllObjects];
            if(![request.data isKindOfClass:[NSArray class]]){
                [self.loadingView showNoDataWithMessage:@"sousuoAtUser" imageString:@"empty_unperson"];
                return;
            }else{
                NSArray *arr = request.data;
                if(arr.count == 0){
                    [self.loadingView showNoDataWithMessage:@"sousuoAtUser" imageString:@"empty_unperson"];
                    return;
                }
            }
            [self.loadingView hiddenLoading];
            NSString *hasNext = SAFESTRING(request.responseObject[@"hasNext"]);
            if ([hasNext isEqualToString:@"0"]) {
                self.mTableView.mj_footer.hidden = YES;
            }else{
                self.mTableView.mj_footer.hidden = NO;
                [self.mTableView.mj_footer endRefreshing];
            }
        }else if (state == RefreshStateUp){
            
            NSString *hasNext = SAFESTRING(request.responseObject[@"hasNext"]);
            if([hasNext isEqualToString:@"1"]){
                [self.mTableView.mj_footer endRefreshing];
            }else{
                [self.mTableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        for(NSDictionary *dict in request.data){
            ConatctModel *model = [ConatctModel objectWithDictionary:dict];
            [self.dataArr addObject:model];
        }
        
        if(self.selectArray.count >0){
            [self.selectArray enumerateObjectsUsingBlock:^(ConatctModel * _Nonnull selectModel, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [self.dataArr enumerateObjectsUsingBlock:^(ConatctModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (selectModel.userId == model.userId) {
                        model.isSelected = YES;
                    }
                }];
            }];
        }
        [self.mTableView reloadData];
        
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

- (void)requestList:(RefreshState)state with:(NSString *)str{
    if (state == RefreshStateNormal) {
        self.searchListPage = 1;
    }
    WS(ws);
    _searchApi = [[BTSearchUserReq alloc] initWithUserName:str currentPage:self.searchListPage];
    [_searchApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        self.isResult = YES;
        NSArray *resultArray = request.data;
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [ws.arrResult removeAllObjects];
            for(NSDictionary *dict in resultArray){
                ConatctModel *model = [ConatctModel objectWithDictionary:dict];
                [ws.arrResult addObject:model];
            }
            NSString *hasNext = SAFESTRING(request.responseObject[@"hasNext"]);
            if ([hasNext isEqualToString:@"0"]) {
                self.mTableView.mj_footer.hidden = YES;
            }else{
                self.mTableView.mj_footer.hidden = NO;
                [self.mTableView.mj_footer endRefreshing];
            }
        }else if (state == RefreshStateUp){
            NSString *hasNext = SAFESTRING(request.responseObject[@"hasNext"]);
            if([hasNext isEqualToString:@"1"]){
                [self.mTableView.mj_footer endRefreshing];
            }else{
                [self.mTableView.mj_footer endRefreshingWithNoMoreData];
            }
            for(NSDictionary *dict in resultArray){
                ConatctModel *model = [ConatctModel objectWithDictionary:dict];
                [ws.arrResult addObject:model];
            }
        }
        if(self.arrResult.count ==0){
            [self.loadingView showNoDataWithMessage:@"zanwurenheneirong" imageString:@"ic_searchNoData"];
        }else{
            [self.loadingView hiddenLoading];
        }
        
        if(self.selectArray.count >0){
            [self.selectArray enumerateObjectsUsingBlock:^(ConatctModel * _Nonnull selectModel, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [self.arrResult enumerateObjectsUsingBlock:^(ConatctModel * _Nonnull searchModel, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (selectModel.userId == searchModel.userId) {
                        searchModel.isSelected = YES;
                    }
                }];
            }];
        }
        [ws.mTableView reloadData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

//
- (void)backBtnClicked{
    if(self.returnParamsBlock){
        self.returnParamsBlock(nil);
        [BTCMInstance popViewController:nil];
    }else{
         [self.navigationController popViewControllerAnimated:YES];
    }
   
}

- (UITableView*)mTableView{
    if(!_mTableView){
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        if(IOS_VERSION >=11.0f){
            _mTableView.estimatedSectionHeaderHeight = 0.0;
            _mTableView.estimatedSectionFooterHeight = 0.0;
        }
        _mTableView.separatorColor = SeparateColor;
        _mTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
        [_mTableView registerNib:[UINib nibWithNibName:@"SelectContactCell" bundle:nil] forCellReuseIdentifier:@"SelectContactCell"];
        _mTableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator =NO;
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView =footView;
    }
    return _mTableView;
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.isResult) return self.arrResult.count;
    return self.dataArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectContactCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectContactCell"];
    ConatctModel *model;
    if(self.isResult) {
        model = self.arrResult[indexPath.row];
    }else{
        model = self.dataArr[indexPath.row];;
    }
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 46.0f)];
    view.backgroundColor = isNightMode ?ViewBGColor :CWhiteColor;
    UILabel *label = [UILabel labelWithFrame:CGRectZero title:@"" font:[UIFont fontWithName:@"PingFangSC-Medium" size:16.0f] textColor:FirstColor];
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(view).offset(15);
    }];
    if(self.isResult){
        label.text = [APPLanguageService sjhSearchContentWith:@"sousuojieguo"];
    }else{
        label.text = [APPLanguageService sjhSearchContentWith:@"wodeguanzhu"];
    }
    if(self.isResult){
        if(self.arrResult.count == 0) return nil;
    }else{
        if(self.dataArr.count == 0) return nil;
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 52.0f;
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(self.isResult){
        if(self.arrResult.count == 0) return 0.01;
    }else{
        if(self.dataArr.count == 0) return 0.01;
    }
    return 46.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ConatctModel *model;
    if(self.isResult){
        model = self.arrResult[indexPath.row];
    }else{
        model = self.dataArr[indexPath.row];
    }
    model.isSelected = !model.isSelected;
    if(model.isSelected){
        [self.selectArray addObject:model];
    }else{
        [self.selectArray enumerateObjectsUsingBlock:^(ConatctModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.userId == model.userId) {
                [self.selectArray removeObject:obj];
                *stop = YES;
            }
        }];
    }
    if(!_selectView){
        [self.view addSubview:self.selectView];
        [self.mTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(121 + 46);
        }];
    }
    if(self.selectArray.count == 0){
        self.selectView.hidden = YES;
        [self.mTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(46);
        }];
    }else{
        self.selectView.hidden = NO;
        [self.mTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(121 + 46);
        }];
    }
    [self.mTableView reloadData];
    [self.selectView updateSubviewsLayout:self.selectArray];
    [self updateRightBarButtonItem];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar.text.length == 0) {
        self.isResult = NO;
//        [self requestUserFollowList:RefreshStatePull];
        [self.mTableView reloadData];
        if(self.dataArr.count == 0){
            [self.loadingView showNoDataWithMessage:@"sousuoAtUser" imageString:@"empty_unperson"];
        }
        if (self.dataArr.count < BTPagesize) {
            self.mTableView.mj_footer.hidden = YES;;
        }else{
            [self.mTableView.mj_footer endRefreshing];
        }
    }
    NSString *searchString = [self searchDeletewhitespaceWithString:searchBar.text];
    if (searchString.length > 0) {
        [self requestList:RefreshStateNormal with:searchString];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder]; //searchBar失去焦点
    UIButton *cancelBtn = [searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    cancelBtn.enabled = YES; //把enabled设置为yes
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    //[self.searchBar resignFirstResponder]; //searchBar失去焦点
    UIButton *cancelBtn = [searchBar valueForKey:@"cancelButton"]; //首先取出cancelBtn
    cancelBtn.enabled = YES; //把enabled设置为yes
}

- (NSString *)searchDeletewhitespaceWithString:(NSString *)text{
    if (text.length == 0) {
        return text;
    }
    NSString *searchText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@" "];
    return searchText;
}

//确定选人
- (void)confirm{
    //多选@ 人s
    if(self.selectArray.count >0){
        NSMutableArray *mutaArr = @[].mutableCopy;
        NSInteger i =0;
        for(ConatctModel *model in self.selectArray){
            NSString *name = model.nickName;
            NSString *insertString = @"";
            if(i == 0){
                insertString = [NSString stringWithFormat:@"%@ ",name];
            }else{
                insertString = [NSString stringWithFormat:@"@%@ ",name];
            }
            [mutaArr addObject:insertString];
            i++;
        }
        
        NSString *selectStr = [mutaArr componentsJoinedByString:@""];
        if (self.selectBlock){
            self.selectBlock(selectStr);
        }
        if(self.returnParamsBlock){
            self.returnParamsBlock(selectStr);
            [BTCMInstance popViewController:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        

    }
}
//
- (SelectMemberWithSearchView*)selectView{
    if(!_selectView){
        _selectView = [[SelectMemberWithSearchView alloc] initWithFrame:CGRectMake(0, 46, ScreenWidth, 121)];
        _selectView.delegate = self;
    }
    return _selectView;
}
- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (void)removeMemberFromSelectArray:(ConatctModel *)member indexPath:(NSIndexPath *)indexPath{
    if(self.selectArray.count == 0){
        self.selectView.hidden = YES;
        [self.mTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(46);
        }];
    }
    [self.dataArr enumerateObjectsUsingBlock:^(ConatctModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.userId == member.userId) {
            obj.isSelected = NO;
            [self.mTableView reloadData];
        }
    }];
    [self.arrResult enumerateObjectsUsingBlock:^(ConatctModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.userId == member.userId) {
            obj.isSelected = NO;
            [self.mTableView reloadData];
        }
    }];
    [self updateRightBarButtonItem];
}
//
- (void)updateRightBarButtonItem {
    self.navigationItem.rightBarButtonItem.enabled = self.selectArray.count >0;
}

@end
