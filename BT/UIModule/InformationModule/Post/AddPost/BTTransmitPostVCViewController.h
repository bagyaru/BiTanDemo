//
//  BTTransmitPostVCViewController.h
//  BT
//
//  Created by apple on 2018/9/11.
//  Copyright © 2018年 apple. All rights reserved.
//

//转发帖子
#import "RootViewController.h"
#import "BTPostMainListModel.h"
@interface BTTransmitPostVCViewController : RootViewController

@property (nonatomic, strong) BTPostMainListModel *listModel;

@property (nonatomic, copy) void (^dismiss)(void);

@end
