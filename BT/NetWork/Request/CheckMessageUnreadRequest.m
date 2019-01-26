//
//  CheckMessageUnreadRequest.m
//  BT
//
//  Created by admin on 2018/1/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CheckMessageUnreadRequest.h"

@implementation CheckMessageUnreadRequest
-(id)initWithCheckMessageUnread {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (NSString *)requestUrl {
    return CheckMessageUnreadUrl;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodGET;
}
@end
