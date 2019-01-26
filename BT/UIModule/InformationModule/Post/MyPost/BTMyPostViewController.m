//
//  BTMyPostViewController.m
//  BT
//
//  Created by apple on 2018/9/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTMyPostViewController.h"
#import "SGPagingView.h"
#import "UIView+SGPagingView.h"
#import "SGCenterTableView.h"
#import "SGPageTitleView.h"

#import "BTMyPostAllVC.h"
#import "BTMyPostCommentVC.h"
#import "BTMyPostCollectVC.h"
#import "BTMyPostHeaderView.h"
#import "BTPostMainListHeadRequest.h"
#import "BTPostMainListModel.h"
#import "BTPostComposeViewController.h"
@interface BTMyPostViewController ()<UITableViewDelegate,UITableViewDataSource,SGPageTitleViewDelegate,SGCenterChildBaseVCDelegate,SGPageContentCollectionViewDelegate>

@property (nonatomic, strong) SGPageTitleView *pageTitleView;
@property (nonatomic, strong) SGPageContentCollectionView *pageContentCollectionView;
@property (nonatomic, strong) UIScrollView *childVCScrollView;
@property (nonatomic, strong) SGCenterTableView *tableView;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong)BTMyPostHeaderView *postHeader;

@end

@implementation BTMyPostViewController

static CGFloat const PersonalCenterVCPageTitleViewHeight = 44;

- (CGFloat)topViewHeight{
    return 80.0f;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self foundTableView];
    [self loadMyPostsInfoData];
    self.title = [APPLanguageService sjhSearchContentWith:@"wodetiezi"];
    [self setRightBtn];
}

- (void)setRightBtn{
    UIBarButtonItem * rightBarItem = [[UIBarButtonItem alloc] initWithTitle:[APPLanguageService sjhSearchContentWith:@"fatie"] style:UIBarButtonItemStylePlain target:self action:@selector(addPost)];
    [rightBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                           NSForegroundColorAttributeName : MainBg_Color} forState:UIControlStateNormal];
    [rightBarItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                           NSForegroundColorAttributeName : MainBg_Color} forState:UIControlStateHighlighted];
    self.navigationItem.rightBarButtonItem = rightBarItem;
}

- (void)loadMyPostsInfoData {
    BTPostMainListHeadRequest *api = [BTPostMainListHeadRequest new];
    [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
        if(request.data &&[request.data isKindOfClass:[NSDictionary class]]){
            BTPostMainListModel *model = [BTPostMainListModel objectWithDictionary:request.data];
            self.postHeader.viewCountL.text = SAFESTRING(@(model.viewCount));
            self.postHeader.huozanCountL.text = SAFESTRING(@(model.likeCount));
            self.postHeader.zhuanfaCountL.text = SAFESTRING(@(model.shareCount));
        }
    } failure:^(__kindof BTBaseRequest *request) {
        
    }];
}
#pragma mark --Create UI
- (void)foundTableView {
    CGFloat tableViewH = self.view.frame.size.height;
    self.tableView = [[SGCenterTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, tableViewH) style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.sectionHeaderHeight = PersonalCenterVCPageTitleViewHeight;
    _tableView.rowHeight = self.view.frame.size.height - PersonalCenterVCPageTitleViewHeight;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    self.tableView.tableHeaderView = self.headerView;
}
//
- (UIView*)headerView{
    if(!_headerView){
        _headerView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, ScreenWidth, [self topViewHeight])];
        [_headerView addSubview:self.postHeader];
        [self.postHeader mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_headerView);
        }];
    }
    return _headerView;
}

- (BTMyPostHeaderView*)postHeader{
    if(!_postHeader){
        _postHeader = [BTMyPostHeaderView loadFromXib];
    }
    return _postHeader;
}

