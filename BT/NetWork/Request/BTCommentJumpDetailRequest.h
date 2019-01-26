//
//  BTCommentJumpDetailRequest.h
//  BT
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTCommentJumpDetailRequest : BTBaseRequest
- (id)initWithCommentId:(NSInteger)commentId currCommentId:(NSInteger)currCommentId;
@end
