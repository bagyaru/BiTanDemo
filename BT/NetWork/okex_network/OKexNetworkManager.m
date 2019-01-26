//
//  OKexNetworkManager.m
//  BT
//
//  Created by apple on 2018/5/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "OKexNetworkManager.h"

@implementation OKexNetworkManager

+ (NSURLSessionDataTask*)getWithUrl:(NSString *) url
                             params:(id) params
                       successBlock:(requestSuccess) successBlock
                       failureBlock:(requestFailure) failureBlock{
    
    return  [NetWorkManager getWithUrl:url params:params tag:nil successBlock:successBlock failureBlock:failureBlock];
}

+ (NSURLSessionDataTask*)postWithUrl:(NSString *) url
                              params:(id) params
                        successBlock:(requestSuccess) successBlock
                        failureBlock:(requestFailure) failureBlock{
    return  [NetWorkManager postWithUrl:url params:params tag:nil successBlock:successBlock failureBlock:failureBlock];
}


@end
