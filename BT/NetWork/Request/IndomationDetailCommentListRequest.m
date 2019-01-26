//
//  IndomationDetailCommentListRequest.m
//  BT
//
//  Created by admin on 2018/1/23.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "IndomationDetailCommentListRequest.h"

@implementation IndomationDetailCommentListRequest{
    NSInteger _refType;
    NSString *_refId;
    NSInteger _pageSize;
    NSInteger _currentPage;
}

- (id)initWithRefType:(NSInteger)refType refId:(NSString *)refId pageIndex:(NSInteger)pageIndex{
    self = [super init];
    if (self) {
        _refType = refType;
        _refId   = refId;
        _pageSize = BTPagesize;
        _currentPage = pageIndex;
    }
    return self;
}
- (NSString *)requestUrl {
    return InfomationCommentListUrl;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"refType":@(_refType),@"refId":_refId,@"pageSize":@(_pageSize),@"pageIndex":@(_currentPage)};
    return [self bodyRequestWithDic:dic];
}

- (id)requestArgument {
    return @{
             @"commentListRequest":@{@"refType":@(_refType),@"refId":_refId,@"pageSize":@(_pageSize),@"pageIndex":@(_currentPage)}
             };
}

@end
