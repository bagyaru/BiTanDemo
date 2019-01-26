//
//  PCNetworkClient+Account.h
//  PCBianceAPIDemo
//
//  Created by peichuang on 2017/10/21.
//  Copyright © 2017年 peichuang. All rights reserved.
//

#import "PCNetworkClient.h"

@interface PCNetworkClient (Account)

+ (void)accountInfoWithApiKey:(NSString*)apiKey apiSecert:(NSString*)apiSecert completion:(ResponseCompletion)completion;

@end
