//
//  AppDelegate.h
//  BT
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTUserCenter.h"
#import "BTTabBarController.h"
#import "BTGroupListModel.h"
#import <UserNotifications/UserNotifications.h>
#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define getUserCenter appDelegate.userCenter
#define getMainTabBar appDelegate.mainTabBarViewController
@interface AppDelegate : UIResponder <UIApplicationDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) BTUserCenter *userCenter;
@property (nonatomic, strong) BTTabBarController *mainTabBarViewController;
@property (nonatomic, strong) BTGroupListModel *listModel;
@end

