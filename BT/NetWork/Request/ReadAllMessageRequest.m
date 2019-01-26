//
//  ReadAllMessageRequest.m
//  BT
//
//  Created by admin on 2018/1/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ReadAllMessageRequest.h"

@implementation ReadAllMessageRequest
-(id)initWithReadAllMessage {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (NSString *)requestUrl {
    return ReadAllMessageUrl;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodPOST;
}
@end
