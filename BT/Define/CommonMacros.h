//
//  CommonMacros.h
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/31.
//  Copyright © 2017年 徐阳. All rights reserved.
//

//全局标记字符串，用于 通知 存储

#ifndef CommonMacros_h
#define CommonMacros_h

#define KDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) lastObject]

#define kUserOptionPath [KDocumentPath stringByAppendingPathComponent:@"userOption.archiver"]

#define kIszh_hans [[APPLanguageService readLanguage] isEqualToString:lang_Language_Zh_Hans]

#define kIsCNY [[APPLanguageService readLegalTendeType] isEqualToString:@"1"]

#define TimerTimeInterval_XianHuoDetail  60.0

#define YI 100000000.0

#define WAN 10000.0


#define ALL_GROUP_ID 10000

#define k_Net_Code @"network"


#define kNotification_Refresh_Group_List @"refresh_group_list"

#define kNotification_ExchangeData_List @"exchangeCoinDataList"

#define NSNotification_SwitchLanguage @"NSNotification_SwitchLanguage"

#define NSNotification_loginSuccess   @"NSNotification_loginSuccess"

#define NSNotification_loginOutSuccess   @"NSNotification_loginOutSuccess"

#define k_Notification_Refresh_Select_Group @"NSNotification_Refresh_Select_Group"
#define k_Notification_Refresh_After_Delete @"NSNotification_Refresh_After_Delete"
#define k_Notification_Change_List_Style @"NSNotification_Change_List_Status"


#define k_Notification_Refresh_Post_List @"NSNotification_Refresh_Post_List"//帖子列表

#define k_Notification_Refresh_Main_Group @"NSNotification_Refresh_Main_Group"

#define NSNotification_RefreshUserBtc @"NSNotification_RefreshUserBtc"

#define NSNotification_needRequest    @"NSNotification_needRequest"
#define NSNotification_future_needRequest    @"NSNotification_future_needRequest"
#define NSNotification_SheQu_needRequest    @"NSNotification_SheQu_needRequest"
#define NSNotification_Refresh_List_Bar @"NSNotification_Refresh_List_Bar"

#define NSNotification_Switch_List_Bar @"NSNotification_Switch_List_Bar"


#define NSNotification_ShowWarningView @"NSNotification_ShowWarningView"

#define NSNotification_noShowWarningView @"NSNotification_noShowWarningView"

#define NSNotification_ShowWarningRotationView @"NSNotification_ShowWarningRotationView"

#define NSNotification_noShowWarningRotationView @"NSNotification_noShowWarningRotationView"

#define NSNotification_chooseJYDSuccess   @"NSNotification_chooseJYDSuccess"

#define NSNotification_addJYTJSuccess   @"NSNotification_addJYTJSuccess"

#define NSNotification_ZanOrReply  @"NSNotification_ZanOrReply"

#define NSNotification_ChooseJYS  @"NSNotification_ChooseJYS"

#define NSNotification_PasteSuccess  @"NSNotification_PasteSuccess"

#define NSNotification_RedRiseGreenFall  @"NSNotification_RedRiseGreenFall"

#define NSNotification_HiddenAssets  @"NSNotification_HiddenAssets"
#define kNotificatin_Refresh_Exchange_Tasks @"k_Notification_Exchange_Tasks"

#define lang_SwitchLanguage @"swithLanguage"

#define lang_Language   @"appLanguage"

#define lang_Language_Zh_Hans  @"zh-Hans"

#define lang_Language_En       @"en"

#define lang_SearchHistory     @"searchHistory"

#define lang_SearchXianhuoHistory @"searchXianhuoHistory"

#define lang_SearchQihuoHistory   @"searchQihuoHistory"

#define lang_SearchSYTJHistory   @"searchSYTJHistory"

#define BTExchangeAuthorized   @"BTExchangeAuthorized"

#define SheQuHistoryRead @"SheQuHistoryRead"//社区已读文章记录

#define BTSplashScreenInfo  @"BTSplashScreenInfo"

#define BTSplashScreenDatatime @"BTSplashScreenDatatime"
//自选
#define lang_UserOption       @"userOption"

#pragma mark - Header
#define ApplicationId @"applicationId"

#define ApplicationIdValue @"2"

#define ApplicationClientType @"applicationClientType"

#define ApplicationClientTypeValue @"2"

#define DeviceUUID @"deviceUUID"

#define GetUUID [[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString] stringByReplacingOccurrencesOfString:@"-" withString:@""]

#define UserFrom @"userFrom"

#define UserFromValue @"APPSTORE"

#define UserFromValueOther @"APPQIYE"

#define AppVersion @"appVersion"

#define BuildVersion @"buildVersion"

#define AppVersionValue [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#define TestOrOneLine @""

#define Token @"token"

#define UserID @"userId"

#define langLanguageType  @"lang"

#define legalTendeType        @"legalTende"

#define promptType @"prompt"//本地储存是否引导过用户

#define NewFeatureTips @"新功能已提示"//本地储存是否新功能提示过

