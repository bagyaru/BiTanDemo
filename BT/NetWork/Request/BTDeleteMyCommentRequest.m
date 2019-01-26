//
//  BTDeleteMyCommentRequest.m
//  BT
//
//  Created by admin on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTDeleteMyCommentRequest.h"

@implementation BTDeleteMyCommentRequest{
    NSInteger _commentId;
}

- (id)initWithCommentId:(NSInteger)commentId{
    self = [super init];
    if (self) {
        _commentId = commentId;
    }
    return self;
}


- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (id)requestArgument{
    return @{@"commentId":@(_commentId)};
}

- (NSString *)requestUrl{
    return DeleteMyCommentUrl;
}


@end
