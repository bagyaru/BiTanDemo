//
//  BTShareDomainRequest.m
//  BT
//
//  Created by admin on 2018/10/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTShareDomainRequest.h"

@implementation BTShareDomainRequest
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return Share_Domain_Url;
}
@end
