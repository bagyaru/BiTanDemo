//
//  BTMyPostCommentsRequest.m
//  BT
//
//  Created by admin on 2018/9/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BTMyPostCommentsRequest.h"

@implementation BTMyPostCommentsRequest{
    NSInteger _refType;
    NSInteger _pageSize;
    NSInteger _currentPage;
}

- (id)initWithRefType:(NSInteger)refType pageIndex:(NSInteger)pageIndex{
    self = [super init];
    if (self) {
        _refType     = refType;
        _pageSize    = BTPagesize;
        _currentPage = pageIndex;
    }
    return self;
}
- (NSString *)requestUrl {
    return Posts_MyPosts_Comments_List_Url;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSURLRequest *)buildCustomUrlRequest{
    NSDictionary *dic =  @{@"refType":@(_refType),@"pageSize":@(_pageSize),@"pageIndex":@(_currentPage)};
    return [self bodyRequestWithDic:dic];
}

//- (id)requestArgument {
//    return @{
//             @"commentListRequest":@{@"refType":@(_refType),@"pageSize":@(_pageSize),@"pageIndex":@(_currentPage)}
//             };
//}


@end
