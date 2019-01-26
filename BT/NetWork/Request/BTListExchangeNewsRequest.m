//
//  BTListExchangeNewsRequest.m
//  BT
//
//  Created by admin on 2018/7/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTListExchangeNewsRequest.h"

@implementation BTListExchangeNewsRequest
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return @"knowledge/info/listExchangeNews";
}
@end
