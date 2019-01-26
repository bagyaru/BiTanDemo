//
//  BannersRequest.m
//  BT
//
//  Created by admin on 2018/1/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BannersRequest.h"

@implementation BannersRequest{
    
    NSInteger _type;
}
-(id)initWithType:(NSInteger)type {
    
    self = [super init];
    if (self) {
        
        _type = type;
    }
    return self;
}
- (NSString *)requestUrl {
    return NewBannersUrl;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{
             @"type": @(_type)
             };
}


@end
