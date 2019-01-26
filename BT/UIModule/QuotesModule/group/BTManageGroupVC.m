//
//  BTManageGroupVC.m
//  BT
//
//  Created by apple on 2018/5/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTManageGroupVC.h"
#import "BTGroupManageCell.h"

#import "BTGroupListRequest.h"

#import "BTAddGroupRequest.h"
#import "BTDeleteGroupRequest.h"
#import "BTUpdateGroupReq.h"

#import "NewCreateGroupAlert.h"
#import "BTGroupRankReq.h"

@interface BTManageGroupVC ()<BTGroupManageCellDelegate>

@property (nonatomic, strong) BTButton *addBtn;
@property (nonatomic, strong) UIButton *editorBtn;
@property (nonatomic, strong) BTGroupManageCell *headView;

@end

@implementation BTManageGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =[APPLanguageService sjhSearchContentWith:@"manageGroup"];
    _editorBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_editorBtn setImage:[UIImage imageNamed:@"editor"] forState:UIControlStateNormal];
    [_editorBtn setImage:[UIImage imageNamed:@"done"] forState:UIControlStateSelected];
    
    _editorBtn.frame = CGRectMake(0, 0, 30, 30);
    WS(weakSelf)
    [_editorBtn bk_addEventHandler:^(id  _Nonnull sender) {
        
       if(weakSelf.editorBtn.isSelected){
            //保存排序
            [weakSelf save];
        }
        weakSelf.editorBtn.selected = !weakSelf.editorBtn.selected;
        [weakSelf.mTableView setEditing:weakSelf.editorBtn.selected animated:NO];
        [weakSelf.mTableView reloadData];
        
        weakSelf.headView.isAllEdit = weakSelf.editorBtn.isSelected;
       
    } forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:_editorBtn];
    self.navigationItem.rightBarButtonItem = item;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:kNotification_Refresh_Group_List object:nil];
    
}

- (NSString*)cellIdentifier{
    return [self nibNameOfCell];
}

- (NSString*)nibNameOfCell{
    return @"BTGroupManageCell";
}

- (void)createOtherViews{
    //self.mTableView.separatorColor = LineColor;
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.addBtn];
    [self.mTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(62.0f);
        make.bottom.equalTo(self.addBtn.mas_top);
    }];
    
    [self.view addSubview:self.headView];
    self.headView.frame =CGRectMake(0, 0, ScreenWidth, 62.0f);
    BTGroupListModel *listModel = [[BTGroupListModel alloc] init];
    listModel.groupName =[APPLanguageService sjhSearchContentWith:@"quanbu"];//@"全部";
    listModel.userGroupId = ALL_GROUP_ID;
    self.headView.model = listModel;
    self.headView.isAllEdit = self.editorBtn.selected;
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-(iPhoneX?52:18));
        make.height.mas_equalTo(44);
    }];
   
}
//
- (void)loadData{
    [self requestList];
}

- (void)requestList{
    BTGroupListRequest *api = [[BTGroupListRequest alloc]init];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data&&[request.data isKindOfClass:[NSArray class]]){
            self.dataArray =@[].mutableCopy;
            for (NSDictionary *dict in request.data){
                BTGroupListModel *info =[BTGroupListModel objectWithDictionary:dict];
                [self.dataArray addObject:info];
            }
            
            self.dataArray= (NSMutableArray*)[[self.dataArray reverseObjectEnumerator] allObjects];
            [self.mTableView reloadData];
            
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

- (void)addGroupRequest:(NSString*)groupName{
    BTAddGroupRequest *api = [[BTAddGroupRequest alloc] initWithGroupName:groupName];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [HintAlert showHint:[APPLanguageService sjhSearchContentWith:@"addSuccess"]];
        [self requestList];
        
    } failure:^(__kindof BTBaseRequest *request) {
        
        
    }];
}

