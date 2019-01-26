//
//  BTConceptMainRequest.m
//  BT
//
//  Created by apple on 2018/4/3.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTConceptMainRequest.h"

@implementation BTConceptMainRequest{
    NSInteger _first;
}

- (instancetype)initWithFirstRequest:(NSInteger)first{
    if(self =[super init]){
        _first = first;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString*)requestUrl{
    return CONCEPT_MAIN_PAGE;
}

- (id)requestArgument{
    return @{@"isFirstRequest":@(_first)};
}
@end
