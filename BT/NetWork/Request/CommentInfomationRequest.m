//
//  CommentInfomationRequest.m
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CommentInfomationRequest.h"

@implementation CommentInfomationRequest{
    NSString *_content;
    NSInteger _refType;
    NSString *_refId;
    NSInteger _refUserId;
}

- (id)initWithRefType:(NSInteger)refType refId:(NSString *)refId content:(NSString *)content refUserId:(NSInteger)refUserId{
    self = [super init];
    if (self) {
        _refType = refType;
        _refId = refId;
        _content = content;
        _refUserId = refUserId;
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
             @"refUserId":@(_refUserId)
             };
}

- (NSString *)requestUrl{
    return CommentInfomationUrl;
}

@end
