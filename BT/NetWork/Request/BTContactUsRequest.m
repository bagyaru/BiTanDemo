//
//  BTContactUsRequest.m
//  BT
//
//  Created by admin on 2018/9/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTContactUsRequest.h"

@implementation BTContactUsRequest
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return ContactUs_Url;
}
@end
