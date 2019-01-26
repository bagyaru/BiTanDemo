//
//  EditOptionViewController.m
//  BT
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "EditOptionViewController.h"
#import "EditOptionCell.h"
#import "SortUserBtcRequest.h"
#import "QueryUserBtcRequest.h"
#import "ItemModel.h"
#import "AddToGroupAlert.h"

#import "BTGroupCoinListReq.h"
#import "ConfirmSelectAlert.h"
#import "ComfirmAlertView.h"
#import "BTDeleteGroupCoinReq.h"

#import "BTGroupCoinRankReq.h"
#import "BTAddGroupCoinReq.h"
#import "NewCreateGroupAlert.h"
#import "BTAddGroupRequest.h"
#import "BTGroupListRequest.h"

static NSString *const identifier = @"EditOptionCell";

@interface EditOptionViewController ()<UITableViewDataSource,UITableViewDelegate,BTLoadingViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewTop;

@property (weak, nonatomic) IBOutlet BTLabel *labelMarket;

@property (weak, nonatomic) IBOutlet BTLabel *labelMove;

@property (weak, nonatomic) IBOutlet BTLabel *labelTop;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, strong) NSMutableArray *arrData;

@property (nonatomic, strong) NSMutableArray *arrChange;

@property (nonatomic, assign) BOOL isDelete;

@property (nonatomic, assign) BOOL isChangeSort;


@property (nonatomic, strong) BTLoadingView *loadingView;

@property (nonatomic, strong) NSMutableArray *arrDelete;

@property (nonatomic, strong) BTButton *allSelectBtn;
@property (nonatomic, strong) BTButton *addGroupBtn;
@property (nonatomic, strong) BTButton *deleteBtn;

@property (nonatomic, strong)NSArray *groupArr;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConst;

@property (weak, nonatomic) IBOutlet UILabel *separateView;


@end

@implementation EditOptionViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    [self createBottomView];
    //[self requestUserBtcList];
    [self requestList];
    if(self.groupArr.count == 0){
        [self requestGroupList];
    }
}

