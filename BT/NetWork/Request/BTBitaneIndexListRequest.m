//
//  BTBitaneIndexListRequest.m
//  BT
//
//  Created by admin on 2018/6/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTBitaneIndexListRequest.h"

@implementation BTBitaneIndexListRequest
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return HOME_BTZS;
}
@end
