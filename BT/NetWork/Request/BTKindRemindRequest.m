//
//  BTKindRemindRequest.m
//  BT
//
//  Created by apple on 2018/3/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTKindRemindRequest.h"

@implementation BTKindRemindRequest{
    NSString *_kind;
}
- (instancetype)initWithKind:(NSString *)kind{
    if(self =[super init]){
        _kind = kind;
    }
    return self;
}
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString*)requestUrl{
    return USER_REMINE_LIST;
}

- (id)requestArgument{
    return @{@"kind":SAFESTRING(_kind)};
}


@end
