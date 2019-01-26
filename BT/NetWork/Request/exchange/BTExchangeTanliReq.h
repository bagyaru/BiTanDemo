//
//  BTExchangeTanliReq.h
//  BT
//
//  Created by apple on 2018/8/29.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTExchangeTanliReq : BTBaseRequest

- (instancetype)initWithUserId:(NSInteger)userId exchangeNum:(NSInteger)num;

@end
