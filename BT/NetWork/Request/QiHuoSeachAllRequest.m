//
//  QiHuoSeachAllRequest.m
//  BT
//
//  Created by admin on 2018/1/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "QiHuoSeachAllRequest.h"

@implementation QiHuoSeachAllRequest
-(id)initWithQiHuoSeachAllRequest {
    
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (NSString *)requestUrl {
    
    return QiHuoSeachAllUrl;
}

- (YTKRequestMethod)requestMethod {
    
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic = @{@"pageIndex":@(1),@"pageSize":@(10000)};
   return [self bodyRequestWithDic:dic];
}
@end
