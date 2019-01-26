//
//  UserAccountMainRequest.m
//  BT
//
//  Created by admin on 2018/3/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UserAccountMainRequest.h"

@implementation UserAccountMainRequest
{
    NSInteger _sort;
}

- (instancetype)initWithSort:(NSInteger)sort{
    self = [super init];
    if (self) {
        _sort = sort;
       
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return USER_ACCOUNT;
}

- (id)requestArgument{
    return @{@"sort":@(_sort)};
}

@end
