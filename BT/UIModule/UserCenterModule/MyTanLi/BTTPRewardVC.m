//
//  BTTPRewardVC.m
//  BT
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTTPRewardVC.h"
#import "BYListBar.h"
#import "BTTPRewardDetailVC.h"

@interface BTTPRewardVC()<UIScrollViewDelegate>

@property (nonatomic, strong) BYListBar *listBar;
@property (nonatomic, strong) UIScrollView *scrollViewContainer;
@property (nonatomic, strong) NSMutableArray *listTop;

@end

@implementation BTTPRewardVC
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [APPLanguageService sjhSearchContentWith:@"dashangjilu"];
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
    [self configListBar];
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
    self.listBar.listBarItemClickBlock = ^(NSString *itemName , NSInteger itemIndex){
        [BTConfigureService shareInstanceService].futureIndex = itemIndex;
        [[NSNotificationCenter defaultCenter] postNotificationName:NSNotification_future_needRequest object:nil];
        [UIView animateWithDuration:0.25 animations:^{
            ws.scrollViewContainer.contentOffset = CGPointMake(ScreenWidth * itemIndex, 0);
        }];
    };
    [self.listBar itemClickByScrollerWithIndex:type];
}

- (void)configListBar{
   NSArray *titles = @[[APPLanguageService sjhSearchContentWith:@"wodashangde"], [APPLanguageService sjhSearchContentWith:@"dashangwode"]];
    [self configSubVCs];
    for (NSInteger i = 0 ; i < titles.count;i++) {
        BTTPRewardDetailVC *contentVC = [[BTTPRewardDetailVC alloc] init];
        contentVC.isNoReward = i;
        [self.listTop addObject:titles[i]];
        contentVC.view.frame =  CGRectMake(ScreenWidth *i, 0,ScreenWidth,self.scrollViewContainer.frame.size.height);
        [self addChildViewController:contentVC];
        [self.scrollViewContainer addSubview:contentVC.view];
    }
    self.scrollViewContainer.contentSize = CGSizeMake(ScreenWidth * titles.count, self.scrollViewContainer.frame.size.height);
    if(self.parameters){
        [self configMoveBar:[self.parameters[@"index"] integerValue]];
    }else{
        [self configMoveBar:0];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index= round(scrollView.contentOffset.x / ScreenWidth);
    [self.listBar itemClickByScrollerWithIndex:index];
}


@end
