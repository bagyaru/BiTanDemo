//
//  DiscussViewController.m
//  BT
//
//  Created by apple on 2018/6/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DiscussViewController.h"
#import "DiscussCurrencyRequest.h"
#import "DiscussModel.h"
#import "SubmitCommentRequest.h"
#import "LikeRequest.h"
#import "BTNewSameCommentsCell.h"
#import "InputAccessoryView.h"

#import "CommentDetailFootView.h"
#import "BTAddPostRequest.h"

#import "BTNewCommentsAlertViewController.h"
static NSString *const identifierDiscuss = @"BTNewSameCommentsCell";

@interface DiscussViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,BTNewSameCommentsCellDelegate> {
    
    CGFloat              _keyboardHeight;
}

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger discussCurrencyIndex;
@property (nonatomic, strong) UITextField *tf;
@property (nonatomic, strong) UIView *headerView;


//键盘弹出
@property (nonatomic, strong) CommentDetailFootView *commentAlertView;
@property (nonatomic,strong) UIView *blackBackView;

@property (nonatomic, strong) SubmitCommentRequest *submitRequest;

@property (nonatomic, strong) BTLoadingView *loadingView;


@end

@implementation DiscussViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self registerNsNotification];
    [IQKeyboardManager sharedManager].enable = NO;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.blackBackView];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.commentAlertView];
//    if(self.commentAlertView.textV.text.length >0){
//         [self.commentAlertView.textV becomeFirstResponder];
//    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [self.blackBackView removeFromSuperview];
    [self.commentAlertView removeFromSuperview];
    [self.commentAlertView.textV resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)createUI{
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.mTableView];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.mTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(45, 0, 0, 0));
    }];
    self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:self.mTableView delegate:nil];
    WS(ws)
    self.mTableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        ws.discussCurrencyIndex++;
        [self requestDiscussCurrencyWith:RefreshStateUp];
    }];
    self.view.backgroundColor = kHEXCOLOR(0xF5F5F5);
}

- (void)loadData{
    self.dataArray = @[].mutableCopy;
    self.discussCurrencyIndex = 1;
    [self requestDiscussCurrencyWith:RefreshStateNormal];
}

- (void)requestDiscussCurrencyWith:(RefreshState)state{
    NSString *strCode = self.kindCode;
    if (strCode.length == 0) {
        return;
    }
    if(state == RefreshStateNormal){
        [self.loadingView showLoading];
    }
    DiscussCurrencyRequest *request = [[DiscussCurrencyRequest alloc] initWithRefId:strCode refType:self.type pageIndex:self.discussCurrencyIndex pageSize:BTPagesize];
    [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        [BTShowLoading hide];
        if([request.data isKindOfClass:[NSArray class]]){
            if([request.data count]>0){
                [self.loadingView hiddenLoading];
            }else{
                
                [self.loadingView removeFromSuperview];
                UIView *view = [[UIView alloc] initWithFrame:self.mTableView.frame];
                [view addSubview:self.loadingView];
                [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(view);
                }];
                self.mTableView.tableFooterView = view;
                [self.loadingView showNoDataWithMessage:@"liuxiahenji" imageString:@"我的帖子-评论为空"];
            }
            
        }else{
            [self.loadingView hiddenLoading];
        }
        
        if (state == RefreshStateNormal ||state == RefreshStatePull) {
            self.dataArray = @[].mutableCopy;
            if ([request.data count] < BTPagesize) {
                self.mTableView.mj_footer.hidden = YES;
            }else{
                self.mTableView.mj_footer.hidden = NO;
                [self.mTableView.mj_footer endRefreshing];
            }
        }else if (state == RefreshStateUp){
            if ([request.data count] < BTPagesize) {
                [self.mTableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                self.mTableView.mj_footer.hidden = NO;
                [self.mTableView.mj_footer endRefreshing];
                
            }
        }
        if(self.discussCurrencyIndex>[request.responseObject[@"totalPage"] integerValue]){
            [self.mTableView reloadData];
            return;
        }
        
        for (NSDictionary *dic in request.data) {
            DiscussModel *model = [DiscussModel modelWithJSON:dic];
            model.isOrNo   = NO;
            [self.dataArray addObject:model];
        }
        [self.mTableView reloadData];
        
    } failure:^(__kindof BTBaseRequest *request) {
        [self.loadingView showErrorWith:request.resultMsg];
        
    }];
}
#pragma mark --Customer Accessor
- (UIView *)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 45)];
        [_headerView addSubview:self.tf];
        [self.tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerView).offset(15);
            make.right.equalTo(_headerView.mas_right).offset(-15);
            make.top.equalTo(_headerView).offset(10);
            make.height.mas_equalTo(30);
        }];
        _headerView.backgroundColor = isNightMode? ViewContentBgColor:CWhiteColor;
        
    }
    return _headerView;
}
- (UITextField*)tf{
    if(!_tf){
        _tf = [[UITextField alloc] initWithFrame:CGRectZero];
        _tf.backgroundColor = isNightMode?ViewBGNightColor:ViewBGDayColor;
        _tf.layer.cornerRadius = 4.0f;
        _tf.layer.masksToBounds = YES;
        _tf.textColor = FirstColor;
        _tf.placeholder = [APPLanguageService wyhSearchContentWith:@"youhegaojian"];
        [_tf setValue:ThirdColor forKeyPath:@"_placeholderLabel.textColor"];
        [_tf setValue:FONTOFSIZE(12) forKeyPath:@"_placeholderLabel.font"];
        _tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 30)];
        _tf.leftViewMode = UITextFieldViewModeAlways;
        _tf.delegate = self;
    }
    return _tf;
}
-(UITableView*)mTableView{
    if(!_mTableView){
        _mTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        if(IOS_VERSION >=11.0f){
            _mTableView.estimatedSectionHeaderHeight = 0.0;
            _mTableView.estimatedSectionFooterHeight = 0.0;
        }
        _mTableView.keyboardDismissMode =UIScrollViewKeyboardDismissModeOnDrag;
        _mTableView.showsVerticalScrollIndicator =NO;
        
        [_mTableView registerNib:[UINib nibWithNibName:@"BTNewSameCommentsCell" bundle:nil] forCellReuseIdentifier:identifierDiscuss];
        UIView *footView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
        _mTableView.tableFooterView =footView;
    }
    return _mTableView;
}

