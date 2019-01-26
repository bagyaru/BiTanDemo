//
//  BTInfoListSubTypesRequest.m
//  BT
//
//  Created by admin on 2018/7/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTInfoListSubTypesRequest.h"

@implementation BTInfoListSubTypesRequest{
    NSInteger _type;
}
- (instancetype)initWithParentType:(NSInteger)type{
    if(self = [super init]){
        _type = type;
    }
    return self;
}
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return @"knowledge/info/listSubTypes";
}
- (id)requestArgument {
    return @{@"parent":@(_type)};
}
@end
