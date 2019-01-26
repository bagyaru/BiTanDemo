//
//  BTTPRewardRecordReq.h
//  BT
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTTPRewardRecordReq : BTBaseRequest

- (instancetype)initWithType:(NSInteger)type pageIndex:(NSInteger)pageIndex;

@end
