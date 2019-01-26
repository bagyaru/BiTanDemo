//
//  ProfitLossDetailRequest.m
//  BT
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ProfitLossDetailRequest.h"

@implementation ProfitLossDetailRequest{
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
    return PROFIT_LOSS_DETAIL;
}

- (id)requestArgument{
    return @{@"kind":SAFESTRING(_kind)};
}

@end
