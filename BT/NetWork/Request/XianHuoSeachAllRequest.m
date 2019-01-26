//
//  XianHuoSeachAllRequest.m
//  BT
//
//  Created by admin on 2018/1/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "XianHuoSeachAllRequest.h"

@implementation XianHuoSeachAllRequest
-(id)initWithXianHuoSeachAllRequest {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (NSString *)requestUrl {
    return XianHuoSeachAllUrl;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodPOST;
}
@end
