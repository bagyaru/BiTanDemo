//
//  HotCommentRequest.m
//  BT
//
//  Created by admin on 2018/4/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HotCommentRequest.h"

@implementation HotCommentRequest{
    NSInteger _refType;
    NSString *_refId;
}

- (id)initWithRefType:(NSInteger)refType refId:(NSString *)refId{
    self = [super init];
    if (self) {
        _refType = refType;
        _refId = refId;
    }
    return self;
}


- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    return @{@"refType":@(_refType),
             @"refId":_refId
             };
}

- (NSString *)requestUrl{
    return HotCommentListUrl;
}

@end
