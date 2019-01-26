//
//  BTUserFansListReq.h
//  BT
//
//  Created by apple on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTUserFansListReq : BTBaseRequest

- (id)initWithUserId:(NSInteger)userId CurrentPage:(NSInteger)currentPage;

@end