//创建底部view
- (void)createBottomView{
    self.viewTop.backgroundColor = isNightMode?ViewContentBgColor :CWhiteColor;
    self.separateView.backgroundColor = SeparateColor;
    self.bottomConst.constant =iPhoneX?(34+49):(49);
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = isNightMode? ViewContentBgColor :CWhiteColor;
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(49);
        make.bottom.equalTo(self.view).offset(iPhoneX?(-34):0);
    }];
    bottomView.layer.shadowOffset = CGSizeMake(0, 0);
    bottomView.layer.shadowColor = FirstColor.CGColor;
    bottomView.layer.shadowOpacity = 0.05;
    
    _allSelectBtn = [BTButton buttonWithType:UIButtonTypeCustom];
    _allSelectBtn.fixTitle = @"allSelect";
    [_allSelectBtn setImage:[UIImage imageNamed:@"choose-nor"] forState:UIControlStateNormal];
    [_allSelectBtn setImage:[UIImage imageNamed:@"choose-sel"] forState:UIControlStateSelected];
    
    [_allSelectBtn setTitleColor:FirstColor forState:UIControlStateNormal];
    _allSelectBtn.titleLabel.font = FONTOFSIZE(14.0f);
    [_allSelectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
    
    WS(weakSelf)
    [_allSelectBtn bk_addEventHandler:^(id  _Nonnull sender) {
        weakSelf.allSelectBtn.selected =!weakSelf.allSelectBtn.selected;
        for(ItemModel *model in weakSelf.arrChange){
            model.isSelected = weakSelf.allSelectBtn.selected;
        }
        [weakSelf.tableView reloadData];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    _addGroupBtn = [BTButton buttonWithType:UIButtonTypeCustom];
    _addGroupBtn.fixTitle = @"addToGroup";
    [_addGroupBtn setTitleColor:FirstColor forState:UIControlStateNormal];
    _addGroupBtn.titleLabel.font = FONTOFSIZE(14.0f);
    
    [_addGroupBtn bk_addEventHandler:^(id  _Nonnull sender) {
        BOOL isSelected = NO;
        for(ItemModel *model in weakSelf.arrChange){
            if(model.isSelected){
                isSelected =YES;
                break;
            }
        }
        if(!isSelected){
            [HintAlert showHint:[APPLanguageService sjhSearchContentWith:@"hintNotChoose"]];
            return ;
        }
        [AddToGroupAlert showWithArr:weakSelf.groupArr completion:^(NSString *groupName) {
            if(groupName.length>0){
                if([groupName isEqualToString:[APPLanguageService sjhSearchContentWith:@"quanbu"]]){
                    groupName =@"全部";
                }
                [weakSelf addCoinToGroup:groupName];
                
            }else{//新建
                [NewCreateGroupAlert showWithModel:nil completion:^(NSString *name) {
                    BTAddGroupRequest *api = [[BTAddGroupRequest alloc]initWithGroupName:name];
                    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
                        
                        [weakSelf addCoinToGroup:name];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_Refresh_Group_List object:nil];
                        
                    } failure:^(__kindof BTBaseRequest *request) {
                        
                    }];
                    
                }];
                
            }
        }];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    _deleteBtn = [BTButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.fixTitle = @"delete";
    [_deleteBtn setImage:[UIImage imageNamed:@"delete-nor"] forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:FirstColor forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = FONTOFSIZE(14.0f);
    [_deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
    
    //删除
    [_deleteBtn bk_addEventHandler:^(id  _Nonnull sender) {
        if(weakSelf.arrChange.count>0){
            BOOL isSelected = NO;
            for(ItemModel *model in weakSelf.arrChange){
                if(model.isSelected){
                    isSelected =YES;
                    break;
                }
            }
            if(!isSelected){
                [HintAlert showHint:[APPLanguageService sjhSearchContentWith:@"hintNotChoose"]];
                return ;
            }
            if([self.dic[@"groupName"] isEqualToString:[APPLanguageService sjhSearchContentWith:@"quanbu"]]){
                [ComfirmAlertView showWithTitle:[APPLanguageService sjhSearchContentWith:@"deleteFromAllgroup"] Completion:^{
                    [weakSelf deleteGroupCoinRequest:YES];
                }];
                
                
            }else{
                [ConfirmSelectAlert showWithCompletion:^(BOOL isAll) {
                    if(isAll){
                        [ComfirmAlertView showWithTitle:[APPLanguageService sjhSearchContentWith:@"deleteFromAllgroup"] Completion:^{
                            
                            [weakSelf deleteGroupCoinRequest:isAll];
                            
                            
                        }];
                        
                    }else{
                        [weakSelf deleteGroupCoinRequest:isAll];
                    }
                    
                }];
                
                
            }
            
            
        }
        
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [bottomView addSubview:_allSelectBtn];
    [bottomView addSubview:_addGroupBtn];
    [bottomView addSubview:_deleteBtn];
    
    [_allSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(bottomView);
        make.width.mas_equalTo(87.0f);
    }];
    [_addGroupBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(bottomView);
        //make.left.equalTo(_allSelectBtn.mas_right);
        make.centerX.equalTo(bottomView.mas_centerX);
        make.width.mas_equalTo(100);
    }];
    [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(bottomView);
        make.right.equalTo(bottomView);
        make.width.mas_equalTo(87.0f);
    }];
}

// 增加币到组内
- (void)addCoinToGroup:(NSString*)groupName{
    NSMutableArray *mutaArr =@[].mutableCopy;
    for(ItemModel *model in self.arrChange){
        if(model.isSelected){
            NSString *code = SAFESTRING(model.currencyCode);
            if(SAFESTRING(model.currencyCodeRelation).length>0){
                code = [NSString stringWithFormat:@"%@/%@",SAFESTRING(model.currencyCode),SAFESTRING(model.currencyCodeRelation)];
            }
            NSDictionary *dict =@{@"code":SAFESTRING(code),@"exchangeCode":SAFESTRING(model.exchangeCode)};
            [mutaArr addObject:dict];
        }
    }
    BTAddGroupCoinReq *api = [[BTAddGroupCoinReq alloc] initWithAllDelete:NO list:mutaArr groupName:groupName];
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [HintAlert showHint:[APPLanguageService sjhSearchContentWith:@"addSuccess"]];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_RefreshUserBtc object:nil];
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

//删除组内货币
- (void)deleteGroupCoinRequest:(BOOL)isAllDelete{
    NSMutableArray *mutaArr =@[].mutableCopy;
    for(ItemModel *model in self.arrChange){
        NSString *code = SAFESTRING(model.currencyCode);
        if(SAFESTRING(model.currencyCodeRelation).length>0){
            code = [NSString stringWithFormat:@"%@/%@",SAFESTRING(model.currencyCode),SAFESTRING(model.currencyCodeRelation)];
        }
        if(model.isSelected){
            NSDictionary *dict =@{@"code":SAFESTRING(code),@"exchangeCode":SAFESTRING(model.exchangeCode)};
            [mutaArr addObject:dict];
        }
    }
    NSString *groupName =@"";
    if(isAllDelete){
        groupName = @"全部";
    }else{
        groupName = self.dic[@"groupName"];
    }
    BTDeleteGroupCoinReq *api = [[BTDeleteGroupCoinReq alloc] initWithAllDelete:isAllDelete list:mutaArr groupName:groupName];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_RefreshUserBtc object:nil];
        [HintAlert showHint:[APPLanguageService sjhSearchContentWith:@"deleteSuccess"]];
        [self requestList];
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

- (void)configView{
    [self addNavigationItemWithImageNames:@[@"done"] isLeft:NO target:self action:@selector(done:) tags:@[@2000]];
    self.title = self.dic[@"groupName"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([EditOptionCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    self.tableView.separatorColor = SeparateColor;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [self.view addSubview:self.tableView];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:self.tableView delegate:self];
    [self.tableView setEditing:YES animated:YES];
}

#pragma mark - BTLoadingViewDelegate
- (void)refreshingData{
    [self requestList];
}

- (void)requestList{
    [self.loadingView showLoading];
    
    NSString *groupName =SAFESTRING(self.dic[@"groupName"]);
    if([groupName isEqualToString:[APPLanguageService sjhSearchContentWith:@"quanbu"]]){
        groupName = @"全部";
    }
    BTGroupCoinListReq *api = [[BTGroupCoinListReq alloc] initWithGroupName:groupName];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        self.arrData =@[].mutableCopy;
        for (NSDictionary *dic  in request.data) {
            ItemModel *item = [ItemModel modelWithJSON:dic];
            //if([item.exchangeCode isEqualToString:[AppHelper getExchangeCode]]){
            [self.arrData addObject:item];
            //}
            
        }
        self.arrChange = [self.arrData mutableCopy];
        [self.tableView reloadData];
        if(self.arrData.count == 0){
            [self.loadingView showNoDataWith:@"zanwushuju"];
        }else{
            [self.loadingView hiddenLoading];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
    }];
}

- (void)sortUserBtcRequest{
    //自选排序
    if (self.arrChange.count == 0) {
        //[MBProgressHUD showMessage:[APPLanguageService sjhSearchContentWith:@"bianjizixuanchenggong"] wait:NO];
        return;
    }
    NSMutableArray *arrBtcVOList = [NSMutableArray array];

    
    NSUInteger i = -1;
    for (ItemModel *itemodel in self.arrChange) {
        i++;
        itemodel.sortId = self.arrChange.count -i;
        NSDictionary *dic = [itemodel modelToJSONObject];
        NSMutableDictionary *dict = dic.mutableCopy;
        [dict removeObjectForKey:@"isSelected"];
        [arrBtcVOList addObject:dict];
        
    }
    
    BTGroupCoinRankReq *api = [[BTGroupCoinRankReq alloc] initWithData:arrBtcVOList];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [MBProgressHUD showMessage:[APPLanguageService sjhSearchContentWith:@"bianjizixuanchenggong"] wait:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_RefreshUserBtc object:nil];
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

- (void)done:(UIButton *)btn{
    [self sortUserBtcRequest];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrChange.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EditOptionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.itemModel = self.arrChange[indexPath.row];
    
//    cell.title = self.arrChange[indexPath.row];
    WS(ws);
    cell.topHandle = ^{
        //置顶操作
        NSLog(@"row:%ld",indexPath.row);
        [ws.arrChange insertObject:ws.arrChange[indexPath.row] atIndex:0];
        [ws.arrChange removeObjectAtIndex:indexPath.row + 1];
        [ws.tableView reloadData];
        DLog(@"arrChange:%@ arrData:%@",self.arrChange,self.arrData);
    };
    
    //选择
    cell.selectHandle = ^{
        BOOL isAll = YES;
        for(ItemModel *model in ws.arrChange){
            if(!model.isSelected){
                isAll = NO;
                break;
            }
            
        }
        BOOL isSelected = NO;
        for(ItemModel *model in self.arrChange){
            if(model.isSelected){
                isSelected = YES;
                break;
            }
        }
        if(isSelected){
            [_deleteBtn setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
            [_deleteBtn setTitleColor:CCommonRedColor forState:UIControlStateNormal];
            
        }else{
            [_deleteBtn setImage:[UIImage imageNamed:@"delete-nor"] forState:UIControlStateNormal];
            [_deleteBtn setTitleColor:FirstColor forState:UIControlStateNormal];
            
        }
        self.allSelectBtn.selected = isAll;
        
    };
    
    BOOL isSelected = NO;
    for(ItemModel *model in self.arrChange){
        if(model.isSelected){
            isSelected = YES;
            break;
        }
    }
    if(isSelected){
        [_deleteBtn setImage:[UIImage imageNamed:@"edit_delete"] forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:CRedColor forState:UIControlStateNormal];
        
    }else{
        [_deleteBtn setImage:[UIImage imageNamed:@"delete-nor"] forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:FirstColor forState:UIControlStateNormal];
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //删除操作
    [self.arrChange removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    DLog(@"arrChange:%@",self.arrChange);
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {

    ItemModel *model = self.arrChange[fromIndexPath.row];
    [self.arrChange removeObjectAtIndex:fromIndexPath.row];
    [self.arrChange insertObject:model atIndex:toIndexPath.row];
    
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

+ (id)createWithParams: (NSDictionary *)params{
    EditOptionViewController *vc = [[EditOptionViewController alloc] init];
    [vc updateWithParams:params];
    return vc;
}

- (void)updateWithParams:(NSDictionary *)params{
    self.dic = params;
    self.groupArr =self.dic[@"data"];
}

#pragma mark - Lazy

- (NSMutableArray *)arrData{
    if (!_arrData) {
        _arrData = [NSMutableArray array];
    }
    return _arrData;
}

- (void)requestGroupList{
    BTGroupListRequest *groupListApi = [[BTGroupListRequest alloc]init];
    [groupListApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data&&[request.data isKindOfClass:[NSArray class]]){
            NSMutableArray *data =@[].mutableCopy;
            
            BTGroupListModel *modelAll = [[BTGroupListModel alloc] init];
            modelAll.groupName = [APPLanguageService sjhSearchContentWith:@"quanbu"];//@"全部";
            modelAll.userGroupId = ALL_GROUP_ID;
            
            [data addObject:modelAll];
            NSMutableArray *infoArr =@[].mutableCopy;
            for (NSDictionary *dict in request.data){
                BTGroupListModel *info =[BTGroupListModel objectWithDictionary:dict];
                [infoArr addObject:info];
            }
            NSArray *reverseArr =[[infoArr reverseObjectEnumerator] allObjects];
            [data addObjectsFromArray:reverseArr];
            self.groupArr = data;
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
    }];
    
    
}


@end
