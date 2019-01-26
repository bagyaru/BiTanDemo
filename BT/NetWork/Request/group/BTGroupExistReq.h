//
//  BTGroupExistReq.h
//  BT
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTGroupExistReq : BTBaseRequest

- (instancetype)initWithCode:(NSString*)code exchangeCode:(NSString *)exchangeCode;

@end
