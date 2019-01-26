//
//  BTSheQuHeadListRequest.m
//  BT
//
//  Created by admin on 2018/8/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTSheQuHeadListRequest.h"

@implementation BTSheQuHeadListRequest
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return SheQuHeadListUrl;
}
@end
