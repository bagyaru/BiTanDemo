//
//  OKexRequestApi.m
//  BT
//
//  Created by apple on 2018/5/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OKexRequestApi.h"
#import "OKexNetworkManager.h"
#import "OKexUtil.h"

#define okex_base_url @"https://www.okex.com/api/v1"
@implementation OKexRequestApi

+ (void)accountWithApiKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret succeed:(requestSuccess)succeed  failed:(requestFailure)failed{
    NSString *url = @"/userinfo.do";
    NSString *urlStr = [self url:url withApikey:apiKey apiSecret:apiSecret param:nil];
    [OKexNetworkManager postWithUrl:urlStr params:nil successBlock:succeed failureBlock:failed];
}

+ (NSString*)url:(NSString*)url withApikey:(NSString*)apiKey apiSecret:(NSString*)apiSecret param:(NSDictionary*)param{
    url = [NSString stringWithFormat:@"%@%@",okex_base_url,url];
    
    NSMutableDictionary *mutaParams = @{}.mutableCopy;
    [mutaParams setObject:SAFESTRING(apiKey) forKey:@"api_key"];
    
    if(param){
        [mutaParams addEntriesFromDictionary:param];
    }
    [mutaParams setObject:SAFESTRING(apiSecret) forKey:@"secret_key"];
    
    NSMutableString *string = [[NSMutableString alloc] init];
    NSArray* res = [mutaParams keysSortedByValueUsingSelector:@selector(caseInsensitiveCompare:)];
    for(int i=0; i<res.count; i++){
        NSString *key = res[i];
        if(i == 0){
            [string appendFormat:@"%@=%@",key,mutaParams[key]];
        }else{
            [string appendFormat:@"&%@=%@",key,mutaParams[key]];
        }
    }
    NSString *md5Str = [OKexUtil md532Upper:string];
    [mutaParams removeObjectForKey:@"secret_key"];
    [mutaParams setObject:SAFESTRING(md5Str) forKey:@"sign"];
    return [OKexUtil getGetUrlWithUrl:url params:mutaParams];
}


@end
