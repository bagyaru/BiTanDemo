//
//  AnalysisService.h
//  BT
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalysisService : NSObject


+ (instancetype)shareInstanceService;

//自选页面
+ (void)alaysisOption_page;

//自选页面登录按钮
+ (void)alaysisOption_login;

//添加自选按钮
+ (void)alaysisOption_add;

//编辑自选按钮
+ (void)alaysisOption_editor;

//自选页面列表点击
+ (void)alaysisOption_page_list;

//市值页面
+ (void)alaysisMarket_page;

//市值页面列表点击
+ (void)alaysisMarket_page_list;

//市值页面按名称排序
+ (void)alaysisMarket_sort_name;

//市值页面按市值排序
+ (void)alaysisMarket_sort_market;

//市值页面按成交量排序
+ (void)alaysisMarket_sort_deal;

//市值页面按最新价排序
+ (void)alaysisMarket_sort_price;

//市值页面按24h涨跌幅排序
+ (void)alaysisMarket_sort_increase;

//交易对页面
+ (void)alaysisTransaction_page;

//交易对页面列表点击
+ (void)alaysisTransaction_page_list;

//交易对页面按名称排序
+ (void)alaysisTransaction_sort_name;

//交易对页面按市值排序
+ (void)alaysisTransaction_sort_market;

//交易对页面按成交量排序
+ (void)alaysisTransaction_sort_deal;

//交易对页面按最新价排序
+ (void)alaysisTransaction_sort_price;

//交易对页面按24h涨跌幅排序
+ (void)alaysisTransaction_sort_increase;

//详情页面
+ (void)alaysisDetail_page;

//详情页面添加自选
+ (void)alaysisDetail_add;

//详情页面分时图按钮点击
+ (void)alaysisDetail_table_time;

//详情页面日线按钮点击
+ (void)alaysisDetail_table_day;

//详情页面周线按钮点击
+ (void)alaysisDetail_table_week;

//详情页面月线按钮点击
+ (void)alaysisDetail_table_month;

//详情页面全屏按钮点击
+ (void)alaysisDetail_table_fullScreen;

//详情页面市场按钮点击
+ (void)alaysisDetail_market;

//详情页面新闻按钮点击
+ (void)alaysisDetail_news;

//详情页面论币按钮点击
+ (void)alaysisDetail_discussion;

//详情页面简介按钮点击
+ (void)alaysisDetail_prospectus;

//详情页面新闻按钮点击
+ (void)alaysisDetail_news_list;

//详情页面论币发布内容按钮点击
+ (void)alaysisDetail_discussion_send;

//行情页面搜索点击
+ (void)alaysisHome_search;

//行情页面消息点击
+ (void)alaysisHome_message;

//行情页面
+ (void)alaysisHome_page;

//资讯页面
+ (void)alaysisNews_page;

//市场页面
+ (void)alaysisExchange_page;

//我的页面
+ (void)alaysisMine_page;

//资讯-快讯页面
+ (void)alaysisNews_newsflash;

//资讯-要闻页面
+ (void)alaysisNews_headlines;

//资讯-攻略页面
+ (void)alaysisNews_tactic;

//快讯列表分享按钮
+ (void)alaysisNews_newsflash_share;

//要闻轮播图点击
+ (void)alaysisNews_headlines_rotation;

//要闻列表点击
+ (void)alaysisNews_headlines_list;

//攻略列表点击
+ (void)alaysisNews_tactic_list;

//市场页面搜索
+ (void)alaysisExchange_search;

//市场列表点击
+ (void)alaysisExchange_list;

//个人中心登录按钮
+ (void)alaysisMine_login;

//点击编辑资料
+ (void)alaysisMine_editor;

//点击我的收藏
+ (void)alaysisMine_collect;

//点击系统设置
+ (void)alaysisMine_set;

//点击邀请好友
+ (void)alaysisMine_invite;

