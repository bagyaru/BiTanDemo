//
//  AppDelegate.m
//  BT
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AppDelegate.h"
#import "BTTabBarController.h"
#import "Preference.h"
#import "BTConfigureService.h"
#import "BTLanguageTrasnferService.h"
#import "BTConfig.h"
#import "BTSearchService.h"
#import "LaunchIntroductionView.h"
#import <ShareSDK/ShareSDK.h>

//交易所
#import "BTExchangeManager.h"
#import "BTExchangeModel.h"
#import "PCNetworkClient+Account.h"
#import "SYYHuobiNetHandler.h"
#import "OKexRequestApi.h"

#import "BTUserExchangeAccountApi.h"
#import "BTMyCoinRewardRequest.h"
#import "BTExchangeTanliReq.h"

#import "BTViewControllerSetting.h"

@interface AppDelegate ()<JPUSHRegisterDelegate>

@property (nonatomic, strong)NSTimer *timer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
  
    
    [self initApplication];
    
    //所有第三方注册管理类
    [BTThreeManager sharedInstance];
    [BTThreeManager registerApp:application Options:launchOptions];
    self.mainTabBarViewController = [[BTTabBarController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.mainTabBarViewController;
    [self.window makeKeyAndVisible];
    
    NSString *exchangeCode = [AppHelper getExchangeCode];
    if(SAFESTRING(exchangeCode).length==0){
        [AppHelper saveExchangeName:SAFESTRING([APPLanguageService sjhSearchContentWith:@"quanwang"])];
        [AppHelper saveExchangeCode:k_Net_Code];
    }
    
    //引导页（带按钮的
    [LaunchIntroductionView sharedWithImages:ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans)?@[@"1",@"2",@"3"]:@[@"1_EN",@"2_EN",@"3_EN"] buttonImage:ISStringEqualToString([APPLanguageService readLanguage], lang_Language_Zh_Hans) ? @"ic_lijikaishi" : @"ic_lijikaishi_EN" buttonFrame:CGRectMake(0, ScreenHeight - 110, ScreenWidth, 38)];
    return YES;
}

- (void)initApplication{
    self.userCenter = [[BTUserCenter alloc] init];
    [[BTConfigureService shareInstanceService] checkServerSite];//配置服务器地址
    YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
    config.baseUrl = [BTConfig sharedInstance].domain;
    config.cdnUrl = [BTConfig sharedInstance].h5domain;
    config.debugLogEnabled = YES;
    [APPLanguageService switchOfTestLanguage:NO];//是否打开测试语言环境开关
    [APPLanguageService checkLanguage];//配置语言
    [[BTConfigureService shareInstanceService] checkTimerInterVal];
    [[BTConfigureService shareInstanceService] getGlobal_HTML_configuration];
    [[BTConfigureService shareInstanceService] saveHotSearchData];
    [getUserCenter loadVesionCheck];//版本检测
    [[BTConfigureService shareInstanceService] checkMessageCenter];//检测未读消息
    [[BTSearchService sharedService] checkIfNeedUpdateStocks];
    if ([[Preference sharedInstance] readIsAppFirstInstalled]) {
        [[Preference sharedInstance] initDefaultPreference];
        // 初次安装，做一些必要的初始化
    }
    
    [AppHelper requestCurrency];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTimerTasks) name:kNotificatin_Refresh_Exchange_Tasks object:nil];
    
    appDelegate.listModel = [[BTGroupListModel alloc] init];
    appDelegate.listModel.groupName = [APPLanguageService sjhSearchContentWith:@"quanbu"];
    appDelegate.listModel.userGroupId = ALL_GROUP_ID;
    
}

- (void)authrozeExchangeTanLi{
    if (getUserCenter.userInfo.token.length == 0) {
        return;
    }
    NSArray *tasks = [[BTSearchService sharedService] readExchangeAuthorizedWithUserId:SAFESTRING(@(getUserCenter.userInfo.userId))];
    if(tasks.count == 0){
        return;
    }
    
    NSDate *agoDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"nowDate"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [NSDate date];
    NSString *ageDateString = [dateFormatter stringFromDate:agoDate];
    NSString *nowDateString = [dateFormatter stringFromDate:now];
    
    if([ageDateString isEqualToString:nowDateString]){//相同则不加探力
        
    }else{

        BTExchangeTanliReq *api = [[BTExchangeTanliReq alloc] initWithUserId:getUserCenter.userInfo.userId exchangeNum:tasks.count];
        [api requestWithCompletionBlockWithSuccess:^(__kindof BTBaseRequest *request) {
            NSDate *nowDate = [NSDate date];
            NSUserDefaults *dataUser = [NSUserDefaults standardUserDefaults];
            [dataUser setObject:nowDate forKey:@"nowDate"];
        } failure:^(__kindof BTBaseRequest *request) {
            NSLog(@"失败");
        }];
        
    }
}

