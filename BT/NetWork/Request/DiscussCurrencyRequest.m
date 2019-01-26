//
//  DiscussCurrencyRequest.m
//  BT
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "DiscussCurrencyRequest.h"

@implementation DiscussCurrencyRequest{
    NSString *_refId;
    NSInteger _refType;
    NSInteger _pageIndex;
    NSInteger _pageSize;
}

- (instancetype)initWithRefId:(NSString *)refId refType:(NSInteger)refType pageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize{
    self = [super init];
    if (self) {
        _refId = refId;
        _refType = refType;
        _pageIndex = pageIndex;
        _pageSize = pageSize;
    }
    return self;
}

- (YTKRequestMethod)requestMethod{
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    return DISCUSSCURRENCY_URL;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic = @{@"refId":_refId,@"refType":@(_refType),@"pageIndex":@(_pageIndex),@"pageSize":@(_pageSize)};
   return  [self bodyRequestWithDic:dic];
}

@end
