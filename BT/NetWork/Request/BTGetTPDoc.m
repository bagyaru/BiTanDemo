//
//  BTGetTPDoc.m
//  BT
//
//  Created by apple on 2018/10/22.
//  Copyright © 2018 apple. All rights reserved.
//

#import "BTGetTPDoc.h"

@implementation BTGetTPDoc

- (NSString *)requestUrl {
    return @"oauth/oauth-rest/getDoc";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}
@end