- (void)refreshTimerTasks{
//    [self startTimer];
}

- (void)stopTimer{
//    [_timer invalidate];
//    _timer = nil;
}

- (void)startTimer{
    if (getUserCenter.userInfo.token.length > 0) {
        if(!_timer){
            _timer = [NSTimer timerWithTimeInterval:600 target:self selector:@selector(refreshTasks) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
            [_timer fire];
        }
    }
}

//开始交易所定时任务
- (void)refreshTasks{
    NSArray *tasks = [[BTSearchService sharedService] readExchangeAuthorizedWithUserId:SAFESTRING(@(getUserCenter.userInfo.userId))];
    if(tasks.count == 0){
        [self stopTimer];
        return;
    }
    [AppHelper startRefreshTasks];
}


-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    return [BTThreeManager handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [BTThreeManager handleOpenURL:url];
    
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    return [BTThreeManager handleOpenURL:url];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    
    [JPUSHService registerDeviceToken:deviceToken];
    
}

//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [JPUSHService handleRemoteNotification:userInfo];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    if(application.applicationState == UIApplicationStateInactive) {
        //app被关闭或处于后台时用户点击了通知
        NSLog(@"app被关闭或处于后台时用户点击了通知");
        //[THFThreeManager application:application OnDealNotification:userInfo];
    } else if (application.applicationState == UIApplicationStateBackground) {
        //app在后台时收到了通知
        NSLog(@"app在后台时收到了通知");
        //[THFThreeManager application:application OnDealNotification:userInfo];
    } else {
        //app位于前台
        NSLog(@"app位于前台");
        //[THFThreeManager application:application OnDealNotification:userInfo];
    }
}

#pragma mark- JPUSHRegisterDelegate

// iOS10新增：处理前台收到通知的代理方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //应用处于前台时的远程推送接受
            [JPUSHService handleRemoteNotification:userInfo];
            [BTThreeManager applicationAlertViewWith:[UIApplication sharedApplication] OnDealNotification:userInfo];
        } else {
            //应用处于前台时的本地推送接受
        }
    } else {
        // Fallback on earlier versions
    }
    if (@available(iOS 10.0, *)) {
        completionHandler(UNNotificationPresentationOptionAlert);
    } else {
        
        // Fallback on earlier versions
    } // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS10新增：处理后台点击通知的代理方法
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            //应用处于后台时的远程推送接受
            [JPUSHService handleRemoteNotification:userInfo];
            if([UIApplication sharedApplication].applicationState == UIApplicationStateInactive) {
                //app被关闭或处于后台时用户点击了通知
                NSLog(@"app被关闭或处于后台时用户点击了通知");
                [BTThreeManager application:[UIApplication sharedApplication] OnDealNotification:userInfo];
            } else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
                //app在后台时收到了通知
                NSLog(@"app在后台时收到了通知");
                [BTThreeManager application:[UIApplication sharedApplication] OnDealNotification:userInfo];
            } else {
                //app位于前台
                NSLog(@"app位于前台");
                
            }
            
        } else {
            //应用处于后台时的本地推送接受
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [JPUSHService setBadge:0];//重置JPush服务器上面的badge值。如果下次服务端推送badge传"+1",则会在你当时JPush服务器上该设备的badge值的基础上＋1；
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];//apple自己的接口，变更应用本地（icon）的badge值；
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 实现如下代码，才能使程序处于后台时被杀死，调用applicationWillTerminate:方法
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(){}];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //[self authrozeExchangeTanLi];
    [[BTConfigureService shareInstanceService] checkMessageCenter];//检测未读消息
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"程序被杀死，applicationWillTerminate %ld",getMainTabBar.selectedIndex);
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
