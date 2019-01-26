//
//  OKexNetworkManager.h
//  BT
//
//  Created by apple on 2018/5/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NetWorkManager.h"

@interface OKexNetworkManager : NSObject

+ (NSURLSessionDataTask*)getWithUrl:(NSString *) url
            params:(id) params
      successBlock:(requestSuccess) successBlock
      failureBlock:(requestFailure) failureBlock;


+ (NSURLSessionDataTask*)postWithUrl:(NSString *) url
                             params:(id) params
                       successBlock:(requestSuccess) successBlock
                       failureBlock:(requestFailure) failureBlock;



@end
