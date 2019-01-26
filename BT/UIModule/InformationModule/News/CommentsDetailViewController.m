//
//  CommentsDetailViewController.m
//  BT
//
//  Created by admin on 2018/4/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CommentsDetailViewController.h"
#import "IndomationDetailCommentListRequest.h"
#import "CommentInfomationRequest.h"
#import "FastInfomationObj.h"
#import "InputAccessoryView.h"
#import "CommentsSameCell.h"
#import "DiscussModel.h"
#import "LikeRequest.h"
#import "BTGetCommentsDetailRequest.h"
static NSString *const identifier = @"CommentsSameCell";
@interface CommentsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet BTTextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewIcon;

@property (weak, nonatomic) IBOutlet UILabel *labelName;

@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@property (weak, nonatomic) IBOutlet UILabel *labelLike;

@property (weak, nonatomic) IBOutlet UILabel *labelContent;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewLike;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) InputAccessoryView *iaView;
@property (nonatomic, strong) UIView  *iaViewBack;
@property (nonatomic, strong) DiscussModel *detailModel;
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic,strong) UIView *blackBackView;
@end

@implementation CommentsDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.blackBackView];
    [self.iaViewBack addSubview:self.iaView];
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self.iaViewBack];
    [self.iaView.textView resignFirstResponder];
    [self.textField resignFirstResponder];
    [self registerNsNotification];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
    [self.blackBackView removeFromSuperview];
    [self.iaViewBack removeFromSuperview];
    [self.iaView.textView resignFirstResponder];
    [self.textField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    // Do any additional setup after loading the view from its nib.
}
+ (id)createWithParams:(NSDictionary *)params{
    CommentsDetailViewController *vc = [[CommentsDetailViewController alloc] init];
    vc.commentId = [params objectForKey:@"commentId"];
    return vc;
}
-(void)creatUI {
    
    if (iPhoneX) {
        
        self.bottomConstraint.constant = 34;
    }
    ViewRadius(self.textField, 35/2);
    self.title = [APPLanguageService wyhSearchContentWith:@"pinglunxiangqing"];
    self.pageIndex = 1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CommentsSameCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = CFontColor7;
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
    [self loadDatailData];
    [self requestList:RefreshStateNormal];
}
-(void)loadDatailData {
    
    BTGetCommentsDetailRequest *api = [[BTGetCommentsDetailRequest alloc] initWithCommentId:self.commentId];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        NSLog(@"%@",request.data);
        self.detailModel = [DiscussModel modelWithJSON:request.data];
        _iaView.titleL.text = [NSString stringWithFormat:@"回复：%@",self.detailModel.userName];
        [self refreshHeadView];
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
-(void)refreshHeadView {
    
    ViewRadius(self.imageViewIcon, 20);
    self.labelName.textColor = CFontColor5;
    self.labelTime.textColor = CGBorderColor;
    self.labelContent.textColor = CBlackColor;
    self.labelLike.textColor = CGrayColor;
    self.imageViewLike.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        
        NSLog(@"点赞!!!!!!!!!!!!");
        if (getUserCenter.userInfo.token.length == 0) {
            [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil animated:YES];
            return ;
        }
        NSInteger likeStatus;
        if (!self.detailModel.liked) {
            likeStatus = 1;
            self.detailModel.liked = YES;
            self.detailModel.likeCount = self.detailModel.likeCount + 1;
        }else{
            likeStatus = 2;
            self.detailModel.liked = NO;
            self.detailModel.likeCount = self.detailModel.likeCount - 1;
        }
        LikeRequest *request = [[LikeRequest alloc] initWithLikeRefId:self.commentId likeRefType:1 likeStatus:likeStatus likedUserId:self.detailModel.userId];
        [request requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            [self refreshHeadView];
            [[NSNotificationCenter  defaultCenter] postNotificationName:KNotificationCommentsOperation object:nil];
        } failure:^(__kindof BTBaseRequest *request) {
            
        }];
    }];
    [self.imageViewLike addGestureRecognizer:tap];
    
    if (self.detailModel) {
        self.labelName.text = self.detailModel.userName;
        [self.imageViewIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoImageURL,self.detailModel.userAvatar]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        self.labelLike.text = [NSString stringWithFormat:@"%ld",self.detailModel.likeCount];
        self.detailModel.likeCount > 0 ? (self.labelLike.textColor = CCommonRedColor) : (self.labelLike.textColor = CGrayColor);
        if (!self.detailModel.liked) {
            self.imageViewLike.image = [UIImage imageNamed:@"xin-nor"];
        }else{
            self.imageViewLike.image = [UIImage imageNamed:@"xin-sel"];
        }
        
        self.labelTime.text = [getUserCenter NewTimePresentationStringWithTimeStamp:[NSString stringWithFormat:@"%ld", (long)[self.detailModel.createTime timeIntervalSince1970]*1000]];
        self.labelContent.text = self.detailModel.content;
        [getUserCenter setLabelSpace:self.labelContent withValue:self.detailModel.content withFont:SYSTEMFONT(14) withHJJ:5.0 withZJJ:0.0];
        CGFloat height = [getUserCenter getSpaceLabelHeight:self.detailModel.content withFont:SYSTEMFONT(14) withWidth:ScreenWidth-83 withHJJ:5.0 withZJJ:0.0]+1;
        self.backViewHeight.constant = 81+height;
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
    //获取键盘的高度
    NSLog(@"当键盘出现");
    [self.iaView.textView becomeFirstResponder];
    //获取键盘的高度
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    int height = keyboardRect.size.height;
    
    self.blackBackView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.iaViewBack.frame = CGRectMake(0, ScreenHeight-height-167, ScreenWidth, 167);
    
}