//点击分享后分享成功
+ (void)alaysisMine_invite_01;

//点击意见反馈
+ (void)alaysisMine_advice;

//点击意见反馈后提交成功
+ (void)alaysisMine_advice_01;

//点击关于我们
+ (void)alaysisMine_about;

//首页弹窗去看看按钮点击UV
+ (void)alaysisHome_windows_button_01;

//首页弹窗关闭按钮点击UV
+ (void)alaysisHome_windows_button_00;

//收益统计添加交易按钮点击PV，UV
+ (void)alaysisIncome_add_button;

//收益统计曲线按钮点击PV，UV
+ (void)alaysisIncome_graph_button;

//收益统计添加完成按钮PV，UV
+ (void)alaysisIncome_add_succesd;

//个人中心收益统计卡片点击PV，UV
+ (void)alaysisMine_income_card;

//个人中心收益统计卡片隐藏资产按钮点击PV，UV
+ (void)alaysisMine_income_card_behind;

//发现页面轮播图PV，UV
+ (void)alaysisfind_page_lunbo_01;
//发现页面轮播图PV，UV
+ (void)alaysisfind_page_lunbo_01_index:(NSInteger)index;
//发现中新币上现中的cell点击
+ (void)alaysisfind_page_new_currency_detail;
//新币上线点击PV，UV
+ (void)alaysisfind_page_xinbi;
//货币概念点击PV，UV
+ (void)alaysisfind_page_gainian;
//现货市场点击PV，UV
+ (void)alaysisfind_page_xianhuo;
//期货市场点击PV，UV
+ (void)alaysisfind_page_qihuo;
//首页-涨幅榜列表点击PV，UV
+ (void)alaysisfind_page_zfb;
//首页-跌幅榜列表点击PV，UV
+ (void)alaysisfind_page_dfb;
//首页-成交额榜点击PV，UV
+ (void)alaysishome_amount;
//资讯页面话题点击PV，UV
+ (void)alaysisfind_page_huati_01;
//话题详情分享点击PV，UV
+ (void)alaysisfind_page_huati_01_share;
//我的页面我的探力点击人数PV，UV
+ (void)alaysismine_page_tanli;
//我的探力页面邀请好友点击PV，UV
+ (void)alaysismine_page_tanli_yaoqing;
/****************1.4.0********************/
//我的资产-授权导入PV，UV
+ (void)alaysisMY_Asset_Authorization_import;
//火币-点击授权
+ (void)alaysisClick_Authorization_huobi;
//币安-点击授权
+ (void)alaysisClick_Authorization_bian;
//OKex-点击授权
+ (void)alaysisClick_Authorization_OKex;
//火币-完成授权交易
+ (void)alaysisComplete_the_Authorization_huobi;
//币安-完成授权交易
+ (void)alaysisComplete_the_Authorization_bian;
//OKex-完成授权交易
+ (void)alaysisComplete_the_Authorization_OKex;
/*******************截图分享************************/
//微信分享
+ (void)alaysisWeChat_screenshot_sharing;
//微博分享
+ (void)alaysisWeibo_screenshot_sharing;
//QQ分享
+ (void)alaysisQQ_sharing;
/////////
//详情评论
+ (void)alaysis_detail_comment;
//详情预警
+ (void)alaysis_detail_alert;
//详情自选
+ (void)alaysis_detail_collect;


+ (void)alaysisMoments_screenshot_sharing;
/*******************资讯分享************************/
//微信分享
+ (void)alaysisWeChat_info_sharing;
//微博分享
+ (void)alaysisWeibo_info_sharing;
//QQ分享
+ (void)alaysisMoments_info_sharing;
//我的-加用户群
+ (void)alaysis_usergroup_page;
//资讯-话题列表点击
+ (void)alaysis_news_topic_list;
//资讯-查看话题详情
+ (void)alaysis_news_topic;
//发现-热门币种
+ (void)alaysis_hot_currencies;
@end
