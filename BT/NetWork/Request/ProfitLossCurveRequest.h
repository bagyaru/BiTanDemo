//
//  ProfitLossCurveRequest.h
//  BT
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface ProfitLossCurveRequest : BTBaseRequest

- (instancetype)initWithCurrentPage:(NSInteger)currentPage pageSize:(NSInteger)pageSize;

@end
