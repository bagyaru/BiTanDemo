//
//  CommentReplyRequest.h
//  BT
//
//  Created by admin on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface CommentReplyRequest : BTBaseRequest
- (id)initWithRefType:(NSInteger)refType refId:(NSString *)refId content:(NSString *)content refUserId:(NSInteger)refUserId replyId:(NSString *)replyId replyUserId:(NSInteger)replyUserId;
@end