- (SGPageTitleView *)pageTitleView {
    if (!_pageTitleView) {
        NSArray *titleArr = @[[APPLanguageService sjhSearchContentWith:@"quanbu"], [APPLanguageService sjhSearchContentWith:@"yuanchuang"],[APPLanguageService wyhSearchContentWith:@"pinglun"], [APPLanguageService wyhSearchContentWith:@"shoucang"]];
        SGPageTitleViewConfigure *configure = [SGPageTitleViewConfigure pageTitleViewConfigure];
        configure.titleSelectedColor = kHEXCOLOR(0x108ee9);
        configure.titleColor = SecondColor;
        configure.indicatorColor = kHEXCOLOR(0x108ee9);
        configure.showBottomSeparator = YES;
        _pageTitleView = [SGPageTitleView pageTitleViewWithFrame:CGRectMake(0, 0, ScreenWidth, PersonalCenterVCPageTitleViewHeight) delegate:self titleNames:titleArr configure:configure];
        _pageTitleView.backgroundColor = isNightMode?ViewContentBgColor:CWhiteColor;
    }
    return _pageTitleView;
}

- (SGPageContentCollectionView *)pageContentCollectionView {
    if (!_pageContentCollectionView) {
        
        BTMyPostAllVC *postAllVC = [[BTMyPostAllVC alloc] init];
        postAllVC.delegatePersonalCenterChildBaseVC = self;
        postAllVC.original = NO;
        
        BTMyPostAllVC *postVC = [[BTMyPostAllVC alloc] init];
        postVC.delegatePersonalCenterChildBaseVC = self;
        postVC.original = YES;
        
        BTMyPostCommentVC *commentVC = [[BTMyPostCommentVC alloc] init];
        commentVC.delegatePersonalCenterChildBaseVC = self;
        
        BTMyPostCollectVC *collectVC = [[BTMyPostCollectVC alloc] init];
        collectVC.delegatePersonalCenterChildBaseVC = self;
        
        NSArray *childArr = @[postAllVC,postVC,commentVC,collectVC];
        CGFloat ContentCollectionViewHeight = self.view.frame.size.height  - PersonalCenterVCPageTitleViewHeight;
        _pageContentCollectionView = [[SGPageContentCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ContentCollectionViewHeight) parentVC:self childVCs:childArr];
        _pageContentCollectionView.delegatePageContentCollectionView = self;
    }
    return _pageContentCollectionView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.childVCScrollView && _childVCScrollView.contentOffset.y > 0) {
        self.tableView.contentOffset = CGPointMake(0, [self topViewHeight]);
    }
    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY < [self topViewHeight]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pageTitleViewToTop" object:nil];
    }
}
- (void)personalCenterChildBaseVCScrollViewDidScroll:(UIScrollView *)scrollView {
    self.childVCScrollView = scrollView;
    if (self.tableView.contentOffset.y < [self topViewHeight]) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    } else {
       self.tableView.contentOffset = CGPointMake(0, [self topViewHeight]);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [cell.contentView addSubview:self.pageContentCollectionView];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.pageTitleView;
}

#pragma mark - - - SGPageTitleViewDelegate - SGPageContentCollectionViewDelegate
- (void)pageTitleView:(SGPageTitleView *)pageTitleView selectedIndex:(NSInteger)selectedIndex {
    [self.pageContentCollectionView setPageContentCollectionViewCurrentIndex:selectedIndex];
    //
    if(selectedIndex == 0){
        [MobClick event:@"post_mypost_all"];
    }else if(selectedIndex ==1){
        [MobClick event:@"post_mypost_original"];
    }else if(selectedIndex ==2){
        [MobClick event:@"post_mypost_comment"];
    }else if(selectedIndex == 3){
        [MobClick event:@"post_mypost_collection"];
    }
}

- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView progress:(CGFloat)progress originalIndex:(NSInteger)originalIndex targetIndex:(NSInteger)targetIndex {
    _tableView.scrollEnabled = NO;
    [self.pageTitleView setPageTitleViewWithProgress:progress originalIndex:originalIndex targetIndex:targetIndex];
}

- (void)pageContentCollectionView:(SGPageContentCollectionView *)pageContentCollectionView offsetX:(CGFloat)offsetX {
    _tableView.scrollEnabled = YES;
}

//发帖
- (void)addPost{
    [MobClick event:@"post_mypost_fatie"];
    if ([getUserCenter isLogined]) {
        BTPostComposeViewController *vc = [BTPostComposeViewController new];
        vc.type = WBStatusComposeViewTypeComment;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        @weakify(nav);
        vc.dismiss = ^{
            @strongify(nav);
            [nav dismissViewControllerAnimated:YES completion:NULL];
        };
        [self presentViewController:nav animated:YES completion:NULL];
    }else {
        
        [getUserCenter loginoutPullView];
    }
    
}

@end
