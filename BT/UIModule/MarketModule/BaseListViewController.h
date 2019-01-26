//
//  BaseListViewController.h
//  BT
//
//  Created by apple on 2017/8/14.
//  Copyright © 2017年 mc. All rights reserved.
//

//列表 基类
#import "RootViewController.h"

@interface BaseListViewController : RootViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *mTableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

- (void)createOtherViews;
- (void)loadData;

- (NSString*)nibNameOfCell;
- (NSString*)cellIdentifier;
- (UITableViewStyle)tableViewStyle;


@end
