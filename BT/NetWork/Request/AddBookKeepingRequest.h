//
//  AddBookKeepingRequest.h
//  BT
//
//  Created by admin on 2018/3/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface AddBookKeepingRequest : BTBaseRequest
- (instancetype)initWithBuy:(BOOL)buy currency:(BOOL)currency dealCount:(NSString *)dealCount dealDate:(NSString *)dealDate dealTotal:(NSString *)dealTotal dealUnitPrice:(NSString *)dealUnitPrice kind:(NSString *)kind legalType:(NSInteger)legalType note:(NSString *)note dealSource:(NSInteger)dealSource dealSourceInfo:(NSString *)dealSourceInfo;
@end