//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    //获取键盘的高度
    
    NSLog(@"当键退出");
    
    self.blackBackView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight);
    self.iaViewBack.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 167);
    
}
#pragma mark UITextViewDelegeta
//将要开始编辑是
-(void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.iaView.titleL.hidden = self.iaView.textView.text.length > 0;
}
//正在编辑中
-(void)textViewDidChange:(UITextView *)textView {
    
    
    self.iaView.titleL.hidden = self.iaView.textView.text.length > 0;
    (self.iaView.textView.text.length > 0) ? (self.iaView.submitBtn.titleLabel.textColor = CGreenColor) : (self.iaView.submitBtn.titleLabel.textColor = CTbarColor);
    
    if ([self.iaView.textView.text length] > contentTVMaxLenth) {
        self.iaView.textView.text = [self.iaView.textView.text substringWithRange:NSMakeRange(0, contentTVMaxLenth)];
        [self.iaView.textView.undoManager removeAllActions];
        [self.iaView.textView becomeFirstResponder];
        return;
    }
}
- (void)requestList:(RefreshState)state{
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    IndomationDetailCommentListRequest *api = [[IndomationDetailCommentListRequest alloc] initWithRefType:3 refId:self.commentId pageIndex:self.pageIndex];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            if ([request.data count]) {
                
                [self.loadingView hiddenLoading];
            } else {
                
                [self.loadingView showNoDataWith:@"zanwurenhehuifuneirong"];
            }
            
            if ([request.data count] < BTPagesize) {
                self.tableView.mj_footer.hidden = YES;;
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else if (state == RefreshStateUp){
            if ([request.data count] < BTPagesize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }
        for (NSDictionary *dic in request.data) {
            
            DiscussModel *model = [DiscussModel modelWithJSON:dic];
            model.isOrNo   = NO;
            [self.dataArray addObject:model];
        }
        [self.tableView.mj_header endRefreshing];
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
    
    DiscussModel *model = self.dataArray[indexPath.row];
    return [CommentsSameCell cellHeightWithDiscussModel:model];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    DiscussModel *model = self.dataArray[indexPath.row];
    CommentsSameCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.isShowLike = NO;
    [cell configWithDiscussModel:model];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark layz
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
-(UIView *)iaViewBack {
    
    if (!_iaViewBack) {
        
        _iaViewBack = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 167)];
        _iaViewBack.backgroundColor = [UIColor blackColor];
    }
    return _iaViewBack;
}
-(UIView *)blackBackView {
    
    if (!_blackBackView) {
        
        _blackBackView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight)];
        _blackBackView.backgroundColor = [UIColor blackColor];
        _blackBackView.alpha = 0.5;
    }
    return _blackBackView;
}
-(InputAccessoryView *)iaView {
    
    if (!_iaView) {
        
        _iaView = [InputAccessoryView loadFromXib];
        _iaView.frame = CGRectMake(0, 0, ScreenWidth, 167);
        _iaView.textView.delegate = self;
        //_iaView.titleL.text = [NSString stringWithFormat:@"回复：%@",self.detailModel.userName];
        [_iaView.cancellBtn addTarget:self action:@selector(cancellBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_iaView.submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _iaView;
}
-(void)cancellBtnClick {
    
    [self.iaView.textView resignFirstResponder];
}
-(void)submitBtnClick {
    if (getUserCenter.userInfo.token.length == 0) {
        [BTCMInstance presentViewControllerWithName:@"logion" andParams:nil animated:YES];
        return ;
    }
    if (!ISNSStringValid(self.iaView.textView.text)) {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"shurupinglunneirong"] wait:YES];
        return;
    }
    self.iaView.submitBtn.enabled = NO;
    CommentInfomationRequest *api = [[CommentInfomationRequest alloc] initWithRefType:3 refId:self.commentId content:self.iaView.textView.text refUserId:self.detailModel.userId];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"pinglunchenggong"] wait:YES];
        self.iaView.textView.text = nil;
        [self.iaView.textView resignFirstResponder];
        self.iaView.submitBtn.enabled = YES;
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
        [[NSNotificationCenter  defaultCenter] postNotificationName:KNotificationCommentsOperation object:nil];
    } failure:^(__kindof BTBaseRequest *request) {
        self.iaView.submitBtn.enabled = YES;
    }];
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
