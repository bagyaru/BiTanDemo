//
//  BTThreeManager.m
//  BT
//
//  Created by admin on 2018/1/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTThreeManager.h"
#import "HYShareKit.h"
BTThreeManager    *g_HYThreeDealMsg = NULL;
@interface BTThreeManager()<WXApiDelegate>

@end
@implementation BTThreeManager
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_HYThreeDealMsg = [[[self class] alloc] init];
    });
    return g_HYThreeDealMsg;
}
+(void)registerApp:(UIApplication *)application Options:(NSDictionary *)launchOptions//第三方注册
{
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setShouldShowToolbarPlaceholder:NO];
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    //SHareSDK注册
    [HYShareKit registerShareApp];
    //极光推送
    [self initJPush:application Options:launchOptions];
    //友盟统计
    [self initUMAnalyst];
    //iOS10以下点击图标打开app时对推送的处理
    NSDictionary *userInfo = [launchOptions valueForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    if(apsInfo) {
        //there is some pending push notification, so do something
        //in your case, show the desired viewController in this if block
        NSLog(@"iOS10以下点击图标打开app时对推送的处理");
        [self application:application OnDealNotification:userInfo];
    }
    
}


+(void)application:(UIApplication *)application OnDealNotification:(NSDictionary *)userInfo
{
    NSLog(@"%@",userInfo);
    NSString* params = [userInfo objectForKey:@"params"];
    NSLog(@"%@",params);
    if (!params) {
        return;
    }
    NSDictionary *dict = [getUserCenter jsonStringChangeDict:params];
    
    if (ISStringEqualToString(dict[@"code"], @"USER_REMIND")) {//提醒
        
        if (![getUserCenter isLogined]) {
            [AnalysisService alaysisMine_login];
            [getUserCenter loginoutPullView];
            return;
        }
        [AnalysisService alaysisMine_income_card];
        if (![BTCMInstance instanceWithControllerName:@"LncomeStatisticsMain"]) {
            
            [BTCMInstance pushViewControllerWithName:@"LncomeStatisticsMain" andParams:nil];
        }
    }
    if (ISStringEqualToString(dict[@"code"], @"PRICE_WARNING")) {//价格预警
        NSString *busId = dict[@"busId"];
        NSString *title = dict[@"PRICE_WARNING_INFO"];
        NSArray *busIdArr = [busId componentsSeparatedByString:@"|"];
        [getUserCenter creatRemindViewWithString:SAFESTRING(title) dict:@{@"kindCode":busIdArr[0],@"exchangeCode":busIdArr[1],@"exchangeName":busIdArr[2]}];
    }
    
    if (ISStringEqualToString(dict[@"code"], @"INFORMATION_RECOMMEND")) {//新闻 攻略
        
        [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":[dict objectForKey:@"busId"]}];
    }
    /*****************************探报推送**********************************/
    
    if (ISStringEqualToString(dict[@"code"], @"COIN_CIRCLE")) {//探报
        
        [BTCMInstance pushViewControllerWithName:@"wenzhangxiangqing" andParams:@{@"refId":dict[@"busId"],@"bigType":@(6)}];
    }
    
    if (ISStringEqualToString(dict[@"code"], @"ARTICLE_COMMENT")) {//探报的评论
        [self goToUserCenterWithType:1];
    }
    if (ISStringEqualToString(dict[@"code"], @"COIN_CIRCLE_USER_LIKE")) {//探报点赞
        [self goToUserCenterWithType:2];
    }
    if (ISStringEqualToString(dict[@"code"], @"COIN_CIRCLE_AUDIT_PASS")) {//探报发表成功
        [self goToUserCenterWithType:0];
    }
    /*****************************帖子推送**********************************/
    if (ISStringEqualToString(dict[@"code"], @"POST_COMMENT")) {//帖子评论
        
        [self goToUserCenterWithType:1];
    }
    if (ISStringEqualToString(dict[@"code"], @"POST_LIKE")) {//帖子点赞

        [self goToUserCenterWithType:2];
    }
    if (ISStringEqualToString(dict[@"code"], @"MENTION_ME_POST")) {//帖子@我
        
        [self goToUserCenterWithType:3];
    }
    if (ISStringEqualToString(dict[@"code"], @"POST_OFFLINE")) {//帖子下线
        
        [self goToUserCenterWithType:0];
    }
    /*****************************探力奖励推送**********************************/
    
    if (ISStringEqualToString(dict[@"code"], @"POST_TPREWARD")) {//帖子奖励消息

        
        [self goToUserCenterWithType:0];
    }
    if (ISStringEqualToString(dict[@"code"], @"POSTREPORT_TPREWARD")) {//探报奖励消息
        
        [self goToUserCenterWithType:0];
    }
    if (ISStringEqualToString(dict[@"code"], @"FANS")) {//粉丝奖励消息
        
        NSInteger userId = [BTGetUserInfoDefalut sharedManager].userInfo.userId;
        if (![getUserCenter isLogined]) {
            [AnalysisService alaysisMine_login];
            [getUserCenter loginoutPullView];
            return;
        }
        [BTCMInstance pushViewControllerWithName:@"BTFansViewController" andParams:@{@"userName":@"",@"userId":@(userId)}];
    }
    if (ISStringEqualToString(dict[@"code"], @"PLAY_TPREWARD")) {//打赏 跳打赏我的
        
        if (![getUserCenter isLogined]) {
            [AnalysisService alaysisMine_login];
            [getUserCenter loginoutPullView];
            return;
        }
        [BTCMInstance pushViewControllerWithName:@"BTTPRewardVC" andParams:@{@"index":@(1)}];
    }
    /*****************************用户行为推送**********************************/
    if (ISStringEqualToString(dict[@"code"], @"USER_FOLLOW")) {//用户关注
        NSInteger userId = [BTGetUserInfoDefalut sharedManager].userInfo.userId;
        if (![getUserCenter isLogined]) {
            [AnalysisService alaysisMine_login];
            [getUserCenter loginoutPullView];
            return;
        }
        [BTCMInstance pushViewControllerWithName:@"BTFansViewController" andParams:@{@"userName":@"",@"userId":@(userId)}];
    }
    if (ISStringEqualToString(dict[@"code"], @"USER_COMMENT")) {//评论被被回复
        [self goToUserCenterWithType:1];
    }
    if (ISStringEqualToString(dict[@"code"], @"USER_LIKE")) {//评论被点赞
        [self goToUserCenterWithType:2];
    }
    if (ISStringEqualToString(dict[@"code"], @"REPLY_FEEDBACK")) {//意见反馈
        [self goToUserCenterWithType:0];
    }
    if (ISStringEqualToString(dict[@"code"], @"USER_BANNED")) {//禁言
        [self goToUserCenterWithType:0];
    }
    /*****************************系统推送推送**********************************/
    
    if (ISStringEqualToString(dict[@"code"], @"SYSTEM")) {//文章被驳回 文章被下架
        [self goToUserCenterWithType:0];
    }
}
+(void)goToUserCenterWithType:(NSInteger)type {
    
    if (![getUserCenter isLogined]) {
        [AnalysisService alaysisMine_login];
        [getUserCenter loginoutPullView];
        return;
    }
    [AnalysisService alaysisHome_message];
    [BTCMInstance pushViewControllerWithName:@"MessageCenter" andParams:@{@"index":@(type)}];
}
+(void)applicationAlertViewWith:(UIApplication *)application OnDealNotification:(NSDictionary *)userInfo {
    
    NSLog(@"%@",userInfo);
    NSString* params = [userInfo objectForKey:@"params"];
    NSLog(@"%@",params);
    if (!params) {
        return;
    }
     NSDictionary *dict = [getUserCenter jsonStringChangeDict:params];
    if (ISStringEqualToString(dict[@"code"], @"USER_REMIND")) {//提醒
        
        [getUserCenter creatRemindViewWithString:SAFESTRING(userInfo[@"aps"][@"alert"][@"body"])];
    }
    if (ISStringEqualToString(dict[@"code"], @"PRICE_WARNING")) {//价格预警
        NSString *busId = dict[@"busId"];
        NSString *title = dict[@"PRICE_WARNING_INFO"];
        NSArray *busIdArr = [busId componentsSeparatedByString:@"|"];
        [getUserCenter creatRemindViewWithString:SAFESTRING(title) dict:@{@"kindCode":busIdArr[0],@"exchangeCode":busIdArr[1],@"exchangeName":busIdArr[2]}];
    }
    [[BTConfigureService shareInstanceService] checkMessageCenter];//检测未读消息
}
+(BOOL)handleOpenURL:(NSURL *)url//URL 处理
{
    BOOL bReturn = NO;
    if ( [WXApi handleOpenURL:url delegate:g_HYThreeDealMsg] )
    {
        bReturn = YES;
    }
    return bReturn;
}
+(void)initJPush:(UIApplication *)application Options:(NSDictionary *)launchOptions {
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:application.delegate];
    
    [JPUSHService setupWithOption:launchOptions
                           appKey:kJPushAppKey
                          channel:@"App Store"
                 apsForProduction:1//0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。
            advertisingIdentifier:nil];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            
            NSLog(@"registrationID获取成功：%@",registrationID);
            [getUserCenter JPUSHLogin];//绑定别名
            
        }else{
            
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}
+(void)initUMAnalyst {
    UMConfigInstance.appKey = kUMAppKey;
    UMConfigInstance.channelId = @"App Store";
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setEncryptEnabled:YES];
    [MobClick startWithConfigure:UMConfigInstance];
    //TODO: 友盟的集成测试模式，打开时数据不计入正式统计，发布时要关掉
    [MobClick setLogEnabled:YES];
}

@end
