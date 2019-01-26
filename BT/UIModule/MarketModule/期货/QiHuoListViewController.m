//
//  QiHuoListViewController.m
//  BT
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 apple. All rights reserved.
//

//期货主页面
#import "QiHuoListViewController.h"
#import "BYListBar.h"
#import "QiHuoListContentVC.h"
#import "BTFutureListApi.h"
@interface QiHuoListViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) BYListBar *listBar;
@property (nonatomic, strong) UIScrollView *scrollViewContainer;
@property (nonatomic, strong) NSMutableArray *listTop;
@property (nonatomic, strong) BTFutureListApi *api;

@end

@implementation QiHuoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [APPLanguageService wyhSearchContentWith:@"qihuoshichang"];
    [self createUI];
    [self loadData];
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
    self.view.backgroundColor = isNightMode?ViewContentBgColor: CViewBgColor;
}

- (void)configMoveBar:(NSInteger)type{
    self.listBar = [[BYListBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 36)];
    self.listBar.backgroundColor = kHEXCOLOR(0xF5F5F5);
    [self.view addSubview:self.listBar];
    self.listBar.isFuture = YES;
    self.listBar.visibleItemList = [NSMutableArray arrayWithArray:self.listTop];
    WS(ws);
    self.listBar.listBarItemClickBlock = ^(NSString *itemName , NSInteger itemIndex){
       
        [MobClick event: [NSString stringWithFormat:@"qihuo_%@",itemName.lowercaseString]];
        [ws startTimeWithVcIndex:itemIndex];
        [BTConfigureService shareInstanceService].futureIndex = itemIndex;
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_future_needRequest object:nil];
        [UIView animateWithDuration:0.25 animations:^{
            ws.scrollViewContainer.contentOffset = CGPointMake(ScreenWidth * itemIndex, 0);
        }];
    };
    [self.listBar itemClickByScrollerWithIndex:0];
}

- (void)requestFutureList{
    
    [self configSubVCs];
    self.api = [[BTFutureListApi alloc] init];
    [self.api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data&&[request.data isKindOfClass:[NSArray class]]){
            for (NSInteger i = 0 ; i < [request.data count];i++) {
                QiHuoListContentVC *contentVC = [[QiHuoListContentVC alloc] init];
                NSDictionary *dict = request.data[i];
                contentVC.futureCode = SAFESTRING(dict[@"futureExchangeCode"]);
                [self.listTop addObject:SAFESTRING(dict[@"futureExchangeName"])];
                contentVC.view.frame =  CGRectMake(ScreenWidth *i, 0,ScreenWidth,self.scrollViewContainer.frame.size.height);
                [self addChildViewController:contentVC];
                [self.scrollViewContainer addSubview:contentVC.view];
            }
            
            self.scrollViewContainer.contentSize = CGSizeMake(ScreenWidth * [request.data count], self.scrollViewContainer.frame.size.height);
            [self configMoveBar:0];
        }
    } failure:^(__kindof BTBaseRequest *request) {
        //        [self.loadingView hiddenLoading];
    }];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index= round(scrollView.contentOffset.x / ScreenWidth);
    [self.listBar itemClickByScrollerWithIndex:index];
}

- (void)startTimeWithVcIndex:(NSInteger)index{
    UIViewController *vc = self.childViewControllers[index];
    for (UIView *vcItem in self.childViewControllers) {
        if (![vcItem isEqual:vc]) {
            if ([vcItem isKindOfClass:[QiHuoListContentVC class]]) {
//                [(QiHuoListContentVC *)vcItem stopTimer];
            }
           
        }
    }
//    if ([vc isKindOfClass:[QiHuoListContentVC class]]) {
//        [(QiHuoListContentVC *)vc startTimer];
//    }
    
}


@end
