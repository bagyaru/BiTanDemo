//
//  AnalysisService.m
//  BT
//
//  Created by apple on 2018/3/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AnalysisService.h"

@implementation AnalysisService


+ (instancetype)shareInstanceService{
    static AnalysisService *service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[AnalysisService alloc] init];
    });
    return service;
}

+ (void)alaysisOption_page{
    [MobClick event:optional_page];
}

+ (void)alaysisOption_login{
    [MobClick event:optional_login];
}

+ (void)alaysisOption_add{
    [MobClick event:optional_add];
}

+ (void)alaysisOption_editor{
    [MobClick event:optional_editor];
}

+ (void)alaysisOption_page_list{
    [MobClick event:optional_page_list];
}

+ (void)alaysisMarket_page{
    [MobClick event:market_page];
}

+ (void)alaysisMarket_page_list{
    [MobClick event:market_page_list];
}

+ (void)alaysisMarket_sort_name{
    [MobClick event:market_sort_name];
}

+ (void)alaysisMarket_sort_market{
    [MobClick event:market_sort_market];
}

+ (void)alaysisMarket_sort_deal{
    [MobClick event:market_sort_deal];
}

+ (void)alaysisMarket_sort_price{
    [MobClick event:market_sort_price];
}

+ (void)alaysisMarket_sort_increase{
    [MobClick event:market_sort_increase];
}

+ (void)alaysisTransaction_page{
    [MobClick event:transaction_page];
}

+ (void)alaysisTransaction_page_list{
    [MobClick event:transaction_page_list];
}

+ (void)alaysisTransaction_sort_name{
    [MobClick event:transaction_sort_name];
}

+ (void)alaysisTransaction_sort_market{
    [MobClick event:transaction_sort_market];
}

+ (void)alaysisTransaction_sort_deal{
    [MobClick event:transaction_sort_deal];
}

+ (void)alaysisTransaction_sort_price{
    [MobClick event:transaction_sort_price];
}

+ (void)alaysisTransaction_sort_increase{
    [MobClick event:transaction_sort_increase];
}

+ (void)alaysisDetail_page{
    [MobClick event:detail_page];
}

+ (void)alaysisDetail_add{
    [MobClick event:detail_add];
}

+ (void)alaysisDetail_table_time{
    [MobClick event:detail_table_time];
}

+ (void)alaysisDetail_table_day{
    [MobClick event:detail_table_day];
}

+ (void)alaysisDetail_table_week{
    [MobClick event:detail_table_week];
}

+ (void)alaysisDetail_table_month{
    [MobClick event:detail_table_month];
}

+ (void)alaysisDetail_table_fullScreen{
    [MobClick event:detail_table_fullscreen];
}

+ (void)alaysisDetail_market{
    [MobClick event:detail_market];
}

+ (void)alaysisDetail_news{
    [MobClick event:detail_news];
}

+ (void)alaysisDetail_discussion{
    [MobClick event:detail_discussion];
}


+ (void)alaysisDetail_prospectus{
    [MobClick event:detail_prospectus];
}

+ (void)alaysisDetail_news_list{
    [MobClick event:detail_news_list];
}

+ (void)alaysisDetail_discussion_send{
    [MobClick event:detail_discussion_send];
}

+ (void)alaysisHome_search{
    [MobClick event:home_search];
}

+ (void)alaysisHome_message{
    [MobClick event:home_message];
}

+ (void)alaysisHome_page{
    [MobClick event:home_page];
}

+ (void)alaysisNews_page{
    [MobClick event:news_page];
}

+ (void)alaysisExchange_page{
    [MobClick event:exchange_page];
}

+ (void)alaysisMine_page{
    [MobClick event:mine_page];
}

+ (void)alaysisNews_newsflash{
    [MobClick event:news_newsflash];
}

+ (void)alaysisNews_headlines{
    [MobClick event:news_headlines];
}

+ (void)alaysisNews_tactic{
    [MobClick event:news_tactic];
}

+ (void)alaysisNews_newsflash_share{
    [MobClick event:news_newsflash_share];
}

+ (void)alaysisNews_headlines_rotation{
    [MobClick event:news_headlines_rotation];
}

+ (void)alaysisNews_headlines_list{
    [MobClick event:news_headlines_list];
}

+ (void)alaysisNews_tactic_list{
    [MobClick event:news_tactic_list];
}

+ (void)alaysisExchange_search{
    [MobClick event:exchange_search];
}

+ (void)alaysisExchange_list{
    [MobClick event:exchange_list];
}

+ (void)alaysisMine_login{
    [MobClick event:mine_login];
}

+ (void)alaysisMine_editor{
    [MobClick event:mine_editor];
}

+ (void)alaysisMine_collect{
    [MobClick event:mine_collect];
}

+ (void)alaysisMine_set{
    [MobClick event:mine_set];
}

+ (void)alaysisMine_invite{
    [MobClick event:mine_invite];
}

+ (void)alaysisMine_invite_01{
    [MobClick event:mine_invite_01];
}

+ (void)alaysisMine_advice{
    [MobClick event:mine_advice];
}

+ (void)alaysisMine_advice_01{
    [MobClick event:mine_advice_01];
}

