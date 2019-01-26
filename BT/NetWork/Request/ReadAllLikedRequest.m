//
//  ReadAllLikedRequest.m
//  BT
//
//  Created by admin on 2018/4/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ReadAllLikedRequest.h"

@implementation ReadAllLikedRequest
-(id)initWithReadAllLiked {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (NSString *)requestUrl {
    return ReadAllLikedUrl;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodPOST;
}
@end
