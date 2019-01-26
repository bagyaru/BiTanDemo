//
//  BTBZSeachRequset.m
//  BT
//
//  Created by admin on 2018/5/28.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBZSeachRequset.h"

@implementation BTBZSeachRequset{
    
    NSString *_input;

}

- (instancetype)initWithInput:(NSString *)input {
    
    self = [super init];
    if (self) {
        _input = input;
    }
    return self;
}
- (NSString *)requestUrl {
    return BZ_SEACH;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    return @{@"input":_input};
}


@end
