//
//  BTSearchUserReq.h
//  BT
//
//  Created by apple on 2018/10/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTSearchUserReq : BTBaseRequest

- (instancetype)initWithUserName:(NSString*)name currentPage:(NSInteger)currentPage;


@end
