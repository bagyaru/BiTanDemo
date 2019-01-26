//
//  BTThreeManager.h
//  BT
//
//  Created by admin on 2018/1/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
#import <UserNotifications/UserNotifications.h>
#endif
@interface BTThreeManager : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic,strong)NSString *typeStr;

/**
 *  第三方注册
 *
 *  @param launchOptions launchOptions
 */
+(void)registerApp:(UIApplication *)application Options:(NSDictionary *)launchOptions;//第三方注册
+(BOOL)handleOpenURL:(NSURL *)url;//URL 第三方调用URL处理
+(void)application:(UIApplication *)application OnDealNotification:(NSDictionary *)userInfo;
+(void)applicationAlertViewWith:(UIApplication *)application OnDealNotification:(NSDictionary *)userInfo;
@end