#define IsOrNoEyes @"IsOrNoEyes"//明文或暗文

#define ContentType @"Content-Type"

#define RedRiseGreenFall @"RedRiseGreenFall"   //是否是红涨绿跌

#define RedRiseAlert @"RedRiseAlert"

#define GreenRiseAlert @"GreenRiseAlert"
//判断是否红涨绿跌
#define isRedRise [kUserDefaults boolForKey:RedRiseGreenFall]

#define NightModeOrDayMode @"NightModeOrDayMode"   //是否是夜间模式
//判断是否是夜间模式
#define isNightMode [kUserDefaults boolForKey:NightModeOrDayMode]

//签到时间保存本地
#define qianDaoDay  @"qianDaoDay"

//连续签到提醒
#define continueQianDao @"continueQianDao"


#pragma mark - ——————— 用户相关 ————————
//登录状态改变通知
#define KNotificationLoginStateChange @"loginStateChange"

//自动登录成功
#define KNotificationAutoLoginSuccess @"KNotificationAutoLoginSuccess"

//被踢下线
#define KNotificationOnKick @"KNotificationOnKick"

//用户信息缓存 名称
#define KUserCacheName @"KUserCacheName"

//用户model缓存
#define KUserModelCache @"KUserModelCache"

//收藏状态改变
#define CollectionChange @"CollectionChange"

#pragma mark - ——————— 网络状态相关 ————————

//网络状态变化
#define KNotificationNetWorkStateChange @"KNotificationNetWorkStateChange"

#pragma mark - ——————— 评论相关的用户操作（点赞 回复 删除） ————————
#define KNotificationCommentsOperation @"KNotificationCommentsOperation"
//记录退出时页面名字和参数
#define BTClassName @"BTClassName"
#define BTClassParameters @"BTClassParameters"
#define BTGetMainTabBarSelectedIndex @"GetMainTabBarSelectedIndex"

#pragma mark --统计分析---

//查看每日查看自选列表人数
#define optional_page  @"optional_page"

//查看每日通过自选页面的登录转化率
#define optional_login @"optional_login"

//查看用户添加自选转化率
#define optional_add   @"optional_add"

//查看用户编辑自选数据
#define optional_editor @"optional_editor"

//查看每日查看自选详情人数
#define optional_page_list @"optional_page_list"

//查看每日查看市值列表人数
#define market_page  @"market_page"

//查看每日查看市值详情人数
#define market_page_list @"market_page_list"

//币种查看用户筛选优先级

//名称筛选
#define market_sort_name @"market_sort_name"

//市值筛选
#define market_sort_market @"market_sort_market"

//成交量筛选
#define market_sort_deal @"market_sort_deal"

//最新价筛选
#define market_sort_price @"market_sort_price"

//24h涨跌幅筛选
#define market_sort_increase @"market_sort_increase"

//查看每日查看交易对列表人数
#define transaction_page @"transaction_page"

//查看每日查看交易对详情人数
#define transaction_page_list @"transaction_page_list"

//交易对查看用户筛选优先级

//名称筛选
#define transaction_sort_name @"transaction_sort_name"

//市值筛选
#define transaction_sort_market @"transaction_sort_market"

//成交量筛选
#define transaction_sort_deal @"transaction_sort_deal"

//最新价筛选
#define transaction_sort_price @"transaction_sort_price"

//24h涨跌幅筛选
#define transaction_sort_increase @"transaction_sort_increase"


//查看每天查看详情页面的PV，UV
#define detail_page @"detail_page"

//查看详情页面，添加自选转化率
#define detail_add  @"detail_add"

//详情页面分时按钮点击PV，UV
#define detail_table_time @"detail_table_time"

//详情页面日线按钮点击PV，UV
#define detail_table_day @"detail_table_day"

//详情页面周线按钮点击PV，UV
#define detail_table_week @"detail_table_week"

//详情页面月线按钮点击PV，UV
#define detail_table_month @"detail_table_month"

//详情页面全屏按钮点击PV，UV
#define detail_table_fullscreen @"detail_table_fullscreen"

//详情页面市场按钮点击PV，UV
#define detail_market @"detail_market"

//详情页面新闻按钮点击PV，UV
#define detail_news  @"detail_news"

//详情页面论币按钮点击PV，UV
#define detail_discussion @"detail_discussion"

//详情页面简介按钮点击PV，UV
#define detail_prospectus @"detail_prospectus"

//详情页面新闻列表点击PV，UV
#define detail_news_list @"detail_news_list"

//详情页面论币列表发布内容PV，UV
#define detail_discussion_send @"detail_discussion_send"

//行情页面搜索点击PV，UV
#define home_search @"home_search"

//行情页面消息点击PV，UV
#define home_message @"home_message"

//行情页面用户PV，UV
#define home_page @"home_page"

//资讯页面用户PV，UV（社区主页面）
#define news_page @"news_page"

//市场页面用户（发现）PV，UV
#define exchange_page @"exchange_page"

