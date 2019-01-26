//
//  BTGetCommentsDetailRequest.m
//  BT
//
//  Created by admin on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTGetCommentsDetailRequest.h"

@implementation BTGetCommentsDetailRequest{
    NSString *_commentId;
}
- (instancetype)initWithCommentId:(NSString *)commentId{
    if(self =[super init]){
        _commentId = commentId;
    }
    return self;
}
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString*)requestUrl{
    return GetCommentDetailUrl;
}

- (id)requestArgument{
    return @{@"commentId":SAFESTRING(_commentId)};
}


@end
