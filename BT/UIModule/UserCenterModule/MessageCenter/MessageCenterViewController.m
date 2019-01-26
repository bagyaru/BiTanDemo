//
//  MessageCenterViewController.m
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "MessageCenterCell.h"
#import "NoLoginView.h"
#import "MessageCenterObj.h"
#import "MessageCenterRequest.h"
#import "ReadAllMessageRequest.h"
#import "MessageHeadView.h"
#import "CheckMessageUnreadRequest.h"
#import "MessageModel.h"

#import "InfomationDetailRequest.h"
#import "FastInfomationObj.h"
#import "FastInfoShareView.h"
#import "UIView+saveImageWithScale.h"

static NSString *const identifier = @"MessageCenterCell";
@interface MessageCenterViewController ()<UITableViewDelegate,UITableViewDataSource,BTLoadingViewDelegate,HYShareActivityViewDelegate>{
    
    HYShareActivityView *_shareView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NoLoginView *noLoginView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) MessageHeadView *headView;
@property (nonatomic, strong) BTView *backView;
@property (nonatomic, strong) UIImageView *photoImageVIew;
@property (nonatomic, strong) UIImage *resultImage;
@property (nonatomic, strong) UIImage *resultShareOutImage;
@property (nonatomic, strong) FastInfoShareView *fastInfoShareV;
@property (nonatomic, strong) FastInfoShareView *fastInfoShareOutV;
@property (nonatomic, strong) InfomationDetailRequest *InfomationDetailApi;

@property (nonatomic, assign) BOOL isAgainRequest;
@end