#pragma mark -- Custom Accessor
//新建分组
- (BTButton*)addBtn{
    if(!_addBtn){
        _addBtn = [BTButton buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:[UIImage imageNamed:@"add_group"] forState:UIControlStateNormal];
        _addBtn.backgroundColor = kHEXCOLOR(0x0174FF);
        [_addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addBtn.fixTitle =@"newCreateGroup";
        _addBtn.titleLabel.font = FONTOFSIZE(14.0f);
        WS(weakSelf)
        [_addBtn bk_addEventHandler:^(id  _Nonnull sender) {
            [NewCreateGroupAlert showWithModel:nil completion:^(NSString *name) {
               [weakSelf addGroupRequest:name];
            }];
            
            
        } forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 8)];
        _addBtn.layer.cornerRadius =1.0;
        _addBtn.layer.masksToBounds = YES;
    }
    return _addBtn;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BTGroupManageCell *cell =[tableView dequeueReusableCellWithIdentifier:[self cellIdentifier]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.dataArray[indexPath.row];
    cell.delegate = self;
    cell.isEdit = self.editorBtn.isSelected;
    
    WS(ws)
    cell.groupBlock  = ^{
        //置顶操作
        [ws.dataArray insertObject:ws.dataArray[indexPath.row] atIndex:0];
        [ws.dataArray removeObjectAtIndex:indexPath.row + 1];
        [ws.mTableView reloadData];
        
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 62.0f;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 62.0f;
//}
//
//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//
//    BTGroupManageCell *view = self.headView;
//    //view.contentView.backgroundColor = CFontColor6;
//    view.isAllEdit = self.editorBtn.isSelected;
//    return view;
//}

//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *arr =@[].mutableCopy;
    BTGroupListModel *listModel = [[BTGroupListModel alloc] init];
    listModel.groupName = [APPLanguageService sjhSearchContentWith:@"quanbu"]; //@"全部";
    listModel.userGroupId = ALL_GROUP_ID;
    [arr addObject:listModel];
    [arr addObjectsFromArray:self.dataArray];
    
    BTGroupListModel *model = self.dataArray[indexPath.row];
    [BTCMInstance pushViewControllerWithName:@"editoption" andParams:@{@"groupName":SAFESTRING(model.groupName),@"data":arr}];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    //删除操作
    //    [self.arrChange removeObjectAtIndex:indexPath.row];
    //    [self.tableView reloadData];
    //    DLog(@"arrChange:%@",self.arrChange);
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    BTGroupListModel *model = self.dataArray[fromIndexPath.row];
    [self.dataArray removeObjectAtIndex:fromIndexPath.row];
    [self.dataArray insertObject:model atIndex:toIndexPath.row];
    [self.mTableView reloadData];
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark -- BTManageGroupDelegate Delegate
- (void)refreshData{
    [self requestList];
}

- (void)save{
    NSMutableArray *list = [NSMutableArray array];
    
    NSUInteger i = -1;
    for (BTGroupListModel *listModel in self.dataArray) {
        i++;
        NSDictionary *dict =@{@"rank":@(self.dataArray.count -i),@"userGroupId":@(listModel.userGroupId),@"userGroupName":SAFESTRING(listModel.groupName)};
        [list addObject:dict];
    }
    
    BTGroupRankReq *api = [[BTGroupRankReq alloc] initWithData:list];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}

//点击全部
- (void)allClick{
    NSMutableArray *arr =@[].mutableCopy;
    BTGroupListModel *listModel = [[BTGroupListModel alloc] init];
    listModel.groupName =[APPLanguageService sjhSearchContentWith:@"quanbu"];//@"全部";
    listModel.userGroupId = ALL_GROUP_ID;
    [arr addObject:listModel];
    [arr addObjectsFromArray:self.dataArray];
    [BTCMInstance pushViewControllerWithName:@"editoption" andParams:@{@"groupName":SAFESTRING([APPLanguageService sjhSearchContentWith:@"quanbu"]),@"data":arr}];
}

- (BTGroupManageCell*)headView{
    if(!_headView){
        BTGroupManageCell *view = [BTGroupManageCell loadFromXib];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(allClick)];
        [view addGestureRecognizer:tap];
        _headView = view;
        _headView.backgroundColor = [UIColor whiteColor];
    }
    return _headView;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
