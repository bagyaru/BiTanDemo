//
//  BTICOListApi.h
//  BT
//
//  Created by apple on 2018/8/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTICOListApi : BTBaseRequest

- (instancetype)initWithType:(NSInteger)type pageIndex:(NSInteger)pageIndex;

@end
