//
//  MessageMainListViewController.m
//  BT
//
//  Created by admin on 2018/9/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MessageMainListViewController.h"
#import "BYListBar.h"
#import "QiHuoListContentVC.h"
#import "BTFutureListApi.h"
#import "MessageCenterViewController.h"
#import "ZanAndReplayListViewController.h"

#import "ReadAllMessageRequest.h"
#import "ReadAllLikedRequest.h"
#import "ReadAllReplayedRequest.h"
#import "CheckMessageUnreadRequest.h"
#import "MessageModel.h"

#import "BTAitMeListViewController.h"
#import "BTAllReadMessageRequest.h"
@interface MessageMainListViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) BYListBar *listBar;
@property (nonatomic, strong) UIScrollView *scrollViewContainer;
@property (nonatomic, strong) NSMutableArray *listTop;
@property (nonatomic, strong) BTFutureListApi *api;
@property (nonatomic, assign) NSInteger totalUnread;
@property (nonatomic, strong) NSString *allRead;
@end

@implementation MessageMainListViewController
-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUnreadMessageData) name:@"ReadSingleMessage" object:nil];
    [self checkMessageCenter];
}
-(void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //[self readAllMessage];
}
//读取单条未读消息 接到通知后 刷新未读消息接口
-(void)refreshUnreadMessageData {
    
    [self checkMessageCenter];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNavigationItemWithTitles:@[[APPLanguageService wyhSearchContentWith:@"quanbuyidu"]] isLeft:NO target:self action:@selector(btnClick:) tags:@[@(9999)] whereVC:@"全部已读"];
    self.title = [APPLanguageService wyhSearchContentWith:@"messageCenter"];
    //self.allRead = @"";
    [self createUI];
    [self loadData];
}
- (void)btnClick:(UIButton*)btn{
    if (self.totalUnread > 0) {
        self.allRead = @"全部已读";
        BTAllReadMessageRequest *api = [BTAllReadMessageRequest new];
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"yiquanbuyidu"] wait:YES];
            [self checkMessageCenter];
            [self viewDidLoad];
        } failure:^(__kindof BTBaseRequest *request) {
            
            
        }];
    }else {
        
        [MBProgressHUD showMessageIsWait:[APPLanguageService wyhSearchContentWith:@"yiquanbuyidu"] wait:YES];
    }
}
- (void)createUI{
    self.scrollViewContainer.delegate = self;
    [self.view addSubview:self.scrollViewContainer];
    [self configSubVCs];
    [_scrollViewContainer.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}
- (void)loadData{
    _listTop = @[].mutableCopy;
    [self requestFutureList];
}

- (UIScrollView *)scrollViewContainer{
    if (!_scrollViewContainer) {
        CGFloat bottom = 0.0;
        _scrollViewContainer = [[UIScrollView alloc] init];
        _scrollViewContainer.frame = CGRectMake(0, 36, ScreenWidth, ScreenHeight - kTopHeight - bottom - 36);
        _scrollViewContainer.pagingEnabled = YES;
        _scrollViewContainer.bounces = NO;
        _scrollViewContainer.showsHorizontalScrollIndicator = NO;
    }
    return _scrollViewContainer;
}

- (void)configSubVCs{
    self.view.backgroundColor = CViewBgColor;
}

- (void)configMoveBar:(NSInteger)type{
    self.listBar = [[BYListBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 36)];
    self.listBar.backgroundColor = kHEXCOLOR(0xF5F5F5);
    [self.view addSubview:self.listBar];
    self.listBar.isFuture = YES;
    self.listBar.isMessageCenter = YES;
    self.listBar.visibleItemList = [NSMutableArray arrayWithArray:self.listTop];
    WS(ws);
    self.listBar.listBarItemClickBlock = ^(NSString *itemName , NSInteger itemIndex){
        [ws startTimeWithVcIndex:itemIndex];
        [BTConfigureService shareInstanceService].futureIndex = itemIndex;
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_future_needRequest object:nil];
        [UIView animateWithDuration:0.25 animations:^{
            ws.scrollViewContainer.contentOffset = CGPointMake(ScreenWidth * itemIndex, 0);
        }];
    };
    [self.listBar itemClickByScrollerWithIndex:type];
}

