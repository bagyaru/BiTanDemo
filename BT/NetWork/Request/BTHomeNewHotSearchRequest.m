//
//  BTHomeNewHotSearchRequest.m
//  BT
//
//  Created by admin on 2018/8/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTHomeNewHotSearchRequest.h"

@implementation BTHomeNewHotSearchRequest
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return HOME_HOTSEARCH;
}
@end
