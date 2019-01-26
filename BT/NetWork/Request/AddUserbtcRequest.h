//
//  AddUserbtcRequest.h
//  BT
//
//  Created by apple on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface AddUserbtcRequest : BTBaseRequest

- (id)initWithCurrencyCode:(NSString *)currencyCode currencyCodeRelation:(NSString *)currencyCodeRelation;

@end
