//
//  PCNetworkClient.h
//  PCBianceAPIDemo
//
//  Created by peichuang on 2017/10/19.
//  Copyright © 2017年 peichuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

static NSString const *orderTypeLimit = @"LIMIT";
static NSString const *orderTypeMarket = @"MARKET";
static NSString const *orderSideBuy = @"BUY";
static NSString const *orderSideSell = @"SELL";
static NSString const *timeForceGTC = @"GTC";
static NSString const *timeForceIOC = @"IOC";

typedef void(^ResponseCompletion)(NSError *error, id responseObj);

@interface PCNetworkClient : NSObject

+ (void)setupApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret;

+ (void)GET:(NSString *)api apiKey:(NSString*)apiKey parameters:(NSDictionary *)paraDict responseDataClass:(__unsafe_unretained Class)dataClass completion:(ResponseCompletion)completion;

+ (void)POST:(NSString *)api parameters:(NSDictionary *)paraDict withSignature:(BOOL)flag responseDataClass:(Class)dataClass completion:(ResponseCompletion)completion;

+ (void)DELETE:(NSString *)api parameters:(NSDictionary *)paraDict responseDataClass:(__unsafe_unretained Class)dataClass completion:(ResponseCompletion)completion;

+ (void)GETWithSignature:(NSString *)api parameters:(NSDictionary *)paraDict responseDataClass:(__unsafe_unretained Class)dataClass completion:(ResponseCompletion)completion;

+ (void)GETWithSignature:(NSString *)api apiKey:(NSString*)apiKey apiSecert:(NSString*)apiSecert parameters:(NSDictionary *)paraDict responseDataClass:(__unsafe_unretained Class)dataClass completion:(ResponseCompletion)completion;

+ (void)POSTWithSignature:(NSString *)api parameters:(NSDictionary *)paraDict responseDataClass:(Class)dataClass completion:(ResponseCompletion)completion;

+ (void)DELETEWithSignature:(NSString *)api parameters:(NSDictionary *)paraDict responseDataClass:(__unsafe_unretained Class)dataClass completion:(ResponseCompletion)completion;

@end
