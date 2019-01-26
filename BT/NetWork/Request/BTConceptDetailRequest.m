//
//  BTConceptDetailRequest.m
//  BT
//
//  Created by apple on 2018/4/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTConceptDetailRequest.h"

@implementation BTConceptDetailRequest{
    NSString *_conceptId;
    NSInteger _type;
}
- (instancetype)initWithId:(NSString *)conceptId sortType:(NSInteger)type{
    if(self =[super init]){
        _conceptId = conceptId;
        _type = type;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString*)requestUrl{
    return CONCEPT_INFO_DETAIL;
}

- (id)requestArgument{
    return @{
             @"conceptId":SAFESTRING(_conceptId),
             @"sortType":@(_type)
             
             };
}
@end
