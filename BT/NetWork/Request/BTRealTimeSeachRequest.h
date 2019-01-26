//
//  BTRealTimeSeachRequest.h
//  BT
//
//  Created by admin on 2018/5/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTRealTimeSeachRequest : BTBaseRequest
- (instancetype)initWithInput:(NSString *)input pageIndex:(NSInteger)pageIndex;
@end
