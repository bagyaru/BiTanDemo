//
//  FastInfomationViewController.m
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FastInfomationViewController.h"
#import "FastInfomationCell.h"
#import "FastInfoRequest.h"
#import "FastInfomationSetionObj.h"
#import "FastInfomationObj.h"
#import "NSString+StringSize.h"
#import "NSString+Utils.h"
#import "NSDate+Extent.h"

#import "FastInfoShareView.h"
#import "UIView+saveImageWithScale.h"

static NSString *const identifier = @"FastInfomationCell";
@interface FastInfomationViewController ()<UITableViewDelegate,UITableViewDataSource,HYShareActivityViewDelegate,BTLoadingViewDelegate>{
    
     HYShareActivityView *_shareView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView *photoImageVIew;
@property (nonatomic, strong) BTLoadingView *loadingView;
@property (nonatomic, strong) UIImage *resultImage;
@property (nonatomic, strong) UIImage *resultShareOutImage;

@property (nonatomic, strong) FastInfoShareView *fastInfoShareV;
@property (nonatomic, strong) FastInfoShareView *fastInfoShareOutV;

@end

@implementation FastInfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(needRequest) name:NSNotification_SheQu_needRequest object:nil];
    //[self creatNewsHead];
    // Do any additional setup after loading the view from its nib.
}
- (void)needRequest{
    if (self.dataArray.count > 0) {
        return;
    }
    NSInteger index = [BTConfigureService shareInstanceService].sheQuIndex;
    NSArray *vcs = [[self.navigationController visibleViewController] childViewControllers];
    if (index < vcs.count) {
        if ([vcs[index] isEqual:self]) {
            [self requestList:RefreshStateNormal];
        }
    }
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)creatUI {

    self.pageIndex = 1;
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FastInfomationCell class]) bundle:nil] forCellReuseIdentifier:identifier];
    _tableView.backgroundColor = CViewBgColor;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.mj_header = [BTRefreshHeader headerWithRefreshingBlock:^{
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
    }];
    [_tableView configToTop:^{
        self.pageIndex = 1;
        [self requestList:RefreshStatePull];
    }];
    _tableView.mj_footer = [BTRefreshFooter footerWithRefreshingBlock:^{
        self.pageIndex++;
        [self requestList:RefreshStateUp];
    }];
   self.loadingView = [[BTLoadingView alloc] initWithParentView:self.view aboveSubView:_tableView delegate:self];
   //[self requestList:RefreshStateNormal];
   
}
- (void)requestList:(RefreshState)state{
   
    if (state == RefreshStateNormal) {
        self.pageIndex = 1;
        [self.loadingView showLoading];
    }
    FastInfoRequest *api = [[FastInfoRequest alloc] initWithPageIndex:self.pageIndex];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {

        if (state == RefreshStatePull || state == RefreshStateNormal) {
            [self.dataArray removeAllObjects];
            if ([request.data count]) {
                
                [self.loadingView hiddenLoading];
            } else {
                
                [self.loadingView showNoDataWith:@"zanwushuju"];
            }
            for (NSDictionary *dic in request.data) {
               
                FastInfomationSetionObj *setionObj = [[FastInfomationSetionObj alloc] init];
                setionObj.todayAndYesterday = [dic objectForKey:@"top"];
                NSArray *buttonArr = [dic objectForKey:@"bottom"];
                setionObj.fastInfoArray = [[NSMutableArray alloc] init];
                for (NSDictionary *oneInfoDict in buttonArr) {
                    
                    FastInfomationObj *obj = [FastInfomationObj objectWithDictionary:oneInfoDict];
                    obj.IsOrNoLookDetail = NO;
                    [setionObj.fastInfoArray addObject:obj];
                }
                [self.dataArray addObject:setionObj];
                
            }
            BOOL hasNext =[[request.responseObject objectForKey:@"hasNext"] boolValue];
            if (hasNext) {
               
                [self.tableView.mj_footer endRefreshing];
            }else{
            
                self.tableView.mj_footer.hidden = YES;
            }
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else if (state == RefreshStateUp){
//            if ([request.data count] < BTPagesize) {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }else{
//                [self.tableView.mj_footer endRefreshing];
//            }
            [self.tableView.mj_footer endRefreshing];
            for (NSDictionary *dic in request.data) {
                
                FastInfomationSetionObj *setionObjOld = self.dataArray[self.dataArray.count-1];
                FastInfomationSetionObj *setionObj = [[FastInfomationSetionObj alloc] init];
                setionObj.todayAndYesterday = [dic objectForKey:@"top"];
                NSArray *buttonArr = [dic objectForKey:@"bottom"];
                if (ISStringEqualToString(setionObjOld.todayAndYesterday, setionObj.todayAndYesterday)) {//本组数据与前一组数据比较 如果头部相同 则添加到前一组数据中
                    
                    for (NSDictionary *oneInfoDict in buttonArr) {
                        
                        FastInfomationObj *obj = [FastInfomationObj objectWithDictionary:oneInfoDict];
                        obj.IsOrNoLookDetail = NO;
                        
                        [setionObjOld.fastInfoArray addObject:obj];
                    }
                }else {//本组数据与前一组数据比较 如果头部不相同 则新添加一组数据
                    
                    
                    setionObj.fastInfoArray = [[NSMutableArray alloc] init];
                    for (NSDictionary *oneInfoDict in buttonArr) {
                        
                        FastInfomationObj *obj = [FastInfomationObj objectWithDictionary:oneInfoDict];
                        obj.IsOrNoLookDetail = NO;
                        
                        [setionObj.fastInfoArray addObject:obj];
                    }
                    [self.dataArray addObject:setionObj];
                }
               
            }
        }
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
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    FastInfomationSetionObj *setionObj = self.dataArray[section];
    return setionObj.fastInfoArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FastInfomationSetionObj *setionObj = self.dataArray[indexPath.section];
    FastInfomationObj *obj = setionObj.fastInfoArray[indexPath.row];

    CGFloat height = 0.0;
    CGFloat height1 = 0.0;
    
    if ([obj.content containsString:@"【"] && [obj.content containsString:@"】"]) {
        
        NSRange startRange = [obj.content rangeOfString:@"【"];
        NSRange endRange = [obj.content rangeOfString:@"】"];
        NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
        NSString *titleResult = [obj.content substringWithRange:range];
        NSString *contentResult = [[obj.content substringFromIndex:endRange.location] stringByReplacingOccurrencesOfString:@"】" withString:@""];
        
        height = [getUserCenter getSpaceLabelHeight:contentResult withFont:FONT(PF_REGULAR, 16) withWidth:ScreenWidth-50 withHJJ:6.0 withZJJ:0.0];
        
        height1 = [getUserCenter getSpaceLabelHeight:titleResult withFont:FONT(PF_MEDIUM, 16) withWidth:ScreenWidth-50 withHJJ:6.0 withZJJ:0.0];
    }else {
        
        height1  = 0.0;
        height = [getUserCenter getSpaceLabelHeight:obj.content withFont:FONT(PF_MEDIUM, 16) withWidth:ScreenWidth-50 withHJJ:6.0 withZJJ:0.0];
    }
    
    if (obj.IsOrNoLookDetail) {
        
        return height+height1+114;
        
    } else {
        
        if (height > 110) {
            
            return 110+height1+114;
        }else {
            
            return height+height1+114;
        }
    }
    return 110+height1+114;;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    FastInfomationSetionObj *setionObj = self.dataArray[section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 35)];
    view.backgroundColor = ViewBGColor;
    
    UIImageView *imageIV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 12, 12)];
    imageIV.image = IMAGE_NAMED(@"快讯时间");
    [view addSubview:imageIV];
    
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, ScreenWidth, 15)];
    lab.text= [NSString stringWithFormat:@"%@",setionObj.todayAndYesterday];
    lab.textColor = ThirdColor;
    lab.font =  FONT(@"PingFangSC-Regular", 14);
    [view addSubview:lab];
    return view;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    FastInfomationSetionObj *setionObj = self.dataArray[indexPath.section];
    FastInfomationObj *obj = setionObj.fastInfoArray[indexPath.row];
    FastInfomationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell creatUIWith:obj];
    cell.detailBtn.tag = indexPath.section*1000+indexPath.row;
    [cell.detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.shareBtn.tag = indexPath.section*100+indexPath.row;
    cell.shareBtn.ts_acceptEventInterval = 3.0;
    [cell.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(void)detailBtnClick:(BTButton *)btn {
    
    NSLog(@"第%ld组,第%ld行",btn.tag/1000,btn.tag%1000);
    FastInfomationSetionObj *setionObj = self.dataArray[btn.tag/1000];
    FastInfomationObj *obj = setionObj.fastInfoArray[btn.tag%1000];
    
    if (obj.IsOrNoLookDetail) {
        
        obj.IsOrNoLookDetail = NO;
    } else {
       obj.IsOrNoLookDetail = YES;
    }
    
    [setionObj.fastInfoArray replaceObjectAtIndex:btn.tag%1000 withObject:obj];
    [self.dataArray replaceObjectAtIndex:btn.tag/1000 withObject:setionObj];

   // 某个cell刷新
   NSIndexPath *indexPath = [NSIndexPath indexPathForRow:btn.tag%1000 inSection:btn.tag/1000];
   [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationFade];
}
//分享
-(void)shareBtnClick:(BTButton *)btn {
    
    [AnalysisService alaysisNews_newsflash_share];
    FastInfomationSetionObj *setionObj = self.dataArray[btn.tag/100];
    FastInfomationObj *obj = setionObj.fastInfoArray[btn.tag%100];
    
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

-(UIImage *)compressOriginalImage:(UIImage *)image toSize:(CGSize)size{
    UIImage * resultImage = image;
    UIGraphicsBeginImageContext(size);
    [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIGraphicsEndImageContext();
    return resultImage;
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
- (UIImageView *)photoImageVIew{
    if (!_photoImageVIew) {
       
        _photoImageVIew = [[UIImageView alloc] init];
        _photoImageVIew.userInteractionEnabled = YES;
    }
    return _photoImageVIew;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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

@end