@implementation MessageCenterViewController
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    //[self checkMessageCenter];
    
}
-(void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    self.isAgainRequest = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    //[self readAllMessage];
    // Do any additional setup after loading the view from its nib.
}
-(void)readAllMessage {
    
    ReadAllMessageRequest *api = [[ReadAllMessageRequest alloc] initWithReadAllMessage];
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
-(void)creatUI {
    self.title = [APPLanguageService wyhSearchContentWith:@"messageCenter"];
    self.pageIndex = 1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageCenterCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = CWhiteColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    //_tableView.tableHeaderView = self.backView;
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
    MessageCenterRequest *api = [[MessageCenterRequest alloc] initWithMesageCenter:self.pageIndex];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            
            if ([request.data count]) {
                
                [self.loadingView hiddenLoading];
            } else {
                
                [self.loadingView showNoDataWithMessage:@"meiyoufaxiantongzhi" imageString:@"ic_zanwutongzhi"];
            }
            for (NSDictionary *dic in request.data) {
                
                MessageCenterObj *obj = [MessageCenterObj objectWithDictionary:dic];
                obj.IsOrNoLookDetail = NO;
                obj.unread = [[dic objectForKey:@"unread"] boolValue];
                obj.messageId = dic[@"id"];
                if (ISStringEqualToString(obj.messageCode, @"REPLY_FEEDBACK")) {
                    
                    NSArray *contentArray = [obj.content componentsSeparatedByString:@"@source@"];
                    obj.content = contentArray[0];
                    obj.feedBackcontent = contentArray[1];
                }
                
                [self.dataArray addObject:obj];
                
            }
            if (!request.hasNext) {
                self.tableView.mj_footer.hidden = YES;;
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
        }else if (state == RefreshStateUp){
            if (!request.hasNext) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer endRefreshing];
            }
            for (NSDictionary *dic in request.data) {
                
                MessageCenterObj *obj = [MessageCenterObj objectWithDictionary:dic];
                obj.IsOrNoLookDetail = NO;
                obj.messageId = dic[@"id"];
                obj.unread = [[dic objectForKey:@"unread"] boolValue];
                if (ISStringEqualToString(obj.messageCode, @"REPLY_FEEDBACK")) {
                    
                    NSArray *contentArray = [obj.content componentsSeparatedByString:@"@source@"];
                    obj.content = contentArray[0];
                    obj.feedBackcontent = contentArray[1];
                }
                [self.dataArray addObject:obj];
                
            }
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
- (IBAction)goNewZanList:(UIButton *)sender {
    
    [BTCMInstance pushViewControllerWithName:@"ZanAndReplayListVC" andParams:@{@"type":@"1"}];
}
- (IBAction)goNewReplayList:(UIButton *)sender {
    
    [BTCMInstance pushViewControllerWithName:@"ZanAndReplayListVC" andParams:@{@"type":@"2"}];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MessageCenterObj *obj = self.dataArray[indexPath.row];
    CGFloat feedBackHeight = 0.0;
    CGFloat sourceHeight = 0.0;
    CGFloat height = 0.0;
    if (ISStringEqualToString(obj.messageCode, @"REPLY_FEEDBACK")) {
        
        feedBackHeight = [getUserCenter getSpaceLabelHeight:obj.feedBackcontent withFont:SYSTEMFONT(14) withWidth:ScreenWidth-30 withHJJ:6.0 withZJJ:0.0]+1+50;
        
    }
    
    if (ISStringEqualToString(obj.messageCode, @"COIN_CIRCLE_AUDIT_PASS")||ISStringEqualToString(obj.messageCode, @"POST_TPREWARD")||ISStringEqualToString(obj.messageCode, @"POSTREPORT_TPREWARD")) {//发表文章 帖子奖励
        
        sourceHeight = 50;
    }
    
    height = [getUserCenter getSpaceLabelHeight:obj.content withFont:SYSTEMFONT(14) withWidth:ScreenWidth-30 withHJJ:6.0 withZJJ:0.0];
    if (ISStringEqualToString(obj.messageCode, @"SYSTEM")||ISStringEqualToString(obj.messageCode, @"POST_OFFLINE")||ISStringEqualToString(obj.messageCode, @"COIN_CIRCLE_AUDIT_PASS")||ISStringEqualToString(obj.messageCode, @"POST_TPREWARD")||ISStringEqualToString(obj.messageCode, @"POSTREPORT_TPREWARD")) {//文章被下架 文章被驳回 帖子下线 禁言 发表文章 帖子奖励 探报奖励
        height = [getUserCenter getSpaceLabelHeight:obj.content withFont:SYSTEMFONT(16) withWidth:ScreenWidth-30-((ISStringEqualToString(obj.messageCode, @"SYSTEM")||ISStringEqualToString(obj.messageCode, @"POST_OFFLINE")||ISStringEqualToString(obj.messageCode, @"USER_BANNED")||ISStringEqualToString(obj.messageCode, @"COIN_CIRCLE_AUDIT_PASS")) ? 0 : 43) withHJJ:6.0 withZJJ:0.0]+1-20;
    }
    if (obj.IsOrNoLookDetail) {
        
        return height+140+feedBackHeight+sourceHeight;
        
    } else {
        
        
        if (ISStringEqualToString(obj.messageCode, @"SYSTEM")||ISStringEqualToString(obj.messageCode, @"POST_OFFLINE")||ISStringEqualToString(obj.messageCode, @"COIN_CIRCLE_AUDIT_PASS")||ISStringEqualToString(obj.messageCode, @"POST_TPREWARD")||ISStringEqualToString(obj.messageCode, @"POSTREPORT_TPREWARD")) {//文章被下架 文章被驳回 帖子下线 禁言 发表文章 帖子奖励 探报奖励
           
            return height+140-40+feedBackHeight+sourceHeight+14;//内容过小 隐藏查看详情按钮
            
        }else {
            
            if (height > 65) {
                
                return 200+feedBackHeight+sourceHeight+14;
            }else {
                if (ISStringEqualToString(obj.messageCode, @"COIN_CIRCLE")||ISStringEqualToString(obj.messageCode, @"INFORMATION_RECOMMEND")) {
                    
                    return height+140+feedBackHeight+sourceHeight;
                }
                return height+140-40+feedBackHeight+sourceHeight+14;//内容过小 隐藏查看详情按钮
            }
        }
    }
    
    return 200+feedBackHeight+sourceHeight;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MessageCenterObj *obj = self.dataArray[indexPath.row];
    MessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell creatUIWith:obj];
    cell.detailBtn.tag = 1000+indexPath.row;
    [cell.detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MessageCenterObj *obj = self.dataArray[indexPath.row];
    
    [self goDetailViewControllerWithModel:obj];
}
-(void)detailBtnClick:(BTButton *)btn {
    
    NSLog(@"第%ld行",btn.tag-1000);
    
    MessageCenterObj *obj = self.dataArray[btn.tag-1000];
    if (obj.IsOrNoLookDetail) {
        
        obj.IsOrNoLookDetail = NO;
    } else {
        obj.IsOrNoLookDetail = YES;
    }
    
    [self.dataArray replaceObjectAtIndex:btn.tag-1000 withObject:obj];
    // 某个cell刷新
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag-1000 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
    
    [self goDetailViewControllerWithModel:obj];
}
-(void)goDetailViewControllerWithModel:(MessageCenterObj *)obj {
    
    if (ISStringEqualToString(obj.messageCode, @"COIN_CIRCLE")||ISStringEqualToString(obj.messageCode, @"COIN_CIRCLE_AUDIT_PASS")||ISStringEqualToString(obj.messageCode, @"POSTREPORT_TPREWARD")) {//探报 探报发表成功 探报奖励
        if ([obj.sourceInfo isKindOfClass:[NSDictionary class]]) {
            [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":obj.refId,@"bigType":@(6)}];
        }
    }
    if (ISStringEqualToString(obj.messageCode, @"INFORMATION_RECOMMEND")) {//要闻 攻略
        if (self.isAgainRequest) {
            return;
        }
        self.isAgainRequest = YES;
        self.InfomationDetailApi = [[InfomationDetailRequest alloc] initWithDetailID:obj.refId];
        [self.InfomationDetailApi requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            //[self.loadingView hiddenLoading];
            FastInfomationObj *model = [FastInfomationObj objectWithDictionary:request.data];
            
            if (model.type == 1) {//快讯
                [self shareBtnClick:model];
            }else {//其他资讯
                
                [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":obj.refId}];
            }
            
        } failure:^(__kindof BTBaseRequest *request) {
            
            self.isAgainRequest = NO;
        }];
        
    }
    if (ISStringEqualToString(obj.messageCode, @"POST_TPREWARD") && [obj.sourceInfo isKindOfClass:[NSDictionary class]]) {//帖子奖励
        
        [BTCMInstance pushViewControllerWithName:@"FOTPostDetailViewController" andParams:@{@"postId":obj.refId}];
    }
    WS(ws);
    [getUserCenter ReadSingleMessageWithMessageId:[obj.messageId integerValue] andType:1 andUnread:obj.unread completion:^{
        KPostNotification(@"ReadSingleMessage", nil);
        ws.pageIndex = 1;
        [ws requestList:RefreshStatePull];
    }];
}

//分享
-(void)shareBtnClick:(FastInfomationObj *)obj {
    
    [AnalysisService alaysisNews_newsflash_share];
    
    self.fastInfoShareV.obj = obj;
    self.fastInfoShareOutV.obj = obj;
    CGFloat height    = 0.0;
    CGFloat heightOut = 0.0;
    if ([obj.content containsString:@"【"] && [obj.content containsString:@"】"]) {
        NSRange startRange = [obj.content rangeOfString:@"【"];
        NSRange endRange = [obj.content rangeOfString:@"】"];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *titleResult = [obj.content substringWithRange:range];
        NSString *contentResult = [[obj.content substringFromIndex:endRange.location] stringByReplacingOccurrencesOfString:@"】" withString:@""];
        NSLog(@"%@ %@",titleResult,contentResult);
        
        CGFloat titleHeight = [getUserCenter getSpaceLabelHeight:titleResult withFont:FONT(@"PingFangSC-Medium", 20) withWidth:235 withHJJ:4.0 withZJJ:0.0];
        CGFloat contentHeight = [getUserCenter getSpaceLabelHeight:contentResult withFont:FONTOFSIZE(14) withWidth:235 withHJJ:8.0 withZJJ:0.0];;
        NSLog(@"%.0f  %.0f",titleHeight,contentHeight);
        height = 86.0 + 124.0 + 107.0 + contentHeight +titleHeight;
        
        CGFloat titleOutHeight = [getUserCenter getSpaceLabelHeight:titleResult withFont:FONT(@"PingFangSC-Medium", 20) withWidth:ScreenWidth-70 withHJJ:4.0 withZJJ:0.0];
        CGFloat contentOutHeight = [getUserCenter getSpaceLabelHeight:contentResult withFont:FONTOFSIZE(14) withWidth:ScreenWidth-70 withHJJ:8.0 withZJJ:0.0];;
        NSLog(@"%.0f  %.0f",titleHeight,contentHeight);
        heightOut = 86.0 + 124.0 + 107.0 + contentOutHeight +titleOutHeight;
        
    }else {
        
        CGFloat titleHeight = 0.0;
        CGFloat contentHeight = [getUserCenter getSpaceLabelHeight:obj.content withFont:FONTOFSIZE(14) withWidth:235 withHJJ:8.0 withZJJ:0.0];;
        NSLog(@"%.0f  %.0f",titleHeight,contentHeight);
        height = 86.0 + 124.0 + 107.0 + contentHeight +titleHeight;
        
        CGFloat titleOutHeight = 0.0;
        CGFloat contentOutHeight = [getUserCenter getSpaceLabelHeight:obj.content withFont:FONTOFSIZE(14) withWidth:ScreenWidth-70 withHJJ:8.0 withZJJ:0.0];;
        NSLog(@"%.0f  %.0f",titleHeight,contentHeight);
        heightOut = 86.0 + 124.0 + 107.0 + contentOutHeight +titleOutHeight;
    }
    self.fastInfoShareOutV.frame = CGRectMake(0, 0, ScreenWidth, heightOut);
    [self.fastInfoShareOutV layoutIfNeeded];
    self.resultShareOutImage = [self.fastInfoShareOutV saveImageWithScale:[UIScreen mainScreen].scale];
    
    self.fastInfoShareV.frame = CGRectMake(0, 0, 305, height);
    [self.fastInfoShareV layoutIfNeeded];
    self.resultImage = [self.fastInfoShareV saveImageWithScale:[UIScreen mainScreen].scale];
    [self alertShareView];
    self.fastInfoShareV = nil;
    self.fastInfoShareOutV = nil;
}

-(void)alertShareView {
    
    self.photoImageVIew.image = self.resultImage;
    self.photoImageVIew.frame = CGRectMake((ScreenWidth-305)/2, self.resultImage.size.height > ScreenHeight-160-kTopHeight ? kTopHeight : (ScreenHeight-160-self.resultImage.size.height)/2, 305, self.resultImage.size.height);
    //分享
    _shareView = [[HYShareActivityView alloc] initWithButtons:@[@(HYSharePlatformTypeWechatSession),@(HYSharePlatformTypeWechatTimeline),@(HYSharePlatformTypeSinaWeibo),@(HYSharePlatformTypeCopy)] title:@"快讯" image:self.photoImageVIew shareTypeBlock:^(HYSharePlatformType type) {
        
        [self shareActiveType:type];
    }];
    
    _shareView.delegate = self;
    [_shareView show];
}
-(void)shareActiveType:(NSUInteger)type {
    
    if (self.resultImage)
    {
        if (type == 4) {//保存图片
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImageWriteToSavedPhotosAlbum(self.resultShareOutImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            });
            
            return;
        }
        
        //        if (type == 2) {//微博
        //            if ([WeiboSDK isWeiboAppInstalled] )
        //            {
        //                [getUserCenter shareSuccseGetTanLiWithType:3 withTime:2];
        //            }
        //        }else {//微信
        //
        //            if ([WXApi isWXAppInstalled] )
        //            {
        //                [getUserCenter shareSuccseGetTanLiWithType:3 withTime:2];
        //            }
        //        }
        [getUserCenter shareBuriedPointWithType:type withWhereVc:10];
        HYShareInfo *info = [[HYShareInfo alloc] init];
        info.content = [APPLanguageService wyhSearchContentWith:@"fenxiangfubiaoti"];
        info.images = self.resultShareOutImage;
        info.type = (HYPlatformType)type;
        info.shareType    = HYShareDKContentTypeImage;
        [HYShareKit shareImageWeChat:info  completion:^(NSString *errorMsg)
         {
             if ( ISNSStringValid(errorMsg) )
             {
                 
                 [MBProgressHUD showMessageIsWait:errorMsg wait:YES];
                 [getUserCenter shareSuccseGetTanLiWithType:3 withTime:2];
                 [self.photoImageVIew removeFromSuperview];
                 self.photoImageVIew = nil;
                 [_shareView hide];
             }
         }];
    }else
    {
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"fenxiangshibai"] wait:YES];
    }
}
-(void)closeView {
    
    [self.photoImageVIew removeFromSuperview];
    self.photoImageVIew = nil;
    self.isAgainRequest = NO;
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"baocunshibai"] wait:YES];
    } else {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"chenggongbaocundaoxiangce"] wait:YES];
    }
}

