//
//  PCNetworkClient.m
//  PCBianceAPIDemo
//
//  Created by peichuang on 2017/10/19.
//  Copyright © 2017年 peichuang. All rights reserved.
//

#import "PCNetworkClient.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

//static NSString *apiKey = @"G7JwS43hH6jijqfMlDLIhg8QFNJjTlupG2dvLAC4DuykCk5wGhoQ4xKEE9BFvREm";
//static NSString *apiSecret = @"47iDb8YTvhKNOr7ZfPh7E0GQCwmh946tNTiEecDHp6ASrNgf15LFeNHH6laGlts9";

@implementation PCNetworkClient

+ (void)setupApiKey:(NSString *)apiKey apiSecret:(NSString *)apiSecret
{
    apiKey = apiKey;
    apiSecret = apiSecret;
}

+ (void)GET:(NSString *)api apiKey:(NSString*)apiKey parameters:(NSDictionary *)paraDict responseDataClass:(__unsafe_unretained Class)dataClass completion:(ResponseCompletion)completion
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/javascript",@"application/json",@"text/json", nil];
    
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:apiKey forHTTPHeaderField:@"X-MBX-APIKEY"];
    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
        NSString *query;
        if (parameters[@"signature"]) {
            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
            NSString *sign = mDict[@"signature"];
            [mDict removeObjectForKey:@"signature"];
            query = AFQueryStringFromParameters(mDict);
            query = [NSString stringWithFormat:@"%@&signature=%@", query, sign];
        } else {
            query = AFQueryStringFromParameters(parameters);
        }
        
        return query;
    }];
    
    [manager GET:[self urlForApi:api] parameters:paraDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@ response: %@", api, responseObject);
        if (completion) {
            completion(nil, responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completion) {
            completion(error, nil);
        }
    }];
}

//+ (void)POST:(NSString *)api parameters:(NSDictionary *)paraDict withSignature:(BOOL)flag responseDataClass:(__unsafe_unretained Class)dataClass completion:(ResponseCompletion)completion
//{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    [manager.requestSerializer setValue:apiKey forHTTPHeaderField:@"X-MBX-APIKEY"];
//    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
//        NSString *query;
//        if (flag) {
//            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
//            NSString *sign = mDict[@"signature"];
//            [mDict removeObjectForKey:@"signature"];
//            query = AFQueryStringFromParameters(mDict);
//            query = [NSString stringWithFormat:@"%@&signature=%@", query, sign];
//        } else {
//            query = AFQueryStringFromParameters(parameters);
//        }
//
//        return query;
//    }];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/javascript",@"application/json",@"text/json", nil];
//
//    [manager POST:[self urlForApi:api] parameters:paraDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@ response: %@", api, responseObject);
//        if (completion) {
//            completion(nil, responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (completion) {
//            completion(error, nil);
//        }
//    }];
//}

//+ (void)DELETE:(NSString *)api parameters:(NSDictionary *)paraDict responseDataClass:(__unsafe_unretained Class)dataClass completion:(ResponseCompletion)completion
//{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//
//    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [manager.requestSerializer setValue:apiKey forHTTPHeaderField:@"X-MBX-APIKEY"];
//    [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString * _Nonnull(NSURLRequest * _Nonnull request, id  _Nonnull parameters, NSError * _Nullable __autoreleasing * _Nullable error) {
//        NSString *query;
//        if (parameters[@"signature"]) {
//            NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:parameters];
//            NSString *sign = mDict[@"signature"];
//            [mDict removeObjectForKey:@"signature"];
//            query = AFQueryStringFromParameters(mDict);
//            query = [NSString stringWithFormat:@"%@&signature=%@", query, sign];
//        } else {
//            query = AFQueryStringFromParameters(parameters);
//        }
//
//        return query;
//    }];
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/javascript",@"application/json",@"text/json", nil];
//
//    [manager DELETE:[self urlForApi:api] parameters:paraDict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@ response: %@", api, responseObject);
//        if (completion) {
//            completion(nil, responseObject);
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        if (completion) {
//            completion(error, nil);
//        }
//    }];
//}

+ (void)GETWithSignature:(NSString *)api apiKey:(NSString*)apiKey apiSecert:(NSString*)apiSecert parameters:(NSDictionary *)paraDict responseDataClass:(__unsafe_unretained Class)dataClass completion:(ResponseCompletion)completion
{
    NSDictionary *signDict = [self addSignatureFromOriginParaDict:paraDict apiSecret:apiSecert];
    [self GET:api apiKey:apiKey  parameters:signDict responseDataClass:dataClass completion:completion];
}

+ (void)POSTWithSignature:(NSString *)api parameters:(NSDictionary *)paraDict responseDataClass:(Class)dataClass completion:(ResponseCompletion)completion
{
    [self POST:api parameters:paraDict withSignature:YES responseDataClass:dataClass completion:completion];
}

//+ (void)DELETEWithSignature:(NSString *)api parameters:(NSDictionary *)paraDict responseDataClass:(__unsafe_unretained Class)dataClass completion:(ResponseCompletion)completion
//{
//    NSDictionary *signDict = [self addSignatureFromOriginParaDict:paraDict];
//    [self DELETE:api parameters:signDict responseDataClass:dataClass completion:completion];
//}

+ (id)transferJsonObj:(id)jsonObj toMTLClass:(Class)mtlClass
{
    return nil;
}

+ (NSDictionary *)addSignatureFromOriginParaDict:(NSDictionary *)paraDict apiSecret:(NSString*)apiSecret{
    NSString *query = AFQueryStringFromParameters(paraDict);
    NSString *sign = [self hmac:query withKey:apiSecret];
    
    NSMutableDictionary *mDict = [NSMutableDictionary dictionaryWithDictionary:paraDict];
    if (sign) {
        [mDict setObject:sign forKey:@"signature"];
    }
    
    return [mDict copy];
}

+ (NSString *)hmac:(NSString *)plaintext withKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    
    return HMAC;
}

+ (NSString *)baseUrl
{
    return @"https://www.binance.com";
}

+ (NSString *)urlForApi:(NSString *)api
{
    return [NSString stringWithFormat:@"%@%@", [self baseUrl], api];
}

@end
