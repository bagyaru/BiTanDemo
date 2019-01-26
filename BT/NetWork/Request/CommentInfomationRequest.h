//
//  CommentInfomationRequest.h
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface CommentInfomationRequest : BTBaseRequest
- (id)initWithRefType:(NSInteger)refType refId:(NSString *)refId content:(NSString *)content refUserId:(NSInteger)refUserId;
@end