#pragma mark - lazy

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NoLoginView *)noLoginView{
    if (!_noLoginView) {
        _noLoginView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NoLoginView class]) owner:self options:nil][0];
    }
    return _noLoginView;
}
-(MessageHeadView *)headView {
    
    if (!_headView) {
        
        _headView = [MessageHeadView loadFromXib];
        _headView.frame = CGRectMake(0, 0, ScreenWidth, 157);
    }
    
    return _headView;
}
-(BTView *)backView {
    
    if (!_backView) {
        _backView = [[BTView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 157)];
        [_backView addSubview:self.headView];
    }
    return _backView;
}
- (UIImageView *)photoImageVIew{
    if (!_photoImageVIew) {
        
        _photoImageVIew = [[UIImageView alloc] init];
        _photoImageVIew.userInteractionEnabled = YES;
    }
    return _photoImageVIew;
}
- (FastInfoShareView*)fastInfoShareV{
    if(!_fastInfoShareV){
        _fastInfoShareV = [FastInfoShareView loadFromXib];
        _fastInfoShareV.frame = CGRectMake(0, 0, ScreenWidth, 600);
    }
    return _fastInfoShareV;
}
-(FastInfoShareView *)fastInfoShareOutV {
    
    if (!_fastInfoShareOutV) {
        _fastInfoShareOutV = [FastInfoShareView loadFromXib];
        _fastInfoShareOutV.frame = CGRectMake(0, 0, ScreenWidth, 600);
    }
    return _fastInfoShareOutV;
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
