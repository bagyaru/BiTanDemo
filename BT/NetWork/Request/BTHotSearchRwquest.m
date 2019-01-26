//
//  BTHotSearchRwquest.m
//  BT
//
//  Created by admin on 2018/5/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTHotSearchRwquest.h"

@implementation BTHotSearchRwquest
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return HOT_SEARCH;
}
@end
