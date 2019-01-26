//
//  UserAccountMainRequest.h
//  BT
//
//  Created by admin on 2018/3/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface UserAccountMainRequest : BTBaseRequest
- (instancetype)initWithSort:(NSInteger)sort;//1最高持有数 2最低持有数 3最高持有金额 4最低持有金额 5收益最多 6亏损最多
@end
