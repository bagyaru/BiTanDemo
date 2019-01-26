//
//  PCNetworkClient+MarketData.m
//  PCBianceAPIDemo
//
//  Created by peichuang on 2017/10/21.
//  Copyright © 2017年 peichuang. All rights reserved.
//

#import "PCNetworkClient+MarketData.h"

@implementation PCNetworkClient (MarketData)

+ (void)marketDepthForSymbol:(NSString *)symbol withCompletion:(ResponseCompletion)completion
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (symbol.length > 0) {
        [dict setObject:symbol forKey:@"symbol"];
    }
    [dict setObject:@(20) forKey:@"limit"];
    [self GET:@"/api/v1/depth" parameters:dict responseDataClass:[NSDictionary class] completion:^(NSError *error, id responseObj) {
        if (completion) {
            completion(error, responseObj);
        }
    }];
}

+ (void)aggregateTradesListForSymbol:(NSString *)symbol
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (symbol.length > 0) {
        [dict setObject:symbol forKey:@"symbol"];
    }
    [dict setObject:@(100) forKey:@"limit"];
    [self GET:@"/api/v1/aggTrades" parameters:dict responseDataClass:[NSDictionary class] completion:^(NSError *error, id responseObj) {
        
    }];
}

+ (void)klineListForSymbol:(NSString *)symbol intervals:(NSString *)intervals
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (symbol.length > 0) {
        [dict setObject:symbol forKey:@"symbol"];
    }
    if (intervals.length > 0) {
        [dict setObject:intervals forKey:@"interval"];
    }
    [self GET:@"/api/v1/klines" parameters:dict responseDataClass:[NSDictionary class] completion:^(NSError *error, id responseObj) {
        
    }];
}

+ (void)priceChangeIn24hForSymbol:(NSString *)symbol
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (symbol.length > 0) {
        [dict setObject:symbol forKey:@"symbol"];
    }
    [self GET:@"/api/v1/ticker/24hr" parameters:dict responseDataClass:[NSDictionary class] completion:^(NSError *error, id responseObj) {
        
    }];
}

+ (void)lastPriceForAllSymbolWithCompletion:(ResponseCompletion)completion
{
    [self GET:@"/api/v1/ticker/allPrices" parameters:nil responseDataClass:[NSDictionary class] completion:^(NSError *error, id responseObj) {
        if (completion) {
            completion(error, responseObj);
        }
    }];
}

+ (void)allBookTickersWithCompletion:(ResponseCompletion)completion
{
    [self GET:@"/api/v1/ticker/allBookTickers" parameters:nil responseDataClass:[NSDictionary class] completion:^(NSError *error, id responseObj) {
        if (completion) {
            completion(error, responseObj);
        }
    }];
}

@end
