//
//  BTExchangeContainerVC.m
//  BT
//
//  Created by apple on 2018/9/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTExchangeContainerVC.h"
#import "BTExchangeToolBar.h"
#import "TabContentView.h"
#import "XianHuoDetailViewController.h"
#import "QuotesViewController.h"
#import "BTExchangeListModel.h"

@interface BTExchangeContainerVC ()<BTExchangeToolBarDelegate>

@property (nonatomic, strong) BTExchangeToolBar *toolBar;
@property (nonatomic, strong) TabContentView *tabContentView;

@end

@implementation BTExchangeContainerVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadData];
    //默认打一个市场的点
    [MobClick event:@"exchange_market"];
}

- (void)createUI{
    [self.view addSubview:self.toolBar];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.mas_equalTo(49.0f);
    }];
    [self.view addSubview:self.tabContentView];
    [self.tabContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 49, 0));
    }];
    self.tabContentView.navController = self.navigationController;
    [self configExchangeView];
}

- (void)loadData{
    
}
//
- (void)configExchangeView{
    BTExchangeListModel *model = self.parameters[@"model"];
    XianHuoDetailViewController *introVC = [[XianHuoDetailViewController alloc] init];
    introVC.exchangeId = model.exchangeId;
    introVC.exchangeCode = model.exchangeCode;
    introVC.isExchangeIntro = YES;
    
    QuotesViewController * quotesVC = [[QuotesViewController alloc] init];
    [quotesVC bk_associateValue:self.parameters withKey:UIViewController_key_parameters];
    NSMutableArray *controllers = @[quotesVC,introVC].mutableCopy;
    WS(ws)
    [self.tabContentView configParam:controllers Index:0 block:^(NSInteger index) {
        [ws.toolBar itemSelectIndex:index];
    }];
    self.title = model.exchangeName;
    
}

- (BTExchangeToolBar*)toolBar{
    if(!_toolBar){
        _toolBar = [[BTExchangeToolBar alloc] initWithFrame:CGRectZero];
        NSArray *menus =@[
                          @{@"image":@"exchange_market",@"selectImage":@"exchange_market_sel",@"title":@"shichang",@"index":@"0"
                            
                            },
                          @{@"image":@"exchange_intro",@"selectImage":@"exchange_intro_sel",@"title":@"jiaoyisuojieshao",@"index":@"1"
                            }
                         ];
        _toolBar.menus = menus;
        _toolBar.delegate = self;
    }
    return _toolBar;
}

- (TabContentView*)tabContentView{
    if(!_tabContentView){
        _tabContentView = [[TabContentView alloc] initWithFrame:CGRectZero];
        _tabContentView.backgroundColor = ViewBGColor;
        
    }
    return _tabContentView;
}

- (void)menuView:(BTExchangeToolBar*)containerView didClickIndex:(NSInteger)index{
    [self.tabContentView updateTab:index];
    if(index == 0){
        [MobClick event:@"exchange_market"];
    }else{
        [MobClick event:@"exchange_introduction"];
    }
}

@end