- (void)requestFutureList{
    
    [self configSubVCs];
    [self.listTop addObjectsFromArray:@[[APPLanguageService wyhSearchContentWith:@"tongzhi"],[APPLanguageService wyhSearchContentWith:@"pinglun"],[APPLanguageService wyhSearchContentWith:@"dianzan"],[APPLanguageService wyhSearchContentWith:@"aitwode"]]];
    
    for (NSInteger i = 0 ; i < self.listTop.count;i++) {
        UIViewController *contentVC = nil;
        if (i == 0) {
            
            contentVC = [[MessageCenterViewController alloc] init];
        }
        if (i == 1) {
            ZanAndReplayListViewController * VC = [[ZanAndReplayListViewController alloc] init];
            VC.dic = @{@"type":@"2"};
            contentVC = VC;
        }
        if (i == 2) {
            ZanAndReplayListViewController * VC = [[ZanAndReplayListViewController alloc] init];
            VC.dic = @{@"type":@"1"};
            contentVC = VC;
        }
        
        if (i == 3) {
            contentVC = [[BTAitMeListViewController alloc] init];
        }
        
        contentVC.view.frame =  CGRectMake(ScreenWidth *i, 0,ScreenWidth,self.scrollViewContainer.frame.size.height);
        [self addChildViewController:contentVC];
        [self.scrollViewContainer addSubview:contentVC.view];
    }
    
    self.scrollViewContainer.contentSize = CGSizeMake(ScreenWidth * self.listTop.count, self.scrollViewContainer.frame.size.height);
    NSLog(@"%@",self.allRead);
    if (ISStringEqualToString(self.allRead, @"全部已读")) {
        [self configMoveBar:[UserDefaults integerForKey:@"MessageMainListViewController_ItemIndex"]];
    }else {
        [self configMoveBar:[self.parameters[@"index"] integerValue]];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index= round(scrollView.contentOffset.x / ScreenWidth);
    [self.listBar itemClickByScrollerWithIndex:index];
}

- (void)startTimeWithVcIndex:(NSInteger)index{
    NSLog(@"%ld",(long)index);
    [UserDefaults setInteger:index forKey:@"MessageMainListViewController_ItemIndex"];
    [UserDefaults synchronize];
//    if (index == 0) {
//        [self readAllMessage];
//    }
//    if (index == 1) {
//        [self readAllReplayed];
//    }
//    if (index == 2) {
//        [self readAllLiked];
//    }
//    if (index == 3) {//读取全部@我的信息
//        
//    }
}
//检查未读消息
-(void)checkMessageCenter {
    
    CheckMessageUnreadRequest *api = [[CheckMessageUnreadRequest alloc] initWithCheckMessageUnread];
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        MessageModel *model = [MessageModel modelWithJSON:request.data];
        NSMutableArray *unreadList = @[].mutableCopy;
        [unreadList addObject:model.message > 0 ? @(model.message) : @(0)];
        [unreadList addObject:model.comment > 0 ? @(model.comment) : @(0)];
        [unreadList addObject:model.like > 0 ? @(model.like) : @(0)];
        [unreadList addObject:model.mention > 0 ? @(model.mention) : @(0)];
        self.totalUnread = model.message + model.comment+ model.like+ model.mention;
        self.listBar.unreadNumList = [NSMutableArray arrayWithArray:unreadList];
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
    
}
-(void)readAllMessage {
    
    ReadAllMessageRequest *api = [[ReadAllMessageRequest alloc] initWithReadAllMessage];
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
         self.returnParamsBlock(nil);
        [self checkMessageCenter];
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
-(void)readAllLiked {
    
    ReadAllLikedRequest *api = [[ReadAllLikedRequest alloc] initWithReadAllLiked];
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        [self checkMessageCenter];
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
-(void)readAllReplayed {
    
    ReadAllReplayedRequest *api = [[ReadAllReplayedRequest alloc] initWithReadReplayed];
    
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        [self checkMessageCenter];
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
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
