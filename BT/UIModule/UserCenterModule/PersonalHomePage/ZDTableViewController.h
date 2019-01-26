//
//  ZDTableViewController.h
//  ZDPerson
//
//  Created by zdd. on 2017/8/26.
//  Copyright © 2017年 zdd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
@protocol ZDTableViewDelegate <NSObject>

- (void)tableViewDidScroll:(UIScrollView *)scrollView;

@end

@interface ZDTableViewController : UITableViewController

@property (nonatomic,weak)id <ZDTableViewDelegate>  scrollViewDelegate;
//@property (nonatomic, strong)UITableView *tableView;
- (void)setContentOffset:(CGFloat)Offset withTag:(NSInteger)tag;


@end
