//
//  SubmitCommentRequest.m
//  BT
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SubmitCommentRequest.h"

@implementation SubmitCommentRequest{
    NSString *_refId;
    NSInteger _refType;
    NSInteger _refUserId;
    NSString *_content;
}

- (instancetype)initWithRefId:(NSString *)refId refType:(NSInteger)refType refUserId:(NSInteger)refUserId content:(NSString *)content{
    self = [super init];
    if (self) {
        _refId = refId;
        _refType = refType;
        _refUserId = refUserId;
        _content = content;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return SUBMITCOMMENT_URL;
}

- (id)requestArgument{
    return @{@"refId":_refId,@"refType":@(_refType),@"refUserId":[NSNull null],@"content":_content};
}

@end
