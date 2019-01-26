//
//  HotCommentRequest.h
//  BT
//
//  Created by admin on 2018/4/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface HotCommentRequest : BTBaseRequest
- (id)initWithRefType:(NSInteger)refType refId:(NSString *)refId;
@end
