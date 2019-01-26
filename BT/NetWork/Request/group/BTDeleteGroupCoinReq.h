//
//  BTDeleteGroupCoinReq.h
//  BT
//
//  Created by apple on 2018/5/4.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTDeleteGroupCoinReq : BTBaseRequest

- (instancetype)initWithAllDelete:(BOOL)allDelete list:(NSArray*)list groupName:(NSString*)groupName;

@end
