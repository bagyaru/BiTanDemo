//
//  BTHotCurrencyListRequest.m
//  BT
//
//  Created by admin on 2018/6/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTHotCurrencyListRequest.h"

@implementation BTHotCurrencyListRequest
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return DISCOVERSY_HOTCURRENCY_LIST;
}
@end
