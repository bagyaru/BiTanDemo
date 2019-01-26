//
//  CommentReplyRequest.m
//  BT
//
//  Created by admin on 2018/8/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CommentReplyRequest.h"

@implementation CommentReplyRequest{
    NSString *_content;
    NSString *_refId;
    NSInteger _refType;
    NSInteger _refUserId;
    NSString *_replyId;
    NSInteger _replyUserId;
}

- (id)initWithRefType:(NSInteger)refType refId:(NSString *)refId content:(NSString *)content refUserId:(NSInteger)refUserId replyId:(NSString *)replyId replyUserId:(NSInteger)replyUserId{
    self = [super init];
    if (self) {
        _refType = refType;
        _refId = refId;
        _content = content;
        _refUserId = refUserId;
        _replyId = replyId;
        _replyUserId = replyUserId;
    }
    return self;
}


- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (id)requestArgument{
    return @{@"refType":@(_refType),
             @"refId":_refId,
             @"content":_content,
             @"refUserId":@(_refUserId),
             @"replyId":_replyId,
             @"replyUserId":@(_replyUserId)
             };
}

- (NSString *)requestUrl{
    return CommentInfomationUrl;
}

@end
