//
//  BTMyCoinDetailRequest.h
//  BT
//
//  Created by apple on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTMyCoinDetailRequest : BTBaseRequest
- (instancetype)initWithCurrentPage:(NSInteger)currentPage pageSize:(NSInteger)pageSize;
@end
