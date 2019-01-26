//
//  BTPostMainListHeadRequest.m
//  BT
//
//  Created by admin on 2018/9/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTPostMainListHeadRequest.h"

@implementation BTPostMainListHeadRequest
- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodGET;
}

- (NSString *)requestUrl{
    return Posts_List_Head_Url;
}
@end
