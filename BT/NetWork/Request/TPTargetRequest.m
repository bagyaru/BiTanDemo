//
//  TPTargetRequest.m
//  BT
//
//  Created by apple on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TPTargetRequest.h"

@implementation TPTargetRequest

- (NSString *)requestUrl {
    return TP_TARGET;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
- (id)requestArgument {
    
    if (self.type == 1) {
        return @{
                 @"type": @(self.type)
                 };
    }
    return nil;
}
@end
