//
//  YZMStockSearchService.h
//  YZMicroStock
//
//  Created by wangminhong on 16/4/8.
//  Copyright © 2016年 cqjr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTExchangeModel.h"
#import "BTSplashScreenModel.h"
#import "BTBZSeachRequset.h"
#include "FastInfomationObj.h"
@interface BTSearchService : NSObject

+ (instancetype)sharedService;

//搜索
@property (nonatomic, strong) BTBZSeachRequset *bzSeachApi;


- (void)checkIfNeedUpdateStocks;
- (void)fecthStocksWithInput:(NSString *)inputStr result: (void (^)(NSArray *))result;

- (void)fecthStocksXianhuoWithInput:(NSString *)inputStr result: (void (^)(NSArray *))result;

- (void)fecthStocksQihuoWithInput:(NSString *)inputStr result: (void (^)(NSArray *))result;

- (void)appendHistoryWithCode:(NSString *)code;
- (void)fecthHistoryResult:(void (^)(NSArray *))result;
- (void)clearHistory;

- (void)writeHistorySearch:(NSString *)str;

- (NSArray *)readHistorySearch;

- (void)writeHistoryQihuoSearch:(NSString *)str;

- (NSArray *)readHistoryQihuoSearch;


- (void)writeHistoryXianhuoSearch:(NSString *)str;

- (NSArray *)readHistoryXianhuoSearch;

- (void)clearSearchHistory;

- (void)clearSearchXianhuoHistory;

- (void)clearSearchQihuoHistory;
/*************************收益统计********************/
- (void)fecthStocksSYTJWithInput:(NSString *)inputStr result: (void (^)(NSArray *))result;

- (void)writeHistorySYTJSearch:(NSString *)str;

- (NSArray *)readHistorySYTJSearch;

- (void)clearSearchSYTJHistory;
//添加交易选择币种对应的交易对列表
- (void)fecthStocksTJJYWithSimpleName:(NSString *)simpleName ChineseName:(NSString *)chineseName result: (void (^)(NSMutableArray *))result;
//根据币种 筛选交易对
- (void)searchJYDWithArray:(NSMutableArray *)arr withInput:(NSString *)inputStr result: (void (^)(NSArray *))result;
//自选
- (void)writeUserOption:(NSArray *)array;

- (NSArray *)readUserOption;

//实时搜索
- (void)realTimeWithInput:(NSString *)inputStr pageIndex:(NSInteger)pageIndex  result: (void (^)(NSArray *))result;

- (void)optionSearchWithInput:(NSString *)inputStr pageIndex:(NSInteger)pageIndex  result: (void (^)(NSArray *))result;

//币种-实时搜索
- (void)BZ_RealTimeWithInput:(NSString *)inputStr result: (void (^)(NSArray *))result;
//插入已授权交易所model
- (void)writeExchangeAuthorized:(BTExchangeModel *)model;

//读取已授权交易所列表
- (NSArray *)readExchangeAuthorized;

//
- (NSArray *)readExchangeAuthorizedWithUserId:(NSString*)userId;

//根据交易所名字与userID 判断该交易所是否授权
- (BOOL)readExchangeAuthorizedWithExchangeName:(NSString *)exchangeName userId:(NSString*)userId;
//根据交易所名字 查询该交易所model
- (BTExchangeModel *)readExchangeAuthorizedBackWithExchangeName:(NSString *)exchangeName;
//清除本地已授权交易所列表
- (void)clearExchangeAuthorized;

//存储闪屏信息
- (void)writeBTSplashScreenModel:(BTSplashScreenModel *)model;
//读取闪屏信息
- (BTSplashScreenModel *)readBTSplashScreenModel;
//清除闪屏信息
- (void)clearBTSplashScreenModel;
//记录闪屏的启动时间
- (void)writeBTSplashScreenDatatime;
//读取闪屏的启动时间
- (NSDate *)readBTSplashScreenDatatime;
//清除闪屏的启动时间
- (void)clearBTSplashScreenDatatime;
//插入已阅读的文章
-(void)writeSheQuHistoryRead:(FastInfomationObj *)model;
//读取已经阅读过的文章
-(NSArray *)readSheQuHistoryRead;
//判断是否阅读过
-(BOOL)readSheQuHistoryReadWithInfoID:(NSString *)infoID type:(NSInteger )type;
//清除阅读记录
-(void)clearSheQuHistoryRead;
@end
