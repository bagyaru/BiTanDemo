//
//  TPTargetRequest.h
//  BT
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface TPTargetRequest : BTBaseRequest
@property (nonatomic,assign)NSInteger type;//列表类型（传1表示首页列表，不传返回全部列表）
@end
