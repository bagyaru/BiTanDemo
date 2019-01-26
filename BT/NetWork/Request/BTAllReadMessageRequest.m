//
//  BTAllReadMessageRequest.m
//  BT
//
//  Created by admin on 2018/10/31.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTAllReadMessageRequest.h"

@implementation BTAllReadMessageRequest
- (NSString *)requestUrl {
    return NewReadAllMessageUrl;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}
@end
