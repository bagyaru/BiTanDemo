//
//  LoginOutRequest.m
//  BT
//
//  Created by admin on 2018/1/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "LoginOutRequest.h"

@implementation LoginOutRequest

-(id)initWithLoginOut {
    
    self = [super init];
    if (self) {
       
    }
    return self;
}
- (NSString *)requestUrl {
    return LoginOutUrl;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodGET;
}

@end
