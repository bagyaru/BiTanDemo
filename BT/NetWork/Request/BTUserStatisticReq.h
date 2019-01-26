//
//  BTUserStatisticReq.h
//  BT
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

//个人主页 请求一个接口

#import "BTBaseRequest.h"

@interface BTUserStatisticReq : BTBaseRequest

- (instancetype)initWithUserId:(NSInteger)userId userName:(NSString*)userName;

@end
