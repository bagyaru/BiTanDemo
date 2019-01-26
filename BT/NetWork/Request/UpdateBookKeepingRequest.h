//
//  UpdateBookKeepingRequest.h
//  BT
//
//  Created by admin on 2018/5/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface UpdateBookKeepingRequest : BTBaseRequest
- (instancetype)initWithBuy:(BOOL)buy currency:(BOOL)currency dealCount:(NSString *)dealCount dealDate:(NSString *)dealDate dealTotal:(NSString *)dealTotal dealUnitPrice:(NSString *)dealUnitPrice kind:(NSString *)kind legalType:(NSInteger)legalType note:(NSString *)note dealSource:(NSInteger)dealSource dealSourceInfo:(NSString *)dealSourceInfo bookkeepingId:(NSInteger)bookkeepingId;
@end
