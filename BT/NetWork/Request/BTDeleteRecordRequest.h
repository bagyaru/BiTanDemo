//
//  BTDeleteRecordRequest.h
//  BT
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"
#import "BTRecordModel.h"
@interface BTDeleteRecordRequest : BTBaseRequest

- (instancetype)initWithRecord:(BTRecordModel*)model;

@end
