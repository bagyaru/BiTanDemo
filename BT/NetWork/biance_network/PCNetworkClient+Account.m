//
//  PCNetworkClient+Account.m
//  PCBianceAPIDemo
//
//  Created by peichuang on 2017/10/21.
//  Copyright © 2017年 peichuang. All rights reserved.
//

#import "PCNetworkClient+Account.h"

@implementation PCNetworkClient (Account)

+ (void)accountInfoWithApiKey:(NSString*)apiKey apiSecert:(NSString*)apiSecert completion:(ResponseCompletion)completion{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:[NSString stringWithFormat:@"%.0lf", [[NSDate date] timeIntervalSince1970] * 1000] forKey:@"timestamp"];
    
    [self GETWithSignature:@"/api/v3/account" apiKey:apiKey apiSecert:apiSecert parameters:dict responseDataClass:[NSDictionary class] completion:^(NSError *error, id responseObj) {
        if (completion) {
            completion(error, responseObj);
        }
    }];
}

@end
