//
//  BTControllerManager.h
//  BT
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UIViewController_key_parameters    "UIViewController.parameters"
#define  UIViewController_block_parameters "UIViewController.blockParameters"
#define  UIView_block_parameters "UIView.blockParameters"
typedef void(^UIViewController_block_returnParameters)(id obj);

@class BTTabBarController;

#define BTCMInstance [BTControllerManager sharedManager]

@interface BTControllerManager : NSObject

@property (nonatomic, strong, readonly) UITabBarController *rootTabBarCtrl;


+ (instancetype)sharedManager;

- (void)setupBtNibObject: (BTTabBarController*)ctrl;

- (UIViewController *)viewControllerForName: (NSString *)name withParams: (NSDictionary *)params;

//不带回传参数
- (void)pushViewControllerWithName: (NSString *)name andParams: (NSDictionary *)params;

// push 带有回传参数
- (void)pushViewControllerWithName: (NSString *)name andParams: (NSDictionary *)params completion:(UIViewController_block_returnParameters)completion;



- (void)pushViewController:(id)ctrl;
//回到上一级
- (void)popViewController:(id)ctrl;
//回到最前面
- (void)popRootViewController:(id)ctrl;

//查找对应实例
- (id)instanceWithControllerName: (NSString *)name;

- (void)presentViewController: (id)ctrl animated:(BOOL)animated;

//跳到指定的类名对应实例
- (void)popViewControllerToControllerName: (NSString *)ctrlName params:(NSDictionary *)params animated: (BOOL)animated;

- (void)presentViewControllerWithName: (NSString *)name andParams: (NSDictionary *)params animated:(BOOL)animated;
- (void)presentViewControllerWithName: (NSString *)name andParams: (NSDictionary *)params animated:(BOOL)animated ompletion:(UIViewController_block_returnParameters)completion;



- (void)presentViewControllerWithName: (NSString *)name andParams: (NSDictionary *)params;

- (void)dismissViewControllerComplete: (void(^)(void))complete;

- (void)dismissViewController;

- (UIViewController*)topViewController;


@end
