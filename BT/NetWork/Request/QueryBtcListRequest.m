//
//  QueryBtcListRequest.m
//  BT
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QueryBtcListRequest.h"

@implementation QueryBtcListRequest

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return QUERYBTCKISTNEW_URL;
}

//- (BOOL)useCDN{
//    return YES;
//}
@end
