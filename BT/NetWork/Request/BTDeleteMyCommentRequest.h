//
//  BTDeleteMyCommentRequest.h
//  BT
//
//  Created by admin on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBaseRequest.h"

@interface BTDeleteMyCommentRequest : BTBaseRequest
- (id)initWithCommentId:(NSInteger)commentId;
@end
