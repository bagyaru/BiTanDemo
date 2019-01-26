//
//  FeedBackRequest.m
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FeedBackRequest.h"

@implementation FeedBackRequest{
    
    NSString *_content;
}
- (id)initWithContent:(NSString *)content {
    
    self = [super init];
    if (self) {
        _content = content;
        
    }
    return self;
}
-(NSString *)requestUrl {
    return FeedBackUrl;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}


- (id)requestArgument {
    return @{
             @"content":_content
             };
}

@end
