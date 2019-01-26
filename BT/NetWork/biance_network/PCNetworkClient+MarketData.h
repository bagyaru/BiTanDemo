//
//  PCNetworkClient+MarketData.h
//  PCBianceAPIDemo
//
//  Created by peichuang on 2017/10/21.
//  Copyright © 2017年 peichuang. All rights reserved.
//

#import "PCNetworkClient.h"

static NSString const *KlineIntervalsArray[] = {@"1m", @"3m", @"5m", @"15m", @"30m", @"1h", @"2h", @"4h", @"6h", @"8h", @"12h", @"1d", @"3d", @"1w", @"1M"};

@interface PCNetworkClient (MarketData)

//获取交易品类市场深度
+ (void)marketDepthForSymbol:(NSString *)symbol withCompletion:(ResponseCompletion)completion;
//获取交易品类交易列表
+ (void)aggregateTradesListForSymbol:(NSString *)symbol;
//获取k线数据
+ (void)klineListForSymbol:(NSString *)symbol intervals:(NSString const *)intervals;
//24小时内价格变化
+ (void)priceChangeIn24hForSymbol:(NSString *)symbol;
//所有交易品类当前价格
+ (void)lastPriceForAllSymbolWithCompletion:(ResponseCompletion)completion;
//所有交易品类当前下单信息
+ (void)allBookTickersWithCompletion:(ResponseCompletion)completion;

@end
