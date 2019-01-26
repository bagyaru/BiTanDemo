//
//  DiscussCurrencyRequest.h
//  BT
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface DiscussCurrencyRequest : BTBaseRequest

- (instancetype)initWithRefId:(NSString *)refId refType:(NSInteger)refType pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize;

@end
