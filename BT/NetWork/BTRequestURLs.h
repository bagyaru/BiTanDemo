//
//  BTRequestURLs.h
//  BT
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

//登录
#define LoginUrl @"oauth/oauth-rest/login-no-password"
//获取验证码
#define GetYZM @"oauth/oauth-rest/send-captcha"
//登出
#define LoginOutUrl @"oauth/oauth-rest/logout"
//忘记密码
#define FORGOT_PASSWPRD_URL @"oauth/oauth-rest/forgot-password"



//获取个人资料
#define UserInfoUrl @"oauth/oauth-rest/user-center-info"
//修改个人资料
#define changeNikeNameUrl @"oauth/oauth-rest/upload-user-extend-info"
//头像上传七牛生成URL
#define changePhotoUrl @"system/file-upload/upload-pic"
//头像上传服务器
#define updatePhotoToServiceUrl @"oauth/oauth-rest/avatar-upload"
//意见反馈
#define FeedBackUrl @"oauth/oauth-rest/feedback"

//////////////探力
//我的探力
#define MyCoinUrl @"oauth/oauth-rest/my-coin"
//探力记录详情
#define MyCoinDetailUrl @"oauth/oauth-rest/coin-detail"
//邀请好友
#define MyInviteFriendUrl @"oauth/oauth-rest/inviteCode"
//活动细则
#define myInviteRulesUrl @"rules"
#define myInviteRuleDesc @"rule.html"

//秘籍
#define myCoinSecretUrl  @"cheats"
//奖励
#define myCoinRewardUrl @"oauth/oauth-rest/coin-reward"



//资讯导航下的接口 类型2要闻3攻略
#define InformationModuleUrl @"knowledge/info/search"
//获取社区分类
#define SheQuHeadListUrl @"knowledge/info/listTypes"
//快讯
#define FlashNewsUrl @"knowledge/info/flashNews"
//要闻banner
#define NewBannersUrl @"knowledge/info/listBanners"
//要闻 攻略详情
#define NewInfoDetail @"knowledge/info/detail"
//要闻 攻略收藏
#define InfomationCollectionUrl @"oauth/oauth-rest/favors"
//要闻 攻略评论列表(话题最新评论)
#define InfomationCommentListUrl @"oauth/oauth-rest/comment-list"
//要闻 攻略 评论 帖子
#define CommentInfomationUrl @"oauth/oauth-rest/comment"
//获取热门评论
#define HotCommentListUrl @"oauth/oauth-rest/list-hot-comment"
//被点赞的评论列表
#define LikedListUrl @"oauth/oauth-rest/listLikedComments"
//被回复的评论列表
#define RepliedListUrl @"oauth/oauth-rest/listRepliedComments"
//评论详情
#define GetCommentDetailUrl @"oauth/oauth-rest/getCommentDetail"
//删除自己的评论/回复
#define DeleteMyCommentUrl @"oauth/oauth-rest/deleteMyComment"
//删除自己的评论/回复
#define CommentJumpDetailUrl @"oauth/oauth-rest/commentJumpDetail"
//币圈-记录用户操作的数据
#define RecordArticleInfoUrl @"article/article-rest/record-article-info"

//现货列表
#define XianHuoListUrl @"market/market-rest/select-exchangeAllByPage"
//现货所有数据
#define XianHuoAllUrl @"market/market-rest/select-exchangeAll"
//现货详情
#define XianHuoDetailUrl @"market/market-rest/select-exchangeList"
//现货-行情
#define XianHuoDetailHangQingUrl @"market/market-rest/exchange-market-info"
//现货-行情 实时刷新 可见部分
#define XianHuoDetailHangQingChangeUrl @"market/market-rest/exchange-realtime-one-point"
//现货-查询所有交易所信息（搜索用）
#define XianHuoSeachAllUrl @"market/market-rest/select-exchangeAll"


//期货列表
#define QiHuoListUrl @"market/market-rest/select-futures-info-front"
//期货详情
#define QiHuoDetailUrl @"market/market-rest/get-futures-info-front"
//期货-查询所有期货信息（搜索用）
#define QiHuoSeachAllUrl @"market/market-rest/select-all-futures-info-front"

