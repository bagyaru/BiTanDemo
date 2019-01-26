//
//  BTPersonalInfoReq.h
//  BT
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

//获取 个人主页里面的个人信息
#import "BTBaseRequest.h"

@interface BTPersonalInfoReq : BTBaseRequest

- (instancetype)initWithUserId:(NSInteger)userId;
@end