#pragma mark- UITableView DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    DiscussModel *model = self.dataArray[indexPath.row];
    return  [BTNewSameCommentsCell cellHeightWithDiscussModel:model];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTNewSameCommentsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierDiscuss forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.delegate = self;
    WS(ws);
    cell.likeBlock = ^(DiscussModel *model) {
        if (getUserCenter.userInfo.token.length == 0) {
            [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil animated:YES];
            return ;
        }
        NSInteger likeStatus;
        if (!model.liked) {
            likeStatus = 1;
        }else{
            likeStatus = 2;
        }
        [BTShowLoading show];
        LikeRequest *request = [[LikeRequest alloc] initWithLikeRefId:model.commentId likeRefType:1 likeStatus:likeStatus likedUserId:model.userId];
        [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            model.liked = !model.liked;
            model.likeCount = model.liked ? model.likeCount + 1 : model.likeCount - 1;
            [ws.mTableView reloadData];
            [BTShowLoading hide];
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    };
    
    //删除
    cell.deletBlock = ^(DiscussModel *model) {
        if (getUserCenter.userInfo.token.length == 0) {
            [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil animated:YES];
            return ;
        }
        NSLog(@"========到时候加删除接口=============");
        BTDeleteMyCommentRequest *api = [[BTDeleteMyCommentRequest alloc] initWithCommentId:[model.commentId integerValue]];
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            
            [ws requestDiscussCurrencyWith:RefreshStatePull];
            
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    };
    
    DiscussModel *model = self.dataArray[indexPath.row];
    cell.lookAllBlock = ^(NSInteger index, BOOL isAddLine) {
      
        model.IsOrNoLookDetail = !model.IsOrNoLookDetail;
        model.isAddOneLine     = isAddLine;
        [ws.dataArray replaceObjectAtIndex:index withObject:model];
        [ws.mTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    };
    [cell configWithDiscussModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    DiscussModel *model = self.dataArray[indexPath.row];
//    [BTCMInstance presentViewControllerWithName:@"BTNewCommentsAlert" andParams:@{@"commentId":model.commentId,@"isHaveShare":@(YES)} animated:YES];
}
#pragma mark BTNewSameCommentsCellDelegate
-(void)BTNewSameCommentsCellCopyLableWithDiscussModel:(DiscussModel *)model {
    
    NSLog(@"===============弹出键盘=============");
    
    //[BTCMInstance presentViewControllerWithName:@"BTNewCommentsAlert" andParams:@{@"commentId":model.commentId,@"isHaveShare":@(YES)} animated:YES];
    if (self.isSearch) {

        [BTCMInstance pushViewControllerWithName:@"BTNewCommentsAlert" andParams:@{@"commentId":model.commentId,@"isHaveShare":@(YES),@"isSearch":@(YES)} completion:^(id obj) {
            
            self.discussCurrencyIndex = 1;
            [self requestDiscussCurrencyWith:RefreshStatePull];
        }];
    }else {
        
        [BTCMInstance presentViewControllerWithName:@"BTNewCommentsAlert" andParams:@{@"commentId":model.commentId,@"isHaveShare":@(YES)} animated:YES ompletion:^(id obj) {
        
            self.discussCurrencyIndex = 1;
            [self requestDiscussCurrencyWith:RefreshStatePull];
        }];
    }
}

- (UIView *)blackBackView {
    if (!_blackBackView) {
        _blackBackView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
        _blackBackView.backgroundColor = [UIColor blackColor];
        _blackBackView.alpha = 0.5;
        _blackBackView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_blackBackView addGestureRecognizer:tap];
    }
    return _blackBackView;
}

- (void)tapAction{
    [self.commentAlertView.textV resignFirstResponder];
}


- (CommentDetailFootView *)commentAlertView {
    
    if (!_commentAlertView) {
        
        _commentAlertView = [CommentDetailFootView loadFromXib];
        _commentAlertView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 50);
//        _commentAlertView.textV.delegate = self;
        [_commentAlertView.fasongBtn addTarget:self action:@selector(fasongBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commentAlertView;
}
//发表评论
-(void)fasongBtnClick {
    
    if (!ISNSStringValid(self.commentAlertView.textV.text)) {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"shurupinglunneirong"] wait:YES];
        return;
    }
    self.commentAlertView.fasongBtn.enabled = NO;
    NSString *strCode = self.kindCode;
    if (strCode.length == 0) {
        return;
    }
    
    if(_submitRequest.isExecuting){
        [_submitRequest stop];
    }
    _submitRequest = [[SubmitCommentRequest alloc] initWithRefId:strCode refType:self.type refUserId:-1 content:self.commentAlertView.textV.text];
    
    [_submitRequest requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
       
        [self postRequest:self.commentAlertView.textV.text];
        self.commentAlertView.textV.text = nil;
        [AnalysisService alaysisDetail_discussion_send];
        self.mTableView.scrollsToTop = YES;
        self.commentAlertView.fasongBtn.enabled = YES;
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"pinglunchenggong"] wait:YES];
        [getUserCenter shareSuccseGetTanLiWithType:6 withTime:2];
        self.discussCurrencyIndex = 1;
        [self requestDiscussCurrencyWith:RefreshStatePull];
        [self.commentAlertView.textV resignFirstResponder];
    } failure:^(__kindof BTBaseRequest *request) {
        self.commentAlertView.fasongBtn.enabled = YES;
    }];
}
//滚动指定位置
-(void)SlidingToTop {
    //滚动指定位置
    if (self.dataArray.count > 0) {
        NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.mTableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)registerNsNotification {
    //监听当键盘将要出现时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//当键盘出现
- (void)keyboardWillShow:(NSNotification *)notification
{
//    if(!self.textFieldComment.isFirstResponder){
//        return;
//    }
    //获取键盘的高度
    NSLog(@"当键盘出现");
    NSLog(@"当键盘出现");
    [self.commentAlertView.textV becomeFirstResponder];
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    _keyboardHeight = height;
    self.blackBackView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.commentAlertView.frame = CGRectMake(0, ScreenHeight-height-50, ScreenWidth, 50);
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification{
    //获取键盘的高度
    NSLog(@"当键退出");
    self.blackBackView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    self.commentAlertView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 50);
}

//#pragma mark UITextViewDelegeta
//-(void)textViewDidChange:(UITextView *)textView {
//    
//    self.commentAlertView.placeL.hidden = self.commentAlertView.textV.text.length > 0;
//    [self.commentAlertView.fasongBtn setTitleColor:self.commentAlertView.textV.text.length > 0 ? MainBg_Color : CFontColor11 forState:UIControlStateNormal];
//    static CGFloat maxHeight = 73.0f;
//    
//    CGRect frame = textView.frame;
//    
//    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
//    
//    CGSize size = [textView sizeThatFits:constraintSize];
//    
//    NSLog(@"前======%.0f %.0f",size.height,frame.size.height);
//    if (size.height >= maxHeight) {
//        
//        size.height = maxHeight;
//        textView.scrollEnabled = YES;  // 允许滚动
//        
//    }else{
//        
//        textView.scrollEnabled = YES;    // 不允许滚动
//    }
//    NSLog(@"后======%.0f %.0f",size.height,frame.size.height);
//    self.commentAlertView.textV.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
//    self.commentAlertView.frame = CGRectMake(0, ScreenHeight-_keyboardHeight-50-(size.height-35), ScreenWidth, 15+size.height);
//    
//    if (textView == self.commentAlertView.textV) {
//        
//        if ([self.commentAlertView.textV.text length] > CommentsMaxLength) {
//            self.commentAlertView.textV.text = [self.commentAlertView.textV.text substringWithRange:NSMakeRange(0, CommentsMaxLength)];
//            [self.commentAlertView.textV.undoManager removeAllActions];
//            [self.commentAlertView.textV becomeFirstResponder];
//            return;
//        }
//    }
//}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (getUserCenter.userInfo.token.length == 0) {
        [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil animated:YES];
        return NO;
    }
    return YES;
}


//发帖子
- (void)postRequest:(NSString*)content{
    NSString *imagesKey = @"";
    NSString *afterContent = [NSString stringWithFormat:@"#%@# %@",self.postCode,content];
    NSDictionary *params = @{
                             @"content": SAFESTRING(afterContent),
                             @"images": SAFESTRING(imagesKey),
                             @"shareId": @(0),
                             @"sourceId": @(0),
                             @"type": @(4),//论币
                             @"userId": @([BTGetUserInfoDefalut sharedManager].userInfo.userId),
                             };
    BTAddPostRequest *addPostApi = [[BTAddPostRequest alloc] initWithDict:params];
    [addPostApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
    } failure:^(__kindof BTBaseRequest *request) {
       
      
    }];
}
@end
