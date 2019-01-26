//
//  BTPriceWarnInfoReq.h
//  BT
//
//  Created by apple on 2018/5/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTPriceWarnInfoReq : BTBaseRequest

- (instancetype)initWithKind:(NSString*)kind exchange:(NSString*)exCode;

@end
