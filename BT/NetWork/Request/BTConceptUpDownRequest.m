//
//  BTConceptUpDownRequest.m
//  BT
//
//  Created by apple on 2018/4/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTConceptUpDownRequest.h"

@implementation BTConceptUpDownRequest{
    NSInteger _kind;
}

- (instancetype)initWithKind:(NSInteger)kind{
    if(self =[super init]){
        _kind = kind;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString*)requestUrl{
    return CONCEPT_UPDOWN_LIST;
}

- (id)requestArgument{
    return @{@"riseType":@(_kind)};
}

@end
