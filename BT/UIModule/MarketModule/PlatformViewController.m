//
//  PlatformViewController.m
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PlatformViewController.h"
#import "PlatformNavagationView.h"
#import "XianHuoMainViewController.h"
#import "QiHuoMainViewController.h"
@interface PlatformViewController ()<UIScrollViewDelegate>{
    
    PlatformNavagationView *_navagaTionHeaderView;
}
@property (nonatomic,strong) UIScrollView     *scrollView;
@end

@implementation PlatformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self addNavigationItemWithImageNames:@[@"search2"] isLeft:NO target:self action:@selector(search:) tags:@[@1000]];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [AnalysisService alaysisExchange_page];
}

-(void)search:(UIButton *)btn {
    NSInteger index =  (NSInteger)(self.scrollView.contentOffset.x / ScreenWidth);
    NSString *title = @"";
    switch (index) {
        case 0:
            title = @"xianhuo";
            break;
        case 1:
            title = @"qihuo";
            
        default:
            break;
    }
    NSDictionary *dic =@{@"title":title};
    [AnalysisService alaysisExchange_search];
    [BTCMInstance presentViewControllerWithName:@"historySearch" andParams:dic animated:NO];
}

-(void)creatUI {
    
    _navagaTionHeaderView = [PlatformNavagationView loadFromXib];
    _navagaTionHeaderView.frame = CGRectMake(0, 0, ScreenWidth-150, 44);
    
    _navagaTionHeaderView.intrinsicContentSize = CGSizeMake(ScreenWidth-150, 44);
    self.navigationItem.titleView = _navagaTionHeaderView;
    [_navagaTionHeaderView.xianhuoBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_navagaTionHeaderView.qihuoBtn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
   
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth*2, 0);
    self.scrollView.delegate = self;
    //self.scrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.scrollView];
    
    //现货
    XianHuoMainViewController *orderListVC1 = [[XianHuoMainViewController alloc] init];
    orderListVC1.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49);
    //期货
    QiHuoMainViewController *orderListVC2 = [[QiHuoMainViewController alloc] init];
    
    orderListVC2.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight-64-49);
    
    [self addChildViewController:orderListVC1];
    [self addChildViewController:orderListVC2];
    [self.scrollView addSubview:orderListVC1.view];
    [self.scrollView addSubview:orderListVC2.view];
}

-(void)headerBtnClick:(UIButton *)btn {
    
    switch (btn.tag) {
        case 188:
            
            [_navagaTionHeaderView.xianhuoBtn setTitleColor:CBlackColor forState:UIControlStateNormal];
            _navagaTionHeaderView.xianhuoBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:16];
            [_navagaTionHeaderView.qihuoBtn setTitleColor:CGBorderColor forState:UIControlStateNormal];
            _navagaTionHeaderView.qihuoBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
            _navagaTionHeaderView.xianhuoL.hidden = YES;
            _navagaTionHeaderView.qihuoL.hidden   = NO;
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        case 189:
            [_navagaTionHeaderView.qihuoBtn setTitleColor:CBlackColor forState:UIControlStateNormal];
            _navagaTionHeaderView.qihuoBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:16];
            [_navagaTionHeaderView.xianhuoBtn setTitleColor:CGBorderColor forState:UIControlStateNormal];
            _navagaTionHeaderView.xianhuoBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
            _navagaTionHeaderView.qihuoL.hidden = YES;
            _navagaTionHeaderView.xianhuoL.hidden   = NO;
            [self.scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
            break;
        default:
            break;
    }
    
}
//视图已经开始滑动时触发的方法

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scrollView.contentOffset.x == 0) {
        
        [_navagaTionHeaderView.xianhuoBtn setTitleColor:CBlackColor forState:UIControlStateNormal];
        _navagaTionHeaderView.xianhuoBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:16];
        [_navagaTionHeaderView.qihuoBtn setTitleColor:CGBorderColor forState:UIControlStateNormal];
        _navagaTionHeaderView.qihuoBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
        _navagaTionHeaderView.xianhuoL.hidden = YES;
        _navagaTionHeaderView.qihuoL.hidden   = NO;
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    if (self.scrollView.contentOffset.x == ScreenWidth) {
        
        [_navagaTionHeaderView.qihuoBtn setTitleColor:CBlackColor forState:UIControlStateNormal];
        _navagaTionHeaderView.qihuoBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:16];
        [_navagaTionHeaderView.xianhuoBtn setTitleColor:CGBorderColor forState:UIControlStateNormal];
        _navagaTionHeaderView.xianhuoBtn.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Light" size:16];
        _navagaTionHeaderView.qihuoL.hidden = YES;
        _navagaTionHeaderView.xianhuoL.hidden   = NO;
        [self.scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
        
    }
    
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