//我的收藏
#define MyCollectionlistUrl @"knowledge/info/listFavors"
//消息中心
#define MessagecenterListUrl @"message/message-center/listMessages"
//统计未读消息数
#define CheckMessageUnreadUrl @"message/message-center/countUnreadByType"
//一键已读通知消息
#define ReadAllMessageUrl @"message/message-center/readAll"
//一键已读评论
#define ReadAllReplayUrl @"message/message-center/readAllComment"
//一键已读点赞
#define ReadAllLikedUrl @"message/message-center/readAllLike"
//一键已读全部消息
#define NewReadAllMessageUrl @"message/message-center/readAllMessage"
//单条消息读取
#define ReadSingleMessageUrl @"message/message-center/readSingleMessage"
//@我的消息列表
#define MentionMeListUrl @"message/message-center/mentionMeList"


//版本检测
#define VersionReleaseUrl @"system/release/getLatest"
//h5协议
#define XieYi_H5 @"agreement"
//关于我们
#define AboutUs_H5 @"about"
//邀请好友
#define Yaoqinghaoyou_H5 @"down"
//错误日志上报
#define SavaErrorLogUrl @"log/log-rest/saveErrorLog"
//币探小助手
#define BTXZS_H5 @"addWechat"
//加用户群
#define ADD_GROUP_URL @"addWechat"

#define Verify_URL @"Authentication.html"

//资讯分享
#define InfoDetail_H5 @""
//话题分享
#define TOPICURL_H5 @"conversation"
//帖子分享
#define POSTSHARE_H5 @"postShare.html"

//导航栏币种
#define CURRENCY_LIST_URL @"market/market-rest/select-currency-show"

// 搜索币种列表
#define QUERYBTCKIST_URL  @"market/market-rest/query-currency-relation-list"//

#define QUERYBTCKISTNEW_URL  @"market/market-rest/query-currency-relation-list-new"//

//市值list
#define MARKET_URL @"market/market-rest/market-info-list-v2"


//实时刷新 可见部分的数据
#define MARKEY_REALTIME_URL @"market/market-rest/realtime-one-point-v2"

//添加自选
#define ADDUSERBTC_URL @"market/market-rest/add-user-currency"//

//删除自选
#define DELETEUSERBTC_URL @"market/market-rest/delete-user-currency"//

//自选排序
#define SORTUSERBTC_URL   @"market/market-rest/sort-user-currency"//

//查询自选
#define QUERYUSERBTC_URL @"market/market-rest/query-user-currency-list"//

//新闻
#define NEWS_URL          @"knowledge/info/search"

//论币列表
#define DISCUSSCURRENCY_URL @"oauth/oauth-rest/comment-list"

// 提交评论
#define SUBMITCOMMENT_URL   @"oauth/oauth-rest/comment"

//点赞
#define LIKE_URL            @"oauth/oauth-rest/like"

//行情详情市场 从市值过来
#define QUTOESDETAILMARKET_URL @"market/market-rest/currency-exchange-info"

//行情详情市场 从交易对过来
#define QUTOEXDETAILMARKETCURRENCY_URL @"market/market-rest/trand-pair-exchange-info"

//简介
#define INTRODUCE_URL  @"market/market-rest/select-currencyList"

//分时图
#define FENSHI_URL     @"market/market-rest/realtime-line"

#define KLINE_URL      @"market/market-rest/kline"

//获取轮询间隔
#define TIMER_URL      @"market/market-rest/poll-interval"

//用户账户首页
#define USER_ACCOUNT @"market/market-rest/user-account-v2"

//添加交易（记账）
#define ADD_BOOKKEEPING @"market/market-rest/add-bookkeeping"

//添加交易（编辑）
#define UPDATE_BOOKKEEPING @"market/market-rest/update-bookkeeping"

//获取用户历史钱包地址
#define USER_WALLET_HISTORY @"market/market-rest/user-wallet-history"


