//
//  BTCandyViewController.m
//  BT
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTCandyViewController.h"
#import "BYListBar.h"
#import "BTCandyListContentVC.h"
#import "BTInfoListSubTypesRequest.h"

@interface BTCandyViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) BYListBar *listBar;
@property (nonatomic, strong) UIScrollView *scrollViewContainer;
@property (nonatomic, strong) NSMutableArray *listTop;
@property (nonatomic, strong) NSArray *topArr;
@end

@implementation BTCandyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [APPLanguageService sjhSearchContentWith:@"tangguozhuanqu"];
    [self createUI];
    [self loadData];
}

- (void)createUI{
    self.view.backgroundColor = isNightMode?ViewContentBgColor: CViewBgColor;;
    self.scrollViewContainer.delegate = self;
    [self.view addSubview:self.scrollViewContainer];
    [_scrollViewContainer.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
}

- (void)loadData{
    _listTop = @[].mutableCopy;
    BTInfoListSubTypesRequest *api = [[BTInfoListSubTypesRequest alloc] initWithParentType:7];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        
        if (request.data &&[request.data isKindOfClass:[NSArray class]]) {
            self.topArr = (NSArray*)request.data;
            [self configListBar];
        }
        
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
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

- (void)configMoveBar:(NSInteger)type{
    self.listBar = [[BYListBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 36)];
    [self.view addSubview:self.listBar];
    self.listBar.isFuture = YES;
    
    UIView *ivLine = [UIView new];
    ivLine.backgroundColor = SeparateColor;
    [self.view addSubview:ivLine];
    [ivLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(0.5);
        make.top.equalTo(self.listBar.mas_bottom).offset(-1);
    }];
    self.listBar.visibleItemList = [NSMutableArray arrayWithArray:self.listTop];
    WS(ws);
    NSDictionary *points = @{@"71":@"candy_airdrop",@"72":@"candy_platform",@"73":@"candy_app",@"74":@"candy_tel"};
    self.listBar.listBarItemClickBlock = ^(NSString *itemName , NSInteger itemIndex){
        [BTConfigureService shareInstanceService].futureIndex = itemIndex;
        NSString *value = SAFESTRING(ws.topArr[itemIndex][@"value"]);
        [MobClick event:points[value]];
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_future_needRequest object:nil];
        [UIView animateWithDuration:0.25 animations:^{
            ws.scrollViewContainer.contentOffset = CGPointMake(ScreenWidth * itemIndex, 0);
        }];
    };
    [self.listBar itemClickByScrollerWithIndex:0];
}

- (void)configListBar{

//    NSArray *titles = @[ [APPLanguageService sjhSearchContentWith:@"candykongtou"], [APPLanguageService sjhSearchContentWith:@"pingtai"], [APPLanguageService sjhSearchContentWith:@"app"],[APPLanguageService sjhSearchContentWith:@"dianbao"]];
    for (NSInteger i = 0 ; i < self.topArr.count;i++) {
        NSDictionary *dict = self.topArr[i];
        BTCandyListContentVC *contentVC = [[BTCandyListContentVC alloc] init];
        [self.listTop addObject:SAFESTRING(dict[@"name"])];
        contentVC.type = [SAFESTRING(dict[@"value"]) integerValue];
        contentVC.view.frame =  CGRectMake(ScreenWidth *i, 0,ScreenWidth,self.scrollViewContainer.frame.size.height);
        [self addChildViewController:contentVC];
        [self.scrollViewContainer addSubview:contentVC.view];
    }
    
    self.scrollViewContainer.contentSize = CGSizeMake(ScreenWidth * self.topArr.count, self.scrollViewContainer.frame.size.height);
    [self configMoveBar:0];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index= round(scrollView.contentOffset.x / ScreenWidth);
    [self.listBar itemClickByScrollerWithIndex:index];
}


@end
