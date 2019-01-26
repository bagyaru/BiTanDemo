//
//  BTReadSingleMessageRequest.m
//  BT
//
//  Created by admin on 2018/10/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTReadSingleMessageRequest.h"

@implementation BTReadSingleMessageRequest{
    NSInteger _type;
    NSInteger _messageId;
}

- (instancetype)initWithType:(NSInteger)type messageId:(NSInteger)messageId {
    if(self = [super init]){
        _messageId = messageId;
        _type = type;
    }
    return self;
}

- (NSString *)requestUrl {
    return ReadSingleMessageUrl;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument{
    NSDictionary *dic;
    dic =  @{@"messageId":@(_messageId),@"type":@(_type)};
    return dic;
}


@end
