//
//  BTOptionSearchRequest.h
//  BT
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTOptionSearchRequest : BTBaseRequest

- (instancetype)initWithInput:(NSString *)input pageIndex:(NSInteger)pageIndex;

@end