//我的页面用户PV，UV
#define mine_page @"mine_page"

//资讯-快讯页面PV，UV
#define news_newsflash @"news_newsflash"

//资讯-要闻页面PV，UV
#define news_headlines @"news_headlines"

//资讯-攻略页面PV，UV
#define news_tactic @"news_tactic"

//快讯列表分享按钮点击PV，UV
#define news_newsflash_share @"news_newsflash_share"

//要闻轮播图点击PV，UV
#define news_headlines_rotation @"news_headlines_rotation"

//要闻列表点击PV，UV
#define news_headlines_list @"news_headlines_list"

//攻略列表点击PV，UV
#define news_tactic_list @"news_tactic_list"

//市场页面搜索按钮点击PV，UV
#define exchange_search @"exchange_search"

//市场列表点击PV，UV
#define exchange_list @"exchange_list"

//个人中心登录按钮PV，UV
#define mine_login @"mine_login"

//点击编辑资料PV，UV
#define mine_editor @"mine_editor"

//点击我的收藏PV，UV
#define mine_collect @"mine_collect"

//点击系统设置PV，UV
#define mine_set @"mine_set"

//点击邀请好友PV，UV
#define mine_invite @"mine_invite"

//点击分享后分享成功PV，UV
#define mine_invite_01 @"mine_invite_01"

//点击意见反馈PV，UV
#define mine_advice @"mine_advice"

//点击意见反馈后提交成功PV，UV
#define mine_advice_01 @"mine_advice_01"

//点击关于我们PV，UV
#define mine_about   @"mine_about"

/************收益统计打点*************/
//首页弹窗去看看按钮点击UV
#define home_windows_button_01 @"home_windows_button_01"

//首页弹窗关闭按钮点击UV
#define home_windows_button_00 @"home_windows_button_00"

//收益统计添加交易按钮点击PV，UV
#define income_add_button @"income_add_button"

//收益统计曲线按钮点击PV，UV
#define income_graph_button @"income_graph_button"

//收益统计添加完成按钮PV，UV
#define income_add_succesd @"income_add_succesd"

//个人中心收益统计卡片点击PV，UV
#define mine_income_card @"mine_income_card"

//个人中心收益统计卡片隐藏资产按钮点击PV，UV
#define mine_income_card_behind @"mine_income_card_behind"

/************1.2.0统计打点*************/
//发现页面轮播图PV，UV
#define find_page_lunbo_01 @"find_page_lunbo_01"

//发现界面新币上现cell店家PV，UV
#define find_page_new_currency_detail @"find_page_new_currency_detail"

//新币上线点击PV，UV
#define find_page_xinbi   @"find_page_xinbi"

//货币概念点击PV，UV
#define find_page_gainian @"find_page_gainian"

//现货市场点击PV，UV
#define find_page_xianhuo @"find_page_xianhuo"

//期货市场点击PV，UV
#define find_page_qihuo @"find_page_qihuo"

//首页-涨幅榜点击PV，UV
#define find_page_zfb @"home_zfb"

//首页-跌幅榜点击PV，UV
#define find_page_dfb @"home_dfb"

//首页-成交额榜点击PV，UV
#define home_amount @"home_amount"

//资讯页面话题点击PV，UV
#define find_page_huati_01 @"find_page_huati_01"

//话题详情分享点击PV，UV
#define find_page_huati_01_share @"find_page_huati_01_share"

//我的页面我的探力点击人数PV，UV
#define mine_page_tanli @"mine_page_tanli"

//我的探力页面邀请好友点击PV，UV
#define mine_page_tanli_yaoqing @"mine_page_tanli_yaoqing"

//我的资产-授权导入
#define MY_Asset_Authorization_import @"MY_Asset_Authorization_import"

//火币-点击授权
#define Click_Authorization_huobi @"Click_Authorization_huobi"

//币安-点击授权
#define Click_Authorization_bian @"Click_Authorization_bian"

//OKex-点击授权
#define Click_Authorization_OKex @"Click_Authorization_OKex"

//火币-完成授权交易
#define Complete_the_Authorization_huobi @"Complete_the_Authorization_huobi"

//币安-完成授权交易
#define Complete_the_Authorization_bian @"Complete_the_Authorization_bian"

//OKex-完成授权交易
#define Complete_the_Authorization_OKex @"Complete_the_Authorization_OKex"
/*******************截图分享************************/
//微信分享
#define WeChat_screenshot_sharing @"WeChat_screenshot_sharing"

//微博分享
#define Weibo_screenshot_sharing @"Weibo_screenshot_sharing"

//朋友圈分享
#define Moments_screenshot_sharing @"Moments_screenshot_sharing"
/*******************资讯分享************************/
//微信分享
#define WeChat_info_sharing @"WeChat_info_sharing"

//微博分享
#define Weibo_info_sharing @"Weibo_info_sharing"

//朋友圈分享
#define Moments_info_sharing @"Moments_info_sharing"
#endif /* CommonMacros_h */
