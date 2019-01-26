//
//  BTRemindShutRequest.h
//  BT
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"
#import "BTRemindModel.h"
@interface BTRemindShutRequest : BTBaseRequest

- (instancetype)initWithRemind:(BTRemindModel*)model;

@end