+ (void)alaysisMine_about{
    [MobClick event:mine_about];
}

+ (void)alaysisHome_windows_button_01 {
    
    [MobClick event:home_windows_button_01];
}

+ (void)alaysisHome_windows_button_00 {
    
    [MobClick event:home_windows_button_00];
}

+ (void)alaysisIncome_add_button {
    
    [MobClick event:income_add_button];
}

+ (void)alaysisIncome_graph_button {
    
    [MobClick event:income_graph_button];
}

+ (void)alaysisIncome_add_succesd {
    
    [MobClick event:income_add_succesd];
}

+ (void)alaysisMine_income_card {
    
    [MobClick event:mine_income_card];
}

+ (void)alaysisMine_income_card_behind {
    
    [MobClick event:mine_income_card_behind];
}

+ (void)alaysisfind_page_lunbo_01 {
    
    [MobClick event:find_page_lunbo_01];
}

+ (void)alaysisfind_page_lunbo_01_index:(NSInteger)index{
    [MobClick event:[NSString stringWithFormat:@"%@_%ld",find_page_lunbo_01,index]];
}

+ (void)alaysisfind_page_new_currency_detail {
    
    [MobClick event:find_page_new_currency_detail];
}



+ (void)alaysisfind_page_xinbi{
    
    [MobClick event:find_page_xinbi];
}
+ (void)alaysisfind_page_gainian {
    
    [MobClick event:find_page_gainian];
}
+ (void)alaysisfind_page_xianhuo {
    
    [MobClick event:find_page_xianhuo];
}
+ (void)alaysisfind_page_qihuo {
    
    [MobClick event:find_page_qihuo];
}
+ (void)alaysisfind_page_zfb {
    
    [MobClick event:find_page_zfb];
}
+ (void)alaysisfind_page_dfb {
    
    [MobClick event:find_page_dfb];
}
+ (void)alaysishome_amount {
    
    [MobClick event:home_amount];
}
+ (void)alaysisfind_page_huati_01 {
    
    [MobClick event:find_page_huati_01];
}
+ (void)alaysisfind_page_huati_01_share {
    
    [MobClick event:find_page_huati_01_share];
}
+ (void)alaysismine_page_tanli {
    
    [MobClick event:mine_page_tanli];
}
+ (void)alaysismine_page_tanli_yaoqing {
    
    [MobClick event:mine_page_tanli_yaoqing];
}
//我的资产-授权导入PV，UV
+ (void)alaysisMY_Asset_Authorization_import {
    
    [MobClick event:MY_Asset_Authorization_import];
}
//火币-点击授权
+ (void)alaysisClick_Authorization_huobi {
    
    [MobClick event:Click_Authorization_huobi];
}
//币安-点击授权
+ (void)alaysisClick_Authorization_bian {
    
    [MobClick event:Click_Authorization_bian];
}
//OKex-点击授权
+ (void)alaysisClick_Authorization_OKex {
    
    [MobClick event:Click_Authorization_OKex];
}
//火币-完成授权交易
+ (void)alaysisComplete_the_Authorization_huobi {
    
    [MobClick event:Complete_the_Authorization_huobi];
}
//币安-完成授权交易
+ (void)alaysisComplete_the_Authorization_bian {
    
    [MobClick event:Complete_the_Authorization_bian];
}
//OKex-完成授权交易
+ (void)alaysisComplete_the_Authorization_OKex {
    
    [MobClick event:Complete_the_Authorization_OKex];
}
/*******************截图分享************************/
//微信分享
+ (void)alaysisWeChat_screenshot_sharing {
    
    [MobClick event:WeChat_screenshot_sharing];
}
//微博分享
+ (void)alaysisWeibo_screenshot_sharing {
    
    [MobClick event:Weibo_screenshot_sharing];
}
//朋友圈
+ (void)alaysisMoments_screenshot_sharing {
    
    [MobClick event:Moments_screenshot_sharing];
}
/*******************资讯分享************************/
//微信分享
+ (void)alaysisWeChat_info_sharing {
    
    [MobClick event:WeChat_info_sharing];
}
//微博分享
+ (void)alaysisWeibo_info_sharing {
    
    [MobClick event:Weibo_info_sharing];
}
//朋友圈
+ (void)alaysisMoments_info_sharing {
    
    [MobClick event:Moments_info_sharing];
}

//评论
+ (void)alaysis_detail_comment{
    [MobClick event:@"ADD_Comment"];
}

//预警
+ (void)alaysis_detail_alert{
     [MobClick event:@"Alerts"];
}

//自选
+ (void)alaysis_detail_collect{
    [MobClick event:@"Add_to"];
}
//我的-加用户群
+ (void)alaysis_usergroup_page {
    
    [MobClick event:@"mine_join_group"];
}
//资讯-话题列表点击
+ (void)alaysis_news_topic_list {
    
    [MobClick event:@"news_topic_list"];
}
//资讯-查看话题详情
+ (void)alaysis_news_topic {
    
    [MobClick event:@"news_topic"];
}
//发现-热门币种
+ (void)alaysis_hot_currencies {
    
    [MobClick event:@"hot_currencies"];
}
@end
