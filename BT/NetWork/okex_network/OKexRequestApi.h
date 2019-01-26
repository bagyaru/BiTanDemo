//
//  OKexRequestApi.h
//  BT
//
//  Created by apple on 2018/5/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OKexNetworkManager.h"
@interface OKexRequestApi : NSObject

+ (void)accountWithApiKey:(NSString*)apiKey apiSecret:(NSString*)apiSecret succeed:(requestSuccess)succeed  failed:(requestFailure)failed;



@end
