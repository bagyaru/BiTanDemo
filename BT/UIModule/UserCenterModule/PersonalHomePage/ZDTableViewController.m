//
//  ZDTableViewController.m
//  ZDPerson
//
//  Created by zdd. on 2017/8/26.
//  Copyright © 2017年 zdd. All rights reserved.
//

#import "ZDTableViewController.h"

#define IS_SafeAreaHeight (iPhoneX ? 34.0f : 0.0f)
#define IS_StatusBarHeight (iPhoneX ? 44.0f : 20.0f)
#define IS_NavigationBarHeight (iPhoneX ? 88.0f : 64.0f)

static CGFloat const HEADERVIEW_HEIGHT  =  370; //头部的高度
static CGFloat const HEADERVIEW_MENU_HEIGHT = 44;//头部菜单的高度

@interface ZDTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@end

@implementation ZDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    //每一个tableView头部初始化一个占位view
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HEADERVIEW_HEIGHT)];
//    [self.view addSubview:self.tableView];
//    self.tableView.delegate = self;
//    self.tableView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
        //self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)setContentOffset:(CGFloat)Offset withTag:(NSInteger)tag{
    if (tag != self.tableView.tag) {
        if (Offset > HEADERVIEW_HEIGHT - IS_NavigationBarHeight - HEADERVIEW_MENU_HEIGHT) {
            [self.tableView setContentOffset:CGPointMake(0, HEADERVIEW_HEIGHT - IS_NavigationBarHeight - HEADERVIEW_MENU_HEIGHT) animated:NO];
        }else{
            if (Offset <= 0) {
                [self.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
            }else{
                [self.tableView setContentOffset:CGPointMake(0, Offset) animated:NO];
            }
         
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if([self.scrollViewDelegate respondsToSelector:@selector(tableViewDidScroll:)]){
        [self.scrollViewDelegate tableViewDidScroll:scrollView];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableVifrvew numberOfRowsInSection:(NSInteger)section{
    return 0;
}


@end
