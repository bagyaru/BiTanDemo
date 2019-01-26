//
//  ReadAllReplayedRequest.m
//  BT
//
//  Created by admin on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ReadAllReplayedRequest.h"

@implementation ReadAllReplayedRequest
-(id)initWithReadReplayed {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (NSString *)requestUrl {
    return ReadAllReplayUrl;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodPOST;
}
@end
