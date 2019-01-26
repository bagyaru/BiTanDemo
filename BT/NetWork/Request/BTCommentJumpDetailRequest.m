//
//  BTCommentJumpDetailRequest.m
//  BT
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTCommentJumpDetailRequest.h"

@implementation BTCommentJumpDetailRequest{
    NSInteger _commentId;
    NSInteger _currCommentId;
}

- (id)initWithCommentId:(NSInteger)commentId currCommentId:(NSInteger)currCommentId{
    self = [super init];
    if (self) {
        _commentId = commentId;
        _currCommentId = currCommentId;
    }
    return self;
}


- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    return @{@"commentId":@(_commentId),
             @"currCommentId":@(_currCommentId)
             };
}

- (NSString *)requestUrl{
    return CommentJumpDetailUrl;
}


@end
