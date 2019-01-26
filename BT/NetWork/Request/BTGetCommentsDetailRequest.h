//
//  BTGetCommentsDetailRequest.h
//  BT
//
//  Created by admin on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTGetCommentsDetailRequest : BTBaseRequest
- (instancetype)initWithCommentId:(NSString*)commentId;
@end
