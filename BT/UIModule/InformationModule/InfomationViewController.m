//
//  InfomationViewController.m
//  BT
//
//  Created by apple on 2018/1/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "InfomationViewController.h"
#import "InfomationNavagationView.h"
#import "FastInfomationViewController.h"
#import "NewsViewController.h"
#import "StrategyViewController.h"
#import "InfomationTopView.h"
#import "CheckMessageUnreadRequest.h"
#import "MessageModel.h"
#import "TopicListViewController.h"
#import "BTJCEntryView.h"
@interface InfomationViewController ()<UIScrollViewDelegate>{
    
    InfomationNavagationView *_navagaTionHeaderView;
}
@property (weak, nonatomic)  IBOutlet UIView   *backView;
@property (nonatomic,strong) InfomationTopView *topView;
@property (nonatomic,strong) UIScrollView      *scrollView;
@property (nonatomic,strong) BTJCEntryView     *jcView;
@end

@implementation InfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    self.title = [APPLanguageService wyhSearchContentWith:@"zixun"];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [AnalysisService alaysisNews_page];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)creatUI {
    self.topView.frame = self.backView.frame;
    [self.backView addSubview:self.topView];
    [self.topView.Btn1 addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView.Btn2 addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView.Btn3 addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView.Btn4 addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
   
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 36, ScreenWidth, ScreenHeight-64-36)];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth*4, 0);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    //要闻
    NewsViewController *orderListVC1 = [[NewsViewController alloc] init];
    orderListVC1.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49-36);
    //快讯
    FastInfomationViewController *orderListVC2 = [[FastInfomationViewController alloc] init];
    orderListVC2.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight-64-49-36);
    //话题
    TopicListViewController *orderListVC3 = [[TopicListViewController alloc] init];
    orderListVC3.view.frame = CGRectMake(ScreenWidth*2, 0, ScreenWidth, ScreenHeight-64-49-36);
    //新手攻略
    StrategyViewController *orderListVC4 = [[StrategyViewController alloc] init];
    orderListVC4.view.frame = CGRectMake(ScreenWidth*3, 0, ScreenWidth, ScreenHeight-64-49-36);
    [self addChildViewController:orderListVC1];
    [self addChildViewController:orderListVC2];
    [self addChildViewController:orderListVC3];
    [self addChildViewController:orderListVC4];
    [self.scrollView addSubview:orderListVC1.view];
    [self.scrollView addSubview:orderListVC2.view];
    [self.scrollView addSubview:orderListVC3.view];
    [self.scrollView addSubview:orderListVC4.view];
    
    UIView *back = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth-52-15, ScreenHeight-kTopHeight-kTabBarHeight-52-15, 52, 52)];
    [back addSubview:self.jcView];
    [self.view addSubview:back];
    //[self.scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
}
-(void)headerBtnClick:(UIButton *)btn {
    
    switch (btn.tag) {
        case 166:
            
            [self.topView.Btn1 setTitleColor:MainBg_Color forState:UIControlStateNormal];
            [self.topView.Btn2 setTitleColor:CFontColor11 forState:UIControlStateNormal];
            [self.topView.Btn3 setTitleColor:CFontColor11 forState:UIControlStateNormal];
            [self.topView.Btn4 setTitleColor:CFontColor11 forState:UIControlStateNormal];
            
            self.topView.line1.hidden = NO;
            self.topView.line2.hidden   = YES;
            self.topView.line3.hidden   = YES;
            self.topView.line4.hidden   = YES;
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        case 167:
            [self.topView.Btn2 setTitleColor:MainBg_Color forState:UIControlStateNormal];
            [self.topView.Btn1 setTitleColor:CFontColor11 forState:UIControlStateNormal];
            [self.topView.Btn3 setTitleColor:CFontColor11 forState:UIControlStateNormal];
            [self.topView.Btn4 setTitleColor:CFontColor11 forState:UIControlStateNormal];
            
            self.topView.line2.hidden = NO;
            self.topView.line1.hidden   = YES;
            self.topView.line3.hidden   = YES;
            self.topView.line4.hidden   = YES;
            [self.scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
            break;
        case 168:
            [self.topView.Btn3 setTitleColor:MainBg_Color forState:UIControlStateNormal];
            [self.topView.Btn2 setTitleColor:CFontColor11 forState:UIControlStateNormal];
            [self.topView.Btn1 setTitleColor:CFontColor11 forState:UIControlStateNormal];
            [self.topView.Btn4 setTitleColor:CFontColor11 forState:UIControlStateNormal];
            
            self.topView.line3.hidden = NO;
            self.topView.line2.hidden   = YES;
            self.topView.line1.hidden   = YES;
            self.topView.line4.hidden   = YES;
            [self.scrollView setContentOffset:CGPointMake(ScreenWidth*2, 0) animated:YES];
            break;
        case 169:
            [self.topView.Btn4 setTitleColor:MainBg_Color forState:UIControlStateNormal];
            [self.topView.Btn2 setTitleColor:CFontColor11 forState:UIControlStateNormal];
            [self.topView.Btn3 setTitleColor:CFontColor11 forState:UIControlStateNormal];
            [self.topView.Btn1 setTitleColor:CFontColor11 forState:UIControlStateNormal];
            
            self.topView.line4.hidden = NO;
            self.topView.line2.hidden   = YES;
            self.topView.line3.hidden   = YES;
            self.topView.line1.hidden   = YES;
            [self.scrollView setContentOffset:CGPointMake(ScreenWidth*3, 0) animated:YES];
            break;
        default:
            break;
    }
    
}
//视图已经开始滑动时触发的方法

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.scrollView.contentOffset.x == 0) {
        [AnalysisService alaysisNews_headlines];
        [self.topView.Btn1 setTitleColor:MainBg_Color forState:UIControlStateNormal];
        [self.topView.Btn2 setTitleColor:CFontColor11 forState:UIControlStateNormal];
        [self.topView.Btn3 setTitleColor:CFontColor11 forState:UIControlStateNormal];
        [self.topView.Btn4 setTitleColor:CFontColor11 forState:UIControlStateNormal];
        
        self.topView.line1.hidden   = NO;
        self.topView.line2.hidden   = YES;
        self.topView.line3.hidden   = YES;
        self.topView.line4.hidden   = YES;
        
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    if (self.scrollView.contentOffset.x == ScreenWidth) {
        [AnalysisService alaysisNews_newsflash];
        [self.topView.Btn2 setTitleColor:MainBg_Color forState:UIControlStateNormal];
        [self.topView.Btn1 setTitleColor:CFontColor11 forState:UIControlStateNormal];
        [self.topView.Btn3 setTitleColor:CFontColor11 forState:UIControlStateNormal];
        [self.topView.Btn4 setTitleColor:CFontColor11 forState:UIControlStateNormal];
        
        self.topView.line2.hidden = NO;
        self.topView.line1.hidden   = YES;
        self.topView.line3.hidden   = YES;
        self.topView.line4.hidden   = YES;
        [self.scrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:YES];
        
    }
    if (self.scrollView.contentOffset.x == ScreenWidth*2) {
        [AnalysisService alaysis_news_topic_list];
        [self.topView.Btn3 setTitleColor:MainBg_Color forState:UIControlStateNormal];
        [self.topView.Btn2 setTitleColor:CFontColor11 forState:UIControlStateNormal];
        [self.topView.Btn1 setTitleColor:CFontColor11 forState:UIControlStateNormal];
        [self.topView.Btn4 setTitleColor:CFontColor11 forState:UIControlStateNormal];
        
        self.topView.line3.hidden = NO;
        self.topView.line2.hidden   = YES;
        self.topView.line1.hidden   = YES;
        self.topView.line4.hidden   = YES;
        [self.scrollView setContentOffset:CGPointMake(ScreenWidth*2, 0) animated:YES];
    }
    if (self.scrollView.contentOffset.x == ScreenWidth*3) {
        [AnalysisService alaysisNews_tactic];
        [self.topView.Btn4 setTitleColor:MainBg_Color forState:UIControlStateNormal];
        [self.topView.Btn2 setTitleColor:CFontColor11 forState:UIControlStateNormal];
        [self.topView.Btn3 setTitleColor:CFontColor11 forState:UIControlStateNormal];
        [self.topView.Btn1 setTitleColor:CFontColor11 forState:UIControlStateNormal];
        
        self.topView.line4.hidden = NO;
        self.topView.line2.hidden   = YES;
        self.topView.line3.hidden   = YES;
        self.topView.line1.hidden   = YES;
        [self.scrollView setContentOffset:CGPointMake(ScreenWidth*3, 0) animated:YES];
    }
    
    
}
- (void)messageNaviBtnClick:(UIButton *)btn{
    
    if ([getUserCenter isLogined]) {
        [AnalysisService alaysisHome_message];
        [BTCMInstance pushViewControllerWithName:@"MessageCenter" andParams:nil];
    } else {
        
        [getUserCenter loginoutPullView];
    }
}
#pragma mark lazy
-(InfomationTopView *)topView {
    
    if (!_topView) {
        
        _topView = [InfomationTopView loadFromXib];
    }
    return _topView;
}
-(BTJCEntryView *)jcView {
    
    if (!_jcView) {
        _jcView = [BTJCEntryView loadFromXib];
        _jcView.frame = CGRectMake(0, 0, 52, 52);
        ViewRadius(_jcView, 26);
    }
    return _jcView;
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
