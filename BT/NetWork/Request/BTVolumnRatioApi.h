//
//  BTVolumnRatioApi.h
//  BT
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTVolumnRatioApi : BTBaseRequest

- (instancetype)initWithCode:(NSString *)code exchangeCode:(NSString*)exchangeCode isFuture:(NSInteger)type;
@end
