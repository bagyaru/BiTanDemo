//
//  MessageCenterRequest.h
//  BT
//
//  Created by admin on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface MessageCenterRequest : BTBaseRequest
- (id)initWithMesageCenter:(NSInteger)pageIndex;
@end
