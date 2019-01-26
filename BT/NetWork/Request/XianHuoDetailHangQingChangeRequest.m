//
//  XianHuoDetailHangQingChangeRequest.m
//  BT
//
//  Created by admin on 2018/1/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "XianHuoDetailHangQingChangeRequest.h"

@implementation XianHuoDetailHangQingChangeRequest{
    NSString *_exchangeCode;
    NSArray  *_kindList;
}

- (instancetype)initWithMarketType:(NSString *)exchangeCode kindList:(NSArray *)kindList{
    self = [super init];
    if (self) {
        _exchangeCode = exchangeCode;
        _kindList = kindList;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return XianHuoDetailHangQingChangeUrl;
}

- (id)requestArgument{
    return @{@"exchangeCode":_exchangeCode,@"kindList":[_kindList componentsJoinedByString:@","]};
}

@end
