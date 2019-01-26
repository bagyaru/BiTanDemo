//
//  BTUserFollowListReq.h
//  BT
//
//  Created by apple on 2018/10/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTUserFollowListReq : BTBaseRequest

- (id)initWithUserId:(NSInteger)userId CurrentPage:(NSInteger)currentPage;

@end