#define  USER_EXCHANGE_ACCOUNT @"market/market-rest/user-exchange-account"

//收益币种详情
#define PROFIT_LOSS_DETAIL @"market/market-rest/currency-detail-v2"

//用户收益曲线
#define PTOFIT_LOSS_CURVE  @"market/market-rest/user-earning-line"

// 获取用户提醒列表
#define USER_REMINE_LIST @"market/market-rest/user-remind-list"

#define USER_REMIND_SHUT @"market/market-rest/save-user-remind"
#define DELETE_RECORF_URL @"market/market-rest/del-bookkeeping"

//实时搜索
#define REAL_TIME_SEACH @"market/market-rest/search-coin"
//币种-实时搜索
#define BZ_SEACH @"market/market-rest/currency-search"
//热门搜索
#define HOT_SEARCH @"market/market-rest/hot-search"

//探力签到
#define TP_SIGN  @"oauth/oauth-rest/sign"

//获得当前的探力数额
#define TP_GETTP @"oauth/oauth-rest/my-coin"

//判断是否签到
#define TP_IsSignIn @"oauth/oauth-rest/is-sign"

//探力签到详情
#define TP_SignInDetail @"oauth/oauth-rest/sign-detail"

//探力任务
#define TP_TARGET @"oauth/oauth-rest/task-list"

//探力历史获得的探力
#define TP_HISTORYGETTP @"oauth/oauth-rest/coin-detail"

//探力周期奖励列表
#define TP_SIGNREWARD @"oauth/oauth-rest/signReward"

//app获取闪屏信息
#define SPLASH_SHOW @"system/splash/splash-show"
//验证闪屏版本
#define VALIDATE_SPLASHVERSION @"system/splash/validate-splash-version"
//闪屏增加pv,uv
#define SPLASH_ADD_PVUV @"system/splash/manage/add-pvuv"


//首页 涨幅分布信息
#define HOME_ZFFB @"market/market-rest/rise-distribution"
//首页 币探指数列表
#define HOME_BTZS @"market/market-rest/bitane-index-list"
//首页 指数详情头部数据
#define HOME_HEADDATA @"market/market-rest/bitane-realtime-one-point"
//首页 热搜
#define HOME_HOTSEARCH @"market/market-rest/new-hot-currency-list"

/*
 discovery
 */
#define CONCEPT_INFO_DETAIL      @"market/market-rest/concept-info"
#define CONCEPT_MAIN_PAGE        @"market/market-rest/concept-main-page"
#define CONCEPT_UPDOWN_LIST      @"market/market-rest/rise-list"
#define CONCEPT_NEW_CURRENCY     @"market/market-rest/new-currency-list"
#define DISCOVERSY_BANNER_URL    @"system/banner/search"
//热门币种列表
#define DISCOVERSY_HOTCURRENCY_LIST @"market/market-rest/hot-currency-list"

/*
 贴子相关
 */
//我的帖子列表（全部、原创)
#define Posts_List_Url @"knowledge/posts/list"
//我的帖子头部信息
#define Posts_List_Head_Url @"knowledge/posts/myPostHead"
//贴子详情
#define Posts_List_Detail_Url @"knowledge/posts/detail"
//贴子详情
#define Posts_List_Delet_Url @"knowledge/posts/deleteMyPost"
//我的帖子列表（全部 原创）
#define Posts_MyPosts_List_Url @"knowledge/posts/myPostList"
//我的帖子 评论列表
#define Posts_MyPosts_Comments_List_Url @"oauth/oauth-rest/myCommentList"
//关注用户
#define Posts_FocusUser_Url @"oauth/oauth-rest/follow"

//社区-关注列表
#define SheQu_FocusList_Url @"knowledge/info/followedArticleList"
//探力打赏
#define Exceotional_TP_Url @"oauth/oauth-rest/article-TP-reward"


//获取分享域名
#define Share_Domain_Url @"system/param/share-domain"

#define ContactUs_Url @"system/param/contactUs"

@interface BTRequestURLs : NSObject

@end
