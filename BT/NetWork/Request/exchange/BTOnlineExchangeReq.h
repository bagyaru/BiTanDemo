//
//  BTOnlineExchangeReq.h
//  BT
//
//  Created by apple on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTOnlineExchangeReq : BTBaseRequest

- (instancetype)initWithIndex:(NSInteger)index category:(NSString *)category keywords:(NSString*)keywords;

@end
